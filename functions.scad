
include <numbers.scad>

function sum(v, n=0) = n + 1 < len(v) ? v[n] + sum(v, n + 1) : v[n];

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
    [0.0 * gold - 0.5, 0.0, -0.5],  // -0.5
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
    [0.0 * gold + 0.5, 0.0, 0.5],  // 0.5
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
function canonvv(vv) = [for (v = vv) canonv(v)];
function canonvvv(vvv) = [for (vv = vvv) canonvv(vv)];

module describe(v) {
    rv = round(v);
    fv = v - rv;
    m = canon_find(fv, 0, len(value_table) - 1);
    mid = (value_table[m][0] + value_table[m+1][0]) / 2;
    mm = fv < mid ? m : m + 1;
    pp = value_table[mm][1];
    ii = value_table[mm][2];
    recalc = pp * gold + (rv + ii);
    echo(v, recalc, pp, rv + ii, v - recalc);
}

function unit(v) = v / norm(v);

function transpose(dx, dy, dz, p = undef) = p
    ? [[dx.x, dy.x, dz.x, p.x],
       [dx.y, dy.y, dz.y, p.y],
       [dx.z, dy.z, dz.z, p.z],
       [0, 0, 0, 1]]
    : [[dx.x, dy.x, dz.x],
       [dx.y, dy.y, dz.y],
       [dx.z, dy.z, dz.z]];

// Return an orthonormal matrix that converts from (x,y,z) to a co-ordinate
// system based on the input vectors.  `x` transforms to the direction of `u`.
// `y` transforms to the projection of `v` onto the plane transverse to `u`.
// `z` is normal to both, with a sign convention to make its dot-product with
// `w` positive, if possible.  The origin transforms to `p`.
function orthonormal(u, v, w=[0,0,0], p=undef) = let (
    dx = unit(u),
    dy = unit(v - (dx * v) * dx),
    dz1 = cross(dx, dy),
    dz = dz1 * w < 0 ? -dz1 : dz1)
    assert(dx * dy < 1e-7)
    assert(dy * dz < 1e-7)
    assert(dz * dx < 1e-7)
    transpose(dx, dy, dz, p);

module orthonormal(u, v, w=[0,0,0], p=undef)
    multmatrix(orthonormal(u, v, w, p)) children();

function verticate_na(v) = let (
    vn = v / norm(v),
    x = vn.x,
    y = vn.y,
    z = vn.z,
    d = x * x + y * y,
    factor = d > 1e-6 ? (abs(z) - 1) / d : -0.5 - 0.125 * d,
    a = factor * x * x + 1,
    b = factor * y * y + 1,
    c = factor * x * y)
    z >= 0
    ? [[ a,  c, -x], [c, b, -y], [x, y, z]]
    : [[-a, -c, -x], [c, b, y], [x, y, z]];

function verticate(v, align=undef) = let(
    vrot = verticate_na(v),
    valign = align ? vrot * align : [1, 0, 0],
    vnorm = norm([valign.x, valign.y]),
    c = valign.x / vnorm,
    s = valign.y / vnorm)
    [[c, s, 0], [-s, c, 0], [0, 0, 1]] * vrot;

function inverticate(v) = let (v = verticate(v)) transpose(v.x, v.y, v.z);

// Rotate children to bring the vector `v` vertical.  The rotation is in the v-z
// plane.
module verticate(v, align=undef) multmatrix(verticate(v, align)) children();
module inverticate(v) multmatrix(inverticate(v)) children();

// Bring mean of face to vertical and align first edge.
module verticate_align(f) {
    m = verticate(sum(f));
    a = m * (f[0] + f[1]);
    b = unit([a.x, a.y]);
    multmatrix([[b.x, b.y, 0], [-b.y, b.x, 0], [0, 0, 1]])
        multmatrix(m) children();
}

// A pyramid connecting a face to an point.  When not rendering, do the
// triangles to the apex in red.
module pyramid(f, a=[0,0,0], topcolor="gold", undercolor="red") {
    if ($preview) {
        mid = (a + sum(f) / len(f)) * 0.5;
        color(topcolor) basic(f, mid);
        color(undercolor) for (i = [1:len(f)])
            basic([f[i-1], f[i%len(f)], mid], a);
    }
    else {
        basic(f, a);
    }
    module basic(f, a) polyhedron(
        points=[a, each f],
        faces=[[each [1:len(f)]],
               [1, len(f), 0],
               for (x = [2:len(f)]) [x, x-1, 0]]);
}

module star_pyramid(f, stride=2, a=[0,0,0],
                    topcolor="gold", undercolor="red") {
    n = len(f);
    c = sum(f) / n;
    for (i = [0 : n - 1])
        pyramid([f[i], f[(i+stride) % n], c], a, topcolor, undercolor);
}

module pyramids(ff, topcolor="gold") for (f = ff) pyramid(f, topcolor=topcolor);

module star_pyramids(ff, stride = 2) for (f = ff) star_pyramid(f, stride);

module chamfer_pyramid(f, a=[0, 0, 0], chamfer=0.4, inset=0.3) {
    mid = sum(f) / len(f);
    difference() {
        pyramid(f, a);
        for (i = [1:len(f)])
            chamfer_box(f[i-1],f[i%len(f)]);
        for (p = f)
            chamfer_side(p);
    }
    module chamfer_box(u, v) {
        // Establish a coordinate system for the box...
        c = (u+v)/ 2;
        multmatrix(orthonormal(v - u, unit(mid - c) + unit(a - c), p=c))
            cube([norm(v - u)+2, chamfer*2, chamfer*4], center=true);
    }
    module chamfer_side(p) {
        multmatrix(orthonormal(p, p - mid, p=p/2))
            rotate([-45,0,0])
            cube([norm(p), inset*2, inset*2], center=true);
    }
}

// Order 3 rotation of a vector.
function pls(p) = [p.z, p.x, p.y];
// Order 3 rotation of a face.
function ppls(vv) = [for (v = vv) pls(v)];

// Inverse to pls, ppls.
function mns(p) = [p.y, p.z, p.x];
function mmns(vv) = [for (v = vv) mns(v)];

// Rotate 180° around x axis.
function rx(v) = [v.x, -v.y, -v.z];
function rrx(vv) = [for (v = vv) rx(v)];

// Rotate 180° around y axis.
function ry(v) = [-v.x, v.y, -v.z];
function rry(vv) = [for (v = vv) ry(v)];

// Rotate 180° around z axis.
function rz(v) = [-v.x, -v.y, v.z];
function rrz(vv) = [for (v = vv) rz(v)];

// 90° around x axis.
function rpx(v) = [v.x, -v.z, v.y];
function rmx(v) = [v.x, v.z, -v.y];
function rrpx(vv) = [for (v = vv) rpx(v)];
function rrmx(vv) = [for (v = vv) rmx(v)];

// 90° around y axis.
function rpy(v) = [v.z, v.y, -v.x];
function rmy(v) = [-v.z, v.y, v.x];
function rrpy(vv) = [for (v = vv) rpy(v)];
function rrmy(vv) = [for (v = vv) rmy(v)];

// 90° around z axis.
function rpz(v) = [-v.y, v.x, v.z];
function rmz(v) = [v.y, -v.x, v.z];
function rrpz(vv) = [for (v = vv) rpz(v)];
function rrmz(vv) = [for (v = vv) rmz(v)];

// Mirror along axes.
function mx(v) = [-v.x, v.y, v.z];
function my(v) = [v.x, -v.y, v.z];
function mz(v) = [v.x, v.y, -v.z];

// Reverse an array.
function reverse(v) = [for (i = [len(v)-1 : -1 : 0]) v[i]];
// Flip the orientation of an array, preserving element 0.
function reorient(v) = [for (i = [len(v) : -1 : 1]) v[i % len(v)]];

// Inversion symmetry.
function invert(f) = -reorient(f);

function cycle(v, from=1) = let (l = len(v))
    [for (i = [from + l : from + 2 * l - 1]) v[i % l]];
function cycles(v, froms) =
    [for (f = froms) each is_list(f) ? [cycles(v, f)] : cycle(v, f)];

// Lexicographical order for vectors, accomodating rounding errors.
function vless(u, v, tol=1e-7) =
    abs(u.x - v.x) <= tol ? abs(u.y - v.y) <= tol ?
    abs(u.z - v.z) > tol && u.z < v.z : u.y < v.y : u.x < v.x;

// Is a face permutate to have lexicographically least vector first?
function is_least_first(f, tol=1e-7) =
    [for (v = f) vless(v, f[0], tol)] == [for (v = f) false];

// Three fold symmetry.
function three(face) = [face, ppls(face), mmns(face)];

module three() {
    children();
    multmatrix([[0,1,0], [0,0,1], [1,0,0]]) children();
    multmatrix([[0,0,1], [1,0,0], [0,1,0]]) children();
}

module four() {
    children();
    multmatrix([[-1,0,0], [0,-1,0], [0,0,1]]) children();
    multmatrix([[-1,0,0], [0,1,0], [0,0,-1]]) children();
    multmatrix([[1,0,0], [0,-1,0], [0,0,-1]]) children();
}

module twelve() three() four() children();

// Construct a triangle.
function triangle(v) = [v, mns(v), pls(v)];
function hexagon(u, v) = [u, v, mns(u), mns(v), pls(u), pls(v)];

// Given a face with old rotational symmetry, double it up.
function double(vv) = let (l = len(vv), a = ceil(l / 2), mid = sum(vv) / l)
    [ for (i = [0:l-1]) each [vv[i], 2 * mid - vv[(i + a) % l]] ];

// Generate four images, the Klein four grup.
function four(f) = [f, rrx(f), rry(f), rrz(f)];

// Square around z axis.
function zsquare(v) = [v, rmz(v), rz(v), rpz(v)];

// Octohedron around z axis, the vertex should be rotated <45° positive from
// the x.
function octogon(v) = [v, my(v), rmz(v), rmz(my(v)),
                       rz(v), rz(my(v)), rpz(v), rpz(my(v))];

// Give a face, generate 5 images, rotating about a dodec. face.
function five(f) = [for (m = rotate5) [for (v = f) m * v]];

// Construct a pentagon.
function pentagon(v) = [for (m = rotate5) m * v];

//function six(face) = [each three(face), for (f = three(face)) invert(f)];
function six(face) = [each three(face), each three(rrx(face))];

// Generate eight images, four-fold rotation about each axis.
function eight(f) = [each four(f), each four(rrpy(f))];

// Given a face, generate twelve images.
function twelve(face) = [for (f = three(face)) each four(f)];

// Generate twenty images of a face.  This assumes the face is on an octahedral
// plane so that Klein four above acts freely.  If not then one of the coset
// modules below would be better.
function twenty(face) = [for (f = four(face)) each five(f)];

// Close under three fold rotation and four fold rotation about each axis.
function twentyfour(face) = [for (f = eight(face)) each three(f)];

// Given a face, generate 60 images, dodec. rotational symmetry.
function sixty(f) = [for (ff = five(f)) each twelve(ff)];

// Full symmetry.
function onetwenty(f) = [each sixty(f), each sixty(invert(f))];

// If we've generated a set of faces, with the redundancy of each face having
// permutations bringing each vertex to the front, then remove the redundancy.
function coset(ff, tol=1e-7) = let (
    result = [for (f = ff) if (is_least_first(f, tol)) f ])
    echo("Coset reduction to", len(result), "from", len(ff))
    result;

function coset60(ff, tol=1e-7) = let (
    matrixes = [
        for (m = sixty([0,0,1],[0,1,0],[1,0,0])) transpose(m.x, m.y, m.z)],
    all60 = sixty(ff))
    [for (i = [0:59]) if (is_least_first(all60[i], tol)) matrixes[i]];
