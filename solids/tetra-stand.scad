
function r(theta, v) = [
    v.x * cos(theta) - v.y * sin(theta),
    v.x * sin(theta) + v.y * cos(theta),
    v.z];

// Tetrahedron standing on a corner, side length = sqrt(3).
module tetra() {
    polyhedron(
        points=[
            [0, 0, 0],
            [1, 0, sqrt(2)],
            [-0.5, sqrt(3)/2, sqrt(2)],
            [-0.5, -sqrt(3)/2, sqrt(2)]],
        faces=[
            [0, 1, 2],
            [2, 1, 3],
            [2, 3, 0],
            [0, 3, 1]]);
}

$fn=20;

minkowski() {
    difference() {
        union() {
            rotate( 60) translate([6,0,0]) cylinder(r=2.5,h=30, $fn=3*$fn);
            rotate(-60) translate([6,0,0]) cylinder(r=2.5,h=30, $fn=3*$fn);
            rotate(180) translate([6,0,0]) cylinder(r=2.5,h=30, $fn=3*$fn);
        }
        rotate(60) scale(50) tetra();
    }
    intersection() {
        cylinder(r=1, h=2);
        sphere(r=1);
    }
}
minkowski() {
    difference() {
        cylinder(r=14, h=0.001, $fn=6*$fn);
        cylinder(r=3.5, h=2, center=true);
    }
    intersection() {
        cylinder(r=2, h=2, $fn=2*$fn);
        sphere(r=2, $fn=2*$fn);
    }
}
