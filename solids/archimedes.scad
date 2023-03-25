use <functions.scad>
use <splitting.scad>
include <numbers.scad>

// Faces are coloured as follows:
// Rhombication squares - green.
// Icosohedral - Yellow.
// Dodecahdral - Magenta.

// Snub triangles - Pink.

// Octohedral - Orange.
// Cubical - Purple.
// Tetrahedral - Lets do red.
// Truncated tetrahedron - red + pink?  Or maybe black for all truncation?

// Index of the object to print.
archimedes = 12;
// Alternatively, you may replace `main();` below with the object you want.

// 0 = raw object, 1 = main printable, 2 = extra piece, 10 = stand.
$piece = 1;

// The overall radius in mm from the center of the piece to its extremities.
$radius = 65.001;
// Many of the dimensions below are scaled by the radius.

// Depth in mm of the hole for post joiners.
$join_depth=5;

// Diameter in mm of the holes for post joiners.
$join_diameter=2.1;
// This should be the diameter of your filament (or whatever you use), plus a
// little.

// Diameter in mm of the stand posts.
// $stand_diameter = 6;

// For stands and joiners.  (Gets multiplied for larger radii).
$fn=20;

// Print pieces face down rather than face-up.
$flip = true;

main();

module main() {
    // 46.9041 gives an edge length of 40.
    if (archimedes == 1) truncated_tetrahedron(); // 50mm
    // Cuboctahedron has inscribe distance of /sqrt(2) for the squares
    // and /sqrt(3/2) for the trianges.  At 50mm, that gives square inscribe
    // radius of 35.3553mm and triangle inscribe 40.8248mm.
    if (archimedes == 2) cuboctahedron(); // 50mm, ins. 35.3553 and 40.8248
    // 52.1005 gives a square inscribe of 35.355.
    if (archimedes == 3) truncated_cube();
    // 52.7045 gives a triangle inscribe of 40.8247
    if (archimedes == 4) truncated_octahedron();
    if (archimedes == 5) rhombi_cuboctahedron(); // 60mm
    // Inscribes: 53.6863 (cube), 58.638 (octohedron), 61.9008 (rhombis)
    if (archimedes == 6) truncated_cuboctahedron(); // 65mm
    if (archimedes == 7) snub_cube();         // 55mm
    // Inscribe 60.7212 for the triangles and 55.2923 for the pentagons.
    if (archimedes == 8) icosidodecahedron(); // 65mm
    // 75mm gives an edge length of 25.2572.
    // 65.9415 gives an decagon inscribe of 55.2923 and edge length 22.2066.
    if (archimedes == 9) truncated_dodecahedron();
    // 66.3659 gives hexagons matching the inscribe of the icosidodecahedron
    // and an edge length of 26.7815.
    if (archimedes == 10) truncated_icosahedron();
    if (archimedes == 11) rhombicosidodecahedron();      // 65mm
    if (archimedes == 12) truncated_icosidodecahedron(); // 90mm
    if (archimedes == 13) snub_dodecahedron();           // 65mm

    // Platonic solids.
    if (archimedes == 21) tetrahedron();
    if (archimedes == 22) plato_cube();
    if (archimedes == 23) octohedron();
    if (archimedes == 24) dodecahedron();
    if (archimedes == 25) icosahedron();
}

// Joiner array item description is [radius,radius_mm,offset,offset_mm] or just
// [radius_mm,offset_mm] with the origin inferred from the signs.
vertical_joiners=[[1, -4, 0, 0], [0, 2.5, 0, 0]];

module truncated_tetrahedron() {
    $join_depth=4;
    a = [3,1,1];
    // Suppress coset reduction on the hexagon.  The order-6 rotation is not
    // in the full rotational symmetry group!
    joiners=[[2.5,4],[-9,-4]];
    face_list = [
        [triangle(a), 4, "grey", 2, [[[2.5,4],[-9,-4]]] ],
        [invert(double(triangle(mz(a)))), -4, "red", 3,
         [[[2.5,-4],[-9,4]], [[-9,4], [-9, -4]]] ]];
    polygon_face_set(face_list, cut = 1 - 14.5 / $radius);
}

module cuboctahedron() {
    p = [0, 1, 1];
    face_list=[
        [zsquare(p), 6, "purple"],
        [triangle(p), 8, "orange"]];

    joiners=[[1, -6.5, -0.5, 10], [1, -6.5, 0.5, -10]];
    polygon_face_set(face_list, joiners=joiners);
}

module truncated_cube() {
    a = [1 + sqrt(2), 1, 1 + sqrt(2)];
    t_joins=[[2.5,  4.7], [-7, -4.7]];
    s_joint=[[2.5, -4.7], [-7,  4.7]];
    s_joins=[[-7, -3], [-7, 3]];
    face_list = [
        [triangle(a), 8, "orange", 3, [t_joins]],
        [octogon(a), 6, "purple", 2, [s_joint, s_joins]]];
    polygon_face_set(face_list);
}

module truncated_octahedron() {
    a = [0, 1, 2];
    face_list = [
        [zsquare(a), 6, "purple"],
        [double(triangle(a)), 8, "orange"]];
    joiners=[[1, -5.5, -0.5, 6], [1, -5.5, 0.5, -6]];
    polygon_face_set(face_list, joiners=joiners);
}


module rhombi_cuboctahedron() {
    a = [1, 1, 1 + sqrt(2)];
    face_list= [
        [triangle(a), 8, "orange"],
        [zsquare(a), 6, "purple"],
        [[a, pls(a), my(pls(a)), my(a)], 12, "green", 4],
        ];
    joiners=[[1, -4.2, -0.5, 10], [1, -4.2, 0.5, -10]];
    polygon_face_set(face_list, joiners=joiners);
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
        [[a, pls(a), rmz(a)], 24, "pink", 4],
        ];
    joiners=[[-5, 10], [-5, -10], [2.5, 0]];
    polygon_face_set(face_list, joiners=joiners);
}

module icosidodecahedron()
{
    q = [gold - 1, 1, gold];

    face_list = [
        [triangle(q), 20, "yellow"],
        [canonvv(pentagon(q)), 12, "magenta"]];

    joiners=[[-5, 10], [-5, -10], [2.5, 0]];
    polygon_face_set(face_list, cut=0.75, joiners=joiners);
}

module truncated_dodecahedron() {
    q = [gold, 2, gold+1];

    face_list = [
        [triangle(q), 20, "yellow"],
        [canonvv(double(pentagon(q))), 12, "magenta"]];

    joiners=[[-5.2, 0], [2.5, 0]];
    polygon_face_set(face_list, joiners=joiners);
}

module truncated_icosahedron() {
    b = [2, gold, 2 * gold + 1];
    joiners=[[-4, -4.8], [-4, 4.8]];
    face_list = [
        [canonvv(pentagon(b)), 12, "magenta", 2],
        [double(triangle(b)), 20, "yellow", 3]];
    polygon_face_set(face_list, cut=0.85, joiners=joiners);
}

module rhombicosidodecahedron() {
    a = [1, 1, 2*gold + 1];

    face_list = [
        [triangle(rot5*a), 20, "yellow"],
        [zsquare(a), 30, "green"],
        [pentagon(a), 12, "magenta"]
        ];

    polygon_face_set(face_list, joiners=vertical_joiners);
}

module truncated_icosidodecahedron() {
    p = [gold-1, gold-1, 3 + gold];

    face_list = [
        [zsquare(p), 30, "green"],
        [canonvv(double(triangle(rot5*p))), 20, "yellow"],
        [canonvv(double(pentagon(p))), 12, "magenta"]];
    polygon_face_set(face_list);
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
        [[p, rz(p), rz(rot5_4 * p)], -60, "pink", 2],
        [triangle(rot5*p), -20, "yellow"]
        ];

    joiners=[[1, -3.5, 0, 0], [0, 2.5, 0, 0]];
    polygon_face_set(face_list, joiners=joiners);
}

module tetrahedron() {
    $join_depth = 4;
    p = [1,1,-1];
    face_list = [[triangle(p), 4, "red", 2]];
    joiners=[[-13, 6], [-13, -6]];
    polygon_face_set(face_list, joiners=joiners);
}

module plato_cube() {
    p = [1,1,1];
    face_list = [[zsquare(p), 6, "green", 2]];
    joiners=[[-9, 6], [-9, -6]];
    polygon_face_set(face_list, joiners=joiners);
}

module octohedron() {
    p = [0,0,1];
    face_list = [[triangle(p), 8, "orange", 2]];
    joiners = [[-7.5, 9], [-7.5, -9]];
    polygon_face_set(face_list, joiners=joiners);
}

module dodecahedron() {
    p = [0,gold-1,gold];
    face_list = [[pentagon(p), 12, "magenta", 2]];
    joiners = [[-5, 5], [-5, -5]];
    polygon_face_set(face_list, joiners=joiners);
}

module icosahedron() {
    p = [1,0,gold];
    face_list = [[triangle(p), 20, "yellow", 2]];
    joiners = [[-4.5, 10], [-4.5, -10]];
    polygon_face_set(face_list, joiners=joiners);
}

module joinable_frustum(w, cut=0.75, joiners, colour) {
    mean = sum(w) / len(w);
    w_inscribe = norm(mean);
    flipper = $flip
        ? [[1, 0, 0], [0, 1, 0], [0, 0, -1, w_inscribe * (1 - cut)]]
        : [[1, 0, 0], [0, 1, 0], [0, 0, 1]];

    multmatrix(flipper) difference() {
        translate([0, 0, -cut * w_inscribe]) verticate_align(w) difference() {
            color(colour) chamfer_pyramid(w);
            for (i = [1:len(w)]) {
                for (j = joiners[i % len(joiners)]) {
                    v   = len(j) == 4 ? j[0] : 0.5 - 0.5 * sign(j[0]);
                    vmm = len(j) == 4 ? j[1] : j[0];
                    h   = len(j) == 4 ? j[2] : -0.5 * sign(j[1]);
                    hmm = len(j) == 4 ? j[3] : j[1];
                    mid_vertex_joiner_post(
                        w[i-1], w[i%len(w)],
                        radius=cut + v * (1 - cut), radius_mm=vmm,
                        offset=h, offset_mm=hmm);
                }
            }
        }
        translate([0, 0, -$radius]) cube(2*$radius, center=true);
    }
}

module polygon_face_set(faces, cut=0.75,
                        joiners=vertical_joiners,
                        modulo_joiners=undef) {
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
        j = len(f) <= 4 ? [joiners] : f[4];
        if ($piece == p) {
            joinable_frustum($radius / norm(face[0]) * face, cut, j, f[2]);
        }
    }
}

module polygon_face_all(faces) {
    for (f = faces) color(f[2]) polygon_faces(f[0], f[1]);
}

module polygon_faces(face, copies) {
    total = copies * len(face);
    echo("Total", total, "from", copies, "of", len(face));
    echo("Edge length", $radius * norm(face[1] - face[0]) / norm(face[0]));
    echo("Inscribe", $radius * norm(sum(face)) / len(face) / norm(face[0]));
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
    else if (abs(copies) == 4)
        pyramids(four(face));
    else if (copies == 1)
        pyramid(face);
    else
        assert(false);
}

//$piece = 1;
//$radius = 50;
//truncated_icosidodecahedron(false);
