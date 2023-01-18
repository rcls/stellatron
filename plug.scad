
backoff=0.1;
bevel=0.5;
baseheight=3;
countersink=2;
prongheight=5.7;

baseshaft = baseheight - countersink;

echo("Tip", 10 - 6 - 2 * baseshaft);

difference() {
    union() {
        cylinder(r=9.5/2, h=baseheight, $fn=40);
        bevelcylinder(r=18/2, h=baseheight - 0.25, bevel=0.75, $fn=80);
        prongs();
    }
    cylinder(r=2.75/2, h=20, center=true, $fn=40);
    translate([0,0,-bevel])
        botoutbevelcylinder(r=6/2, h=countersink + bevel, $fn=6, bevel=2*bevel);
}

module prongs() {
    intersection() {
        bevelcylinder(r=5.8/2, h = baseheight + prongheight, $fn=20);
        union() {
            translate([backoff,backoff,0]) cube([10,10,10]);
            translate([-10 - backoff,-10 - backoff,0]) cube([10,10,10]);
        }
    }
}

module bevelcylinder(r, h) {
    cylinder(h=bevel, r1=r-bevel, r2 = r);
    translate([0,0,bevel]) cylinder(h=h - 2*bevel, r=r);
    translate([0,0,h-bevel]) cylinder(h=bevel, r1=r, r2=r - bevel);
}

module botbevelcylinder(r, h) {
    cylinder(h=bevel, r1=r-bevel, r2 = r);
    translate([0,0,bevel]) cylinder(h=h - bevel, r=r);
    // translate([0,0,h-bevel]) cylinder(h=bevel, r1=r, r2=r - bevel);
}

module botoutbevelcylinder(r, h) {
    cylinder(h=bevel, r1=r+bevel, r2 = r);
    cylinder(h=h, r=r);
    // translate([0,0,h-bevel]) cylinder(h=bevel, r1=r, r2=r - bevel);
}
