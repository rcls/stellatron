
use <functions.scad>
include <numbers.scad>

// Order of quotient group or sub-group.  When there are multiple with the same
// order, then they are numbered sequentially from the order, e.g., 12, 23, 14.
order = 3;
// Normally we plot points.  Set to true to plot great circles.
circles = false;

iii = str("i");
s5 = [iii, "a", "b", "c", "d"];
s4 = [iii, "x", "y", "z"];
s3 = [iii, "p", "m"];
s2 = [iii, "x"];
si = [iii, "-"];

s6 = sprod(s3, s2);
s8 = sprod(s4, ["i", "r"]);
s12 = sprod(s3, s4);
s20 = sprod(s5, s4);
s24 = sprod(s3, s8);
s30 = sprod(s5, s6);
s48 = sprod(si, s24);
s60 = sprod(s20, s3);
s120 = sprod(si, s60);

p60 = [1, 1, 2 * gold + 1];

p120 = [1, 1, 4 * gold + 1];

if (order == 362) {                                     // Geodesic dome.
    s_plot(s12, 4 * unit([1, 0, gold]), c="lightblue"); // Icosahedron.
    s_plot(s20, 4 * unit([1,1,1]), c="red");      // Dodecahedron.
    s_plot(s30, 4 * unit([0, 0, 2])); // Icosidodecahedron
}
if (order == 28) {
    s_plot(s6, [0, 0, 3], c="lightblue");  // Octohedron.
    s_plot(s8, sqrt(3) * [1, 1, 1], c="red");  // Cube.
    s_plot(s12, sqrt(9/2) * [0, 1, 1]);    // Cubeoctahedron.
}

if (order == 2) s_plot(s2, [0, 0, 0.5]);
if (order == 3) s_plot(s3, [0, 0, 1]);
if (order == 4) s_plot(s4, [1, 1, 1]/2, true); // Tetrahedron.
if (order == 5) s_plot(s5, [0, 0, 1]);
if (order == 6) s_plot(s6, [0, 0, 1]);  // Octohedron.
if (order == 8) s_plot(s8, [1, 1, 1]);  // Cube (octahedral).
if (order == 9) s_plot(sprod(si, s4), [1, 1, 1]); // Cube (icosahedral).
if (order == 10) s_plot(sprod(["i", "y"], s5),
                        [gold, 0, 3 * gold - 5]);

if (order == 12) s_plot(s12, [1, 0, gold]); // Icosahedron.
if (order == 13) s_plot(s12, [0, 1, 1]);    // Cubeoctahedron.
if (order == 14) s_plot(s12, [0.5, 0.5, 1.5], true); // Truncated tetrahedron.
if (order == 20) s_plot(s20, [1,1,1]);      // Dodecahedron.
if (order == 24) s_plot(s24, [1, 1, 1 + sqrt(2)]); // Small rhombicuboctahedron
if (order == 25) s_plot(s24, [1, 1 + sqrt(2), 1 + sqrt(2)]); // Truncated cube
if (order == 26) s_plot(s24, [0, 1, 2]); // Truncated octohedron
if (order == 27) {                       // Snub cube.
    t = tribonacci();
    s_plot(s24, [1/t, 1, t], true);
}
if (order == 30) s_plot(s30, [0, 0, 2]); // Icosidodecahedron
if (order == 48) s_plot(s48, [1, 1 + sqrt(2), 1 + 2 * sqrt(2)]); // Great rhombicuboctahedron.
if (order == 60) s_plot(s60, [1, 1, 2 * gold + 1]); // Small rhombicosidodecahedron
if (order == 61) s_plot(s60, [1, 0, 3 * gold]); // Truncated icosahedron
if (order == 62) s_plot(s60, [0, 1, 3 * gold + 1]); // Truncated dodecahedron
if (order == 63) {                                     // Snub dodecahedron.
    epsilon = 0.94315125924;
    p = [
        epsilon * (1 + 2 * epsilon) - gold - 1,
        gold * (1 - epsilon),
        epsilon * (gold - 1)
        ];
    echo(p);
    echo(norm(named_matrix("a") * p - p),
         norm(named_matrix("z") * p - p),
         norm(named_matrix("az") * p - p),
         norm(named_matrix("cp") * p - p));

    s_plot(s60, 6 * p, true);
}
if (order == 120) s_plot(s120, p120);   // Great rhombicosidodecahedron

// map60 = sort([for (n = s60) [named_matrix(n), n]]);
// for (a = ["p", "m", "x", "y", "z"], s = s60)
//    echo(a, s, map(map60, canonvv(named_matrix(a) * named_matrix(s))));

module s_plot(names, p, singlet=false, c=undef) {
    if (circles)
        s_circles(names, p, singlet, c);
    else
        s_points(names, p, c);
}

module s_points(names, p, c="gold") {
    if (!c) color("grey") sphere(norm(p), $fn=40);
    color(c ? c : "gold") for (n = names) {
        v = named_matrix(n) * p;
        inverticate(v) raise(norm(p)) sphere(0.1, $fn=20);
        unflatinate(v) translate([norm(v) + 0.2, 0, ])
            rotate([90, 0, 90])
            linear_extrude(0.01)
            text(n, size=0.5, halign="center", valign="center", $fn=100);
    }
}

module s_circles(names, p, singlet, c) {
    color("grey") sphere(norm(p), $fn=40);
    for (n = names) {
        v = named_matrix(n) * p;
        if (singlet || vless([0,0,0], v))
            color(c) inverticate(v) rotate_extrude($fn=100)
                translate([norm(p), 0]) circle(0.03, $fn=40);
    }
}

function sprod(u, v) =
    [for (a = u) for (b = v) a != "i" ? (a == "-" || b != "i") ? str(a, b) : a : b];

function generator_matrix(s) =
    s == "i" ? identity :
    s == "x" ? [[1,0,0],[0,-1,0],[0,0,-1]] :
    s == "y" ? [[-1,0,0],[0,1,0],[0,0,-1]] :
    s == "z" ? [[-1,0,0],[0,-1,0],[0,0,1]] :
    s == "r" ? [[0,-1,0],[-1,0,0],[0,0,-1]] :
    s == "a" ? rot5 :
    s == "b" ? rot5_2 :
    s == "c" ? rot5_3 :
    s == "d" ? rot5_4 :
    s == "p" ? [[0,0,1],[1,0,0],[0,1,0]] :
    s == "m" ? [[0,1,0],[0,0,1],[1,0,0]] :
    s == "-" ? -identity : assert(false);

function named_matrix(s, idx=0, left=identity) =
    idx >= len(s) ? canonvv(left) :
    named_matrix(s, idx+1, left * generator_matrix(s[idx]));

function tribonacci(a = 2, n=7) = n <= 0 ? a : let (
    delta = (a*a*a - a*a - a - 1) / (3*a*a - 2*a - 1),
    b = a - delta)
    echo(b, delta) tribonacci(b, n - 1);
