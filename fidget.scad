
// Height of bearing retainer lip.
lipheight=0.5;
// Width of bearing retainer lip.
lip=0.5;
// Radius of bearing hole.
holer=19/2 + 0.07;
// Total height of spinner.
height=7;
// Outer radius of bearing holder circles.
outer=28/2;
// Radius from center of spinner to center of bearings.
length=2*outer;//holer + outer; //2*outer*cos(30);
// Size of bevel.
bevel=0.5;

rotate(45) difference() {
    union() {
        cylinder(h=height, r=length, $fn=6);
        translate([length,0,0]) cylinder_bi(r=outer, h=height, fn=60);
        rotate(120) translate([length,0,0])
            cylinder_bi(r=outer, h=height, fn=60);
        rotate(240) translate([length,0,0])
            cylinder_bi(r=outer, h=height, fn=60);
    }
    hole();
    translate([length,0,0]) hole();
    rotate(120) translate([length,0,0]) hole();
    rotate(240) translate([length,0,0]) hole();
    rotate(60) curve();
    rotate(-60) curve();
    rotate(180) curve();
}

module curve() {
    translate([length, 0, 0]) union() {
        cylinder(r = length - outer, h = 3*height, center=true, $fn=120);
        cbo_top(r = length - outer, h = height, fn=120);
        cbo_bot(r = length - outer, h = height, fn=120);
    }
}

module hole() {
    translate([0,0,lipheight])
        cylinder(r=holer, h=height, $fn=60);
    cylinder(h=3*lipheight, r1=holer+lip, r2=holer-2*lip, $fn=60, center=true);
    cbo_top(r=holer, h=height, fn=60);
}

module cylinder_bi(r, h, fn) {
    intersection() {
        cylinder(h=h, r=r, $fn = fn);
        cylinder(h=h+bevel, r2 = r - 2*bevel, r1 = r + h - bevel, $fn=fn);
        translate([0,0,-bevel])
            cylinder(h=h+bevel, r1 = r - 2*bevel, r2 = r + h - bevel, $fn=fn);
    }
}

module cbo_top(r, h, fn) {
    cylinder(h=h+bevel, r2 = r + 2*bevel, r1 = r - h + bevel, $fn = fn);
}

module cbo_bot(r, h, fn) {
    translate([0,0,-bevel])
        cylinder(h=h+bevel, r1 = r + 2*bevel, r2 = r - h + bevel, $fn = fn);
}
