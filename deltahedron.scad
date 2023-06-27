use <functions.scad>
use <splitting.scad>
use <stand.scad>

// Number of the Johnson solid.
deltahedron = 84;

// Piece to generate, 1 for main object, 2 onwards for faces, 10 for stand.
$piece = 1;

// Edge length.
$radius = 75;

// Diameter of the joiner post holes.
$join_diameter = 2.1;
// Depth of the joiner post holes.
$join_depth = 5.001;

$fn=20;

if (deltahedron == 12)
    triangular_bipyramid();

if (deltahedron == 13)
    pentagonal_bipyramid();

if (deltahedron == 17)
    gyroelongated_square_bipyramid();

if (deltahedron == 51)
    triaugmented_triangular_prism();

if (deltahedron == 84)
    snub_disphenoid();

module triangular_bipyramid() {
    id = [[1, 0, 0], [0, 1, 0], [0, 0, 1]];
    rot3 = [[-1/2, -sqrt(3)/2, 0], [sqrt(3)/2, -1/2, 0], [0, 0, 1]];
    rot3_2 = transpose(rot3.x, rot3.y, rot3.z);
    johnson_bipyramid([id, rot3, rot3_2]);
}

module pentagonal_bipyramid() {
    c72 = -(1 - sqrt(5)) / 4;
    s72 = sqrt((5 + sqrt(5)) / 8);
    c144 = -(1 + sqrt(5)) / 4;
    s144 = sqrt((5 - sqrt(5)) / 8);
    johnson_bipyramid(
        [[[1,0,0], [0,1,0], [0,0,1]],
         [[c72, -s72, 0], [s72, c72, 0], [0, 0, 1]],
         [[c144, -s144, 0], [s144, c144, 0], [0, 0, 1]],
         [[c144, s144, 0], [-s144, c144, 0], [0, 0, 1]],
         [[c72, s72, 0], [-s72, c72, 0], [0, 0, 1]]]);
}

module johnson_bipyramid(matrices) {
    n = len(matrices);
    p = matrices[0] * [1, 0, 0];
    q = matrices[1] * [1, 0, 0];
    il = norm(p - q);
    r = [$radius / il, 0, 0];
    h = $radius * sqrt(1 - 1 / (il * il));
    module half() {
        polyhedron(
            [[0, 0, h], for (m = matrices) m * r],
            [[each [1:n]], for (i = [1:n]) [0, i%n + 1, i]]);
    }
    if ($piece == 1) {
        color("lightgrey") half();
        color("grey") multmatrix([[1, 0, 0], [0, -1, 0], [0, 0, -1]]) half();
    }
    if ($piece == 2) {
        ir = [14 * r.x / h, 0, 0];
        difference() {
            half();
            for (m = matrices) translate(m * (r - ir)) joiner_post();
        }
    }
    if ($piece == 10) {
        fn = 40;
        o_rad=$radius/4;
        i_rad=4;
        // Centre of the supporting arcs.
        arc_c = [i_rad + o_rad, 0, o_rad];
        // End of arc.
        arc_e = arc_c + o_rad/2 * [-1, 0, sqrt(3)];
        // This is the point we want an edge to go through...
        pp = arc_c + [-o_rad * h, 0, o_rad * r.x] / norm([h, r.x]);
        // Translate back to centerline...
        qq = [0, 0, pp.z - h / r.x * pp.x];
        // Length of bridge at top.
        bridge = 5;
        difference() {
            intersection () {
                for (m = matrices)
                    multmatrix(m) {
                        translate(arc_c) {
                            rotate([90, 0, 0])
                                rotate_extrude(/*angle=150,*/ $fn = fn * 4)
                                translate([o_rad, 0])
                                circle(i_rad, $fn = fn);
                            //translate([i_rad+o_rad, 0, 0]) sphere(i_rad, $fn = fn);
                            //translate(arc_e) sphere(i_rad, $fn = fn);
                            translate([0, 0, sqrt(o_rad * o_rad - bridge * bridge/4)])
                                rotate([0, 90, 0])
                                cylinder(h=bridge, r=i_rad, center=true, $fn=fn);
                        }
                    }
                translate([0, 0, $radius]) cube($radius*2, center=true);
            }
            cylinder(r=2, h=$radius, $fn=n);
            translate(qq + [0, 0, h])
                multmatrix([[1, 0, 0], [0, -1, 0], [0, 0, -1]]) half();
        }
        rounded_ring(outer=o_rad+i_rad, inner=o_rad*0.75, n=fn*4);
    }
}

module gyroelongated_square_bipyramid() {
    // One square has vertices at [0.5,0.5,0] & 90° rotations, the other at
    // 45° rotations of that.
    //
    // We want the height to give a lenth of one between those...
    // h² + ½² + (½ - sqrt(½))² = 1.
    // h² + ¼ + ¼ + ½ - sqrt(½) = 1
    // h = sqrt(sqrt(½))
    h_by_2 = $radius * 0.5 * sqrt(sqrt(0.5));
    // The pyramid height has:
    // v² + ½ = 1,
    // v = sqrt(½).
    top_z = h_by_2 + $radius * sqrt(0.5);
    top = [0, 0, top_z];
    upper = [$radius / 2, $radius / 2, h_by_2];
    lower = [0, $radius * sqrt(0.5), -h_by_2];
    bot = [0, 0, -top_z];
    rot90 = [[0, -1, 0], [1, 0, 0], [0, 0, 1]];

    main();

    if ($piece == 9)
        posts();

    if ($piece == 10)
        stand();

    module main($piece = $piece) {
        part(top, rot90 * upper, upper, "gold", 2);
        part(upper, rot90 * upper, lower, "magenta", 3);
    }

    module part(u, v, w, topcolor, p) {
        if ($piece == 1)
            zeight() pyramid([u, v, w], topcolor=topcolor);
        if ($piece == p)
            delta_unpost(u, v, w, topcolor) posts();
    }

    module zfour() {
        children();
        multmatrix(rot90) children();
        multmatrix(rot90*rot90) children();
        multmatrix(rot90*rot90*rot90) children();
    }
    module rotmir() {
        children();
        sqh = sqrt(0.5);
        multmatrix([[sqh, sqh, 0], [sqh, -sqh, 0], [0, 0, -1]]) children();
    }
    module zeight() rotmir() zfour() children();

    module posts() {
        zeight() {
            edge_joiner_post(top, upper, 14.5, -5.5);
            edge_joiner_post(top, upper, -10, -5.5);

            color("red") edge_joiner_post(rot90*upper, upper, 10, -4.5);
            color("blue") edge_joiner_post(rot90*upper, upper, -12, -7.7);

            color("green") edge_joiner_post(upper, lower, 10, -4.5);
            color("orange") edge_joiner_post(rot90*upper, lower, 10, -7.7);
        }
    }

    module stand() {
        //$fn = 5;
        sradius = $radius / 2;
        sheight = sradius * sqrt(0.75);
        mradius = 5; // $radius / 10;

        // Each post has radius sradius and meets a 45° edge, so it is
        // centered at sqrt(2) * sradius.
        origin = sqrt(2) * sradius;
        difference() {
            for (angle = [-90, 0, 90, 180]) {
                rotate(angle) {
                    translate([-origin, 0, 2]) {
                        rotate([90, 0, 0])
                            rotate_extrude(angle=60, $fn = $fn * 10)
                                translate([sradius, 0]) circle(mradius);
                        translate([sradius/2, 0, sheight])
                            sphere(mradius, $fn=$fn*4);
                    }
                    if (false)
                        rotate([90, 0, 0]) linear_extrude(height = 1, center=true)
                            polygon(
                                [
                                    [origin-sradius, 0],
                                    [origin-sradius+mradius, 0],
                                    [origin-sradius/2+mradius, sheight+2],
                                    [origin-sradius, sheight+2]],
                                [[0, 1, 2, 3]]);
                }
            }
            translate([0, 0, top_z + 2]) main($piece = 1);
        }
        intersection() {
            rotate_extrude($fn = $fn * 6) {
                hole = 6;
                translate([hole, 0]) circle(2);
                translate([$radius/2, 0]) circle(2);
                translate([hole, -2]) square([$radius/2 - hole, 4]);
            }
            translate([0, 0, 1]) cube([$radius*1.5, $radius*1.5, 2], center=true);
        }
    }
}

module triaugmented_triangular_prism() {
    rot3 = [[-0.5, sqrt(0.75), 0], [-sqrt(0.75), -0.5, 0], [0, 0, 1]];
    rot3_2 = transpose(rot3.x, rot3.y, rot3.z);
    rot2 = [[1, 0, 0], [0, -1, 0], [0, 0, -1]];

    p = [$radius/sqrt(3), 0, $radius/2];
    q = rot3 * p;
    r = rot3_2 * p;
    t = [-$radius * (sqrt(1/12) + sqrt(1/2)), 0, 0];
    assert(norm(p - q) > $radius * 0.99999);
    assert(norm(p - q) < $radius * 1.00001);
    assert(norm(r - q) > $radius * 0.99999);
    assert(norm(r - q) < $radius * 1.00001);
    assert(norm(t - q) > $radius * 0.99999);
    assert(norm(t - q) < $radius * 1.00001);

    main();

    module main() {
        part(p, q, r, "gold", 2);
        part(r, q, t, "lightblue", 3);
        part(q, [q.x, q.y, -q.z], t, "magenta", 4);
    }

    if ($piece == 1 || $piece == 9)
        posts();

    if ($piece == 10)
        stand();

    module part(u, v, w, topcolor, p) {
        if ($piece == 1 && p != 2)
            six() pyramid([u, v, w], topcolor=topcolor);

        if ($piece == 1 && p == 2)
            two() pyramid([u, v, w], topcolor=topcolor);

        if ($piece == p)
            delta_unpost(u, v, w, topcolor) posts();
    }

    module two() {
        children();
        multmatrix(rot2) children();
    }
    module three() {
        children();
        multmatrix(rot3) children();
        multmatrix(rot3_2) children();
    }
    module six() three() two() children();

    module posts() {
        six() {
            color("orange") edge_joiner_post(q, r, 14, -5);
            color("yellow") edge_joiner_post(q, r, -14, -5);

            color("red") edge_joiner_post(p, rot2 * p, 10, -4);

            color("green") edge_joiner_post(t, q, 14.5, -5.5);
            color("blue") edge_joiner_post(t, r, 14.5, -5.5);

            color("lightgreen") edge_joiner_post(t, q, -11.3, -5.5);
            color("lightblue") edge_joiner_post(t, r, -11.3, -5.5);
        }
    }

    module stand() {
        $fn = 60;
        h = 20;
        r = 5;
        rad = $radius / sqrt(3);
        rounded_ring(rad + r, rad - r, n = 100);
        difference() {
            for (i = [0, 120, -120]) {
                rotate(i) {
                    translate([rad, 0, 0]) cylinder(h=h, r=r);
                    translate([rad, 0, h]) sphere(r);
                }
            }
            translate([0, 0, h + $radius / 2]) { $piece = 1; main(); }
        }
    }
}

module snub_disphenoid() {
    // This object isn't a cow so arbitrary use $radius as the edge length.
    top = $radius * [0.5, 0, 0.7839309101528681];
    upper = $radius * [0, 0.6445842843416881, 0.20556156416389393];
    lower = [upper.y, upper.x, -upper.z];
    bot = [top.y, top.x, -top.z];

    m = [[-1, 0, 0], [0, 1, 0], [0, 0, 1]];

    part(top, rz(top), upper, "gold", 2);
    part(top, upper, lower, "lightblue", 3);
    part(m*top, m*lower, m*upper, "lightblue", 4);

    if ($piece == 9)
        posts();

    if ($piece == 10)
        stand();

    module part(u, v, w, topcolor, p) {
        if ($piece == 1)
            rotmirz() pyramid([u, v, w], topcolor=topcolor);
        if ($piece == p)
            delta_unpost(u, v, w, topcolor) posts();
    }

    module rotmirz() {
        children();
        rotate(180) children();
        rotate(90) rotate([180, 0, 0]) children();
        rotate(-90) rotate([180, 0, 0]) children();
    }

    module posts() {
        rotmirz() {
            color("green") post(top, rz(top), -10, -6);

            edge_joiner_post(top, upper, -8, -7);
            edge_joiner_post(top, upper, 12, -7);
            edge_joiner_post(rz(top), upper, -10, -8.68);
            edge_joiner_post(rz(top), upper, 12, -7);

            edge_joiner_post(top, lower, 16, -7);
            edge_joiner_post(top, lower, -8, -7);

            edge_joiner_post(upper, lower, -13, -7);
            edge_joiner_post(upper, lower, 13, -7);

            edge_joiner_post(upper, rz(lower), -13, -7);
            edge_joiner_post(upper, rz(lower), 13, -7);
        }
    }

    module stand() {
        $fn = 80;

        difference() {
            union() {
                arc(angle=45, big_R=$radius*0.6, little_r=$radius/10,
                    offset=$radius/10, rot=0);
                arc(angle=45, big_R=$radius*0.6, little_r=$radius/10,
                    offset=$radius/10, rot=180);

                arc(angle=55, big_R=$radius/5, little_r=$radius/10,
                    offset=$radius*0.2, rot=90);
                arc(angle=55, big_R=$radius/5, little_r=$radius/10,
                    offset=$radius*0.2, rot=-90);
            }

            #translate([0, 0, top.z+$radius*0.15]) main();
        }

        rotate_extrude() {
            square([$radius / 3, 2]);
            translate([$radius / 3, 0]) intersection() {
                circle(2);
                translate([-3,0]) square(6);
            }
        }

        module arc(angle, big_R, little_r, offset, rot=0) {
            rotate(rot) translate([-(big_R + offset), 0, 0]) rotate([90, 0, 0])
            {
                rotate(angle) translate([big_R, 0]) sphere(little_r);
                rotate_extrude(angle=angle)
                    translate([big_R, 0]) circle(little_r);
            }
        }
    }
}

module delta_unpost(u, v, w, topcolor) {
    c = (u + v + w) / 3;
    normal = unit(cross(v - u, w - u));
    intersection() {
        verticate(normal) translate(-c) difference() {
            pyramid([u, v, w], topcolor=topcolor);
            children();
        }
        cube([2 * $radius, 2 * $radius, 20], center=true);
    }
}
