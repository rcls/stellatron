
gold = (1 + sqrt(5)) / 2;
// 0 = raw object, 1... = printable, 10 = stand.
piece = 1;

c7();

radius = 65; // * (1+2*gold) / 2.3839634168752983;

// When slicing, remove this much extra in the z direction.
extra_z_remove=0.0;

$fn=20;

// By default ($retrograde == false), we assume that the object has no caves or
// hollows, so that it is safe to extend components towards (and just beyond),
// the center.
//
// Because we build the part out of surfaces, this makes it easier to extend a
// surface to a 3d part.
//
// $retrograde needs to be set where there are caves or hollows.
$retrograde = false;
$pimple = 0.01;

function mirror(p) = [p.x, p.z, p.y];
function pls(p) = [p.z, p.x, p.y];
function mns(p) = [p.y, p.z, p.x];

function sum(v, n) = n + 1 < len(v) ? v[n] + sum(v, n + 1) : v[n];

// Center of a face.
p0 = [1, 1, 1] / 3;

//1	0	0	6	1
p1 = [1, 0, 0];
radius1 = 1;

//0.4+0.2ϕ	0.4+0.2ϕ	0.2-0.4ϕ	1	0.2+0.6ϕ
p2 = [2 + gold, 2 + gold, 1 - 2 * gold] / 5;
radius2 = 1.0661408512011674;

//0.5+0.5ϕ	-0.5ϕ	0.5	3	(1+ϕ)/√2
p3a = [1 + gold, 1, -gold] / 2;
p3b = mirror(p3a);
radius3 = 1.3763819204711734;

//1	1	-1	1	2
p4 = [1, 1, -1];
radius4 = 1.451059202444919;

//1ϕ	1-1ϕ	0	1	2
p4a = [gold, 0, 1 - gold];
p4b = mirror(p4a);

//0.6+0.8ϕ	0.2-0.4ϕ	0.2-0.4ϕ	1	0.4+1.2ϕ
p5 = [3 + 4 * gold, 1 - 2 * gold, 1 - 2 * gold] / 5;
radius5 = 1.6285570507046667;

//0.8+0.4ϕ	-0.2-0.6ϕ	0.4+0.2ϕ	1	0.4+1.2ϕ
p5a = [4 + 2 * gold, 2 + gold, -1 - 3*gold] / 5;
p5b = mirror(p5a);

// 1+1ϕ	-1ϕ	0	10	(1+ϕ)√2
// Six planes meet.
p6a = [1 + gold, 0, -gold];
p6b = mirror(p6a);
radius6 = 2.3839634168752983;

// -1-2ϕ	1+1ϕ	1+1ϕ	6	2+3ϕ
// Five planes meet.
p7 = [1 + gold, 1 + gold, -1 - 2 * gold];
radius7 = 1 + 2 * gold;

//-2-4ϕ	2+3ϕ	1+1ϕ	1	4+6ϕ
// Six of nine.
p8a = [2 + 3 * gold, 1 + gold, -2 - 4 * gold];
p8b = mirror(p8a);
radius8 = 8.359584944780256;

// 3+4ϕ	-1-2ϕ	-1-2ϕ	1	4+6ϕ
// Three of nine.
p8 = [3 + 4 * gold, -1 - 2 * gold, -1 - 2 * gold];

function apply(tri, p) = tri[0] * p[0] + tri[1] * p[1] + tri[2] * p[2];

module wedge(tri, stellation) {
    d = stellation[1] - stellation[0];
    e = stellation[2] - stellation[1];
    cross_sum = d.y * e.z - d.z * e.y
        +       d.z * e.x - d.x * e.z
        +       d.x * e.y - d.y * e.x;

    midpoint = sum(stellation, 0) / len(stellation);
    anchor_n = -0.01 * midpoint;
    anchor_r = midpoint - $pimple * sign(cross_sum) * [1, 1, 1];
    anchor = $retrograde ? anchor_r : anchor_n;

    points = [
        apply(tri, anchor),
        for (p = stellation) apply(tri, p),
        ];
    faces = [
        [each [1:len(stellation)]],
        [1, len(stellation), 0],
        for (i = [2:len(stellation)]) [i, i-1, 0],
        ];
    if (cross_sum >= 0)
        polyhedron(points = points, faces = faces, convexity=10);
    else
        color("red") polyhedron(points = points, faces = faces, convexity=2);
    // # for (p = stellation) translate(apply(tri, p)) sphere(0.1);
    //% translate(anchor) sphere(0.1);
}

module wedges(tri, stellations) {
    for (s = stellations) wedge(tri, s);
}

ico_scale = sqrt(6 + 3 * gold);

function polar(r, theta, z) = [r * cos(theta), r * sin(theta), z] / ico_scale;

function A(i) = polar(       2, i*120,     -gold - 1);
function B(i) = polar(gold * 2, i*120 + 60, 1 - gold);
function C(i) = polar(gold * 2, i*120,      gold - 1);
function D(i) = polar(       2, i*120 + 60, gold + 1);

module stellate_sym(stellations) {
    wedges([A(0), A(1), A(2)], stellations);

    for (i = [0:2]) {
        wedges([A(i+1), A(i  ), B(i  )], stellations);
        wedges([A(i+1), B(i  ), C(i+1)], stellations);
        wedges([C(i  ), B(i  ), A(i  )], stellations);

        wedges([D(i  ), D(i+1), C(i+1)], stellations);
        wedges([D(i  ), C(i+1), B(i  )], stellations);
        wedges([B(i  ), C(i  ), D(i  )], stellations);
    }

    wedges([D(2), D(1), D(0)], stellations);
}

module stellate(stellations) {
    stellate_sym([ for (s = stellations) each triple(s) ]);
}

function triple(stellation) = [
    stellation,
    [ for (p = stellation) pls(p) ],
    [ for (p = stellation) mns(p) ],
    ];

module full_A() stellate_sym([[p1, pls(p1), mns(p1)]]);

module full_B() stellate_sym(
    [[p1, p2, pls(p1), pls(p2), mns(p1), mns(p2)]]);

module full_C() stellate_sym(
    [[p3a, pls(p3a), mns(p3a)],
     [p3b, pls(p3b), mns(p3b)]]);

module full_D() stellate([[mns(p1), p4a, p4, pls(p4b)]]);

module full_E() stellate(
    [[mns(p2), p5a, pls(p5), mns(p5b)],
     [p6a, pls(p1), mns(p6b)],
        ]);

module full_F() stellate_sym(
    [[p6a, pls(p6a), mns(p6a)],
     [p6b, pls(p6b), mns(p6b)],
     each triple([p1, p7, pls(p1), mns(p1)]),
        ]);

module full_G() stellate_sym([[p7, pls(p7), mns(p7)]]);

module full_H() stellate(
    [[p8, p6a, p6b],
     [p8a, p7, p6a],
     [p8b, p6b, mns(p7)],
        ]);

module cell_e1() {
    $retrograde = true;
    stellate(
        [[p3a, p4a, p6a],
         [p6b, p4b, p3b],
         [p4, p3a, p2, pls(p3b)],
            ]);
}

module cell_f1a() {
    $retrograde = true;
    stellate(
        [[p6a, p5a, p3a],
         [p4a, p5, p6a],

         [p3b, p4b, p6b],
         [p5b, mns(p4), p3b],
            ]);
}

module cell_f1b() {
    $retrograde = true;
    stellate(
        [[p6a, p4a, p3a],
         [p3a, p4, p5a],
         [p6b, p5, p4b],
         [p3b, p5b, p6b],
            ]);
}

module cell_g1() {
    $retrograde = true;
    stellate(
        [[p6a, p5, p6b],
         [p3a, p5a, p6a],
         [p6b, p5b, p3b],
            ]);
}

module cell_e2() {
    $retrograde = true;
    stellate(
        [[p1, p4b, p5, p4a],
         [p1, p3a, p4a],
         [p4b, p3b, p1],
         [p5a, p4, p3a],
         [p3b, mns(p4), p5b],
            ]);
}

module cell_f2() {
    $retrograde = true;
    stellate
        ([
            [p4, p5a, p7, pls(p5b)],
            [p1, p4a, p5, p4b],
            ]);
}

module cell_g2() {
    $retrograde = true;
    stellate
        ([
            [p5a, p6a, p7],
            [mns(p7), p6b, p5b],
            [p7, p5a, p4, pls(p5b)],
            [p6a, p5, p4a],
            [p4b, p5, p6b],
            ]);
}

module c1() full_A();                   // Icosohedron.

module c2() full_B();             // Small triambic / first stellation / triakis

module c3() full_C();                   // Compound five octohedra

module c4() full_D();

module c5() full_E();

module c6() full_F();                   // Second stellation.

module c7()                             // Great.
    dodeca_spikey(post=-0.1) full_G();

module c8()                             // The mighty final stellation.
    icoso_top_bottom(radius8, spoke=-0.5, inset=5) full_H();

module c9() cell_e1();               // Twelfth stellation, spikes point joined.

module c10() {                          // Hex spike cage, face joins.
    cell_f1a();
    cell_f1b();
}

module c11() cell_g1();                 // Fourth stellation, point join.

module c12() {                          // Hex spike cage.
    cell_e1();
    cell_f1a();
    cell_f1b();
}

module c13() {                          // Dodec cage.
    cell_e1();
    cell_f1a();
    cell_f1b();
    cell_g1();
}

module c14() {                          // Dodec cage.
    cell_f1a();
    cell_f1b();
    cell_g1();
}

module c15() cell_e2();                 // Quint dimples, point join.

module c16() cell_f2();                 // Quint spikes, floating.

module c17() cell_g2();                 // Hex spikes, joined by points.

module c18() {                          // Quint spikes joined by points.
    cell_e2();
    cell_f2();
}

module c19() {                          // Hex spikes joined by points.
    cell_e2();
    cell_f2();
    cell_g2();
}

module c20() {                    // Fifth stellation, star spikes, point joins.
    cell_f2();
    cell_g2();
}

module c21() {                          // Seventh stellation, 20 hex spikes.
    full_D();
    cell_e1();
}

module c22() {                          // Ten tetrahedra.
    full_E();
    cell_f1a();
    cell_f1b();
}

module c23()                      // Sixth stellation.  Exc. dodec with spikes.
    dodeca_spikey() stellate([[pls(p7), p6b, p6a]]);    // F g1

module c24() {                          // Ten tetra, hollowed.
    full_D();
    cell_e1();
    cell_f1a();
    cell_f1b();
}

module c25() {                          // Sunken centers of exc. docec.
    full_D();
    cell_e1();
    cell_f1();
    cell_g1();
}

module c26()                            // Excavated dodec.
    dodeca_single(radius6) stellate([[p6a, p1, p6b]]); // E f1 g1

module c27() {                          // Excavated turrets.
    full_D();
    cell_e2();
}

module c28() {                          // Twelve big spikes, twenty small.
    full_E();
    cell_f2();
}

module c29() {          // Eighth stellation, great with mid-edge removed.
    full_F();
    cell_g2();
}

module c30()                    // Great triambic / medial triambic icosohedron.
    stellate([[p2, p3a, p7, pls(p3b)]]); // D e2 f2.

module c31() {                          // c29 but hollow.
    full_D();
    cell_e2();
    cell_f2();
    cell_g2();
}

module c32() {                          // c29 but hollow.
    full_E();
    cell_f2();
    cell_g2();
}

module c33() cell_f1a();                // Tenth stellation

module c34() {                          // Eleventh stellation, point touch.
    cell_e1();
    cell_f1a();
}

module c35() {                          // Quint cube with chunks removed.
    full_D();
    cell_e1();
    cell_f1a();
}

module c36() {                          // Only points touch.
    cell_f1a();
    cell_g1();
}

module c37() {                          // Fourteenth stellation, dodec cage.
    cell_e1();
    cell_f1a();
    cell_g1();
}

module c38() {                          // Exc. dodec with chunks out.
    full_D();
    cell_e1();
    cell_f1a();
    cell_g1();
}

module c39() {                          // Dodec cage, point join.
    cell_f1a();
    cell_g1();
}

module c40() {                          // Twelve hex spikes, hollow.
    cell_e1();
    cell_f1a();
    cell_g2();
}

module c41() {                          // Twelve hex spikes, chunks out.
    full_D();
    cell_e1();
    cell_f1a();
    cell_g2();
}

module c42() {                          // Hex spikes, point join.
    cell_f1a();
    cell_f2();
    cell_g2();
}

module c43() {                          // Hex spikes, hollow.
    cell_e1();
    cell_f1a();
    cell_f2();
    cell_g2();
}

module c44() {                          // Hex spikes, chunks out.
    full_D();
    cell_e1();
    cell_f1a();
    cell_f2();
    cell_g2();
}

module c45() {                          // Fifteenth stellation
    cell_e2();
    cell_f1a();
}

module c46() {                          // Hollow hex spikes, solid support.
    full_D();
    cell_e2();
    cell_f1a();
}

// E f1
module c47()
    icoso_top_bottom(radius6, spoke=-0.94, inset=18, jangle=36.4)
    stellate_sym([[p6a, pls(p6a), mns(p6a)]]); // Five tetrahedra.

module c48() {                          // Hollowed chiral exc. dodec.
    cell_e2();
    cell_f1a();
    cell_g1();
}

module c49() {                          // Exc. dodec, hollow spikes, solid.
    full_D();
    cell_e2();
    cell_f1a();
    cell_g1();
}

module c50() {                          // Exc. dodec, chiral chunks out.
    full_E();
    cell_f1a();
    cell_g1();
}

module c51() {                          // Thirteenth stellation
    cell_e2();                          // Spikes with crazy point joins.
    cell_f1a();
    cell_f2();
}

module c52() {                          // 12 + 20 spikes, some hollow.
    full_D();
    cell_e2();
    cell_f1a();
    cell_f2();
}

module c53() {                          // No retro, crazy!
    full_E();
    cell_f1a();
    cell_f2();
}

module c54() {                          // Spikes with joiners.
    cell_e2();
    cell_f1a();
    cell_f2();
    cell_g1();
}

module c55() {                          //12 + 20 spikes, some hollow.
    full_D();
    cell_e2();
    cell_f1a();
    cell_f2();
    cell_g1();
}

module c56() {                          // Chiral exc. dodec with spikes.
    full_E();
    cell_f1a();
    cell_f2();
    cell_g1();
}

module c57() {                          // Hex spikes, point join.
    cell_e2();
    cell_f1a();
    cell_f2();
    cell_g2();
}

module c58() {                          // Hex spikes, crossed-edge join.
    full_D();
    cell_e2();
    cell_f1a();
    cell_f2();
    cell_g2();
}

module c59() {                          // Hex spikes, chunks out.
    full_E();
    cell_f1a();
    cell_f2();
    cell_g2();
}

module dodeca_single(raw_radius) {
    if (piece == 0) {
        children();
    }
    else if (piece == 1) {
        difference() {
            translate([0,0,-extra_z_remove])
                dodeca_pointup(raw_radius) children();
            if (extra_z_remove > 0)
                translate([0,0,-1.1 * radius]) cube(2.2 * radius, center=true);
        }
    }
}

module dodeca_spikey(post=0.1, inset=0) {
    echo("RCL", post);
    if (piece == 0) {
        children();
    }
    else if (piece == 1) {
        difference() {
            translate([0,0,-1e-3 - extra_z_remove])
                dodeca_pointup(radius7, post=post, inset=inset) children();
            translate([0,0,-1.1 * radius]) cube(2.2 * radius, center=true);
        }
    }
    else if (piece == 2) {
        difference() {
            translate([0,0,-1e-3 - extra_z_remove]) rotate([0,180,0])
                dodeca_pointup(radius7, post=post, inset=inset) children();
            translate([0,0,-1.1 * radius]) cube(2.2 * radius, center=true);
        }
    }
}

module icoso_top_bottom(raw_radius, spoke=0, inset=5, jangle=0) {
    if (piece == 0) {
        children();
    }
    else if (piece == 1) {
        difference() {
            translate([0, 0, -1e-5])
                icoso_tb_whole(raw_radius, spoke, inset, jangle)
                children();
            translate([0, 0, -radius * 1.1]) cube(radius * 2.2, center=true);
        }
    }
    else if (piece == 2) {
        difference() {
            translate([0, 0, -1e-5]) rotate([0,180,0])
                icoso_tb_whole(raw_radius, spoke, inset, jangle)
                children();
            translate([0,0, -radius * 1.1]) cube(radius * 2.2, center=true);
        }
    }
}

module icoso_tb_whole(raw_radius, spoke, inset, jangle) {
    offset = (1 + gold) / ico_scale;
    difference() {
        scale(radius / raw_radius)
            translate([0, 0, offset]) children();
        if (spoke != 0) {                    // Spoke joiners.
            for (i = [0:2])
                rotate(120 * i + jangle)
                    rotate([0, 90 * sign(spoke), 0]) cylinder(
                    r=1.1, h=abs(spoke) * radius - inset);
        }
    }
}

// Rotate so an icoshedral point is upwards.
module pointup() {
    c = 2 / sqrt(3 * gold + 6);
    s = (gold + 1) / sqrt(3 * gold + 6);
    multmatrix([[s, 0, c, 0], [0, 1, 0, 0], [-c, 0, s, 0]]) children();
}

// Position so the 6a, 6b dodecahedron is resting on the x-y plane.
module dodeca_pointup(raw_radius, post, inset) {
    c = 2 / sqrt(3 * gold + 6);
    s = (gold + 1) / sqrt(3 * gold + 6);
    echo(post)
    difference() {
        scale(radius / raw_radius)
            multmatrix([[s, 0, c, 0], [0, 1, 0, 0], [-c, 0, s, s * radius6]])
            children();
        if (post != 0) {
            for (i = [0:4]) {
                rotate(72 * i + 90 * sign(post) - 90)
                    translate([abs(post) * radius, 0, 0])
                    # cylinder(r=1.15, h=20, center=true);
            }
        }
    }
}
