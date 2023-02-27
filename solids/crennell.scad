// ICOSAHEDRAL STELLATIONS.

include <numbers.scad>
use <functions.scad>

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

// Center of a face.
p0 = [1, 1, 1] / 3;

//1	0	0	6	1
p1 = [1, 0, 0];

//0.4+0.2ϕ	0.4+0.2ϕ	0.2-0.4ϕ	1	0.2+0.6ϕ
p2 = [2 + gold, 2 + gold, 1 - 2 * gold] / 5;

//0.5+0.5ϕ	-0.5ϕ	0.5	3	(1+ϕ)/√2
p3a = [1 + gold, 1, -gold] / 2;
p3b = mirror(p3a);

//1	1	-1	1	2
p4 = [1, 1, -1];

//1ϕ	1-1ϕ	0	1	2
p4a = [gold, 0, 1 - gold];
p4b = mirror(p4a);

//0.6+0.8ϕ	0.2-0.4ϕ	0.2-0.4ϕ	1	0.4+1.2ϕ
p5 = [3 + 4 * gold, 1 - 2 * gold, 1 - 2 * gold] / 5;

//0.8+0.4ϕ	-0.2-0.6ϕ	0.4+0.2ϕ	1	0.4+1.2ϕ
p5a = [4 + 2 * gold, 2 + gold, -1 - 3*gold] / 5;
p5b = mirror(p5a);

// 1+1ϕ	-1ϕ	0	10	(1+ϕ)√2
// Six planes meet.
p6a = [1 + gold, 0, -gold];
p6b = mirror(p6a);

// -1-2ϕ	1+1ϕ	1+1ϕ	6	2+3ϕ
// Five planes meet.
p7 = [1 + gold, 1 + gold, -1 - 2 * gold];

//-2-4ϕ	2+3ϕ	1+1ϕ	1	4+6ϕ
// Six of nine.
p8a = [2 + 3 * gold, 1 + gold, -2 - 4 * gold];
p8b = mirror(p8a);

// 3+4ϕ	-1-2ϕ	-1-2ϕ	1	4+6ϕ
// Three of nine.
p8 = [3 + 4 * gold, -1 - 2 * gold, -1 - 2 * gold];

// A mirror symmetry in the `x+y+z=1` plane.
function mirror(p) = [p.x, p.z, p.y];
// Positive rotation in the `x+y+z=1` plane.
function pls(p) = [p.z, p.x, p.y];
// Negative rotation in the `x+y+z=1` plane.
function mns(p) = [p.y, p.z, p.x];

function u_apply(tri, p) = tri[0] * p[0] + tri[1] * p[1] + tri[2] * p[2];

function apply(tri, p) = canonv(u_apply(tri, p));

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

module c3() scale(1/radius3_mm) full_C(); // Compound of five octohedra

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
