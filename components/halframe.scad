//translate([0,0,10]) cube([3,3.95,3], center=true);
difference() {
    translate([0,-22,0]) scale(2) import("Gears1_V8E_PrintInPlace_NoSupports_4.stl", convexity=10);
    translate([-40, -80, -80]) cube([80,160,80]);
    /* rotate(30) translate([0,21,0]) rotate([90,0,0]) */
    /*     cylinder(h=9, r=1, center=true, $fn=24); */
    /* rotate(-30) translate([0,21,0]) rotate([90,0,0]) */
    /*     cylinder(h=9, r=1, center=true, $fn=24); */
    /* rotate(150) translate([0,21,0]) rotate([90,0,0]) */
    /*     cylinder(h=9, r=1, center=true, $fn=24); */
    /* rotate(-150) translate([0,21,0]) rotate([90,0,0]) */
    /*     cylinder(h=9, r=1, center=true, $fn=24); */
    rotate(30) translate([0,20,0])
        cylinder(h=8, r=1.2, center=true, $fn=24);
    rotate(-30) translate([0,20,0])
        cylinder(h=8, r=1.2, center=true, $fn=24);
    rotate(150) translate([0,20,0])
        cylinder(h=8, r=1.2, center=true, $fn=24);
    rotate(-150) translate([0,20,0])
        cylinder(h=8, r=1.2, center=true, $fn=24);
}
