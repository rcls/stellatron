use <functions.scad>
use <splitting.scad>
use <stand.scad>
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

// 0 = raw object, 1, 2... = main printables, 10 = stand.
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

    // 50... for duals.
    if (archimedes == 52) rhombic_dodecahedron();
    if (archimedes == 56) disdyakis_dodecahedron();
    if (archimedes == 58) rhombic_triacontahedron();
    if (archimedes == 62) disdyakis_triacontahedron();

    // 101 - 175 for the Skilling numbering of the uniform compounds.
    // 201 - 275 for their duals.
    if (archimedes == 246) two_dodecahedra();
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
    function tribonacci(a = 2, n=7) = n <= 0 ? a : let (
        delta = (a*a*a - a*a - a - 1) / (3*a*a - 2*a - 1),
        b = a - delta)
        echo(b, delta) tribonacci(b, n - 1);
    t = tribonacci();
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

module truncated_icosidodecahedron() {  // Aka great rhombicosidodecahedron.
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
    joiners=[[-13.25, 6.5], [-13.25, -6.5]];
    polygon_face_set(face_list, cut=0.7, joiners=joiners);

    if ($piece == 10) {                 // Stand.
        stand_diameter = 10;
        echo($radius * sqrt(8/3));
        target = $radius * sqrt(2)/3 + 0.2;
        sr = stand_diameter / 2;
        arc_radius = target * 2 - sr;
        difference() {
            for (a = [-90, -210, 30]) rotate(a) {
                    rotate([0,90,0]) translate([-arc_radius, -arc_radius-sr, 0])
                        rotate_extrude(angle=150, $fn=$fn * 10)
                        translate([arc_radius, 0])
                        circle(stand_diameter / 2);
                    translate([0, target - arc_radius - sr,
                               sqrt(3) * target + arc_radius])
                        sphere(stand_diameter, $fn=$fn * 5);
                    translate([0, -arc_radius-sr, 0]) sphere(sr, $fn=$fn*2);
                }
            translate([0, 0, sqrt(3) * target + arc_radius]) {
                linear_extrude(10) circle($radius * sqrt(8) / 3, $fn = 3);
            }
            translate([0,0,-sr])
                cube([5 * target, 5 * target, stand_diameter], center=true);
        }
        rounded_ring(outer=arc_radius+sr, inner=arc_radius-sr, n=$fn*5);
    }
    if ($piece == 11) {
        stand_diameter = 8;
        gap = 0.4;
        target = $radius * sqrt(2)/3 + 0.2 - gap;
        angle = 75;
        difference() {
            for (a = [60, 180, -60])
                rotate(a) bent_dumbell(target, stand_diameter, angle, gap);
            translate([0,0,-stand_diameter])
                cube([3 * target, 3 * target, 2 *stand_diameter], center=true);
            translate([0,0, bd_height(target, stand_diameter, angle, gap)])
                linear_extrude(stand_diameter)
                circle($radius * sqrt(8) / 3, $fn = 3);
        }
    }
    module bent_dumbell(target, stand_diameter, angle, gap) {
        c = cos(angle);
        s = sin(angle);
        sr = stand_diameter / 2;
        outer_radius = target / (1 - c);
        mid_radius = outer_radius - sr;
        translate([outer_radius + gap, 0, outer_radius * s])
        rotate([90,0,0]) rotate(180-angle) {
            rotate_extrude(angle=angle*2, $fn=$fn*10)
                translate([mid_radius, 0]) circle(sr);
            translate([outer_radius, 0, 0]) sphere(stand_diameter, $fn=$fn*5);
            rotate(angle*2)
                translate([outer_radius, 0, 0]) sphere(stand_diameter, $fn=$fn*5);
        }
    }
    function bd_height(target, stand_diameter, angle, gap) =
        2 * sin(angle) * target / (1 - cos(angle));
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
    polygon_face_set(face_list, joiners=joiners, cut=0.9);
}

module rhombic_dodecahedron() {
    p1 = [0, 0, 1];
    p2 = [1, 0, 0];
    q1 = [0.5, 0.5, 0.5];
    q2 = [0.5, -0.5, 0.5];
    face = [p1, q1, p2, q2];
    mult = $piece < 1 ? 1 / norm(q1) : $radius / norm(q1);
    echo("Edge", mult * norm(p1 - q1));
    if ($piece <= 1)
        for (f = twelve(face))
            pyramid(mult * f);
    if ($piece == 2)
        joinable_frustum(mult * face, 0.85,
                         [[[-6,-9],[-6,9]]]);
}

module disdyakis_dodecahedron() {
    p = [0, 0, 1];
    q = unit([1, 1, 1]);
    r = unit([0, 1, 1]);
    c = unit([1, 1 + sqrt(2), 1 + 2 * sqrt(2)]);
    if ($piece == 11) {
        for (v = fortyeight([c])) translate(v[0]) color("black") sphere(0.025);
        color("#ffffee", 0.75) sphere(0.9, $fn=100);
        for (v = six([p])) translate(v[0]) color("lightgreen") sphere(0.025);
        for (v = eight([q])) translate(v[0]) color("magenta") sphere(0.025);
        for (v = twelve([r])) translate(v[0]) color("yellow") sphere(0.025);
        translate(p) color("lightgreen") sphere(0.05);
        translate(q) color("magenta") sphere(0.05);
        translate(r) color("yellow") sphere(0.05);
    }
    echo("Lengths", $radius * [norm(p - q), norm(q - r), norm(r - p)]);
    face_list = [[[r, q, p], 24, "white", 2],
                 [[p, q, rmz(r)], 24, "black", 3]];
    polygon_face_set(face_list);
    if ($piece == 4) {
        rot = [[0, 0, sqrt(2)], [1, 1, 0], [-1, 1, 0], ] / sqrt(2);
        //rot = [[0, 0, sqrt(2)], [-1, 1, 0], [1, 1, 0]] / sqrt(2);
        //rot = 1;
        // Expand a bit, and orient on a convenient plane.
        pp = $radius * 1.128092 * rot * p;
        qq = $radius * 1.128092 * rot * q;
        rr = $radius * 1.128092 * rot * r;
        // Inner points for the cutting.
        ip = ($radius - 5) * unit(pp);
        iq = ($radius - 5) * unit(qq);
        ir = ($radius - 5) * unit(rr);
        // Normal to the cut triangle.
        n = unit(cross(iq - ip, ir - ip));
        cut_distance = ip * n;
        // Cut normal projected to x-y plane.
        medial = unit([n.x, n.y, 0]);
        echo(norm(pp), norm(qq), norm(rr));
        translate([-cut_distance, 0, 0]) intersection() {
            multmatrix([[medial.x, medial.y, 0],
                        [-medial.y, medial.x, 0],
                        [0, 0, 1]]) difference() {
                polyhedron(
                    points = [[0,0,0], pp, qq, rr],
                    faces = [[0, 1, 2], [0, 2, 3], [0, 3, 1], [3, 2, 1]]);
                mid_vertex_joiner_post(pp, qq, -10, 1, +8, -0.5);
                mid_vertex_joiner_post(pp, qq, -10, 1, -8,  0.5);

                mid_vertex_joiner_post(rr, qq, -9.5, 1, +5, -0.5);
                #mid_vertex_joiner_post(rr, qq, -9.5, 1, -5.25,  0.5);

                #mid_vertex_joiner_post(pp, rr, -9, 1, +7.25, -0.5);
                mid_vertex_joiner_post(pp, rr, -8, 1, -8, +0.5);
                inverticate(n) raise(cut_distance - $radius / 2)
                    cube($radius, center=true);
            }
            sphere($radius, $fn=$fn*20);
        }
    }
}

module rhombic_triacontahedron() {
    p = [gold, 0, gold + 1];
    q = [0, 1, gold + 1];
    face = [q, p, rz(q), rz(p)];
    mult = $piece < 1 ? 1 / norm(p) : $radius / norm(p);
    echo("Edge", mult * sqrt(2 + gold));
    if ($piece <= 1)
        for (f = canonvvv(sixty(face)))
            if (f[1] < f[3])
                pyramid(mult * f);
    if ($piece == 2) {
        joinable_frustum(mult * face, 0.9,
                         [[[-3.5,-9],[-3.5,9]]]);
    }
}

module disdyakis_triacontahedron() {
    p = [0, 0, 1];
    q = unit([1, 0, gold]);
    r = unit([0, gold-1, gold]);
    c = unit([gold-1, gold-1, gold+3]);
    if ($piece == 11) {
        for (v = sixty([p])) translate(v[0]) color("lightgreen") sphere(0.025);
        for (v = twelve([q])) translate(v[0]) color("magenta") sphere(0.025);
        for (v = twenty([r])) translate(v[0]) color("yellow") sphere(0.025);
        for (v = onetwenty([c])) translate(v[0]) color("black") sphere(0.025);
        color("#ffffee", 0.75) sphere(0.9, $fn=100);
        translate(p) color("lightgreen") sphere(0.05);
        translate(q) color("magenta") sphere(0.05);
        translate(r) color("yellow") sphere(0.05);
    }
    echo("Lengths", $radius * [norm(p - q), norm(q - r), norm(r - p)]);
    face_list = [[[r, q, p], 60, "white", 2],
                 [[p, q, my(r)], 60, "black", 3]];
    polygon_face_set(face_list);
    if ($piece == 4) {
        pp = pls($radius * 1.05581 * rot5_2 * p);
        qq = pls($radius * 1.05581 * rot5_2 * q);
        rr = pls($radius * 1.05581 * rot5_2 * r);
        n = unit(cross(qq - pp, rr - pp));
        radial = (pp * n) * n;
        echo(norm(radial));
        medial = unit([n.x, n.y, 0]);
        echo(norm(pp), norm(qq), norm(rr));
        translate([12 - $radius, 0, 0]) rotate(-50.4) difference() {
            intersection() {
                polyhedron(
                    points = [[0,0,0], pp, qq, rr],
                    faces = [[0, 1, 2], [0, 2, 3], [0, 3, 1], [3, 2, 1]]);
                multmatrix([[medial.x, -medial.y, 0],
                            [medial.y, medial.x, 0],
                            [0, 0, 1]])
                    translate([$radius - 12, -$radius/2, 0]) cube($radius);
                sphere($radius, $fn=$fn*20);
            }
            mid_vertex_joiner_post(pp, qq, -6, 1, +10, -0.5);
            mid_vertex_joiner_post(pp, qq, -8.5, 1, -5,  0.5);

            mid_vertex_joiner_post(rr, qq, -8, 1, +10, -0.5);
            #mid_vertex_joiner_post(rr, qq, -8.2, 1, -5.5,  0.5);

            #mid_vertex_joiner_post(pp, rr, -6.4, 1, +5, -0.5);
            mid_vertex_joiner_post(pp, rr, -6.5, 1, -5, +0.5);
        }
    }
}

module two_dodecahedra() {
    A = [for (r = rotate5) canonv(r * [0, gold-1, gold])];
    factor = $radius / sqrt(3);
    if ($piece == 1) {
        scale(1 / sqrt(3)) twelve() pyramid(A);
        color("red") rotate(90) scale(1 / sqrt(3)) twelve() pyramid(A);
        scale(1/sqrt(3)) {
            color("black") translate([1,-1,1]) sphere(0.1);
            color("black") translate([1,1,1]) sphere(0.1);
            color("black") translate([0,0,gold]) sphere(0.1);
            color("blue") translate([gold-1,0,gold]) sphere(0.1);
        }
    }
    if ($piece == 2) {
        p = factor * [0,0,gold];
        q1 = factor * [1,1,1];
        q2 = factor * [1, -1, 1];
        apex = factor * [gold - 1, 0, gold];
        intersection() {
            translate([2 - $radius * 0.65, 0, 0])
                verticate(cross(q2, q1))
                trapezohedron_uncut([p, q1, q2], apex,
                                    // cut_radius = $radius * 0.68 - 2,
                                    joiners=[
                                        [[-3, 16], [-3, -16]],
                                        [[-5.5, 19], [-5.5, -19]],
                                        [[-3, 16], [-3, -16]],
                                        ]
                    );
            translate([$radius, 0, 0]) cube(2 * $radius, center=true);
        }
    }
}

module joinable_frustum(w, cut=0.75, joiners, colour) {
    mean = sum(w) / len(w);
    w_inscribe = norm(mean);
    flipper = $flip
        ? [[1, 0, 0], [0, 1, 0], [0, 0, -1, w_inscribe * (1 - cut)]]
        : [[1, 0, 0], [0, 1, 0], [0, 0, 1]];

    multmatrix(flipper) difference() {
        translate([0, 0, -cut * w_inscribe]) verticate_align(w) difference() {
            color(colour) pyramid(w); // chamfer_pyramid(w);
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
        if ($piece == p)
            joinable_frustum($radius / norm(face[0]) * face, cut, j, f[2]);
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
