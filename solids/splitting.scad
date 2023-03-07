
// PRINTING FORMS
//
// Convert the raw stellation to a printable object.  Normalise the scaling to a
// the exterior `$radius`, divide into practical objects, and create guiding
// indentations for joining.

use <functions.scad>
include <numbers.scad>

module dodeca_single() {
    if ($piece == 0) {
        children();
    }
    if ($piece == 1) {
        difference() {
            translate([0,0,-$extra_z_remove])
                dodeca_pointup() children();
            if ($extra_z_remove > 0)
                translate([0,0,-1.1 * $radius]) cube(2.2 * $radius, center=true);
        }
    }
}

module dodeca_spikey(post=0.1, inset=0, raise = (2 * gold - 1) / 5) {
    if ($piece == 0) {
        children();
    }
    if ($piece == 1) {
        difference() {
            translate([0, 0, -$extra_z_remove])
                dodeca_pointup(post=post, inset=inset, raise=raise) children();
            translate([0,0,-1.1 * $radius]) cube(2.2 * $radius, center=true);
        }
    }
    if ($piece == 2) {
        difference() {
            translate([0,0, -$extra_z_remove]) rotate([0,180,0])
                dodeca_pointup(post=post, inset=inset, raise=raise) children();
            translate([0,0,-1.1 * $radius]) cube(2.2 * $radius, center=true);
        }
    }
}

module icosa_top_bottom(raw_radius, post=0, inset=5, angle=0) {
    if ($piece == 0) {
        children();
    }
    if ($piece == 1) {
        difference() {
            translate([0, 0, -$extra_z_remove])
                icosa_tb_whole(raw_radius, post, inset, angle)
                children();
            translate([0, 0, -$radius * 1.1]) cube($radius * 2.2, center=true);
        }
    }
    if ($piece == 2) {
        difference() {
            translate([0, 0, -$extra_z_remove]) rotate([0,180,0])
                icosa_tb_whole(raw_radius, post, inset, angle)
                children();
            translate([0,0, -$radius * 1.1]) cube($radius * 2.2, center=true);
        }
    }
}

module icosa_tb_whole(raw_radius, post=0, inset=0, angle=0) {
    offset = inscribe * radius1 / raw_radius;
    difference() {
        scale($radius)
            translate([0, 0, offset]) faceup() children();
        if (post != 0)
            for (i = [0:2])
                joiner_post(120 * i + angle,
                            [$radius * post - inset * sign(post), 0, 0]);
    }
}

// Rotate so an icoshedral face is upwards.  Rotate by half the icosahedron
// dihedral angle.
module faceup() {
    // This is actually the complement angle!
    c = dodeca_comidscribe;
    s = dodeca_midscribe;
    multmatrix([[c, 0, s, 0], [0, 1, 0, 0], [-s, 0, c, 0]]) children();
}

// Rotate so an icosahedron point is upwards.  Rotate by half the dodecahedron
// dihedral angle.
module pointup() {
    c = icosa_midscribe;
    s = icosa_comidscribe;
    multmatrix([[c, 0, s, 0],
                [0, 1, 0, 0],
                [-s, 0, c, 0]])
        children();
}

// Position so the 6a, 6b dodecahedron is resting on the x-y plane, with an
// icosahedral point upper most.
module dodeca_pointup(post=0, inset=0, raise = (2 * gold - 1) / 5) {
    difference() {
        scale($radius)
            translate([0, 0, raise])
            pointup()
            children();
        if (post != 0) {
            for (i = [0:4]) {
                joiner_post(72 * i + 90 * sign(post) - 90,
                            [abs(post) * $radius - inset, 0, 0]);
            }
        }
    }
}

// Given a point in a constant x+y+z plane, and a faceup object, rotate around
// the z axis to get the image of the point at a 'y' position.
module align_rot(point) {
    flat = point - (point.x + point.y + point.z) / 3 * [1,1,1];
    unit = flat / norm(flat);
    c = unit * [2, -1, -1] / sqrt(6);
    s = unit * [0, -1, 1] / sqrt(2);

    multmatrix([[c, s, 0, 0], [-s, c, 0, 0], [0, 0, 1, 0]]) children();
}

// Three one-twelfth items placed together.  This is not printabble, except for
// the regular icosahedron where we can flip it!
module three_twelfths(big=1.1/inscribe, top=0, mid=0, small=0,
                      cut=1/3, inset=2.5, topset=2.5, midsetz=2) {
    // This leaves us with a dodecahedral point upwards.  We want an
    // icosahedral point upwards.
    for (i = [0, 120, -120])
        rotate(i) multmatrix([[inscribe, 0, coscribe],
                              [0, 1, 0],
                              [-coscribe, 0, inscribe]]) {
            intersection() {
                raw_twelfth(big, top, mid, small, inset, topset, [0, 1, 4],
                            chamfer_edge=[1, 3], midsetz=midsetz) children();
                translate([0, 0, cut * $radius])
                    scale(big * $radius) translate([-1, -1, 0]) cube([2, 2, 1]);
            }
        }
}

// Two one_twelfth items placed together.  Parameters are very similar to
// one_twelfth().
module two_twelfths(big=1.1/inscribe, top=0, mid=0, small=0,
                    cut=0, inset=2.5, topset=2.5, midsetz=0) {
    difference() {
        translate([0, 0, -cut * $radius]) {
            pointup() rotate(180)
                raw_twelfth(big, top, mid, small, inset, topset, [1:4],
                            chamfer_edge=[0, 4], midsetz=midsetz)
                children();
            rotate(180) pointup() rotate(180)
                raw_twelfth(big, top, mid, small, inset, topset, [1:4],
                            chamfer_edge=[0, 4], midsetz=midsetz)
                children();
        }
        translate([0, 0, -big*$radius]) cube(2*big*$radius, center=true);
    }
}

// Slice off 1/12 of a dodecahedron.
//
// Joiner posts may be put on 3 levels, in a diamond shape.
//
// `big` is the outer radius of the cutting segment; just needs to be big
// enough to envelope the entire piece.
//
// If `cut` is non-zero, then the inner point is cut off with this midscribe
// distance.
//
// `small` places the bottom joiner.
//
// `mid' places the middle pair of joiners, and is the radius (before inset) of
// those.
//
// `top` places the top joiner, and is the radius (before inset) of that.
//
// `inset` is the approximate distance to bring the joiner in from the edge.
module one_twelfth(big=1.1/inscribe, top=0, mid=0, small=0,
                   cut=0, inset=2.5, topset=3.75, post_face=[0:4], midsetz=0) {
    intersection() {
        translate([0, 0, -cut * $radius / dodeca_midscribe * inscribe])
            raw_twelfth(big, top, mid, small, inset, topset, post_face,
                        midsetz=midsetz)
            children();
        translate([0, 0, big * $radius]) cube(big * $radius * 2, center=true);
    }
}


module raw_twelfth(big=1.1/inscribe, top=0, mid=0, small=0,
                   inset=2.5, topset=3.75, post_face=[0:4],
                   chamfer=0.4, chamfer_edge=[], midsetz=0) {
    midscribe = dodeca_midscribe;
    q0 = [0, 1-gold, gold];
    q1 = [-1, -1, 1];
    q2 = [-gold, 0, gold-1];
    q3 = [-1, 1, 1];
    q4 = [0, gold-1, gold];
    q = [q0, q1, q2, q3, q4];
    difference() {
        pointup() {
            intersection() {
                scale($radius / sqrt(3)) polyhedron(
                    points=[[0, 0, 0], each big * q],
                    faces = [
                        [5, 4, 3, 2, 1],
                        [0, 1, 2], [0, 2, 3], [0, 3, 4], [0, 4, 5], [0, 5, 1]]);
                scale($radius) children();
            }
        }
        for (i = post_face) rotate(i * 72) pointup() post_set();
        for (i = chamfer_edge) rotate(i * 72) pointup()
            multmatrix([[1, 0, 0],
                        [0, midscribe, dodeca_comidscribe],
                        [0, -dodeca_comidscribe, midscribe]]) rotate(27) {
                translate([-chamfer/2,-chamfer,0])
                    cube([chamfer, 2*chamfer, big * $radius]);
            }
    }
    module post_set() {
        if (top)
            post_at($radius * top - topset, 0);
        if (small) post_at($radius * small + inset, 0);
        if (mid) {
            rmid = $radius * mid;
            post_at(rmid * midscribe + midsetz,
                    rmid * dodeca_comidscribe - 1.5 * inset);
            post_at(rmid * midscribe + midsetz,
                    -rmid * dodeca_comidscribe + 1.5 * inset);
        }
    }
    module post_at(raise, aside) {
        translate([0, 0, raise]) rotate([0, 90, 0])
            joiner_post(0, [0, aside, 0]);
    }
}

// Position a joiner on the triangle formed by u, v and the origin.  We assume u
// and v have the same radius, forming an isoceles triangle.  `radius` is a
// multiplier for the distance from the origin to the midpoint.  `radius_mm` is
// a distance away from the origin.
module mid_vertex_joiner_post(
    u, v, radius_mm=0, radius=1, offset_mm=0, offset=0)
{
    // Adjust u and v according to the radial parameters.
    uu = u * radius + unit(u) * radius_mm;
    vv = v * radius + unit(v) * radius_mm;

    // Position of the post.
    p = (uu + vv) / 2 + offset * (uu - vv) + offset_mm * unit(uu - vv);
    // Co-ordinate system for the post.  'z' is radial.  'y' is perpendicular to
    // the face, and 'x' is orthogonal and on the face.
    dz = unit(p);
    dy = unit(cross(u, v));
    dx = unit(cross(dy, dz));

    multmatrix([[dz.x, dx.x, dy.x, p.x],
                [dz.y, dx.y, dy.y, p.y],
                [dz.z, dx.z, dy.z, p.z]]) joiner_post(0, [0, 0, 0]);
}

module joiner_post(angle, position) {
    rotate(angle) translate(position) #cylinder(
        r=$join_diameter / 2, h=$join_depth*2, center=true);
}
