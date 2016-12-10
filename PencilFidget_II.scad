use <threads.scad>
ThreadSize = 11;
ThreadPitch = 1.5; 

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

module bolt() {
  difference() {
    union() {
      // the thread body
      metric_thread(ThreadSize,ThreadPitch,38);
      // the head
      hex_block(15,3);
    }
    translate([0, 0, -1]) 
      hex_block(0.3 * 25.4, 100);
  }
}

module nut() {
    difference() {
      hex_block(15, 3);
      translate([0, 0, -1]) metric_thread(ThreadSize,ThreadPitch,5, internal=true);
    }
}

module PencilFidget_II() {
   bolt();
   translate([20, 0, 0]) nut();
   translate([0, 20, 0]) nut();
}

PencilFidget_II();
