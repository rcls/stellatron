use <functions.scad>
use <splitting.scad>
include <numbers.scad>

// Faces are coloured as follows:
// Rhombication squares - green.
// Icosohedral - Yellow.
// Dodecahdral - Magenta.

// Snub triangles - Gray.

// Octohedral - Lets do orange.
// Cubical - Purple.
// Tetrahedral - Lets do red.
// Truncated tetrahedron - red + pink?

// Rhombicuboctahedron - 12 rhombications, green or magneta? 3,(3+3),3 rings not
// 3,3,3,3 - I say green.

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

// Print pieces face down rather than face-up.
$flip = false;

main();

module main() {
    if (archimedes == 1) truncated_tetrahedron();
    if (archimedes == 2) cuboctahedron();
    if (archimedes == 3) truncated_cube();
    if (archimedes == 4) truncated_octahedron();
    if (archimedes == 5) rhombi_cuboctahedron();
    if (archimedes == 6) truncated_cuboctahedron();
    if (archimedes == 7) snub_cube();         // 55mm
    if (archimedes == 8) icosidodecahedron(); // 65mm
    if (archimedes == 9) truncated_dodecahedron();
    if (archimedes == 10) truncated_icosahedron();
    if (archimedes == 11) rhombicosidodecahedron();
    if (archimedes == 12) truncated_icosidodecahedron(); // 90mm
    if (archimedes == 13) snub_dodecahedron();
}

// Joiner array description is [radius,radius_mm,offset,offset_mm].
vertical_joiners=[
    // radius, radius_mm
    [1, -4, 0, 0], [0, 2.5, 0, 0] ];

// Old.
//triangle_joiners=[[1, -5, -0.5, 10],[1, -5, 0.5, -10]]; //, [0, 3, 0, 0]];
// With bottom post.
triangle_joiners=[[1, -5, -0.5, 10], [1, -5, 0.5, -10], [0, 2.5, 0, 0]];
// By four.
//triangle_joiners=[[1, -5, -0.5, 4],[1, -5, 0.5, -4],
//                  [0,3, -0.5, 4], [0, 3, 0.5, -4]];

module truncated_tetrahedron() {
    a = [3,1,1];
    b = pls(a);
    c = mns(a);
    // Suppress coset reduction on the hexagon.  The order-6 rotation is not
    // in the full rotational symmetry group!
    face_list = [
        [[c, b, a], 4, "green", 2],
        [-([mz(a), mz(b), mx(b), mx(c), my(c), my(a)]), 4, "red", 3]];
    polygon_face_set(face_list);
}

module cuboctahedron() {
    //p = [1, 0, 1];
    face_list=[
        [[[1, 0, 1], [0, -1, 1], [-1, 0, 1], [0, 1, 1]], 6, "purple"],
        [[[0, 1, 1], [1, 0, 1], [1, 1, 0]], 8, "orange"]];
    polygon_face_set(face_list);
}

module truncated_cube() {
    a = [1, 1 + sqrt(2), 1 + sqrt(2)];
    b = mns(a);
    c = pls(a);
    face_list = [
        [[a, b, c], 8, "orange"],
        [[a, c, rmz(a), rmz(c), rz(a), rz(c), rpz(a), rpz(c)], 6, "purple", 2]];
    polygon_face_set(face_list);
}

module truncated_octahedron() {
    a = [0, sqrt(2), 1 + sqrt(2)];
    face_list = [
        [[a, rmz(a), rz(a), rpz(a)], 6, "purple"],
        [[rmz(a), a, mns(rmz(a)), mns(a), pls(rmz(a)), pls(a)], 8, "orange"]];
    echo(max([for (f = face_list) [len(f[0]), f[0]]]));
    polygon_face_set(face_list);
}


module rhombi_cuboctahedron() {
    a = [1, 1, 1 + sqrt(2)];
    face_list= [
        [[a, mns(a), pls(a)], 8, "orange", 2],
        [[a, rmz(a), rz(a), rpz(a)], 6, "purple", 3],
        [[a, pls(a), my(pls(a)), my(a)], 12, "green", 4],
        ];
    polygon_face_set(face_list);
}

module truncated_cuboctahedron() {
    p = [1, 1 + sqrt(2), 1 + 2 * sqrt(2)];
    q = [p.y, p.x, p.z];

    f4 = [q, pls(p), my(pls(p)), rmz(p)];
    f6 = [q, p, mns(q), mns(p), pls(q), pls(p)];
    f8 = [p, q, rmz(p), rmz(q), rz(p), rz(q), rpz(p), rpz(q)];

    face_list = [
        [f4, 12, "green"],
        [f6, 8, "orange"],
        [f8, 6, "purple"]];
    polygon_face_set(face_list);
}


module snub_cube() {
    function tribo(n, a) = n == 0 ? a : tribo(n - 1, sqrt(1/a + 1 + a));
    t = tribo(22, 1);
    a = [1/t, 1, t];
    face_list=[
        [[a, rmz(a), rz(a), rpz(a)], 6, "purple"],
        [[a, mns(a), pls(a)], 8, "orange"],
        [[a, pls(a), rmz(a)], 24, "grey", 4],
        ];
    polygon_face_set(face_list, joiners=triangle_joiners);
}

module truncated_dodecahedron() {
    p = [0, gold-1, gold+2];
    q = canonv(rot5 * p);

    quint = [for (r = rotate5) r * p];
    mid_quint = sum(quint) / 5;
    dec = [for (i = [4:-1:0])
            each [quint[i], 2 * mid_quint - quint[(i+2) % 5]]];

    face_list = [
        [[q, mns(q), pls(q)], 20, "yellow"],
        [canonvv(dec), 12, "magenta"]];

    polygon_face_set(face_list);
}

module truncated_icosahedron() {
    a = [1, 0, 3 * gold];
    quint = [for (r = rotate5) canonv(r * a)];
    hex = [quint[2], quint[1],
           mns(quint[2]), mns(quint[1]),
           pls(quint[2]), pls(quint[1])];
    face_list = [
        [quint, 12, "magenta", 2],
        [hex, 20, "yellow", 3]];
    polygon_face_set(face_list);
}

module icosidodecahedron()
{
    p = [0, 0, 1];
    q = [gold/2 - 1/2, 1/2, gold/2];
    quint = [for (m = rotate5) canonv(m * p)];

    face_list = [
        [[q, mns(q), pls(q)], 20, "yellow"],
        [quint, 12, "magenta"]];

    polygon_face_set(face_list, cut=0.75, joiners=triangle_joiners);
}

module rhombicosidodecahedron() {
    a = [1, 1, 2*gold + 1];
    b = rot5 * a;

    face_list = [
        [[b, mns(b), pls(b)], 20, "yellow"],
        [[a, rmz(a), rz(a), rpz(a)], 30, "green"],
        [[for (r = rotate5) r * a], 12, "magenta"]
        ];

    polygon_face_set(face_list);
}

module truncated_icosidodecahedron() {
    p = [gold-1, gold-1, 3 + gold];

    dec = [for (r = rotate5) each [r * my(p), r * p]];
    hex = [rot5_2 * my(p), rot5 * p,
           mns(rot5_2 * my(p)), mns(rot5 * p),
           pls(rot5_2 * my(p)), pls(rot5 * p)];

    face_list = [
        [[p, my(p), rz(p), mx(p)], 30, "green"],
        [hex, 20, "yellow"],
        [dec, 12, "magenta"]];
    polygon_face_set(face_list);

    if ($piece == 4) {
        difference() {
            scale ($radius / norm(p)) polygon_face_all(face_list);
            translate([0, 0, -$radius]) cube(2 * $radius, center=true);
            for (i = [0:90:270]) joiner_post(i, [$radius * 0.9, 0, 0]);
        }
    }
}


// For this guy we give up on canonicalisation and cosets.
module snub_dodecahedron() {
    // ξ ≈ 0.94315125924 from wikipedia.
    epsilon = 0.94315125924;
    p = [
        -gold*gold*gold + gold * epsilon + 2 * gold * epsilon * epsilon,
        (gold + 1) * (1 - epsilon),
        epsilon
        ];

    pentagon = [for (r = rotate5) r * p];
    triangle = [rot5 * p, mns(rot5 * p), pls(rot5 * p)];

    face_list = [
        [pentagon, -12, "magenta"],
        [[p, rz(p), rz(rot5_4 * p)], -60, "grey", 2],
        [triangle, -20, "yellow"]
        ];
    polygon_face_set(face_list, joiners=triangle_joiners);
}

module joinable_frustum(w, cut=0.75, joiners=vertical_joiners, colour) {
    mean = sum(w) / len(w);
    w_inscribe = norm(mean);
    flipper = $flip
        ? [[1, 0, 0], [0, 1, 0], [0, 0, -1, w_inscribe * (1 - cut)]]
        : [[1, 0, 0], [0, 1, 0], [0, 0, 1]];

    multmatrix(flipper) difference() {
        translate([0, 0, -cut * w_inscribe]) verticate_align(w) difference() {
            color(colour) chamfer_pyramid(w);
            for (i = [1:len(w)]) {
                for (j = joiners)
                    mid_vertex_joiner_post(
                        w[i-1], w[i%len(w)],
                        radius=cut + j[0] * (1 - cut), radius_mm=j[1],
                        offset=j[2], offset_mm=j[3]);
            }
        }
        translate([0, 0, -$radius]) cube(2*$radius, center=true);
    }
}

module polygon_face_set(faces, cut=0.75, joiners=vertical_joiners) {
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
            joinable_frustum($radius / norm(face[0]) * face, cut, joiners, f[2]);
        }
    }
}

module polygon_face_all(faces) {
    for (f = faces) color(f[2]) polygon_faces(f[0], f[1]);
}

module polygon_faces(face, copies) {
    echo("Edge length", $radius * norm(face[1] - face[0]) / norm(face[0]));
    total = copies * len(face);
    echo("Total", total, "from", copies, "of", len(face));
    // If it's sensible to do coset reduction, then just do it.
    if (total == 120)
        pyramids(coset(canonvvv(onetwenty(face))));
    else if (total == 60)
        pyramids(coset(canonvvv(sixty(face))));
    // The <5 is a hack, we really should be using the order of the I5
    // stabiliser of the face rather than len(face).
    else if (total == 24 && len(face) < 5)
        pyramids(coset(twentyfour(face)));
    else if (copies == 24)
        pyramids(twentyfour(face));
    else if (abs(copies) == 60)
        pyramids(sixty(face));
    else if (abs(copies) == 20)
        pyramids(twenty(face));
    else if (abs(copies) == 12)
        pyramids(twelve(face));
    else if (copies == 8)
        pyramids(eight(face));
    else if (copies == 6)
        pyramids(six(face));
    else if (copies == 4)
        pyramids(four(face));
    else if (copies == 1)
        pyramid(face);
    else
        assert(false);
}

//$piece = 1;
//$radius = 50;
//truncated_icosidodecahedron(false);
