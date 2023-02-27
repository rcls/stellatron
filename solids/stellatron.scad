
include <numbers.scad>
use <crennell.scad>
use <dodecatron.scad>
use <splitting.scad>

// Crennell number of the object to print.
crennell = 8;
// Alternatively, you may replace `main();` below with the object you want.

// 0 = raw object, 1 = main printable, 2 = extra piece, 10 = stand.
$piece = 1;

// The overall radius in mm from the center of the piece to its extremities.
$radius = 65;
// Many of the dimensions below are scaled by the radius.

// When cutting into pieces, remove this much extra in the z direction (mm).
$extra_z_remove=0.001;
// This may be helpful where you have edges touching the base plate.

// Depth in mm of the hole for post joiners.
$join_depth=5;
// I use 10 for larger pieces, 5 for smaller ones where space is tight.

// Diameter in mm of the holes for post joiners.
$join_diameter=2.2;
// This should be the diameter of your filament (or whatever you use), plus a
// little.

// Diameter in mm of the stand posts.
$stand_diameter = 6;

// For stands and joiners.  (Gets multiplied for larger radii).
$fn=20;

main();

module main() {
    if (crennell == 1) {
        if ($piece == 0) c1();
        if ($piece == 1) icosa_tb_whole(radius1) c1();
        if ($piece == 4)
            translate([0, 0, $radius * inscribe]) rotate([180, 0, 0])
                three_twelfths(top=icosa_midscribe, cut=1/3,
                               mid=inscribe,
                               small=dodeca_midscribe/inscribe/3,
                               midsetz=-1.5, topset=3)
                c1();
        if ($piece == 5) one_twelfth(small=1/2,
                                     mid=radius1*inscribe,
                                     top=radius1*sqrt(inscribe)) c1();
        if ($piece == 6) two_twelfths() c1();
    }
    if (crennell == 2) c2();
    if (crennell == 3) c3();
    if (crennell == 4) c4();
    if (crennell == 5) c5();
    if (crennell == 6) {
        icosa_top_bottom(radius7, post=-1/3) c6();
        stand_tripod(height=inscribe, strut=-1/ico_scale/6, base=$radius/5) c6();
    }
    if (crennell == 7) {
        dodeca_spikey(post=0.1) c7();
        stand_pentapod(strut=-0.153) c7();
    }
    if (crennell == 8) {
        if ($piece == 0) c8();
        if ($piece == 1)
            two_twelfths(cut=0.09, // radius6/radius8 / gold / sqrt(3),
                         top=radius6/radius8 * dodeca_midscribe,
                         topset=2.25
                         ) c8();

        stand_tripod(strut=-0.2, hole=$radius/8) c8();
        stand_pentapod(strut=0.12, p=11) c8();
    }

    if (crennell == 9) c9();
    if (crennell == 10) c10();
    if (crennell == 11) c11();
    if (crennell == 12) c12();
    if (crennell == 13) dodeca_single() c13();
    if (crennell == 14) c14();
    if (crennell == 15) c15();
    if (crennell == 16) c16();
    if (crennell == 17) c17();
    if (crennell == 18) c18();
    if (crennell == 19) c19();
    if (crennell == 20) c20();
    if (crennell == 21) c21();
    if (crennell == 22) c22();
    if (crennell == 23) {
        icosa_top_bottom(radius7, post=-1/3, inset=5) c23();
        stand_tripod(height=inscribe,strut=-1/ico_scale/6, base=$radius/5) c23();
    }
    if (crennell == 24) c24();
    if (crennell == 25) c25();
    if (crennell == 26) {
        dodeca_single() c26();
        stand_tripod(strut=-coscribe/radius6) c26();
        // Piece 11 is a higher stand to match c23 when both have the same
        // size dodecahedron.
        stand_tripod(strut=-coscribe/radius6, length=1.2,
                     height=inscribe * radius7 / radius6, p=11) c26();
    }
    if (crennell == 27) {
        icosa_top_bottom(radius5, post=2/3, inset=5, angle=30) c27();
        if ($piece == 3) {
            one_twelfth(cut=1/2, top=radius3/radius5, topset=5,
                        mid=radius2/radius5) c27();
        }
        stand_tripod(strut=(gold - 1)/2) c27();
        stand_pentapod(strut=0.5 * inscribe, p=11) c27();
    }
    if (crennell == 28) {
        icosa_top_bottom(radius7, post=-1/3, inset=10) c28();
        if ($piece == 10)
            stand_quad(x=0.1, y=gold/10, height=gold/ico_scale) c28();
        stand_tripod(strut=gold-1.5, base=$radius/5, height=inscribe, p=11)
            c28();
    }
    if (crennell == 29) c29();
    if (crennell == 30) {
        icosa_top_bottom(radius7, post=-radius4/radius7, inset=5) c30();
        stand_pentapod(strut=gold * 5 / 7 - 1, base=$radius/4, hole=2)
            c30();
    }
    if (crennell == 31) c31();
    if (crennell == 32) c32();
    if (crennell == 33) c33();
    if (crennell == 34) c34();
    if (crennell == 35) c35();
    if (crennell == 36) c36();
    if (crennell == 37) {
        dodeca_single() c37();
        // Default stand is low-profile.
        stand_tripod(strut=1/4, length=1/3, hole=2) c37();
        // Piece 11 matches the height of c23.
        stand_tripod(strut=1/4, length=2/3,
                     height=inscribe * radius7 / radius6, p=11) c37();
    }
    if (crennell == 38) c38();
    if (crennell == 39) c39();
    if (crennell == 40) c40();
    if (crennell == 41) c41();
    if (crennell == 42) c42();
    if (crennell == 43) c43();
    if (crennell == 44) c44();
    if (crennell == 45) c45();
    if (crennell == 46) {
        if ($piece == 0) c46();
        if ($piece == 1)
            one_twelfth(cut=1/5, small=1/5, top=radius3/radius6,
                        mid=radius2/radius6) c46();
        stand_tripod(strut=-coscribe/radius6, hole=2) c46();
    }
    if (crennell == 47) {
        icosa_top_bottom(radius6, post=0.5, inset=5) c47();
        stand_tripod(strut=0.1, align=p6a, hole=2) c47();
    }
    if (crennell == 48) c48();
    if (crennell == 49) c49();
    if (crennell == 50) c50();
    if (crennell == 51) c51();
    if (crennell == 52) c52();
    if (crennell == 53) c53();
    if (crennell == 54) c54();
    if (crennell == 55) c55();
    if (crennell == 56) c56();
    if (crennell == 57) c57();
    if (crennell == 58) c58();
    if (crennell == 59) c59();

    // DUALS ETC.
    if (crennell == 101) {
        if ($piece == 0) dodecahedron();
        if ($piece == 1)
            scale($radius) translate([0,0,inscribe]) pointup() dodecahedron();
        if ($piece == 4)
            // This would actually work resting on a face.
            three_twelfths(cut=0.25, small=0.25, mid=1, midsetz=-5, inset=5)
                dodecahedron();
        if ($piece == 5)
            one_twelfth(cut=0.5, small=0.5, mid=1, midsetz=-5, inset=5)
                dodecahedron();
        if ($piece == 6)
            two_twelfths(cut=0.25, small=0.5, mid=1, midsetz=-5, inset=5)
                dodecahedron();
        stand_tripod(strut=-1/3, hole=$radius) dodecahedron();
    }
    if (crennell == 107) {
        if ($piece == 0) great_stellated_dodecahedron();
        dodeca_spikey(post=0.3, inset=3, raise=(2 * gold - 3)*inscribe)
            great_stellated_dodecahedron();
        stand_tripod(strut=(0.6 - 0.2 * gold) * inscribe / sqrt(3), hole=2)
            great_stellated_dodecahedron();
    }
    if (crennell == 108) {
        if ($piece == 0) final_dual();
        icosa_top_bottom(radius6, post=0.4, inset=0*5) final_dual();
        if ($piece == 5)
            one_twelfth(cut=0.3, top=0.4, topset=0,
                        mid = $radius>=40 ? 1 : 0, midsetz=-36, inset=11)
                final_dual();
        if ($piece == 6)
            two_twelfths(cut=0.15, top=0.4, topset=0,
                         mid = $radius>=40 ? 1 : 0, midsetz=-36, inset=11)
                final_dual();
        if ($piece == 9) difference() {
                scale($radius) final_dual_peanut();
                translate([0,0,-$radius/2]) cube($radius, center=true);
                for (i = [0, 180]) joiner_post(i, [$radius / 15, 0, 0]);
            }
        stand_pentapod(strut=-0.21, strut_mm=$stand_diameter/2,
                       hole=$radius/5) final_dual();
        stand_pentapod(strut=(2-gold)*coscribe, strut_mm=$stand_diameter/2,
                       hole=$radius/5, p=11) final_dual();
        stand_tripod(strut=0.23, strut_mm=$stand_diameter/2,
                     length=2/3, hole=$radius/5, p=12) final_dual();
    }
    if (crennell == 201) {
        dodeca_spikey(post=-2/sqrt(5), inset=15) great_dodecahedron();
        stand_pentapod(strut=(6 * gold - 8) / 5) great_dodecahedron();
    }
    if (crennell == 202) {
        dodeca_spikey(post=(gold-3)/5, inset=5) small_stellated_dodecahedron();
        stand_pentapod(strut=(gold-3)/5) small_stellated_dodecahedron();
    }
}

// STANDS

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
        3, strut, strut_mm, base, length, height, hole, p)
        align_rot(align) faceup() children();
}

module stand_pentapod(strut, strut_mm=0, base=0,
                      length=1, height=1, hole=0, p=10) {
    stand_generic(
        5, strut, strut_mm, base, length, height, hole, p)
        pointup() children();
}

module stand_generic(num, strut, strut_mm=0, base=0,
                     length=1, height=1, hole=0, p=10) {
    if ($piece == p) {
        strut_all = strut * $radius + strut_mm;
        difference() {
            for (i = [1:num]) {
                rotate(i * 360 / num) translate([strut_all, 0, 0])
                    cylinder(r = $stand_diameter / 2, h=$radius * length + 2);
            }
            # translate([0, 0, $radius * height + 2])
                scale($radius) children();
        }
        minkowski() {
            difference() {
                cylinder(r=max(base, abs(strut_all) + $stand_diameter / 2),
                         h = 0.1, $fn=6 * $fn);
                if (hole > 0) {
                    holey = min(hole + 1.9,
                                abs(strut_all) - $stand_diameter / 2);
                    cylinder(r=holey, h=1, center=true,
                             $fn = holey > 4 ? $fn * 6 : $fn);
                }
            }
            intersection() {
                sphere(r=1.9);
                translate([-3, -3, 0]) cube(6);
            }
        }
    }
}

module stand_quad(x, y, length=1, height=1) {
    r = sqrt(x * x + y * y) * $radius;
    difference() {
        for (c = [[x, y], [-x, y], [-x, -y], [x, -y]])
            translate([c.x * $radius, c.y * $radius, 0])
                cylinder(r = $stand_diameter / 2, h=$radius * length + 2);
        #translate([0, 0, $radius * height + 2])
        scale($radius) children();
    }
    minkowski() {
        cylinder(r = r + $stand_diameter / 2, h = 0.1, $fn=6 * $fn);
        intersection() {
            sphere(r=1.9);
            translate([-3, -3, 0]) cube(6);
        }
    }
}
