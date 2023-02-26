
include <numbers.scad>
use <splitting.scad>

// Sum = [1+gold, 0, 3 * gold - 1]
points = [
    [-gold, 0, -1/gold],                // Points.
    [-gold, 0, 1/gold],
    [-1, -1, -1],                       // More points.
    [-1, -1, 1],
    [-1, 1, -1],
    [-1, 1, 1],
    //[-0.6 * gold + 0.2, -0.2 * gold - 0.2, 0],  // Center of a face.
    //[-0.6 * gold + 0.2,  0.2 * gold + 0.2, 0],
    [-1/gold, -gold, 0],
    [-1/gold, gold, 0],
    //[-0.2 * gold - 0.2, 0, -0.6 * gold + 0.2],
    //[-0.2 * gold - 0.2, 0,  0.6 * gold - 0.2],
    //[0, -0.6 * gold + 0.2, -0.2 * gold - 0.2],
    //[0, -0.6 * gold + 0.2,  0.2 * gold + 0.2],
    [0, -1/gold, -gold],
    [0, -1/gold, gold],
    [0, 0, 0],
    [0, 1/gold, -gold],
    [0, 1/gold, gold],
    //[0, 0.6 * gold - 0.2, -0.2 * gold - 0.2],
    //[0, 0.6 * gold - 0.2,  0.2 * gold + 0.2],
    //[0.2 * gold + 0.2, 0, -0.6 * gold + 0.2],
    //[0.2 * gold + 0.2, 0,  0.6 * gold - 0.2],
    [1/gold, -gold, 0],
    [1/gold, gold, 0],
    //[0.6 * gold - 0.2, -0.2 * gold - 0.2, 0],
    //[0.6 * gold - 0.2,  0.2 * gold + 0.2, 0],
    [1, -1, -1],
    [1, -1, 1],
    [1, 1, -1],
    [1, 1, 1],
    [gold, 0, -1/gold],
    [gold, 0, 1/gold],
    ];

//assert(len(points) == 22);

function near(a, b) = abs(a - b) < 1e-7;

function vless(a, b) =
    near(a[0], b[0]) ? near(a[1], b[1]) ?
    !near(a[2], b[2]) && a[2] < b[2] : a[1] < b[1] : a[0] < b[0];

for (i = [1 : len(points)-1]) {
    assert(vless(points[i-1], points[i]));
}

function p_search(v, i, k) =
    let (j = floor((i + k) / 2))
    i + 1 != k ? vless(v, points[j])
    ? p_search(v, i, j) : p_search(v, j, k) : i;

function P(v) =
    let (i = p_search(v, 0, len(points)))
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

// Given a face, generate twelve images.
function twelve(face) = let (
    f3 = [face, ppls(face), mmns(face)],
    f6 = [each f3, for (vv = f3) rrx(vv)])
    [each f6, for (vv = f6) rry(vv)];


// Triangulate a face with its center.

module poly(faces) {
    polyhedron(points = points, faces = PPP(faces), convexity=100);
}

function sum(v, n=0) = n + 1 < len(v) ? v[n] + sum(v, n + 1) : v[n];

// Four rings of five.
A = [
    [0, -1/gold, -gold],
    [1, -1, -1],
    [gold, 0, -1/gold],
    [1, 1, -1,],
    [0, 1/gold, -gold]
    ];

// Sum = [1+gold, 0, 3 * gold - 1]
cA = [0.2 * gold + 0.2, 0, 0.6 * gold - 0.2];
B = [
    [-1, -1, -1],
    [1/gold, -gold, 0],
    [gold, 0, 1/gold],
    [1/gold, gold, 0],
    [-1, 1, -1]
    ];
C = [for (i = [0:4]) -B[i]];
D = [for (i = [0:4]) -A[i]];
// Sum = [3gold - 4, 0, -3+gold]

// Rotation matrix that maps A[i] -> A[i-1 mod 5] etc.
rot5 = [[1/2, gold/2, -1/2/gold],
        [-gold/2, 1/2/gold, -1/2],
        [-1/2/gold, 1/2, gold/2]];

rot5_2 = rot5 * rot5;
rot5_3 = rot5_2 * rot5;
rot5_4 = rot5_2 * rot5_2;

// Give a face, generate 5 images, rotating about a dodec. face.
function five(f) = [
    f,
    [for (v = f) rot5   * v],
    [for (v = f) rot5_2 * v],
    [for (v = f) rot5_3 * v],
    [for (v = f) rot5_4 * v]];

// Given a face, generate 60 images, dodec. rotational symmetry.
function sixty(f) = [for (ff = five(f)) each twelve(ff)];

// Invert a face.
function invert(f) = [for (n = [1:len(f)]) -f[len(f) - n]];

// Full symmetry.
function onetwenty(f) = [each sixty(f), each sixty(invert(f))];

module wedge(f) {
    poly([f,
          [f[0], f[len(f) - 1], [0,0,0]],
          for (i = [1:len(f) - 1]) [f[i], f[i-1], [0,0,0]]
             ]);
}

module loose_wedge(f, a=[0,0,0]) {
    polyhedron(
        points=[a, each f],
        faces=[[each [1:len(f)]],
               [1, len(f), 0],
               for (x = [2:len(f)]) [x, x-1, 0]]);
}

module dodecahedron() scale(1/sqrt(3)) poly(twelve(A));

module final_dual() {
    scale(1/sqrt(3))
        for (f = sixty([B[0], B[2], C[1]])) wedge(f);
}

// Generate the region of the final_dual() that is bounded by all the faces.
module final_dual_peanut() {
    scale(1/sqrt(3))
        intersection_for (f = sixty([ B[0], B[2], C[1] ]))
        loose_wedge(f, -sum(f));
}

for (v = [each A, each B, each C, each D]) {
    translate(v) color("grey") sphere(0.1);
}

module wedge_sixty(f) {
    for (g = sixty(f)) wedge(g);
}

wedge_sixty([A[0], A[1], D[3]]);
//wedge([A[0], A[2], B[1]]);
//wedge_sixty([A[0], A[2], D[4], D[3]]);
//wedge_sixty([A[2], A[0], D[1]]);

module broken_final_dual() poly(sixty([B[0], B[2], C[1]]));
