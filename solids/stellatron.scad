// Crennell number of the object to print.
crennell = 46;
// Alternatively, you may replace `main();` below with the object you want.

// 0 = raw object, 1 = main printable, 2 = extra piece, 10 = stand.
piece = 1;

// The overall radius in mm from the center of the piece to its extremities.
radius = 65;
// Many of the dimensions below are scaled by the radius.

// When cutting into pieces, remove this much extra in the z direction (mm).
extra_z_remove=0;
// This may be helpful where you have edges touching the base plate.

// Depth in mm of the hole for post joiners.
post_depth=5;
// I use 10 for larger pieces, 5 for smaller ones where space is tight.

// For stands and joiners.
$fn=20;

// Ratio of inner over outer circumscribed radii of the icosahedron.  The
// dodecahedron has the same ratio!
inscribe = sqrt(1/3 + 2/15 * sqrt(5));
// Ratio of face radius to icosahedron radius.
coscribe = sqrt(2/3 - 2/15 * sqrt(5));

main();
//one_twelfth(radius6_mm) c46();;

module main() {
    if (crennell == 1) {
        if (piece == 0) c1();
        if (piece == 1) icosa_tb_whole() c1();
        // For the icosohedron, pieces 2..8 are scaled to match the interior
        // icosahedron of match other objects at the same radius.
        //if (piece == 2) icosa_tb_whole(radius2_mm) c1();
        //if (piece == 3) icosa_tb_whole(radius3_mm) c1();
        //if (piece == 4) icosa_tb_whole(radius4_mm) c1();
        //if (piece == 5) icosa_tb_whole(radius5_mm) c1();
        //if (piece == 6) icosa_tb_whole(radius6_mm) c1();
        //if (piece == 7) icosa_tb_whole(radius7_mm) c1();
        //if (piece == 8) icosa_tb_whole(radius8_mm) c1();
        if (piece == 2) one_twelfth(small=1/2,
                                    mid=radius1_mm*inscribe,
                                    top=radius1_mm*sqrt(inscribe)) c1();
        if (piece == 4) three_twelfths() c1();
        if (piece == 6) two_twelfths() c1();
    }
    if (crennell == 2) c2();
    if (crennell == 3) c3();
    if (crennell == 4) c4();
    if (crennell == 5) c5();
    if (crennell == 6) {
        icosa_top_bottom(post=-1/3) c6();
        stand_tripod(height=inscribe, strut=-1/ico_scale/6, base=radius/5) c6();
    }
    if (crennell == 7) {
        dodeca_spikey(post=0.1) c7();
        stand_pentapod(strut=-0.153) c7();
    }
    if (crennell == 8)
        icosa_top_bottom(post=-0.25, inset=3) c8();

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
        icosa_top_bottom(post=-1/3, inset=5) c23();
        stand_tripod(height=inscribe,strut=-1/ico_scale/6, base=radius/5) c23();
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
    if (crennell == 27) c27();
    if (crennell == 28) {
        icosa_top_bottom(post=-1/3, inset=10) c28();
        if (piece == 10)
            stand_quad(x=0.1, y=gold/10, height=gold/ico_scale) c28();
        stand_tripod(strut=gold-1.5, base=radius/5, height=inscribe, p=11)
            c28();
    }
    if (crennell == 29) c29();
    if (crennell == 30) {
        icosa_top_bottom(post=-radius4/radius7, inset=5) c30();
        stand_pentapod(strut=gold * 5 / 7 - 1, base=radius/4, hole=2)
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
        if (piece == 0) c46();
        if (piece == 1)
            one_twelfth() c46();;
        if (piece == 2)
            two_twelfths(big=radius6_mm + 1, small=radius2_mm/sqrt(3)) c46();
        stand_tripod(strut=-coscribe/radius6, hole=2) c46();
    }
    if (crennell == 47) {
        icosa_top_bottom(post=0.5, inset=5) c47();
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
}

// ICOSAHEDRAL STELLATION DIAGRAM

// This defines the points of the stellation diagram projected into the plane
// `x+y+z=1`.
//
// The diagram has a triangular symmetry, the set of points is closed under
// permutations of the co-ordinates.  This gives each point an orbit of size 3
// (if on axis), or 6 (if off axis) copies.
//
// We define only of the points ⅓, placing the largest coordinate first.
// Off-axis points get 'a' and 'b' copies with a mirror symmetry (exchanging `y`
// and `z`).
//
// The numbering is in order of increasing radial distance.  In some cases there
// are both on-axis and off-axis points at the same radius; these get the same
// numbers.

gold = (1 + sqrt(5)) / 2;

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

// Radius to icosahedron with the vertex definitions above.
ico_scale = sqrt(2 + gold);
// Actual radii in openscad units.
radius1_mm = ico_scale;
radius2_mm = radius2 * ico_scale;
radius3_mm = radius3 * ico_scale;
radius4_mm = radius4 * ico_scale;
radius5_mm = radius5 * ico_scale;
radius6_mm = radius6 * ico_scale;
radius7_mm = radius7 * ico_scale;
radius8_mm = radius8 * ico_scale;

// A mirror symmetry in the `x+y+z=1` plane.
function mirror(p) = [p.x, p.z, p.y];
// Positive rotation in the `x+y+z=1` plane.
function pls(p) = [p.z, p.x, p.y];
// Negative rotation in the `x+y+z=1` plane.
function mns(p) = [p.y, p.z, p.x];

function sum(v, n=0) = n + 1 < len(v) ? v[n] + sum(v, n + 1) : v[n];

function u_apply(tri, p) = tri[0] * p[0] + tri[1] * p[1] + tri[2] * p[2];

function apply(tri, p) = canonv(u_apply(tri, p));

// NUMERIC CANONICALIZATION - exact Q(ϕ) representation.
//
// The object vertexes all have co-ordinates in the form `q·ϕ + r` where `q` and
// `r` are rational, and `ϕ` is the golden ratio.
//
// We use an 'exact' representation for the points in question.  We keep a table
// of the expected values, and round calculated co-ordinates to the table.
//
// This keeps openscad happy: the shared vertexes, edges and faces are exactly
// shared.  This turns out to be easier than the usual procedure of slightly
// over-sizing an object to compensate for in-exact floating point arithmetic.

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

// Binary search helper on the `value_table`.
function canon_find(v, m, p) =
    let (n = floor((m + p) / 2))
    p - m <= 1 ? m : (
        v <= value_table[n][0] ? canon_find(v, m, n) : canon_find(v, n, p));

// Look up a value in the `value_table`.  If we don't get a good match, the
// barf.
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

// PLAIN ICOSAHEDRON

// The co-ordinates of each vertex is an even permutation of [0, ±1, ±ϕ].  The
// edges have length 2.

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

// STELLATION CELLS
//
// Following the wikipedia page notation somewhat.  `full_X` is a filled shape
// containing the origin.  `cell_x` is a "floating" object not containing the
// origin.  We use 'a' and 'b' suffixes for the 'f1' chiral pair.

// e1 has axial points. (hex points)
// e2 has axial edge pairs. (rhombus prisms with point not underneath)
// f1a is wedgy.
// f2 has axial points.  (pentagonal spikes)
// g1 is wedgy.
// g2 is hollow pentagram spikes, made from wedges, should be ok.

module full_A() stellate_sym([[p1, pls(p1), mns(p1)]]);

module full_B() stellate_sym(
    [[p1, p2, pls(p1), pls(p2), mns(p1), mns(p2)]]);

module full_C() stellate_sym(
    [[p3a, pls(p3a), mns(p3a)],
     [p3b, pls(p3b), mns(p3b)]]);

// TODO - split this up.
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
    stellate1([p6a, p5a, p3a], weights=[1, 4, 4], normal=-0.4);
    stellate1([p4a, p5, p6a], weights=[1, 2, 0], normal=-0.3);
    stellate1([p3b, p4b, p6b], weights=[7, 3, 1], normal=0.3);
    stellate1([p5b, mns(p4), p3b], weights=[1.3, 1, -1.1], normal=1.1);
}

module cell_f1b() mirror([0,0,1]) cell_f1a();

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

    stellate1([p7, p5a, p4, pls(p5b)], weights=[1,0,6,0], normal=1);
    stellate1([p6a, p5, p4a], weights=[1,1,1], normal=1.2);
    stellate1([p4b, p5, p6b], weights=[1,1,1], normal=1.2);
}

// THE STELLATIONS
//
// We use the Crennell numbering.

module c1() scale(1/radius1_mm) full_A(); // Icosahedron.

module c2()                      // Small triambic / first stellation / triakis.
    scale(1/radius2_mm) full_B();

module c3() scale(1/radius3_mm) full_C(); // Compound five octohedra

module c4() scale(1/radius4_mm) full_D();

module c5() scale(1/radius6_mm) full_E();

module c6() scale(1/radius7_mm) full_F(); // Second stellation.

module c7() scale(1/radius7_mm) full_G(); // Great.

module c8() scale(1/radius8_mm) full_H(); // The mighty final stellation.

module c9() scale(1/radius6_mm) cell_e1(); // Twelfth stellation, spikes point joined.

module c10() scale(1/radius6_mm) {      // Hex spike cage, edge joins.
    cell_f1a();
    cell_f1b();
}

module c11() scale(1/radius6_mm) cell_g1(); // Fourth stellation, point join.

module c12() scale(1/radius6_mm) {      // Hex spike cage, edge joins.
    cell_e1();
    cell_f1a();
    cell_f1b();
}

module c13() scale(1/radius6_mm) {      // Dodec cage.
    cell_e1();
    color("orange") cell_f1a();
    color("green") cell_f1b();
    cell_g1();
}

module c14() scale(1/radius6_mm) {      // Dodec cage, edge joins.
    cell_f1a();
    cell_f1b();
    cell_g1();
}

module c15() scale(1/radius5_mm) cell_e2(); // Quint dimples, point join.

module c16() scale(1/radius7_mm) cell_f2(); // Pentagonal spikes, floating.

module c17()                            // Hollow star spikes, joined by points.
    scale(1/radius7_mm) cell_g2();

module c18() scale(1/radius7_mm) {      // Star spikes joined by points.
    cell_e2();
    cell_f2();
}

module c19() {                    // Star spikes with two levels of point joins.
    scale(1/radius7_mm) {
        cell_e2();
        cell_f2();
        cell_g2();
    }
}

module c20() scale(1/radius7_mm)  // Fifth stellation, star spikes, point joins.
{
    cell_f2();
    cell_g2();
}

module c21() scale(1/radius6_mm) {
    // Seventh stellation, great dodecaisocron, 20 hex spikes.
    full_D();
    cell_e1();
}

module c22() scale(1/radius6_mm) {      // Ten tetrahedra.
    full_E();
    cell_f1a();
    cell_f1b();
}

// Sixth stellation.  Exc. dodec with spikes. F g1
module c23() scale(1/radius7_mm) stellate([[pls(p7), p6b, p6a]]);

module c24() scale(1/radius6_mm) {
    // Ten tetra, with chucks out, edge joins but looks printable.
    full_D();
    cell_e1();
    cell_f1a();
    cell_f1b();
}

module c25() scale(1/radius6_mm) {      // Sunken centers of exc. docec.
    full_D();
    cell_e1();
    cell_f1a();
    cell_f1b();
    cell_g1();
}

module c26() scale(1/radius6_mm)        // Excavated dodec., E f1 g1.
    stellate([[p6a, p1, p6b]]);

module c27() scale(1/radius5_mm) {      // Excavated turrets.
    full_D();
    cell_e2();
}

// Twelve big spikes, twenty small.  Compound of triambic icosahedron and
// seventh stellation.
module c28() scale(1/radius7_mm) {
    full_E();
    cell_f2();
}

module c29() scale(1/radius7_mm) {
    // Eighth stellation, great with mid-edge removed.
    full_F();
    cell_g2();
}

module c30()                    // Great triambic / medial triambic icosahedron.
     scale(1/radius7_mm) stellate([[p2, p3a, p7, pls(p3b)]]); // D e2 f2.

module c31() scale(1/radius7_mm) {      // c29 but with gaps.
    full_D();
    cell_e2();
    cell_f2();
    cell_g2();
}

module c32() scale(1/radius7_mm) {      // c29 but with gaps.
    full_E();
    cell_f2();
    cell_g2();
}

module c33() scale(1/radius6_mm) cell_f1a(); // Tenth stellation

module c34() scale(1/radius6_mm) {      // Eleventh stellation, point touch.
    cell_e1();
    cell_f1a();
}

module c35() scale(1/radius6_mm) {      // Quint cube with chunks removed.
    full_D();
    cell_e1();
    cell_f1a();
}

module c36() scale(1/radius6_mm) {      // Only points touch.
    cell_f1a();
    cell_g1();
}

module c37() scale(1/radius6_mm) {  // Fourteenth stellation, chiral dodec cage.
    cell_e1();
    cell_f1a();
    cell_g1();
}

module c38() scale(1/radius6_mm) {      // Exc. dodec with chiral chunks out.
    full_D();
    cell_e1();
    cell_f1a();
    cell_g1();
}

module c39() scale(1/radius6_mm) {      // Dodec cage, point join.
    cell_f1a();
    cell_g1();
}

module c40() scale(1/radius7_mm) {      // Twelve hex spikes, hollow.
    cell_e1();
    cell_f1a();
    cell_g2();
}

module c41() scale(1/radius7_mm) {      // Twelve hex spikes, chunks out.
    full_D();
    cell_e1();
    cell_f1a();
    cell_g2();
}

module c42() scale(1/radius7_mm) {      // Hex spikes, point join.
    cell_f1a();
    cell_f2();
    cell_g2();
}

module c43() scale(1/radius7_mm) {      // Hex spikes, hollow.
    cell_e1();
    cell_f1a();
    cell_f2();
    cell_g2();
}

module c44() scale(1/radius7_mm) {      // Hex spikes, chunks out.
    full_D();
    cell_e1();
    cell_f1a();
    cell_f2();
    cell_g2();
}

module c45() scale(1/radius6_mm) {
    // Fifteenth stellation, point join at dodec spike tips.
    cell_e2();
    cell_f1a();
}

module c46() scale(1/radius6_mm) {      // Hollow hex spikes, solid support.
    full_D();
    cell_e2();
    cell_f1a();
}

module c47() scale(1/radius6_mm)               // Five tetrahedra.
    stellate_sym([[p6a, pls(p6a), mns(p6a)]]); // E f1a

module c48() scale(1/radius6_mm) {      // Hollowed chiral exc. dodec.
    cell_e2();
    cell_f1a();
    cell_g1();
}

module c49() scale(1/radius6_mm) {      // Exc. dodec, hollow spikes, solid.
    full_D();
    cell_e2();
    cell_f1a();
    cell_g1();
}

module c50() scale(1/radius6_mm) {      // Exc. dodec, chiral chunks out.
    full_E();
    cell_f1a();
    cell_g1();
}

module c51() scale(1/radius7_mm) {      // Thirteenth stellation
    cell_e2();                          // Spikes with crazy point joins.
    cell_f1a();
    cell_f2();
}

module c52() scale(1/radius7_mm) {      // 12 + 20 spikes, some hollow.
    full_D();
    cell_e2();
    cell_f1a();
    cell_f2();
}

module c53() scale(1/radius7_mm) {      // No retro, crazy!
    full_E();
    cell_f1a();
    cell_f2();
}

module c54() scale(1/radius7_mm) {      // Spikes with joiners.
    cell_e2();
    cell_f1a();
    cell_f2();
    cell_g1();
}

module c55() scale(1/radius7_mm) {      // 12 + 20 spikes, some hollow.
    full_D();
    cell_e2();
    cell_f1a();
    cell_f2();
    cell_g1();
}

module c56() scale(1/radius7_mm) {      // Chiral exc. dodec with spikes.
    full_E();
    cell_f1a();
    cell_f2();
    cell_g1();
}

module c57() scale(1/radius7_mm) {      // Hex spikes, point join.
    cell_e2();
    cell_f1a();
    cell_f2();
    cell_g2();
}

module c58() scale(1/radius7_mm) {      // Hex spikes, crossed-edge join.
    full_D();
    cell_e2();
    cell_f1a();
    cell_f2();
    cell_g2();
}

module c59() scale(1/radius7_mm) {      // Hex spikes, chunks out.
    full_E();
    cell_f1a();
    cell_f2();
    cell_g2();
}

// PRINTING FORMS
//
// Convert the raw stellation to a printable object.  Normalise the scaling to a
// the exterior `radius`, divide into practical objects, and create guiding
// indentations for joining.

module dodeca_single() {
    if (piece == 0) {
        children();
    }
    if (piece == 1) {
        difference() {
            translate([0,0,-extra_z_remove])
                dodeca_pointup() children();
            if (extra_z_remove > 0)
                translate([0,0,-1.1 * radius]) cube(2.2 * radius, center=true);
        }
    }
}

module dodeca_spikey(post=0.1, inset=0) {
    if (piece == 0) {
        children();
    }
    if (piece == 1) {
        difference() {
            translate([0,0,-1e-3 - extra_z_remove])
                dodeca_pointup(radius7_mm, post=post, inset=inset) children();
            translate([0,0,-1.1 * radius]) cube(2.2 * radius, center=true);
        }
    }
    if (piece == 2) {
        difference() {
            translate([0,0,-1e-3 - extra_z_remove]) rotate([0,180,0])
                dodeca_pointup(radius7_mm, post=post, inset=inset) children();
            translate([0,0,-1.1 * radius]) cube(2.2 * radius, center=true);
        }
    }
}

module icosa_top_bottom(post=0, inset=5) {
    if (piece == 0) {
        children();
    }
    if (piece == 1) {
        difference() {
            translate([0, 0, -1e-3])
                icosa_tb_whole(post, inset)
                children();
            translate([0, 0, -radius * 1.1]) cube(radius * 2.2, center=true);
        }
    }
    if (piece == 2) {
        difference() {
            translate([0, 0, -1e-3]) rotate([0,180,0])
                icosa_tb_whole(post, inset)
                children();
            translate([0,0, -radius * 1.1]) cube(radius * 2.2, center=true);
        }
    }
}

module icosa_tb_whole(post=0, inset=0) {
    offset = inscribe * ico_scale;
    difference() {
        scale(radius)
            translate([0, 0, offset]) faceup() children();
        if (post != 0)
            for (i = [0:2])
                joiner_post(120 * i,
                            [radius * post - inset * sign(post), 0, 0]);
    }
}

// Rotate so an icoshedral face is upwards.  Rotate by half the icosahedron
// dihedral angle.
module faceup() {
    // This is actually the complement angle!
    c = sqrt(1/2 - sqrt(5) / 6);
    s = sqrt(1/2 + sqrt(5) / 6);
    multmatrix([[c, 0, s, 0], [0, 1, 0, 0], [-s, 0, c, 0]]) children();
}

// Rotate so an icosahedron point is upwards.  Rotate by half the dodecahedron
// dihedral sangle.
module pointup() {
    c = sqrt(1/2 + sqrt(5) / 10);
    s = sqrt(1/2 - sqrt(5) / 10);
    multmatrix([[c, 0, s, 0],
                [0, 1, 0, 0],
                [-s, 0, c, 0]])
        children();
}

// Position so the 6a, 6b dodecahedron is resting on the x-y plane, with an
// icosahedral point upper most.
module dodeca_pointup(post=0, inset=0) {
    difference() {
        scale(radius)
            translate([0, 0, radius6_mm * inscribe])
            pointup()
            children();
        if (post != 0) {
            for (i = [0:4]) {
                joiner_post(72 * i + 90 * sign(post) - 90,
                            [abs(post) * radius, 0, 0]);
            }
        }
    }
}

// Given a point in a constant x+y+z plane, and a faceup object, rotate around
// the z axis to get the image of the point at a 'y' position.
module align_rot(point) {
    flat = point - (point.x + point.y + point.z) / 3 * [1,1,1];
    unit = flat / norm(flat);
    c = unit * [2, -1, -1] / sqrt(6);
    s = unit * [0, -1, 1] / sqrt(2);

    multmatrix([[c, s, 0, 0], [-s, c, 0, 0], [0, 0, 1, 0]]) children();
}

// Slice off 3/12 of a dodechedron, a cluster of 3 faces arranged in a triangle.
module three_twelfths() {
    q1 = [-gold, 0, 1 - gold];
    q2 = [-1, 1, -1];
    q3 = [1 - gold, gold, 0];
    q4 = [-1, 1, 1];
    q5 = [0, gold - 1, gold];
    q6 = [0, 1 - gold, gold];
    q7 = [-1, -1, 1];
    q8 = [1 - gold, -gold, 0];
    q9 = [-1, -1, -1];
    intersection() {
        scale(20) polyhedron(
            points=
            [[0,0,0], q1, q2, q3, q4, q5, q6, q7, q8, q9, [-gold, 0, gold - 1]],
            faces=[
                for (i = [1:9]) [(i % 9) + 1, i, 0],
                                    for (i = [1:9]) [i, (i % 9) + 1, 10]]
            );
        children();
    }
    for (v = [q1,q2,q3,q4,q5,q6,q7,q8,q9]) {
        translate(v) sphere(r=0.1);
    }
    //color("green") sphere(0.1);
    //translate([0, 1 - gold, gold]) color("red") sphere(0.1);
}

// Slice off 2/12 of a dodecahedron towards a square, two faces joined by an
// edge.
module two_twelfths(big=10, small = 1, inset=7) {
    q0 = [0, gold-1, gold];
    q1 = [1, 1, 1];
    q2 = [gold, 0, gold-1];
    q3 = [1, -1, 1];
    q4 = [0, 1-gold, gold];
    q5 = [-1, -1, 1];
    q6 = [-gold, 0, gold-1];
    q7 = [-1, 1, 1];
    q = [q0, q1, q2, q3, q4, q5, q6, q7];
    sq = (gold - 1) * small;
    sc = radius;
    difference() {
        scale(sc) translate([0, 0, -sq]) intersection() {
            polyhedron(
                points=[
                    for (v = q) small * v,
                    [sq, sq, sq], [sq, -sq, sq], [-sq, -sq, sq], [-sq, sq, sq],
                    for (v = q) big * v
                    ],
                faces=[
                    [12, 13, 14, 15, 16], [16, 17, 18, 19, 12], [11, 10, 9, 8],
                    for (i = [0:7]) [i, (i+1) % 8, (i+1) % 8 + 12, i + 12],
                                        for (i = [0:3]) each [
                                            [(i*2+1), i*2, i+8],
                                            [(i*2+2)%8, i*2+1, i+8],
                                            [i*2, (i+3)%4 + 8, i+8]],
                    ]
                );
            children();
        }
        translate([sq * sc, 0, 0]) tripost();
        rotate(180) translate([sq * sc, 0, 0]) tripost();
        translate([0, sq * sc, 0]) rotate(90) rotate([0, -90, 0]) tripost();
        translate([0, -sq * sc, 0]) rotate(90) rotate([0, -90, 0]) tripost();
    }

    module tripost() {
        v1 = [0, sq * sc];
        v2 = [0, -sq * sc];
        v3 = [sq * sc * gold, 0];
        centroid = (v1 + v2 + v3) / 3;
        for (v = [v1, v2, v3]) {
            d = v - centroid;
            joiner_post(0, v - inset / norm(d) * d);
        }
    }
}

// Slice off 1/12 of a dodecahedron.
module one_twelfth(big=1.1/inscribe,
                   top=radius3_mm, mid=radius2_mm, small = 1/4,
                   inset=4) {
    q0 = [0, 1-gold, gold];
    q1 = [-1, -1, 1];
    q2 = [-gold, 0, gold-1];
    q3 = [-1, 1, 1];
    q4 = [0, gold-1, gold];
    q = [q0, q1, q2, q3, q4];
    translate([0, 0, -small * radius * inscribe]) difference() {
        pointup() {
            intersection() {
                scale(radius / sqrt(3)) polyhedron(
                    points=[
                        for (v = q) small * v,
                        for (v = q) big * v],
                    faces = [
                        [0, 1, 2, 3, 4],
                        [9, 8, 7, 6, 5],
                        for (i = [0:4]) [i, (i + 4) % 5, (i + 4) % 5 + 5, i + 5]
                        ]);
                scale(radius) children();
            }
        }
        for (i = [0:4]) rotate(i * 72) pointup() post_set();
    }
    module post_set() {
        post_pair(radius * small + inset, 0);
        rmid = radius * mid;
        rtop = radius * top;
        level = rmid * cos(18) - inset/4;
        aside = rmid * sin(18) - inset;
        post_pair(level,  aside);
        post_pair(level, -aside);
        translate([0, 0, rtop - inset]) rotate([0, 90, 0])
            joiner_post(0, [0, 0, 0]);
        translate([0, aside, radius * small + inset]) rotate([0, 90, 0])
            joiner_post(0, [0, 0, 0]);
        translate([0, -aside, radius * small + inset]) rotate([0, 90, 0])
            joiner_post(0, [0, 0, 0]);
    }
    module post_pair(raise, aside) {
        translate([0, 0, raise]) {
            pointup() joiner_post(0, [0, aside, 0]);
            rotate(180) pointup() joiner_post(0, [0, aside, 0]);
        }
    }
}


module joiner_post(angle, position) {
    rotate(angle) translate(position) #cylinder(
        r=2.3 / 2, h=post_depth*2, center=true);
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
module stand_tripod(strut, strut_mm=0, thick=3, base=0,
                    length=1, height=1, align=[1, 0, 0], hole=0, p=10) {
    stand_generic(
        3, strut, strut_mm, thick, base, length, height, hole, p)
        align_rot(align) faceup() children();
}

module stand_pentapod(strut, strut_mm=0, thick=3, base=0,
                      length=1, height=1, hole=0, p=10) {
    stand_generic(
        strut, strut_mm, thick, base, length, height, hole, p)
        pointup() children();
}

module stand_generic(num, strut, strut_mm=0, thick=3, base=0,
                     length=1, height=1, hole=0, p=10) {
    if (piece == p) {
        strut_all = strut * radius + strut_mm;
        difference() {
            for (i = [1:num]) {
                rotate(i * 360 / num) translate([strut_all, 0, 0])
                    cylinder(r = thick, h=radius * length + 2);
            }
            # translate([0, 0, radius * height + 2])
                scale(radius) children();
        }
        minkowski() {
            difference() {
                cylinder(r=max(base, abs(strut_all) + thick),
                         h = 0.1, $fn=6 * $fn);
                if (hole > 0)
                    cylinder(r=hole + 1.9, h=1, center=true);
            }
            intersection() {
                sphere(r=1.9);
                translate([-3, -3, 0]) cube(6);
            }
        }
    }
}

module stand_quad(x, y, thick=3, length=1, height=1) {
    r = sqrt(x * x + y * y) * radius;
    difference() {
        for (c = [[x, y], [-x, y], [-x, -y], [x, -y]])
            translate([c.x * radius, c.y * radius, 0])
                cylinder(r = thick, h=radius * length + 2);
        #translate([0, 0, radius * height + 2])
        scale(radius) children();
    }
    minkowski() {
        cylinder(r=r+thick, h = 0.1, $fn=6 * $fn);
        intersection() {
            sphere(r=1.9);
            translate([-3, -3, 0]) cube(6);
        }
    }
}
