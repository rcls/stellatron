
gold = (1 + sqrt(5)) / 2;
// 0 = raw object, 1... = printable, 10 = stand.
piece = 1;

c13();

// e1 has axial points. (hex points)
// e2 has axial edge pairs. (rhombus prisms with point not underneath)
// f1a is wedgy.
// f2 has axial points.  (pentagonal spikes)
// g1 is wedgy.
// g2 is hollow pentagram spikes, made from wedges, should be ok.

radius = 65; // * (1 + 2 * gold) / 2.3839634168752983;

// When slicing, remove this much extra in the z direction.
extra_z_remove=0.0;

$fn=20;

function mirror(p) = [p.x, p.z, p.y];
function pls(p) = [p.z, p.x, p.y];
function mns(p) = [p.y, p.z, p.x];

function sum(v, n=0) = n + 1 < len(v) ? v[n] + sum(v, n + 1) : v[n];

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

function u_apply(tri, p) = tri[0] * p[0] + tri[1] * p[1] + tri[2] * p[2];

function apply(tri, p) = canonv(u_apply(tri, p));

// NUMERIC CANONICALIZATION - exact Q(ϕ) representation.

// A table of the fractional parts of point co-ordinates, along with
// decomposition in Q(ϕ).
value_table = [
    [-0.4 * gold + 0.2, -0.4, 0.2], // -0.44721359549995804
    [1.0 * gold + -2.0, 1.0, -2.0], // -0.3819660112501051
    [-1.2 * gold + 1.6, -1.2, 1.6], // -0.3416407864998736
    [-7.0 * gold + 11.0, -7.0, 11.0], // -0.3262379212492643
    [-0.5 * gold + 0.5, -0.5, 0.5], // -0.30901699437494745
    [6.0 * gold + -10.0, 6.0, -10.0], // -0.2917960675006306
    [0.2 * gold + -0.6, 0.2, -0.6], // -0.27639320225002095
    [-2.0 * gold + 3.0, -2.0, 3.0], // -0.2360679774997898
    [0.5 * gold + -1.0, 0.5, -1.0], // -0.19098300562505255
    [-0.6 * gold + 0.8, -0.6, 0.8], // -0.1708203932499368
    [3.0 * gold + -5.0, 3.0, -5.0], // -0.1458980337503153
    [-1.0 * gold + 1.5, -1.0, 1.5], // -0.1180339887498949
    [0.8 * gold + -1.4, 0.8, -1.4], // -0.10557280900008381
    [-5.0 * gold + 8.0, -5.0, 8.0], // -0.09016994374947451
    [-1.4 * gold + 2.2, -1.4, 2.2], // -0.06524758424985233
    [-0.0 * gold + -0.0, -0.0, -0.0], // 0.0
    [1.4 * gold + -2.2, 1.4, -2.2], // 0.06524758424985233
    [5.0 * gold + -8.0, 5.0, -8.0], // 0.09016994374947451
    [-0.8 * gold + 1.4, -0.8, 1.4], // 0.10557280900008381
    [1.0 * gold + -1.5, 1.0, -1.5], // 0.1180339887498949
    [-3.0 * gold + 5.0, -3.0, 5.0], // 0.1458980337503153
    [0.6 * gold + -0.8, 0.6, -0.8], // 0.1708203932499368
    [-0.5 * gold + 1.0, -0.5, 1.0], // 0.19098300562505255
    [2.0 * gold + -3.0, 2.0, -3.0], // 0.2360679774997898
    [-0.2 * gold + 0.6, -0.2, 0.6], // 0.27639320225002095
    [-6.0 * gold + 10.0, -6.0, 10.0], // 0.2917960675006306
    [0.5 * gold + -0.5, 0.5, -0.5], // 0.30901699437494745
    [7.0 * gold + -11.0, 7.0, -11.0], // 0.3262379212492643
    [1.2 * gold + -1.6, 1.2, -1.6], // 0.3416407864998736
    [-1.0 * gold + 2.0, -1.0, 2.0], // 0.3819660112501051
    [0.4 * gold + -0.2, 0.4, -0.2], // 0.44721359549995804
    ];

for (i = [1 : len(value_table) - 1])
    assert(value_table[i-1][0] < value_table[i][0]);

for (v = value_table)
    assert(abs(v[0] - gold * v[1] - v[2]) < 1e-7);

function canon_find(v, m, p) =
    let (n = floor((m + p) / 2))
    p - m <= 1 ? m : (
        v <= value_table[n][0] ? canon_find(v, m, n) : canon_find(v, n, p));

function canon(v) =
    let (rv = round(v),
         fv = v - rv,
         m = canon_find(fv, 0, len(value_table) - 1),
         mid = (value_table[m][0] + value_table[m+1][0]) / 2,
         mm = fv < mid ? m : m + 1,
         pp = value_table[mm][1],
         ii = value_table[mm][2],
         recalc = pp * gold + (rv + ii))
    assert(abs(recalc - v) < 1e-7)
    recalc;

function canonv(v) = [for (x = v) canon(x)];
function canonvv(vv) = [for (v = vv) canonv(v)];

echo("Canon", gold, canon(gold));

// PLAIN ICOSOHEDRON

ico_faces_edged1 = [
     [[-1, 0, gold], [ 1, 0, gold], [0, -gold, 1]],
     [[ 1, 0, gold], [-1, 0, gold], [0,  gold, 1]]];
ico_faces_edged = [ for (f = ico_faces_edged1)
        each [f, [for (v = f) pls(v)], [for (v = f) mns(v)]]];
ico_faces_oct = [
    for (sx = [-1, 1]) for (sy = [-1, 1]) [
        [sx, 0, sx * sy * gold], [0, sy * gold, sx * sy], [sx * gold, sy , 0]]];
ico_faces_half = [ each ico_faces_edged, each ico_faces_oct ];
ico_faces = [
    each ico_faces_half,
    for (f = ico_faces_half) [-f[2], -f[1], -f[0]] ];
assert(len(ico_faces) == 20);

// STELLATION LIBRARY

module wedge(tri, stellation, anchor=[0, 0, 0]) {
    d = stellation[1] - stellation[0];
    e = stellation[2] - stellation[1];
    cross_sum = d.y * e.z - d.z * e.y
        +       d.z * e.x - d.x * e.z
        +       d.x * e.y - d.y * e.x;

    points = [
        u_apply(tri, anchor),
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

// Radius to points with the vertex definitions above.
ico_scale = sqrt(2 + gold);

module stellate_sym(stellations) {
    for (f = ico_faces)
        wedges(f, stellations);
}

module stellate(stellations) {
    stellate_sym([ for (s = stellations) each triple(s) ]);
}

module stellate1(stellation, weights=[], normal=0) {
    anchorw = len(weights) == 0 ? [0,0,0] :
        sum([for (i = [0:len(weights)-1]) weights[i] * stellation[i]])
        / sum(weights);
    anchorn = normal * p0;
    anchor = anchorw + anchorn;
    for (f = ico_faces) {
        wedge(f, stellation, anchor);
        wedge(pls(f), stellation, anchor);
        wedge(mns(f), stellation, anchor);
    }
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
    [[p3a, p4a, p6a],
     [p6b, p4b, p3b],
     [p5a, p4, p3a],
     [p3b, mns(p4), p5b],
     [p1, p4b, p5, p4a]]);

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
    stellate1([p3a, p4a, p6a], weights=[1, 1, 0], normal=-0.7);
    stellate1([p6b, p4b, p3b], weights=[0, 1, 1], normal=-0.7);
    stellate1([p4, p3a, p2, pls(p3b)], weights=[1], normal=1);
}

module cell_f1a() {
    stellate1([p6a, p5a, p3a], weights=[1, 4, 4], normal=-1/4);
    stellate1([p4a, p5, p6a], weights=[1, 1, 0], normal=-1/5);
    stellate1([p3b, p4b, p6b], weights=[1, 1, 1], normal=1/7);
    stellate1([p5b, mns(p4), p3b], weights=[1, 1, 0], normal=1/2);
}

module cell_f1b() scale(-1) cell_f1a();

module cell_g1() {
    stellate1([p6a, p5, p6b], weights=[1,4,1], normal=-0.48);
    stellate1([p3a, p5a, p6a], weights=[-2,5,0], normal=0.8);
    stellate1([p6b, p5b, p3b], weights=[0,5,-2], normal=0.8);
}

module cell_e2() {
    stellate1([p1, p4b, p5, p4a], weights=[1,0,4,0], normal=-0.3);
    stellate1([p5a, p4, p3a], weights=[1,2,3], normal=-0.55);
    stellate1([p3b, mns(p4), p5b], weights=[3,2,1], normal=-0.55);

    stellate1([p1, p3a, p4a], weights=[1,4,1], normal=0.33);
    stellate1([p4b, p3b, p1], weights=[1,4,1], normal=0.33);
}

module cell_f2() {
    stellate1([p4, p5a, p7, pls(p5b)], weights=[1,0,0,0], normal=-1);
    stellate1([p1, p4a, p5, p4b], weights=[1,0,1,0], normal=1.5);
}

module cell_g2() {
    stellate1([p5a, p6a, p7], weights=[6,2,1], normal=-0.75);
    stellate1([mns(p7), p6b, p5b], weights=[1,2,6], normal=-0.75);

    stellate1([p7, p5a, p4, pls(p5b)], weights=[1,0,6,0], normal=1 /100);
    stellate1([p6a, p5, p4a], weights=[1,1,1], normal=1.2);
    stellate1([p4b, p5, p6b], weights=[1,1,1], normal=1.2);
}

module c1()                             // Icosohedron.
    if (piece == 0)
        full_A();
    else if (piece == 1)
        icoso_tb_whole(radius1) full_A();

module c2() full_B();             // Small triambic / first stellation / triakis

module c3() full_C();                   // Compound five octohedra

module c4() full_D();

module c5() full_E();

module c6() full_F();                   // Second stellation.

module c7()                             // Great.
    dodeca_spikey(post=0.1) full_G();

module c8()                             // The mighty final stellation.
    icoso_top_bottom(radius8, post=-0.25, spoke=0.5, inset=5) full_H();

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

module c14() {                          // Dodec cage, edge joins.
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
    icoso_top_bottom(raw_radius=radius7, post=-1/3, inset=5)
    stellate([[pls(p7), p6b, p6a]]);    // F g1

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

module c47()                            // Five tetrahedra.
    icoso_top_bottom(radius6, spoke=-0.94, inset=18, jangle=96.4)
    stellate_sym([[p6a, pls(p6a), mns(p6a)]]); // E f1a

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

module icoso_top_bottom(raw_radius, spoke=0, inset=5, jangle=0, post=0) {
    if (piece == 0) {
        children();
    }
    else if (piece == 1) {
        difference() {
            translate([0, 0, -1e-3])
                icoso_tb_whole(raw_radius, spoke, inset, jangle, post)
                children();
            translate([0, 0, -radius * 1.1]) cube(radius * 2.2, center=true);
        }
    }
    else if (piece == 2) {
        difference() {
            translate([0, 0, -1e-3]) rotate([0,180,0])
                icoso_tb_whole(raw_radius, spoke, inset, jangle, post)
                children();
            translate([0,0, -radius * 1.1]) cube(radius * 2.2, center=true);
        }
    }
}

module icoso_tb_whole(raw_radius, spoke = 0, inset, jangle, post) {
    offset = sqrt(1/3 + 2 / 3 / sqrt(5)) * ico_scale;
    difference() {
        scale(radius / raw_radius / ico_scale)
            translate([0, 0, offset]) faceup() children();
        if (spoke != 0) {                    // Spoke joiners.
            for (i = [0:2])
                # rotate(120 * i + jangle)
                    rotate([0, 90, 0]) cylinder(
                    r=1.1, h=spoke * radius - inset);
        }
        if (post != 0)
            for (i = [0:2])
                # rotate(120 * i + jangle)
                translate([radius * post - inset * sign(post), 0, 0])
                    cylinder(r=1.15, h=20, center=true);
    }
}

// Rotate so an icoshedral face is upwards.  Rotate by half the dodecahedron
// dihedral angle.
module faceup() {
    c = sqrt(1/2 - sqrt(5) / 6);
    s = sqrt(1/2 + sqrt(5) / 6);
    multmatrix([[c, 0, s, 0], [0, 1, 0, 0], [-s, 0, c, 0]]) children();
}

// Position so the 6a, 6b dodecahedron is resting on the x-y plane.
module dodeca_pointup(raw_radius, post=0, inset=0) {
    // Rotate by half the icosohedron dihedral angle.
    c = sqrt(1/2 + 1/(2 * sqrt(5)));
    s = sqrt(1/2 - 1/(2 * sqrt(5)));
    magic = sqrt(1/3 + 2/15 * sqrt(5));
    echo(magic);
    echo(post);
    difference() {
        scale(radius / raw_radius / ico_scale)
            multmatrix([[c, 0, s, 0],
                        [0, 1, 0, 0],
                        [-s, 0, c, radius6 * magic * ico_scale]])
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
