// ICOSAHEDRAL STELLATIONS.

use <functions.scad>
use <splitting.scad>
include <numbers.scad>

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
p3b = [p3a.x, p3a.z, p3a.y];

//1	1	-1	1	2
p4 = [1, 1, -1];

//1ϕ	1-1ϕ	0	1	2
p4a = [gold, 0, 1 - gold];
p4b = [p4a.x, p4a.z, p4a.y];

//0.6+0.8ϕ	0.2-0.4ϕ	0.2-0.4ϕ	1	0.4+1.2ϕ
p5 = [3 + 4 * gold, 1 - 2 * gold, 1 - 2 * gold] / 5;

//0.8+0.4ϕ	-0.2-0.6ϕ	0.4+0.2ϕ	1	0.4+1.2ϕ
p5a = [4 + 2 * gold, 2 + gold, -1 - 3*gold] / 5;
p5b = [p5a.x, p5a.z, p5a.y];

// 1+1ϕ	-1ϕ	0	10	(1+ϕ)√2
// Six planes meet.
p6a = [1 + gold, 0, -gold];
p6b = [p6a.x, p6a.z, p6a.y];

// -1-2ϕ	1+1ϕ	1+1ϕ	6	2+3ϕ
// Five planes meet.
p7 = [1 + gold, 1 + gold, -1 - 2 * gold];

//-2-4ϕ	2+3ϕ	1+1ϕ	1	4+6ϕ
// Six of nine.
p8a = [2 + 3 * gold, 1 + gold, -2 - 4 * gold];
p8b = [p8a.x, p8a.z, p8a.y];

// 3+4ϕ	-1-2ϕ	-1-2ϕ	1	4+6ϕ
// Three of nine.
p8 = [3 + 4 * gold, -1 - 2 * gold, -1 - 2 * gold];

// PLAIN ICOSAHEDRON

// The co-ordinates of each vertex is an even permutation of [0, ±1, ±ϕ].  The
// edges have length 2.
ico_faces = canonvvv(twenty(triangle([0, gold, 1])));

$ico_color = [["green", for (i=[1:12]) undef, "green", for (i=[14:19]) undef]];
five_colors = ["lightgreen", "orange", "#8cf", "yellow", "red"];

five_octa_color = [
    [
        "red", "green", "yellow", "blue", "orange",
        "red", "green", "yellow", "blue", "orange",
        "red", "green", "yellow", "blue", "orange",
        "red", "green", "yellow", "blue", "orange"],
    [
        "blue", "orange", "red", "green", "yellow",
        "green", "yellow", "blue", "orange", "red",
        "yellow", "blue", "orange", "red", "green",
        "orange", "red", "green", "yellow", "blue"],
    ];
// STELLATION LIBRARY

module wedge(tri, stellation, anchor=[0, 0, 0], c=undef) {
    cross_sum = cross(stellation[1] - stellation[0],
                      stellation[2] - stellation[1]) * [1,1,1];

    if (c)
        color(c) poly();
    else if (cross_sum >= 0)
        poly();
    else
        color("red") poly();
    // # for (p = stellation) translate(apply(tri, p)) sphere(0.1);
    //% translate(anchor) sphere(0.1);
    function apply(tri, p) = tri[0] * p[0] + tri[1] * p[1] + tri[2] * p[2];
    module poly()
        polyhedron(
            points=[
                apply(tri, anchor), for (p = stellation) canonv(apply(tri, p))],
            faces=[
                [each [1:len(stellation)]],
                [1, len(stellation), 0],
                for (i = [2:len(stellation)]) [i, i-1, 0],
                ],
            convexity=10);
}

module stellate_sym(stellations) {
    cl = len($ico_color);
    for (i = [0:len(stellations) - 1])
        for (j = [0:19])
            wedge(ico_faces[j], stellations[i], c = $ico_color[i%cl][j]);
}

module stellate(stellations) {
    stellate_sym(stellations);
    stellate_sym([for (s = stellations) mmns(s)]);
    stellate_sym([for (s = stellations) ppls(s)]);
}

module stellate1(stellation, weights=[], normal=0) {
    anchorw = len(weights) == 0 ? [0,0,0] :
        sum([for (i = [0:len(weights)-1]) weights[i] * stellation[i]])
        / sum(weights);
    anchorn = normal * p0;
    anchor = anchorw + anchorn;
    for (i = [0:19]) {
        f = ico_faces[i];
        wedge(f, stellation, anchor, c=$ico_color[0][i]);
        wedge([f.y, f.z, f.x], stellation, anchor, c=$ico_color[0][i]);
        wedge([f.z, f.x, f.y], stellation, anchor, c=$ico_color[0][i]);
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

module full_D() stellate(
    // Splitting the kite allows the use of 2 colours, e.g., c21.
    [[mns(p1), p4a, p4],
     [mns(p1), p4, pls(p4b)]]);

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
module full_e1() stellate([[p3a, p4a, p6a], [p6b, p4b, p3b]]);

module cell_f1a() {
    stellate1([p6a, p5a, p3a], weights=[1, 4, 4], normal=-0.4);
    stellate1([p4a, p5, p6a], weights=[1, 2, 0], normal=-0.3);
    stellate1([p3b, p4b, p6b], weights=[7, 3, 1], normal=0.3);
    stellate1([p5b, mns(p4), p3b], weights=[1.3, 1, -1.1], normal=1.1);
}

module cell_f1b() {
    stellate1([p3b, p5b, p6b], weights=[4, 4, 1], normal=-0.4);
    stellate1([p6b, p5, p4b], weights=[0, 2, 1], normal=-0.3);
    stellate1([p6a, p4a, p3a], weights=[1, 3, 7], normal=0.3);
    stellate1([p3a, p4, p5a], weights=[-1.1, 1, 1.3], normal=1.1);
}

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

module c1() scale(1/radius1) full_A();  // Icosahedron.

module c2()                      // Small triambic / first stellation / triakis.
    scale(1/radius2) full_B();

module c3() {                           // Compound of five octohedra
    $ico_color = cycles(five_colors, [[0, 0, 0, 0], [3, 1, 2, 4]]);
    scale(1/radius3) full_C();
}

module c4() scale(1/radius4) full_D();

module c5() scale(1/radius6) full_E();

module c6() scale(1/radius7) full_F();  // Second stellation.

module c7() scale(1/radius7) full_G();  // Great.

module c8() scale(1/radius8) full_H();  // The mighty final stellation.

module c9() scale(1/radius6) cell_e1(); // Twelfth stellation, hex spikes point joined.

module c10() scale(1/radius6) {         // Hex hollow spike cage, edge joins.
    cell_f1a();
    cell_f1b();
}

module c11() scale(1/radius6) cell_g1(); // Fourth stellation, point join.

module c12() scale(1/radius6) {         // Hex spike cage, edge joins.
    cell_e1();
    cell_f1a();
    cell_f1b();
}

module c13() scale(1/radius6) {         // Dodec cage.
    cell_e1();
    color("orange") cell_f1a();
    color("green") cell_f1b();
    cell_g1();
}

module c14() scale(1/radius6) {         // Dodec cage, edge joins.
    cell_f1a();
    cell_f1b();
    cell_g1();
}

module c15() scale(1/radius5) cell_e2(); // Quint dimples, point join.

module c16() scale(1/radius7) cell_f2(); // Pentagonal spikes, floating.

module c17()                            // Hollow star spikes, joined by points.
    scale(1/radius7) cell_g2();

module c18() scale(1/radius7) {         // Star spikes joined by points.
    cell_e2();
    cell_f2();
}

module c19() {                    // Star spikes with two levels of point joins.
    scale(1/radius7) {
        cell_e2();
        cell_f2();
        cell_g2();
    }
}

module c20() scale(1/radius7)     // Fifth stellation, star spikes, point joins.
{
    cell_f2();
    cell_g2();
}

module c21() scale(1/radius6) {
    // Seventh stellation, great dodecaisocron, 20 hex spikes.
    $ico_color = cycles(five_colors, [[3, 1, 2, 4], [0, 0, 0, 0]]);
    full_D();
    full_e1();
}

module c22() scale(1/radius6) {         // Ten tetrahedra.
    // We split the kite in two, and color, so it's easiest to skip the cell
    // definitions (E f1).
    $ico_color = cycles(five_colors, [[3, 1, 2, 4], [0, 0, 0, 0]]);
    stellate([
                 [p1, p5, p6a],
                 [p6b, p5, p1],
                 [p6a, p5a, p3a],
                 [p3b, p5b, p6b]
                 ]);
    color("grey") full_e1();
}

// Sixth stellation.  Exc. dodec with spikes. F g1
module c23() scale(1/radius7) stellate([[pls(p7), p6b, p6a]]);

module c24() scale(1/radius6) {
    // Ten tetra, with chucks out, edge joins but looks printable.
    full_D();
    cell_e1();
    cell_f1a();
    cell_f1b();
}

module c25() scale(1/radius6) {         // Sunken centers of exc. docec.
    full_D();
    cell_e1();
    cell_f1a();
    cell_f1b();
    cell_g1();
}

module c26() scale(1/radius6)           // Excavated dodec., E f1 g1.
    stellate([[p6a, p1, p6b]]);

module c27() scale(1/radius5) {         // Excavated turrets.
    full_D();
    cell_e2();
}

// Twelve big spikes, twenty small.  Compound of triambic icosahedron and
// seventh stellation.  Small enneagrammic icosohedron.
module c28() scale(1/radius7) {
    full_E();
    cell_f2();
}

module c29() scale(1/radius7) {
    // Eighth stellation, great with mid-edge removed.
    full_F();
    cell_g2();
}

module c30()                    // Great triambic / medial triambic icosahedron.
     scale(1/radius7) stellate([[p2, p3a, p7, pls(p3b)]]); // D e2 f2.

module c31() scale(1/radius7) {         // c29 but with gaps.
    full_D();
    cell_e2();
    cell_f2();
    cell_g2();
}

module c32() scale(1/radius7) {         // c29 but with small gaps.
    full_E();
    cell_f2();
    cell_g2();
}

module c33() scale(1/radius6) cell_f1a(); // Tenth stellation

module c34() scale(1/radius6) {         // Eleventh stellation, point touch.
    cell_e1();
    cell_f1a();
}

module c35() scale(1/radius6) {         // Quint cube with chunks removed.
    full_D();
    cell_e1();
    cell_f1a();
}

module c36() scale(1/radius6) {         // Only points touch.
    cell_f1a();
    cell_g1();
}

module c37() scale(1/radius6) {     // Fourteenth stellation, chiral dodec cage.
    cell_e1();
    cell_f1a();
    cell_g1();
}

module c38() scale(1/radius6) {         // Exc. dodec with chiral chunks out.
    full_D();
    cell_e1();
    cell_f1a();
    cell_g1();
}

module c39() scale(1/radius6) {         // Dodec cage, point join.
    cell_f1a();
    cell_g1();
}

module c40() scale(1/radius7) {         // Twelve hex spikes, hollow.
    cell_e1();
    cell_f1a();
    cell_g2();
}

module c41() scale(1/radius7) {         // Twelve hex spikes, chunks out.
    full_D();
    cell_e1();
    cell_f1a();
    cell_g2();
}

module c42() scale(1/radius7) {         // Hex spikes, point join.
    cell_f1a();
    cell_f2();
    cell_g2();
}

module c43() scale(1/radius7) {         // Hex spikes, hollow.
    cell_e1();
    cell_f1a();
    cell_f2();
    cell_g2();
}

module c44() scale(1/radius7) {         // Hex spikes, chunks out.
    full_D();
    cell_e1();
    cell_f1a();
    cell_f2();
    cell_g2();
}

module c45() scale(1/radius6) {
    // Fifteenth stellation, point join at dodec spike tips.
    cell_e2();
    cell_f1a();
}

module c46() scale(1/radius6) {         // Hollow hex spikes, solid support.
    full_D();
    cell_e2();
    cell_f1a();
}

module c47() {                          // Five tetrahedra.
    $ico_color = [cycles(["yellow", "pink", "red", "green", "purple"],
                         [3, 1, 2, 4])];
    scale(1/radius6) stellate_sym([[p6a, pls(p6a), mns(p6a)]]); // E f1a
}

module c48() scale(1/radius6) {         // Hollowed chiral exc. dodec.
    cell_e2();
    cell_f1a();
    cell_g1();
}

module c49() scale(1/radius6) {         // Exc. dodec, hollow spikes, solid.
    full_D();
    cell_e2();
    cell_f1a();
    cell_g1();
}

module c50() scale(1/radius6) {         // Exc. dodec, chiral chunks out.
    full_E();
    cell_f1a();
    cell_g1();
}

module c51() scale(1/radius7) {         // Thirteenth stellation
    cell_e2();                          // Spikes with crazy point joins.
    cell_f1a();
    cell_f2();
}

module c52() scale(1/radius7) {         // 12 + 20 spikes, some hollow.
    full_D();
    cell_e2();
    cell_f1a();
    cell_f2();
}

module c53() scale(1/radius7) {         // No hollows, crazy!
    $ico_color = [cycles(five_colors, [3, 1, 2, 4])];
    full_E();
    cell_f1a();
    cell_f2();
}

module c54() scale(1/radius7) {         // Spikes with joiners.
    cell_e2();
    cell_f1a();
    cell_f2();
    cell_g1();
}

module c55() scale(1/radius7) {         // 12 + 20 spikes, some hollow.
    full_D();
    cell_e2();
    cell_f1a();
    cell_f2();
    cell_g1();
}

module c56() scale(1/radius7) {         // Chiral exc. dodec with spikes.
    full_E();
    cell_f1a();
    cell_f2();
    cell_g1();
}

module c57() scale(1/radius7) {         // Hex spikes, point join.
    cell_e2();
    cell_f1a();
    cell_f2();
    cell_g2();
}

module c58() scale(1/radius7) {         // Hex spikes, crossed-edge join.
    full_D();
    cell_e2();
    cell_f1a();
    cell_f2();
    cell_g2();
}

module c59() scale(1/radius7) {         // Hex spikes, chunks out.
    full_E();
    cell_f1a();
    cell_f2();
    cell_g2();
}

module five_tetrahedron_twentieth() {
    tri = [[1, 0, gold], [gold, -1, 0], [0, -gold, 1]];
    function apply(p) = $radius / radius6 * canonv(tri[0] * p[0] + tri[1] * p[1] + tri[2] * p[2]);
    q4  = apply(p4);
    q4a = apply(p4a);
    q1  = apply(p1);
    q6a = apply(p6a);

    joiners=[[[-3, 0], [3, 0]], [], []];

    trapezohedron(
        [q4, q4a, q1, mns(q4), mns(q4a), mns(q1), pls(q4), pls(q4a), pls(q1)],
        q6a, 0.32 * $radius, joiners);
}

module five_octahedron_twentieth() {
    function apply(p) = $radius / radius3 * canonv(tri[0] * p[0] + tri[1] * p[1] + tri[2] * p[2]);
    tri = [[1, 0, gold], [gold, -1, 0], [0, -gold, 1]];
    q1 = apply(p1);
    q2 = apply(p2);
    q3a = apply(p3a);

    //color("red") indicate(rot5 * apply(p3b));
    trapezohedron(
        [q2, q1, rot5_4 * q2, pls(q1)],
        q3a, 0.5 * $radius,
        [[[-1.5, -5], [-3.5, 9.5]], [[-1.5, 5], [-3.5, -9.5]]]);
}
