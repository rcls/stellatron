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

// With bottom post.
triangle_joiners=[[1, -5, -0.5, 10], [1, -5, 0.5, -10], [0, 2.5, 0, 0]];

module truncated_tetrahedron() {
    a = [3,1,1];
    // Suppress coset reduction on the hexagon.  The order-6 rotation is not
    // in the full rotational symmetry group!
    face_list = [
        [triangle(a), 4, "green", 2],
        [invert(double(triangle(mz(a)))), -4, "red", 3]];
    polygon_face_set(face_list);
}

module cuboctahedron() {
    p = [0, 1, 1];
    face_list=[
        [zsquare(p), 6, "purple"],
        [triangle(p), 8, "orange"]];
    polygon_face_set(face_list);
}

module truncated_cube() {
    a = [1 + sqrt(2), 1, 1 + sqrt(2)];
    face_list = [
        [triangle(a), 8, "orange"],
        [octogon(a), 6, "purple", 2]];
    polygon_face_set(face_list);
}

module truncated_octahedron() {
    a = [0, 1, 2];
    face_list = [
        [zsquare(a), 6, "purple"],
        [double(triangle(a)), 8, "orange"]];
    echo(max([for (f = face_list) [len(f[0]), f[0]]]));
    polygon_face_set(face_list);
}


module rhombi_cuboctahedron() {
    a = [1, 1, 1 + sqrt(2)];
    face_list= [
        [triangle(a), 8, "orange", 2],
        [zsquare(a), 6, "purple", 3],
        [[a, pls(a), my(pls(a)), my(a)], 12, "green", 4],
        ];
    polygon_face_set(face_list);
}

module truncated_cuboctahedron() {
    q = [1 + sqrt(2), 1, 1 + 2 * sqrt(2)];

    f4 = [q, [q.z, q.y, q.x], [q.z, -q.y, q.x], [q.x, -q.y, q.z]];

    face_list = [
        [f4, 12, "green"],
        [double(triangle(q)), 8, "orange"],
        [octogon(q), 6, "purple"]];

    joiners=[[1, -5.3, -0.5, 6.5], [1, -5.3, 0.5, -6.5], [0, 2.5, 0, 0]];
    polygon_face_set(face_list, joiners=joiners);
}


module snub_cube() {
    function tribo(n, a) = n == 0 ? a : tribo(n - 1, sqrt(1/a + 1 + a));
    t = tribo(22, 1);
    a = [1/t, 1, t];
    face_list=[
        [zsquare(a), 6, "purple"],
        [triangle(a), 8, "orange"],
        [[a, pls(a), rmz(a)], 24, "grey", 4],
        ];
    polygon_face_set(face_list, joiners=triangle_joiners);
}

module icosidodecahedron()
{
    q = [gold/2 - 1/2, 1/2, gold/2];

    face_list = [
        [triangle(q), 20, "yellow"],
        [canonvv(pentagon(q)), 12, "magenta"]];

    polygon_face_set(face_list, cut=0.75, joiners=triangle_joiners);
}

module truncated_dodecahedron() {
    q = [gold, 2, gold+1];

    face_list = [
        [triangle(q), 20, "yellow"],
        [canonvv(double(pentagon(q))), 12, "magenta"]];

    polygon_face_set(face_list);
}

module truncated_icosahedron() {
    b = [2, gold, 2 * gold + 1];
    face_list = [
        [canonvv(pentagon(b)), 12, "magenta", 2],
        [double(triangle(b)), 20, "yellow", 3]];
    polygon_face_set(face_list);
}

module rhombicosidodecahedron() {
    a = [1, 1, 2*gold + 1];

    face_list = [
        [triangle(rot5*a), 20, "yellow"],
        [zsquare(a), 30, "green"],
        [pentagon(a), 12, "magenta"]
        ];

    polygon_face_set(face_list);
}

module truncated_icosidodecahedron() {
    p = [gold-1, gold-1, 3 + gold];

    face_list = [
        [zsquare(p), 30, "green"],
        [canonvv(double(triangle(rot5*p))), 20, "yellow"],
        [canonvv(double(pentagon(p))), 12, "magenta"]];
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

    face_list = [
        [pentagon(p), -12, "magenta"],
        [[p, rz(p), rz(rot5_4 * p)], -60, "grey", 2],
        [triangle(rot5*p), -20, "yellow"]
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
    else if (total == 24)
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
