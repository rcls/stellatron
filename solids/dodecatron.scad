
include <numbers.scad>
use <functions.scad>
//use <splitting.scad>

// The twenty points of the dodecahedron, and the origin.
gold1 = gold-1;

points = [
    [-gold, 0, 1-gold],
    [-gold, 0, gold-1],
    [-1, -1, -1],
    [-1, -1, 1],
    [-1, 1, -1],
    [-1, 1, 1],
    [1-gold, -gold, 0],
    [1-gold, gold, 0],
    [0, 1-gold, -gold],
    [0, 1-gold, gold],
    [0, 0, 0],
    [0, gold-1, -gold],
    [0, gold-1, gold],
    [gold-1, -gold, 0],
    [gold-1, gold, 0],
    [1, -1, -1],
    [1, -1, 1],
    [1, 1, -1],
    [1, 1, 1],
    [gold, 0, 1-gold],
    [gold, 0, gold-1],
    ];

assert(len(points) == 21);
assert(canonvv(points) == points);

for (i = [1 : len(points)-1]) {
    assert(points[i-1] < points[i]);
    assert(!(points[i] < points[i-1]));
}

function p_search(v, i, k) =
    let (j = floor((i + k) / 2))
    i + 1 != k ? v < points[j] ? p_search(v, i, j) : p_search(v, j, k) : i;

function P(v) =
    let (i = p_search(canonv(v), 0, len(points)))
    assert(norm(v - points[i]) < 1e-7)
    i;

function PP(vv) = [for (v = vv) P(v)];
function PPP(vvv) = [for (vv = vvv) PP(vv)];

// Create a polyhedron from a set of faces, exact co-ordinates.
module poly(faces) {
    polyhedron(points = points, faces = PPP(faces), convexity=100);
}

// Four rings of five, dodecahedral points.
A = [
    [0, 1-gold, -gold],
    [1, -1, -1],
    [gold, 0, 1-gold],
    [1, 1, -1,],
    [0, gold-1, -gold]
    ];
// Sum: [2 + ϕ, 0, -3ϕ - 1] = (2 + ϕ)[1, 0, -ϕ]

B = [
    [-1, -1, -1],
    [gold-1, -gold, 0],
    [gold, 0, gold-1],
    [gold-1, gold, 0],
    [-1, 1, -1]
    ];
C = -B;
D = -A;

for (i = [0:4]) {
    for (j = [0:4]) {
        assert(A[(i+j)%5] == canonv(rotate5[j] * A[i]));
        assert(B[(i+j)%5] == canonv(rotate5[j] * B[i]));
    }
}

// Icosohedral points.
I0 = [1, 0, -gold];
IA = [canonv(         [-1, 0, -gold]),
      canonv(rot5   * [-1, 0, -gold]),
      canonv(rot5_2 * [-1, 0, -gold]),
      canonv(rot5_3 * [-1, 0, -gold]),
      canonv(rot5_4 * [-1, 0, -gold])];
IB = -IA;
I1 = -I0;

module dodecahedron() scale(1/sqrt(3)) poly(twelve(A));

module final_dual()
    scale(1/sqrt(3)) pyramid_sixty([B[0], B[2], C[1]]);

// Generate the region of the final_dual() that is bounded by all the faces.
module final_dual_peanut() {
    scale(1/sqrt(3))
        intersection_for (f = sixty([B[0], B[2], C[1]]))
        pyramid(f, -sum(f));
}

// Too much self-intersection for openscad to handle!
module broken_final_dual() poly(sixty([B[0], B[2], C[1]]));

module great_stellated_dodecahedron()
    scale(1 / sqrt(3)) pyramid_sixty([B[0], B[2], sum(B) / 5]);

module great_dodecahedron()
    scale(1 / norm(I0)) for (f = twelve(IA)) pyramid(f);

module small_stellated_dodecahedron()
    scale(1 / norm(I0)) pyramid_sixty([IA[0], IA[2], sum(IA) / 5]);
