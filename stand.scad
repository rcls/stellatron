
// STANDS
use <splitting.scad>;

// Create a tripod.  This implies that the object is face-up to get the 3-fold
// symmetry about the z-axis.
//
// `strut` is the distance from the z-axis to the support struts, as a fraction
// of radius.  `strut_mm` is the same in mm.  If both are non-zero then they
// are added together.
//
// `length` is the length of the strut, as fraction of radius.  Note that as
// the object is raised 2mm, we also increase the length by 2mm.
//
// `thick` is the radius of the struts.
//
// `base` is the base radius, if larger than the computed one.
//
// `hole` if non-zero is the radius of a circle to remove from the center of the
// base.
//
// `height` is the height of the center of the object, as a ratio of `radius`.
// 2mm is added to this.
module stand_tripod(strut, strut_mm=0, base=0,
                    length=1, height=1, align=[1, 0, 0], hole=0, p=10) {
    stand_generic(
        3, strut, strut_mm, base, length, height, hole, p=p)
        align_rot(align) faceup() children();
}

module stand_pentapod(strut, strut_mm=0, base=0,
                      length=1, height=1, hole=1, mink=0, p=10) {
    stand_generic(
        5, strut, strut_mm, base, length, height, hole, mink, p=p)
        pointup() children();
}

module stand_generic(num, strut, strut_mm=0, base=0,
                     length=1, height=1, hole=0, mink=0, p=10) {
    if ($piece == p) {
        strut_all = strut * $radius + strut_mm;
        difference() {
            for (i = [1:num]) {
                rotate(i * 360 / num) translate([strut_all, 0, 0])
                    cylinder(r = $stand_diameter / 2, h=$radius * length + 2);
            }
            minkowski() {
                translate([0, 0, $radius * height + 2])
                    scale($radius) children();
                if (mink != 0)
                    translate([0, 0, mink/2 * $radius])
                        cube([0.02, 0.02, mink * $radius], center=true);
            }
        }
        stand_ring(base, hole, strut_all);
    }
}

module stand_quad(x, y, length=1, height=1, hole=0, knob=false) {
    difference() {
        for (c = [[x, y], [-x, y], [-x, -y], [x, -y]]) {
            translate([c.x * $radius, c.y * $radius, 0])
                cylinder(r = $stand_diameter / 2, h=$radius * length + 2);
        }
        #translate([0, 0, $radius * height + 2])
        scale($radius) children();
    }
    stand_ring(0, 1, norm([x, y]) * $radius);
}

module stand_rhombus(x, y, length=1, height=1) {
    difference() {
        for (c = [[x, 0], [-x, 0], [0, -y], [0, y]])
            translate([c.x * $radius, c.y * $radius, 0])
                cylinder(r = $stand_diameter / 2, h=$radius * length + 2);
        #translate([0, 0, $radius * height + 2])
        scale($radius) children();
    }
    stand_ring(max(x, y), min(x, y), x * $radius);
}

module stand_ring(base, hole, strut_mm) {
    outer = max(base * $radius, abs(strut_mm)) + $stand_diameter / 2;
    inner = min(hole * $radius, abs(strut_mm)) - $stand_diameter / 2;
    echo(outer, inner, base, hole, strut_mm);
    rounded_ring(outer, inner, n = $fn * 6);
}

module rounded_ring(outer, inner, height=0, r=2, n=0) {
    rotate_extrude($fn = n ? n : $fn) {
        translate([outer, height]) intersection() {
            circle(r);
            square(r);
        }
        if (inner >= r) translate([inner, height]) intersection() {
                circle(r);
                translate([-r, 0]) square(r);
            }
        if (outer > inner)
            translate([inner, 0]) square([outer - inner, height + r]);
        iinner = inner >= r ? inner - r : inner;
        if (height > 0)
            translate([inner, 0]) square([outer + r - iinner, height]);
    }
}
