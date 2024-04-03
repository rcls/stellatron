
include <numbers.scad>
use <crennell.scad>
use <functions.scad>
use <dodecatron.scad>
use <splitting.scad>
use <stand.scad>

// Crennell number of the object to print.
crennell = 1;
// Alternatively, you may replace `main();` below with the object you want.

// 0 = raw object, 1 = main printable, 2 = extra piece, 10 = stand.
$piece = 1;

// The overall radius in mm from the center of the piece to its extremities.
$radius = 65.00001;

// When cutting into pieces, remove this much extra in the z direction (mm).
$extra_z_remove=0.001;
// This may be helpful where you have edges touching the base plate.

// Depth in mm of the hole for post joiners.
$join_depth=4.99999;
// I use 10 for larger pieces, 5 for smaller ones where space is tight.

// Diameter in mm of the holes for post joiners.
$join_diameter=2.1;
// This should be the diameter of your filament (or whatever you use), plus a
// little.

// Diameter in mm of the stand posts.
$stand_diameter = 6.000001;

$flip = true;

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
    if (crennell == 2) {
        if ($piece == 0)
            c2();
        if ($piece == 1)
            scale($radius) c2();
        if ($piece == 2)
            triakis_icosahedron_piece();
    }
    if (crennell == 3) {
        icosa_top_bottom(radius3, post=1/2) c3();
        if ($piece == 3) five_octahedron_thirtieth();
        if ($piece == 10)
            stand_rhombus(x=2-gold, y=(3 - gold)/5) c3();
    }
    if (crennell == 4) {
        if ($piece == 0) c4();
        if ($piece == 1) scale($radius) c4();
    }
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
            one_twelfth(cut = 0.23,
                        mid=radius6/radius8 * dodeca_midscribe,
                        inset=5
                ) c8();
        if ($piece == 2)
            two_twelfths(cut=0.09, // radius6/radius8 / gold / sqrt(3),
                         top=radius6/radius8 * dodeca_midscribe,
                         topset=2.25
                         ) c8();

        stand_generic(3, strut=-0.3076, hole=$radius/8) minkowski() {
            faceup() c8();
            translate([0,0,0.5]) cube([0.00001, 0.00001, 1], center=true);
        }
        stand_pentapod(strut=0.18, p=11, hole=1, mink=1) c8();
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
    if (crennell == 21) {
        icosa_top_bottom(radius6, post=0.5, inset=5) c21();
        stand_tripod(strut=-coscribe*radius1/radius6, hole=2) c21();
        if ($piece == 9) {
            difference() {
                intersection() {
                    scale($radius) c21();
                    scale($radius*1.1) translate([-1, -1, 0]) cube([2, 2, 1]);
                }
                r = $radius / sqrt(3) - 11;
                joiner_post(position=r*[1/gold,gold,0]);
                joiner_post(position=r*[-1/gold,gold,0]);
                joiner_post(position=r*[1/gold,-gold,0]);
                joiner_post(position=r*[-1/gold,-gold,0]);
            }
        }
    }
    if (crennell == 22) {
        if ($piece == 0)
            c22();
        if ($piece == 1)
            scale($radius) c22();
        if ($piece == 2)
            ten_tetrahedra_piece();

        stand_tripod(strut=-0.254645, base=0.2, hole=1) c22();
    }
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
        if ($piece == 12) {
            difference() {
                union() {
                    minkowski() {
                        cylinder(r1=3, r2=2.5, h=1, $fn=5);
                        intersection() {
                            sphere(1);
                            translate([-2,-2,0]) cube(4);
                        }
                    }
                    for (a = [-36,36,144,-144])
                        rotate(a) rotate([0,60,0]) translate([0,0,2])
                            rounded_ring(0, 0, height=3, r=1);
                            // dome() cylinder(r=0.5, h=2);
                }
                translate([0,0,10-$radius]) scale($radius) pointup() c16();
            }
        }
    }

    if (crennell == 29) c29();
    if (crennell == 30) {
        icosa_top_bottom(radius7, post=-radius4/radius7, inset=5) c30();
        stand_tripod(height=inscribe,strut=1/6, base=1/4, hole=1) c30();
        stand_pentapod(strut=gold * 5 / 7 - 1, base=1/4, hole=2, p=9)
            c30();
        if ($piece == 8) {
            scale(radius7) c30();
            mark([2*gold+1,0, 2 + 3*gold]);
            mark([0,0,gold+1], r=0.1, c="red");
            mark(rot5*[0,0,gold+1], r=0.1, c="pink");
            mark(rot5_4 * [1,1,1] * (1 + 3*gold)/5, c="lightblue");
        }
    }
    module mark(p, r=0.1, c="black") translate(p) color(c) sphere(r);
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
    if (crennell == 40) {
        dodeca_spikey() c40();
    }
    if (crennell == 41) c41();
    if (crennell == 42) c42();
    if (crennell == 43) c43();
    if (crennell == 44) c44();
    if (crennell == 45) c45();
    if (crennell == 46) {
        if ($piece == 0) c46();
        if ($piece == 1)
            one_twelfth(cut=1/3, mid=radius2/radius6, inset=3.5,
                        chamfer_edge=[0:4]) c46();
        stand_tripod(strut=-coscribe / raw_radius6, hole=2) c46();
    }
    if (crennell == 47) {
        icosa_top_bottom(radius6, post=0.5, inset=5) c47();
        p6a = [1 + gold, 0, -gold];
        stand_tripod(strut=-radius1/radius6*coscribe, hole=2) c47();
        if ($piece == 3)
            five_tetrahedron_twentieth();
        if ($piece == 11) {
            stand_tripod(strut=-radius1/radius6*coscribe, hole=2, p=11) c47();
            for (i = [0:4]) {
                translate($radius * [cos(i * 60), sin(i * 60), 0]) {
                    cylinder(h=$radius/4, r=$stand_diameter);
                    translate([0, 0, $radius/2]) faceup()
                        scale($radius/3/sqrt(3))
                        multmatrix(rotate5[(i + 3) * 2 % 5])
                        pyramids(four(invert(triangle([-1,1,1]))));
                }
            }
        }
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
    if (crennell == 102) {
        if ($piece == 0) small_ditrigonal_icosidodecahedron();
        if ($piece == 1)
            scale($radius) translate([0,0,inscribe]) pointup()
                small_ditrigonal_icosidodecahedron();
        small_ditrigonal_icosidodecahedron_piece();
        if ($piece == 10)
            stand_quad(x=0.3047, y=0.3047, hole=1)
                small_ditrigonal_icosidodecahedron();
        if ($piece == 11)
            stand_tripod(strut=0.2845, hole=1, p=11)
                small_ditrigonal_icosidodecahedron();
    }
    if (crennell == 103) {
        five_cubes();
    }
    if (crennell == 108) {
        difference() {
            icosa_top_bottom(radius6, post=0.4, inset=0*5) final_dual();
            if ($piece == 2)
                for (i = [60:120:300])
                    rotate(i) translate([$radius*0.166, 0, 0])
                        cylinder(r=1, h=15);
        }
        fdt = $radius * final_dual_triangle();
        triangle_split(fdt.x, fdt.y, fdt.z,
                       p_main = 3, p_part = 4)
            scale($radius) final_dual();
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
    if (crennell == 128) {
        // I printed this as a single piece in blue.
        // Project [gold,1-gold,0] onto [1,1,1].
        p = [gold, 1-gold, 0];
        q = [1, 1, 1];
        icosa_top_bottom(norm(p)*norm(q),
                         post=0.767,//0.93,
                         inset=5, angle=30,
                         ref_radius=p * q) dual_c28();
        r1 = (2 - gold) * coscribe * $radius + $stand_diameter / 2 / cos(36);
        r2 = (1 - 2 * gold) / 5 * coscribe * $radius;
        stand_pentapod(strut=0, strut_mm=-max(r1, r2), hole=0) dual_c28();
    }
    if (crennell == 200) {              // Out of place!
        if ($piece == 0) stella_octangular();
        if ($piece == 1) scale($radius) translate([0, 0, 1/sqrt(3)])
                             stella_octangular();
        if ($piece == 2) stella_octangular_eighth();
        if ($piece == 3) mirror([1, 0, 0]) stella_octangular_eighth();
    }
    if (crennell == 203)
        octahemioctahedron();

    if (crennell == 204)
        tetrahemihexahedron();

    if (crennell == 234) {
        dodeca_spikey(post=(gold-3)/5, inset=5) small_stellated_dodecahedron();
        stand_pentapod(strut=(gold-3)/5) small_stellated_dodecahedron();
    }
    if (crennell == 235) {
        if ($piece <= 2)
            dodeca_spikey(post=-2/sqrt(5), inset=15) great_dodecahedron();
        if ($piece == 3)
            great_dodecahedron();
        stand_pentapod(strut=(6 * gold - 8) / 5,
                       base=0, hole=1) #great_dodecahedron();
    }
    if (crennell == 236) {
        if ($piece == 0)
            dodecadodecahedron();
        dodecadodecahedron_pieces();
        stand_tripod(strut=(gold - 2) * dodeca_midscribe, hole=1)
            dodecadodecahedron();
        stand_pentapod(strut=0.2, strut_mm = $stand_diameter/4, hole=1, p=11)
            dodecadodecahedron();
    }
    // The 30th stellation can be taken to be either the medial- or the great-
    // triambic icosahedron, the duals of which are visibly different.
    if (crennell == 241)
        dodeca_tri_split() ditrigonal_dodecadodecahedron();

    if (crennell == 247)
        great_ditrigonal_icosidodecahedron();

    if (crennell == 252) {
        if ($piece == 1 || $piece == 2)
            dodeca_spikey(post=0.3, inset=3, raise=(2 * gold - 3)*inscribe)
                great_stellated_dodecahedron();
        stand_tripod(strut=(0.6 - 0.2 * gold) * inscribe / sqrt(3), hole=2)
            great_stellated_dodecahedron();
        if ($piece == 3)
            great_stellated_dodecahedron_piece();
    }
    if (crennell == 254)
        great_icosidodecahedron();

    if (crennell == 255)
        truncated_great_icosahedron();

    if (crennell == 258)
        small_stellated_truncated_dodecahedron();

    if (crennell == 266)
        great_stellated_truncated_dodecahedron();

    if (crennell == 336)
        medial_rhombic_triacontahedron();
}
