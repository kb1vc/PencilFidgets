use <threads.scad>
use <knurledFinishLib_v2.scad>

ThreadSize = 11.5;
ThreadPitch = 2.5;
NutThickness = 4;
NutDiameter = 15;
PencilWidth_in = 0.31;
FidgetLength = 38;

module hexagon(w) {
    side = w / sqrt(3);
    hside = side / 2;
    r = side;
    h = w / 2; 
    polygon( points = [ [-hside, -h], [hside, -h], 
                        [r, 0], 
                        [hside, h], [-hside, h], 
                        [-r, 0], [-hside, -h] ] );
}

module hex_block(w,l) {
   // make a hex block with width w and length l
   linear_extrude(l) hexagon(w); 
}

module nut_body(w, l) {
    union() {
       knurl(k_cyl_hg = l, k_cyl_od = w, 
             knurl_wd = 1, knurl_hg = 1, knurl_dp = 0.5,
	         e_smooth = 0.5, s_smooth = 0);
    }
}

module bolt() {
  difference() {
    union() {
      // the thread body
      metric_thread(ThreadSize,ThreadPitch,FidgetLength,square=true);
      // the head
      nut_body(NutDiameter, NutThickness);
    }
    translate([0, 0, -1]) 
      hex_block(PencilWidth_in * 25.4, 2 * FidgetLength);
  }
}

module nut() {
    difference() {
      nut_body(NutDiameter, NutThickness);
      translate([0, 0, -1]) scale([1.05, 1.05, 1]) metric_thread(ThreadSize,ThreadPitch,5, internal=true, square=true);
    }
}

module PencilFidget_II() {
   bolt();
   translate([1.5 * NutDiameter, 0, 0]) nut();
   translate([0, 1.5 * NutDiameter, 0]) nut();
}

PencilFidget_II();
