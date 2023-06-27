
use <functions.scad>
use <splitting.scad>
use <stand.scad>
include <numbers.scad>

$radius = 200;//333.33333333;
$join_diameter = 2.1;
$join_depth = 10;
$fn = 20;
$piece = 10;
$stand_diameter = 10;

$decorate = true;

// For radius=65 I used 6-6-1.
// For 200: 20,-10,10

topset = 20;
botset = -10;
cut = 10;

p = [gold - 1, gold - 1, 3 + gold];

mult = $radius / norm(p);

face = let (
    p0 = [pls(p), rot5_2 * p, p],
    p1 = [each p0, for (x = reverse(p0)) mx(x)])
    [each p1, for (x = reverse(p1)) mz(x)];

if ($piece == 1)
    final_stellation_of_the_rhombic_triacontrahedron();
else if ($piece == 2)
    thirtieth();
else if ($piece == 3) {
    l = $radius/4;
    w = l;//$radius*0.05;
    h = 10;
    b = 5;
    intersection() {
        scale(0.999) thirtieth();
        union() {
            translate([0, 0, mult + cut])
                for (i = [45:90:315])
                    rotate(i)
                        rotate([90, 0, 0]) linear_extrude(0.5, center=true)
                        polygon(
                            [[0, -b], [w, -l-b], [w, h-l], [0, h]],
                            [[0, 1, 2, 3]]);
            //cylinder(r=2, h=$radius, $fn=4);
        }
        translate([0, 0, $radius/2]) cube([1.5*mult, 1.5*mult, $radius],
                                          center=true);
    }

    // Hack for broken Cura.
    translate([0,0,0.1]) cube(0.2, center=true);
}
else if ($piece == 9) {
    kernel();
}
else if ($piece == 10) {
    stand();
}

module thirtieth() {
    pl = [gold-1, gold-1, gold+1];
    tu = [0, gold-1, 2+gold];
    tl = [0, gold-1, gold];
    qu = [gold-1, 0, 3];
    ql = [gold-1, 0, 1];
    c = [0, 0, 2];
    echo(mult*p);
    echo(mult*pl);
    echo(mult*ql);
    echo(mult*norm(p - ql));
    intersection() {
        translate([0, 0, cut - mult]) difference() {
            scale(mult) polyhedron(
                points=[
                    c,
                    p, qu, rmz(p), rz(tu), rz(p), rz(qu), rpz(p), tu,
                    pl, ql, rmz(pl), rz(tl), rz(pl), rz(ql), rpz(pl), tl,
                    [0, 0, 0]],
                faces=[
                    [0, 2, 3, 4],
                    [0, 4, 5, 6],
                    [0, 6, 7, 8],
                    [0, 8, 1, 2],
                    [3, 2, 1, 9, 10, 11],
                    [5, 4, 3, 11, 12, 13],
                    [7, 6, 5, 13, 14, 15],
                    [1, 8, 7, 15, 16, 9],
                    [12, 11, 10, 17],
                    [14, 13, 12, 17],
                    [16, 15, 14, 17],
                    [10, 9, 16, 17],
                    ],
                convexity=10);
            posts();
            mirror([1,0,0]) posts();
            mirror([0,1,0]) posts();
            rotate(180) posts();
        }
        translate([0, 0, $radius/2]) cube($radius, center=true);
    }
    module posts() {
        // Custom joiner post...
        // use pl as reference with tl and ql.
        multmatrix(orthonormal(pl, tl, p=mult*pl))
            translate([-topset,topset/12,0]) #joiner_post();
        multmatrix(orthonormal(pl, tl, p=mult*pl))
            translate([botset-mult*gold,0]) #joiner_post();
    }
}

module stand() {
    sr = $stand_diameter / 2;
    bottom = $radius / 3;
    h = $radius;
    cut_x = mult * (gold - 1) + 0.2;
    fin_x = mult * (gold - 1);
    arc_x = mult * (gold - 1) + $stand_diameter / 3;
    $decorate = false;
    arc_fn = $fn * 10;

    rounded_ring(bottom, bottom - $stand_diameter, n = arc_fn);
    rounded_ring(fin_x + sr, fin_x - sr, n = arc_fn);
    diffunion(4) {
        // Four curving supports, with fins.
        arc_to(arc_x, h - mult);
        rotate(90) arc_to(arc_x, h - mult * gold);
        rotate(180) arc_to(arc_x, h - mult);
        rotate(-90) arc_to(arc_x, h - mult * gold);

        // Also remove a slightly oversize box.
        translate([0, 0, $radius / 2 + 2.01])
            cube([2 * cut_x, 2 * cut_x, $radius], center=true);
        #translate([0, 0, h]) scale(mult)
            final_stellation_of_the_rhombic_triacontrahedron();
    }

    //mark([sr, 0, 0], r = 5);
    module arc_to(x, z, fin_x=fin_x) {
        //mark([x, 0, z], r=5);
        center = [(x + bottom + z * z / (bottom - x)) / 2, z];
        radius = center.x - x;
        // Slope of transcord is (sr - x, z).
        angle = 2 * atan2(bottom - x, z);
        rotate([90, 0, 0]) {
            diffunion(2) {
                translate(center) rotate(180)
                    rotate_extrude(angle=angle, $fn=arc_fn)
                    translate([radius, 0]) circle(sr);
                translate([bottom, 0, 0]) sphere(sr, $fn=$fn * 2);
                // Remove anything extruding to -z.
                translate([bottom, 0.01-sr*2, 0]) cube(sr*4, center=true);
            }
            linear_extrude(1, center=true) difference() {
                translate([fin_x, 0]) square([bottom - fin_x, z]);
                translate(center) circle(radius, $fn=arc_fn);
            }
        }
    }
}

function coset_i(ff, indexes, tol=1e-7) = let (
    result = [for (f = ff) if (is_least_first_i(f, indexes, tol)) f ])
    echo("Coset reduction to", len(result), "from", len(ff))
    result;

function is_least_first_i(f, indexes, tol=1e-7) =
    [for (i = indexes) vless(f[i], f[0], tol)] == [for (i = indexes) false];

module kernel() {
    pp60 = canonvvv(sixty(face));
    ufaces = coset_i(pp60, [0, 5, 6, 11], tol=0);
    scale(mult) intersection_for (f = ufaces) {
        mean = sum(f) / len(f);
        echo(mean);
        inverticate(mean) cube([2, 2, 2 * norm(mean)], center=true);
    }
}

module final_stellation_of_the_rhombic_triacontrahedron() {
    pp60 = canonvvv(sixty(face));
    ufaces = coset_i(pp60, [0, 5, 6, 11], tol=0);
    faces = [each ufaces, for (f = ufaces) invert(f)];
    echo(len(faces));

    for (f = faces) star_pyramid(f, 5);
    // intersection_for (f = faces) pyramid(f, -sum(f));

    c = [0, 0, 2];
    qu = [gold-1, 0, 3];
    tu = [0, gold-1, gold+2];

    multmatrix([[0,0,1], [1,0,0], [0,1,0]]) {
        mark(p, "blue");
        mark(p-c,"blue");
        mark(rot5_4 * p, "blue");
        mark(rmz(p), "lightblue");
        mark(rmz(p-c), "lightblue");
        mark(c,"black", r=0.2);

        mark(qu - c,"green");
        mark(qu,"green");
        mark(rot5_4*qu,"green");

        mark(tu - c,"red");
        mark(tu,"red");
    }
}

module mark(v, c="gold", r=0.1) {
    if ($decorate && $preview)
        color(c) translate(v) sphere(r);
}
