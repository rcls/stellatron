
include <numbers.scad>
use <functions.scad>
use <splitting.scad>
use <stand.scad>

$fn = 20;
$join_diameter = 2.1;
$join_depth = 5;
$radius = 65;
$stand_diameter = 8;
$piece = 10;

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

$decorate = $preview;

module dodecahedron() scale(1 / sqrt(3)) twelve() pyramid(A);

function final_dual_triangle() = [A[0], C[4], C[1]] / sqrt(3);

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
    pyramids(canonvvv(twenty(hexagon(A[3], A[4]))));
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

module tetrahemihexahedron() {
    face = [[0,0,1],[0,1,0],[1,0,0]];
    if ($piece == 0)
        four() pyramid(face);
    if ($piece == 1)
        scale($radius) four() pyramid(face);
    if ($piece == 2) {
        raise($radius/sqrt(3)) verticate(-[1,1,1]) difference() {
            scale($radius) pyramid(face);
            three() rotate([-45,0,0]) {
                translate([$radius*3/4,0,0]) joiner_post_unchamfer();
                translate([$radius/4,0,0]) joiner_post_unchamfer();
            }
        }
    }
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
                      joiners=joiners, span=2, chamfer=[1:2:10]);

    if ($piece == 3)
        trapezohedron(hexagon(P[0], mns(Q[0])),
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
                      $radius * inscribe - 7, joiners=joiner, span=2,
                      chamfer=[1:2:10]);

    else if ($piece == 3)
        trapezohedron(wedge, wedge_c, $radius * 0.75, joiners=joiner, span=2);
}

module great_ditrigonal_icosidodecahedron() {
    pyramids(canonvvv(twenty([A[2], A[0], B[1]])), topcolor=color20);
    pyramids(coset(canonvvv(sixty(B))), topcolor=color12);
}

module ditrigonal_dodecadodecahedron() scale(1 / sqrt(3)) {
    // Dual to the Medial triambic icosahedron.  As this is a
    // dodecadodecahedron, lets use a different second color!
    twelve() star_pyramid(A, a=sum(A)/5 * (7 - 4 * gold), topcolor=color12,
                          undercolor=color12b);
    twelve() star_pyramid(B, topcolor=color12b);
}

module dodeca_tri_split() {
    // This ain't gonna work for the ditrigonal_dodecadodecahedron.
    h = $radius * (gold - 1) / 2 * coscribe;
    hm = h - $extra_z_remove;
    hp = h + $extra_z_remove;
    if ($piece == 0)
        children();
    if ($piece == 1) {
        translate([0, 0, hm]) intersection() {
            with_joiners() children();
            cube([$radius * 3, $radius * 3, 2 * hm],
                 center=true);
        }
    }
    if ($piece == 2) {
        intersection() {
            translate([0, 0, -hp]) with_joiners() children();
            translate(-$radius * [1.5, 1.5, 0])
                cube([$radius * 3, $radius * 3, $radius]);
        }
    }

    module with_joiners() {
        scale($radius) pointup() children();
    }
}

module flushtruncated_great_icosahedron() scale(1 / sqrt(3)) {
    twelve() star_pyramid(A);
    color("lightgreen") pyramids(twenty(hexagon(A[3], A[4])));
}

module two_icosahedra() {
    module eight() {
        for (x = [-1, 1]) for (y = [-1, 1]) for (z = [-1, 1])
            multmatrix([[x, 0, 0], [0, y, 0], [0, 0, z]]) children();
    }
    p1 = (gold - 1) * I0 + (2 - gold) * IA[1];
    p2 = (2 + gold) / 5 * I0 + (3 - gold) / 5 * IA[2];
    p3 = (2 + gold) / 5 * I0 + (3 - gold) / 5 * IA[3];
    p4 = (gold - 1) * I0 + (2 - gold) * IA[4];
    p5 = (I0 + IA[0]) / 2;
    module pent() {
        p = [p1, p2, p3, p4, p5];
        for (i = [1:5]) pyramid([I0, p[i-1], p[i%5]]);
    }
    color("yellow") twelve() pent();
    color("lightblue") rotate(90) twelve() pent();
    eight() color("lightgreen") pyramid(hexagon(p2, p1));
}

module great_icosidodecahedron() {
    if ($piece == 0)
        gid_main();
    if ($piece == 1)
        scale($radius) gid_main();
    if ($piece == 2)
        gid_cp();
    if ($piece == 3)
        gid_3p();
    if ($piece == 5)
        gid_5t();
    if ($piece == 10)
        gid_stand();

    module gid_main() {
        p1 = [0, 0, 1];
        q = rot5 * p1;
        p2 = [q.y, q.z, -q.x];
        p3 = [q.y, -q.z, -q.x];
        for (f = coset(sixty([p1, p2, p3]))) pyramid(f, topcolor="violet");
        for (f = twelve(pentagon(rz(q)))) star_pyramid(f, topcolor="gold");
        if (true) {
            mark(p1, r=0.02, c="black");
            mark(rot5 * p1, r=0.02, c="green");
            mark(mz(rot5 * p1), r=0.02, c="green");
            mark(rot5_2 * p1, r=0.02, c="blue");
            mark(rx(rot5_2 * p1), r=0.02, c="blue");
            mark(mns(rot5 * p1), r=0.02, c="red");
            mark(rot3(p1), c="black", r=0.02);
            mark(rot3(rot3(p1)), c="black", r=0.02);
            mark([gold-1,0,2-gold], r=0.02, c="yellow");
            mark([2-gold,0,2-gold], r=0.02, c="orange");
            mark([3*gold-4,1/gold,1]/2, r=0.02, c="purple");
            mark(sum([for (r = rotate5) r * mns(rot5 * p1)]) / 5, c="black", r=0.02);
        }
        function rot3(v) = rot5 * mns(rot5_4 * v);
    }

    module gid_5t() {
        p = [0,0,$radius];
        q = mns(rot5 * p);
        center = sum([for (r = rotate5) r * q]) / 5;
        echo(norm(p - rot5 * p));
        difference() {
            intersection() {
                verticate(center) translate(-center) {
                    mark(center, r=0.02, c="black");
                    difference() {
                        for (f = five([p, rot3(p), rot3(rot3(p))]))
                            pyramid(f);

                        for (f = five([p, rot3(p), rot3(rot3(p))])) {
                            #edge_joiner_post(f[0], f[2], 21, -9.5);
                            #edge_joiner_post(f[0], f[1], 24, -9.5);
                        }
                    }
                }
                translate([0,0, $radius]) cube(2 * $radius, center=true);
            }
            for (a = [0:72:288]) {
                $join_depth=2.5;
                #rotate(a) translate([-$radius*0.1-5.5,0,0]) joiner_post();
            }
        }
        function rot3(v) = rot5 * mns(rot5_4 * v);
    }

    module gid_3p() {
        p = [0,0,$radius];
        q = rot5 * p;
        r = mz(q);
        s = rx(rot5_2 * p);
        echo(norm(q - mns(q)));
        base = [q, mns(q), pls(q)] / gold;
        center = sum([q, mns(q), pls(q)]) / 3 / gold;
        intersection() {
            verticate(center, align=q) translate(-center) three() {
                difference() {
                    pyramid([q,r,s]);
                    #edge_joiner_post(q, r, 21, -9.5);
                    #edge_joiner_post(q, s, 24, -9.5);
                }
            }
            translate([0,0,$radius/2]) cube($radius, center=true);
        }
    }

    module gid_cp() {
        difference() {
            cylinder(r=($radius/10 + 5) * 2/gold, h=1, $fn=5);
            for (a = [0:72:288])
                #rotate(a) translate([-$radius*0.1-5.5,0,0]) joiner_post();
                }
    }

    module gid_stand() {
        //stand_rhombus(0.38, 2*gold-3)
        stand_rhombus(2 - gold, 2*gold - 3)
        //stand_rhombus(1 - gold/2, 2*gold - 3)
            gid_main();
    }
}

module small_stellated_truncated_dodecahedron() {
    p = [1, 1, 2 * gold + 1];           // Vertex.  2φ+1 = φ(φ+1) = φ³.
    mult = $piece == 0 ? 1 : $radius / norm(p);
    deca = canonvv(decagon(rz(p), rot5_3 * pls(p)));
    penta = canonvv(pentagon(rz(mns(p))));
    normal = canonv(sum(deca)/10);      // Point on center of decagram.
    assert(normal == [gold, 0, gold + 1], str(normal));

    // Apex of crown slopes.
    pit = [2 - gold, 0, gold - 1];
    assert(canonv(rot5 * pit) == pit);

    crux = [2 - gold, 0, 3 * gold - 1];//[3 - gold, gold, 2 * gold];   // Dip in the crown edge.
    echo(rot5_4 * crux);
    if ($piece <= 1) {
        scale(mult) {
            color("lightgreen") star_pyramids(twelve(deca), 3);
            color("gold") pyramids(twelve(penta));
            mark(normal, r=0.1, c="black");
            mark(p, c="red");
            mark(p + 0.309017 * (pit - p), c="red", r=0.0001);
            mark(crux, r=0.1, c="blue");
            mark(pit, c="purple");
        }
    }
    if ($piece == 5) {
        un = unit(normal);
        difference() {
            scale(mult) verticate(normal) translate(-normal) polyhedron(
                points = [each decagon(crux, p),
                          each decagon(crux - crux * un * un, p - p * un * un),
                          pit],
                faces = [
                    for (i = [1:2:9]) [(i + 9) % 10, i, (i + 1) % 10, 20],
                    for (i = [0:9]) [(i + 1) % 10, i, i + 10, (i + 1) % 10 + 10],
                    [ for (i = [0:9]) 19-i ],
                    ],
                convexity=5);
            raise(-$radius / 2) cube($radius, center=true);
        }
    }
}

module great_stellated_truncated_dodecahedron() {
    // This is a facetation of a rhombicosidodecahedron, it works with any
    // (non)uniform variant of that.  But in general that will give non-regular
    // decagram faces.  The one we want has a regular decagram.
    alpha = [2 * gold - 1, 3 - gold, 2 * gold + 4];
    beta = [0, 7 - 4 * gold, 1 + 3 * gold];
    gamma = [5 * gold - 5, 0, 5];

    valley = [0, 0, 5];
    pit = (3 * gold - 2) * [1,1,1];

    mult = $piece == 0 ? 1 : $radius / norm(alpha);

    if ($piece == 0) {
        // Valley piece.
        mark(beta, "blue", 0.2);
        mark(alpha, "green", 0.2);
        mark(gamma, "orange", 0.15);
        mark(rot5_4 * alpha, "green", 0.15);
        mark(rz(beta), "blue", 0.15);
        mark(rz(alpha), "green", 0.15);
        mark(rz(gamma), "orange", 0.15);
        mark(rz(rot5_4 * alpha), "green", 0.15);
        mark(valley, "black", 0.15);

        // Triangle piece.
        mark(rot5 * alpha, "green", 0.2);
        mark(rot5 * beta, "blue", 0.15);
        mark(mns(rot5 * alpha), "green", 0.15);
        mark(pit, "black", 0.15);
    }
    if ($piece == 3) {
        points = mult * hexagon(rot5 * alpha, rot5 * beta);
        trapezohedron_verticate(points, mult * pit, $radius * 0.734808 - 10) {
            difference() {
                trapezohedron_uncut(points, mult * pit);
                skew_join2(points[0], points[2], points[1]);
                skew_join2(points[2], points[4], points[3]);
                skew_join2(points[4], points[0], points[5]);
            }
        }
    }
    if ($piece == 4) {
        half = mult * [beta, alpha, gamma, rot5_4 * alpha];
        points = [each half, each rrz(half)];
        easy_join = [[], [[-17,26], [-18,-12]], [[-18,12], [-17,-26]], []];
        trapezohedron_verticate(points, mult * valley, $radius * 0.649457 - 5)
            difference() {
            trapezohedron_uncut(points, mult * valley, joiners = easy_join);
            skew_join2(points[1], points[7], points[0]);
            skew_join2(points[5], points[3], points[4]);
        }
    }

    if ($piece == 0 || $piece == 1) {
        deca = canonvv(decagon(mns(alpha), rot5_4 * rx(pls(alpha))));
        tri = canonvv(triangle(rot5_3 * rz(alpha)));
        scale(mult) {
            color("crimson") star_pyramids(twelve(deca), 3);
            color("gold") pyramids(twenty(tri));
        }
    }
    // echo(norm(deca[1] - deca[0]) / norm(deca[2] - deca[1]) - 1);
    module skew_join2(u, v, w) {
        rad = norm((u + w) / 2) - 17;
        p = rad * unit((u + w) / 2);
        q = rad * unit((v + w) / 2);
        skew_joiner_post(p, cross(u, w), cross(p, q));
        skew_joiner_post(q, cross(v, w), cross(p, q));
    }
}

module truncated_great_icosahedron() {
    p0 = [2 - gold, 1, 2 * gold];
    mult = $piece == 0 ? 1 : $radius / norm(p0);
    p = mult * p0;
    pit = mult * [3 - 6 / sqrt(5), 0, 6/5 + 3/5 * gold];
    crux = mult * [1,0,3 * gold - 2];
    crss = mult * rot5_4 * [3, 3, 3] / gold;
    if ($piece == 0) {
        //q = rot5_2 * rx(mns(p));
        //r = rot5_2 * p;
        //s = rot5_4 * rx(mns(p));
        // q-p, p-r, r-s should be equal, p,q,r,s should be coplanar.
        //echo(norm(q - p) / norm(p - r) - 1);
        //echo(unit(q - p) * cross(unit(r - p), unit(s - p)));
        //mark(q, r=0.1);
        mark(p, r=0.1, "black");
        mark(crss, r=0.1, c="green");
        mark(crux, r=0.1, c="blue");
        //mark(rz(p), r=0.1, c="black");
        //mark(rot5_4 * mns(p), r=0.1, c="black");
        mark(pit, r=0.1, c="red");
    }
    if ($piece == 0 || $piece == 1) {
        color("yellow") star_pyramids(twelve(pentagon(p)));
        color("pink") pyramids(twenty(hexagon(rz(p), rot5_4 * mns(p))));
    }
    if ($piece == 2) {
        joiners = [[[-14,0],[-24,0]],[],[],[[-14,-0],[-24,0]],[]];
        trapezohedron_verticate([[1,0,1]], [0,0,$radius],
                                $radius * 0.63686 - 3) diffunion(2) {
            trapezohedron_uncut([crss, p, crux, my(p), my(crss)], pit,
                                joiners=joiners);
            trapezohedron_uncut(rrz([crss, p, crux, my(p), my(crss)]), rz(pit),
                                joiners=joiners);
            cube(1);
            skew_join2(p, my(p), crux);
            skew_join2(mx(p), rz(p), rz(crux));
        }
    }
    if ($piece == 5) {
        q = (gold - 1) * p + (2 - gold) * rot5_2 * p;
        star = decagon(p, q);
        //trapezohedron();
        center = sum(star) / len(star);
        trapezohedron_verticate(star, center, $radius * 0.855 - 14) difference() {
            trapezohedron_uncut(star, center);
            for (r = rotate5)
                #skew_join2(r * p, r * rot5 * p, r * q);
        }
    }
    module skew_join2(u, v, w) {
        rad = norm((u + w) / 2) - 14;
        p = rad * unit((u + w) / 2);
        q = rad * unit((v + w) / 2);
        skew_joiner_post(p, cross(u, w), cross(p, q));
        skew_joiner_post(q, cross(v, w), cross(p, q));
    }
}

//great_icosidodecahedron();
//great_id_5t();
//great_id_3p();
//great_id_cp();
//great_id_stand();
//half_id_tri_facet(0);
//half_id_tri_facet(1, [1,0,gold], $radius-20, [18:72:360]);
if (false)
difference() {
    half_id_tri_facet(2, [1,0,gold], $radius-28, [18:72:360]);
    r = 0.4 * $radius;
    h1 = 0.302 * $radius - 1;
    h2 = 0.598 * $radius - 1;
    rotate_extrude($fn = 100) {
        polygon(
            [[r, -0.01], [r, h1], [0, h2], [0, -0.01]],
            [[0, 1, 2, 3]]);
    }
}

module icosidodecahedron_triangle_facetation(n) {
    $fn = $fn ? $fn : 20;
    p1 = [1, 0, 0];
    p2 = [0, 1, 0];
    // mx(pls) works.
    // rz(mns) works.
    p3a = my((rot5 * [0, 0, 1])); // Outer
    p3b = mx(pls(rot5 * [0, 0, 1]));     // Mid
    p3c = rz(mns(rot5 * [0, 0, 1]));     // Inner
    // lots of the others work with a equatorial dodecagon.
    p3 = n == 0 ? p3a : n == 1 ? p3b : p3c;
    echo(p3.z);
    mark(p1, "red");
    mark(p2, "blue");
    mark(p3, "black");
    for (v = sixty([p1]))
        mark(v[0], "orange", 0.02);

    faces = onetwenty([p3, p2, p1]);
    rod_pyramid(faces[0], topcolor="lightgreen");
    for (i = [1:119])
        rod_pyramid(faces[i]);
}

module half_id_tri_facet(n=0, normal=[0,0,1],
                         offset = $radius-9, angles=[0:90:270]) {
    $decorate = false;
    difference() {
        scale($radius) intersection() {
            verticate(normal) icosidodecahedron_triangle_facetation(n);
            translate([0,0,1]) cube(2, center=true);
        }
        #for (i = angles)
            rotate(i) translate([offset, 0, 0]) joiner_post();
    }
}

module mark(v, c="gold", r=0.05) {
    if ($decorate)
        color(c) translate(v) sphere(r);
}

module rod_pyramid(f, topcolor="gold") {
    pyramid(f, topcolor=topcolor);
    for (i = [1:len(f)]) {
        u = f[i % len(f)];
        v = f[i - 1];
        n = norm(u-v);
        c = n < 1.2 ? "blue" : n < 1.5 ? "green" : "red";
        if ($decorate && vless(u, v))
            rod(u, v);
    }
}

module rod(u, v, c="green", r=0.005) {
    color(c) translate(u) inverticate(v-u)
        cylinder(r=r, h=norm(v-u));
}
