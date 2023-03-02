use <functions.scad>
use <splitting.scad>
include <numbers.scad>

// Faces are coloured as follows:
// Cubical, multiple of 6 (but not 12) faces: Green.
// Tetrahedral, octahedral, icosahedral: Yellow.
// - hmmm truncated tetra has two tetrahedral symmetry faces!
// Magenta: dodecahdral (12 faces).

// Index of the object to print.
archimedes = 12;
// Alternatively, you may replace `main();` below with the object you want.

// 0 = raw object, 1 = main printable, 2 = extra piece, 10 = stand.
$piece = 1;

// The overall radius in mm from the center of the piece to its extremities.
$radius = 65;
// Many of the dimensions below are scaled by the radius.

// When cutting into pieces, remove this much extra in the z direction (mm).
$extra_z_remove=0.001;
// This may be helpful where you have edges touching the base plate.

// Depth in mm of the hole for post joiners.
$join_depth=5;
// I use 10 for larger pieces, 5 for smaller ones where space is tight.

// Diameter in mm of the holes for post joiners.
$join_diameter=2.2;
// This should be the diameter of your filament (or whatever you use), plus a
// little.

// Diameter in mm of the stand posts.
$stand_diameter = 6;

// For stands and joiners.  (Gets multiplied for larger radii).
$fn=20;

main();

module main() {
    if (archimedes == 1) truncated_tetrahedron();
    if (archimedes == 2) cuboctahedron();
    if (archimedes == 3) truncated_cube();
    if (archimedes == 4) truncated_octahedron();
    if (archimedes == 5) rhombi_cuboctahedron();
    if (archimedes == 6) truncated_cuboctahedron();
    if (archimedes == 7) snub_cube();
    if (archimedes == 8) icosidodecahedron();
    if (archimedes == 9) truncated_dodecahedron();
    if (archimedes == 10) truncated_icosahedron();
    if (archimedes == 11) rhombicosidodecahedron();
    if (archimedes == 12) truncated_icosidodecahedron();
}

module truncated_tetrahedron() {
    a = [3,1,1];
    b = pls(a);
    c = mns(a);
    face_list = [
        [[c, b, a], 4, "yellow", 2],
        [-[mz(a), mz(b), mx(b), mx(c), my(c), my(a)], 4, "green", 3]];
    polygon_face_set(face_list);
}

module cuboctahedron() {
    //p = [1, 0, 1];
    face_list=[
        [[[1, 0, 1], [0, -1, 1], [-1, 0, 1], [0, 1, 1]], 6, "green"],
        [[[0, 1, 1], [1, 0, 1], [1, 1, 0]], 8, "yellow"]];
    polygon_face_set(face_list);
}

module truncated_cube() {
    a = [1, 1 + sqrt(2), 1 + sqrt(2)];
    b = mns(a);
    c = pls(a);
    face_list = [
        [[a, b, c], 8, "yellow"],
        [[a, c, rmz(a), rmz(c), rz(a), rz(c), rpz(a), rpz(c)], 6, "green", 2]];
    polygon_face_set(face_list);
}

module truncated_octahedron() {
    a = [0, sqrt(2), 1 + sqrt(2)];
    face_list = [
        [[a, rmz(a), rz(a), rpz(a)], 6, "green"],
        [[rmz(a), a, mns(rmz(a)), mns(a), pls(rmz(a)), pls(a)], 8, "yellow"]];
    echo(max([for (f = face_list) [len(f[0]), f[0]]]));
    polygon_face_set(face_list);
}


module rhombi_cuboctahedron() {
    a = [1, 1, 1 + sqrt(2)];
    face_list= [
        [[a, mns(a), pls(a)], 8, "yellow", 2],
        [[a, rmz(a), rz(a), rpz(a)], 6, "green", 3],
        [[a, pls(a), my(pls(a)), my(a)], 12, "magenta", 4],
        ];
    polygon_face_set(face_list);
}

module truncated_cuboctahedron() {
    p0 = [1, 1 + sqrt(2), 1 + 2 * sqrt(2)];
    p = p0 / norm(p0);
    q = [p.y, p.x, p.z];

    f4 = [q, pls(p), my(pls(p)), rmz(p)];
    f6 = [q, p, mns(q), mns(p), pls(q), pls(p)];
    f8 = [p, q, rmz(p), rmz(q), rz(p), rz(q), rpz(p), rpz(q)];

    face_list = [
        [f4, 12, "magenta"],
        [f6, 8, "yellow"],
        [f8, 6, "green"]];
    polygon_face_set(face_list);
}


module snub_cube() {
    function tribo(n, a, b, c) = n == 0 ? c / b : tribo(n - 1, b, c, a + b + c);
    t = tribo(20, 0, 0, 1);
    echo(t);
    a = [1/t, 1, t];
    translate(a) sphere(0.1);
    face_list=[
        [[a, rmz(a), rz(a), rpz(a)], 6, "green"],
        [[a, mns(a), pls(a)], 8, "yellow"],
        [[a, pls(a), rmz(a)], 24, "grey", 4],
        ];
    polygon_face_set(face_list);
}

module truncated_dodecahedron() {
    p = [0, gold-1, gold+2];
    q = rz(rot5_3 * p);

    quint = [for (r = rotate5) r * p];
    mid_quint = sum(quint) / 5;
    dec = [for (i = [4:-1:0])
            each [quint[i], 2 * mid_quint - quint[(i+2) % 5]]];

    face_list = [
        [[q, mns(q), pls(q)], 20, "yellow"],
        [dec, 12, "magenta"]];

    polygon_face_set(face_list);
}

module truncated_icosahedron() {
    a = [0, 1, 3 * gold];
    quint = [for (r = rotate5) r * rpz(a)];
    hex = [mx(quint[2]), mx(quint[1]),
           mns(mx(quint[2])), mns(mx(quint[1])),
           pls(mx(quint[2])), pls(mx(quint[1]))];
    face_list = [
        [-quint, 12, "magenta", 2],
        [hex, 20, "yellow", 3]];
    polygon_face_set(face_list);
}

module icosidodecahedron()
{
    p0 = [0, 0, 1];
    p1 = [gold/2 - 1/2, 1/2, gold/2];
    quint = [for (m = rotate5) m * p0];

    face_list = [
        [[p1, mns(p1), pls(p1)], 20, "yellow"],
        [-quint, 12, "magenta"]];

    polygon_face_set(face_list);
}

module rhombicosidodecahedron() {
    a = [1, 1, 2*gold + 1];
    b = mx(rot5 * a);

    face_list = [
        [[b, mns(b), pls(b)], 20, "yellow"],
        [[b, pls(b), a, my(rot5_4 * a)], 30, "green"],
        [[for (r = rotate5) -r * mx(a)], 12, "magenta"]
        ];

    polygon_face_set(face_list);
}

module truncated_icosidodecahedron() {
    p0 = [gold-1, gold-1, 3 + gold];
    p1 = [2*gold - 2, gold, 1 + 2 * gold];
    p2 = [gold - 1, gold + 1, 3 * gold - 1];
    p3 = [2 * gold - 1, 2, 2 + gold];
    p4 = [gold, 3, 2 * gold];

    half_dec = [p0, p1, p3, pls(p4), pls(p2)];
    dec = [each half_dec, for (v = reverse(half_dec)) my(v)];

    face_list = [
        [[p0, my(p0), rz(p0), mx(p0)], 30, "green"],
        [[p2, p1, p0, mx(p0), mx(p1), mx(p2)], 20, "yellow"],
        [dec, 12, "magenta"]];
    polygon_face_set(face_list);

    if ($piece == 4) {
        difference() {
            scale ($radius / norm(p0)) polygon_face_all(face_list);
            translate([0, 0, -$radius]) cube(2 * $radius, center=true);
            for (i = [0:90:270]) joiner_post(i, [$radius * 0.9, 0, 0]);
        }
    }
}


module joinable_frustum(w, cut=0.75) {
    mean = sum(w) / len(w);
    w_inscribe = norm(mean);
    difference() {
        translate([0, 0, -cut * w_inscribe]) verticate(sum(w)) difference() {
            chamfer_pyramid(w);
            for (i = [1:len(w)]) {
                mid_vertex_joiner_post(w[i-1], w[i%len(w)], radius_mm=-4);
                mid_vertex_joiner_post(w[i-1], w[i%len(w)],
                                       radius_mm=4, radius=cut);
            }
        }
        translate([0, 0, -$radius]) cube(2*$radius, center=true);
    }
}

module polygon_face_set(faces) {
    big_face = max([for (f = faces) [len(f[0]), f[0]]]);
    vertical = sum(big_face[1]) / big_face[0];
    if ($piece == 0)
        scale(1 / norm(faces[0][0][0])) polygon_face_all(faces);

    if ($piece == 1)
        scale($radius / norm(faces[0][0][0]))
            // Bring the nominated vertical to the bottom (not top!) and
            // sit on it!
            translate([0, 0, norm(vertical)]) verticate(-vertical)
            polygon_face_all(faces);

    for (f = faces) {
        face = f[0];
        p = len(f) <= 3 ? len(face) % 2 == 0 ? len(face) / 2 : len(face) : f[3];
        if ($piece == p) {
            joinable_frustum($radius / norm(face[0]) * face);
        }
    }
}

module polygon_face_all(faces) {
    for (f = faces) color(f[2]) polygon_faces(f[0], f[1]);
}

module polygon_faces(face, copies) {
    total = copies * len(face);
    // If it's sensible to do coset reduction, then just do it.
    if (total == 120)
        pyramid_coset_onetwenty(face);
    else if (total == 60)
        pyramid_coset_sixty(face);
    else if (total == 24) {
        ff = coset(twentyfour(face));
        echo(len(ff));
        for (f = ff) pyramid(f);
    }
    else if (copies == 24)
        for (f = twentyfour(face)) pyramid(f);
    else if (copies == 12)
        for (f = twelve(face)) pyramid(f);
    else if (copies == 8)
        for (f = eight(face)) pyramid(f);
    else if (copies == 6)
        for (f = six(face)) pyramid(f);
    else if (copies == 4)
        for (f = four(face)) pyramid(f);
    else if (copies == 1)
        pyramid(face);
    else
        assert(false);
}

//$piece = 1;
//$radius = 50;
//truncated_icosidodecahedron(false);
