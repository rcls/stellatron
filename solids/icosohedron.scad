
radius = 60;

base = radius * sin(36) / sqrt(3);
echo(base);

gold = (1 + sqrt(5)) / 2;

module g(p) {
    translate(p) cube([epsilon, epsilon, epsilon], center=true);
}

function polar(r, theta, z) = [r * cos(theta), r * sin(theta), z];

function A(i) = polar(       2, i*120,     -gold - 1);
function B(i) = polar(gold * 2, i*120 + 60, 1 - gold);
function C(i) = polar(gold * 2, i*120,      gold - 1);
function D(i) = polar(       2, i*120 + 60, gold + 1);

module wedge(a, b, c) {
    polyhedron(
        points = [a, b, c, - (a + b + c) / 10],
        faces = [[0, 1, 2], [1, 0, 3], [2, 1, 3], [0, 2, 3]]);
}

module bottom() {
    wedge(A(0), A(1), A(2));

    for (i = [0:2]) {
        wedge(A(i+1), A(i+0), B(i+0));
        wedge(A(i+1), B(i+0), C(i+1));
        wedge(C(i+0), B(i+0), A(i+0));
    }
}

module icosohedron() {
    bottom();
    scale(-1) bottom();
}

scale(base) translate([0, 0, 1 + gold]) icosohedron();
