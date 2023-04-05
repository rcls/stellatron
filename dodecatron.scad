
include <numbers.scad>
use <functions.scad>
use <splitting.scad>

// Four rings of five, dodecahedral points.
A = [for (r = rotate5) canonv(r * [0, gold-1, gold])];
B = [for (r = rotate5) canonv(r * [-1, 1, 1])];
C = -B;
D = -A;

// Icosohedral points.
I0 = [1, 0, gold];
IA = [for (r = rotate5) canonv(r * [-1, 0, gold])];
IB = -IA;
I1 = -I0;

module dodecahedron() scale(1 / sqrt(3)) twelve() pyramid(A);

module final_dual()
    scale(1/sqrt(3)) pyramids(canonvvv(sixty([A[0], C[4], C[1]])));

// Generate the region of the final_dual() that is bounded by all the faces.
module final_dual_peanut() scale(1/sqrt(3))
        intersection_for (f = sixty([B[0], B[2], C[1]]))
        pyramid(f, -sum(f));

module great_stellated_dodecahedron()
    scale(1 / sqrt(3)) twelve() star_pyramid(B);

module great_dodecahedron()
    scale(1 / norm(I0)) for (f = twelve(IA)) pyramid(f);

module small_stellated_dodecahedron()
    scale(1 / norm(I0)) twelve() star_pyramid(IA);

module five_cubes() {
    cc = ["#8cf", "lightgreen", "yellow", "red", "orange"];
    for (i = [0:4])
        multmatrix(rotate5[i]) color(cc[i]) cube(2 / sqrt(3), center=true);
}

module dual_c28() scale(1 / sqrt(3)) {
    // Great isogonal icosidodecahedron.
    hex = [A[3], A[4], mns(A[3]), mns(A[4]), pls(A[3]), pls(A[4])];
    pyramids(canonvvv(twenty(hex)));
    color("lightgreen") pyramids(twelve(B));
}

module stella_octangular() scale(1 / sqrt(3)) {
    pyramids(four(triangle([1,1,-1])));
    color("green") pyramids(four(triangle([-1,-1,1])));
}

module stella_octangular_eighth() {
    scl = $radius / sqrt(3);
    joiners=[
        [[-2.5, -6], [-4.5, 8]],
        ];
    trapezohedron(triangle([scl, 0, 0]), [scl,scl,scl], $radius*0.2,
                  joiners=joiners);
}

color20 = "#5cf";                        // Light blue.
color12 = "gold";
color12b = "lightgreen";

module dodecadodecahedron() scale(0.5 / gold) {
    twelve() star_pyramid(cycle(A) + A);
    twelve() pyramid(A + B, topcolor=color12b);
}

module dodecadodecahedron_pieces() {
    scl = $radius / 2 / gold;
    P = scl * (A + cycle(A));
    Q = (gold - 1) * P + (2 - gold) * cycle(P, 2);
    star = [for (i = [0:4]) each [P[i], Q[i]]];

    joiners = [[[-10, 0]]];
    if ($piece == 1)
        translate([0, 0, norm(sum(P)/5)]) scale($radius) pointup()
            dodecadodecahedron();

    if ($piece == 2)
        trapezohedron(star, sum(P) / 5, $radius * 0.71,
                      joiners=joiners, span=2);

    if ($piece == 3)
        trapezohedron([P[0], mns(Q[0]), mns(P[0]), pls(Q[0]), pls(P[0]), Q[0]],
                      $radius * (2 - gold) * [1,1,1],
                      $radius * (2 - gold) * sqrt(3) - 1,
                      joiners=joiners, span=2);
}

module great_ditrigonal_icosidodecahedron() scale(1 / sqrt(3)) {
    twelve() pyramid(B, topcolor=color12);
    pyramids(canonvvv(twenty([A[2], A[0], B[1]])), topcolor=color20);
}

module small_ditrigonal_icosidodecahedron() scale(1 / sqrt(3)) {
    echo("SDI pentagram", norm(A[0] - A[2]) / norm(A[0]));
    // Dual to Small triambic icosahedron.
    twelve() star_pyramid(A, topcolor=color12);
    pyramids(canonvvv(twenty([A[2], A[0], B[1]])), topcolor=color20);
}

module small_ditrigonal_icosidodecahedron_piece() {
    scl = $radius / sqrt(3);
    P = (gold - 1) * A + (2 - gold) * cycle(A, 2);
    star = scl * [for (i = [0:4]) each [A[i], P[i]]];
    wedge = scl * [A[0], mns(P[1]), A[1], P[0]];
    wedge_c = (wedge[1] + wedge[3]) / 2;
    joiner = [[[-5.3,0]]];
    if ($piece == 2)
        trapezohedron(star, sum(star)/len(star),
                      $radius * inscribe - 7, joiners=joiner, span=2);

    else if ($piece == 3)
        trapezohedron(wedge, wedge_c, $radius * 0.75, joiners=joiner, span=2);
}

module ditrigonal_dodecadodecahedron() scale(1 / sqrt(3)) {
    // Dual to the Medial triambic icosahedron.  As this is a
    // dodecadodecahedron, lets use a different second color!
    twelve() star_pyramid(A, a=sum(A) / 10, topcolor=color12,
                          undercolor=color12b);
    twelve() star_pyramid(B, topcolor=color12b);
}

//stella_octangular_eighth();
//five_cubes();
//dodecadodecahedron();
//small_ditrigonal_icosidodecahedron();
//ditrigonal_dodecadodecahedron();
//great_ditrigonal_icosidodecahedron();
//flushtruncated_great_icosahedron();
//dual_c28();

//function one(x) = [x];
//pyramids(sixty([A[0], A[2], D[1]]));

module flushtruncated_great_icosahedron() scale(1 / sqrt(3)) {
    twelve() star_pyramid(A);
    hex = [A[3], A[4], mns(A[3]), mns(A[4]), pls(A[3]), pls(A[4])];
    color("lightgreen") pyramids(twenty(hex));
}
