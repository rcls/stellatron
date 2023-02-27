
include <numbers.scad>
use <functions.scad>

// The twenty points of the dodecahedron, and the origin.
gold1 = gold-1;

points = [
    [-gold, 0, -gold1],
    [-gold, 0, gold1],
    [-1, -1, -1],
    [-1, -1, 1],
    [-1, 1, -1],
    [-1, 1, 1],
    [-gold1, -gold, 0],
    [-gold1, gold, 0],
    [0, -gold1, -gold],
    [0, -gold1, gold],
    [0, 0, 0],
    [0, gold1, -gold],
    [0, gold1, gold],
    [gold1, -gold, 0],
    [gold1, gold, 0],
    [1, -1, -1],
    [1, -1, 1],
    [1, 1, -1],
    [1, 1, 1],
    [gold, 0, -gold1],
    [gold, 0, gold1],
    ];

assert(len(points) == 21);
assert(canonvv(points) == points);

function near(a, b) = abs(a - b) < 1e-7;

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

function rx(v) = [v[0], -v[1], -v[2]];
function rrx(vv) = [for (v = vv) rx(v)];

function ry(v) = [-v[0], v[1], -v[2]];
function rry(vv) = [for (v = vv) ry(v)];

function pls(v) = [v[2], v[0], v[1]];
function ppls(vv) = [for (v = vv) pls(v)];

function mns(v) = [v[1], v[2], v[0]];
function mmns(vv) = [for (v = vv) mns(v)];

// Create a polyhedron from a set of faces, exact co-ordinates.
module poly(faces) {
    polyhedron(points = points, faces = PPP(faces), convexity=100);
}

// Four rings of five, dodecahedral points.
A = [
    [0, -gold1, -gold],
    [1, -1, -1],
    [gold, 0, -gold1],
    [1, 1, -1,],
    [0, gold1, -gold]
    ];
// Sum: [2 + ϕ, 0, -3ϕ - 1] = (2 + ϕ)[1, 0, -ϕ]

B = [
    [-1, -1, -1],
    [gold1, -gold, 0],
    [gold, 0, gold1],
    [gold1, gold, 0],
    [-1, 1, -1]
    ];
C = -B;
D = -A;

// Rotation matrix that maps A[i] -> A[i+1 mod 5] etc.
rot5 = [[1/2, -gold/2, -1/2/gold],
        [gold/2, 1/2/gold, 1/2],
        [-1/2/gold, -1/2, gold/2]];

for (i = [0:4]) {
    echo(A[(i+1)%5]);
    echo(canonv(rot5 * A[i]));
    assert(A[(i+1)%5] == canonv(rot5 * A[i]));
}

rot5_2 = rot5 * rot5;
rot5_3 = rot5_2 * rot5;
rot5_4 = rot5_2 * rot5_2;

// Icosohedral points.
I0 = [1, 0, -gold];
IA = [canonv(         [-1, 0, -gold]),
      canonv(rot5   * [-1, 0, -gold]),
      canonv(rot5_2 * [-1, 0, -gold]),
      canonv(rot5_3 * [-1, 0, -gold]),
      canonv(rot5_4 * [-1, 0, -gold])];
IB = -IA;
I1 = -I0;

// Give a face, generate 5 images, rotating about a dodec. face.
function five(f) = [
    f,
    [for (v = f) rot5   * v],
    [for (v = f) rot5_2 * v],
    [for (v = f) rot5_3 * v],
    [for (v = f) rot5_4 * v]];

// Given a face, generate twelve images.
function twelve(face) = let (
    f3 = [face, ppls(face), mmns(face)],
    f6 = [each f3, for (vv = f3) rrx(vv)])
    [each f6, for (vv = f6) rry(vv)];

// Given a face, generate 60 images, dodec. rotational symmetry.
function sixty(f) = [for (ff = five(f)) each twelve(ff)];

// Invert a face.
function invert(f) = [for (n = [1:len(f)]) -f[len(f) - n]];

// Full symmetry.
function onetwenty(f) = [each sixty(f), each sixty(invert(f))];

module loose_wedge(f, a=[0,0,0]) {
    polyhedron(
        points=[a, each f],
        faces=[[each [1:len(f)]],
               [1, len(f), 0],
               for (x = [2:len(f)]) [x, x-1, 0]]);
}

module wedge_sixty(f) for (g = sixty(f)) loose_wedge(canonvv(g));

module dodecahedron() scale(1/sqrt(3)) poly(twelve(A));

module final_dual()
    scale(1/sqrt(3)) wedge_sixty([B[0], B[2], C[1]]);

// Generate the region of the final_dual() that is bounded by all the faces.
module final_dual_peanut() {
    scale(1/sqrt(3))
        intersection_for (f = sixty([B[0], B[2], C[1]]))
        loose_wedge(f, -sum(f));
}

// Too much self-intersection for openscad to handle!
module broken_final_dual() poly(sixty([B[0], B[2], C[1]]));

module great_stellated_dodecahedron()
    scale(1 / sqrt(3)) wedge_sixty([B[0], B[2], sum(B) / 5]);

module great_dodecahedron()
    scale(1 / norm(I0)) for (f = twelve(IA)) loose_wedge(f);

module small_stellated_dodecahedron()
    scale(1 / norm(I0)) wedge_sixty([IA[0], IA[2], sum(IA) / 5]);

final_dual_peanut();

for (v = [each A, each B, each C, each D]) {
    translate(v) color("grey") sphere(0.1);
}
