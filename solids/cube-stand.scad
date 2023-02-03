
function r(theta, v) = [
    v.x * cos(theta) - v.y * sin(theta),
    v.x * sin(theta) + v.y * cos(theta),
    v.z];

// Cube standing on a corner, side length = 1.
module diagcube() {
    r = sqrt(2/3);
    h = sqrt(1/3);
    polyhedron(
        points=[
            [0,0,0],
            [r,0,h],
            r(120, [r,0,h]),
            r(-120, [r,0,h]),
            r(60, [r,0,h*2]),
            r(180, [r,0,h*2]),
            r(-60, [r,0,h*2]),
            [0,0,h*3]],
        faces=[
            [0, 1, 4, 2],
            [0, 2, 5, 3],
            [0, 3, 6, 1],
            [7, 4, 1, 6],
            [7, 5, 2, 4],
            [7, 6, 3, 5]]);
}

//diagcube();

difference() {
    union() {
        rotate( 60) translate([8,0,0]) cylinder(r=5,h=30, $fn=60);
        rotate(-60) translate([8,0,0]) cylinder(r=5,h=30, $fn=60);
        rotate(180) translate([8,0,0]) cylinder(r=5,h=30, $fn=60);
    }
    translate([0,0,4]) scale(50) diagcube();
}
minkowski() {
    cylinder(r=14, h=1, $fn=120);
    intersection() {
        cylinder(r=2, h=2, $fn=40);
        sphere(r=2, $fn=40);
    }
}
