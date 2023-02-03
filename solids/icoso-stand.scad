
module icoso_slice() {
    // Side of a pentagram with radius 1 to corners.
    pentside = 2 * sin(36);
    // Height of the icoshedral slice.
    height = sqrt(pentside * pentside - 1);

    polyhedron(
        points = [
            [0, 0, 0],
            [cos(   0), sin(   0), height],
            [cos(  72), sin( -72), height],
            [cos( 144), sin(-144), height],
            [cos( 144), sin( 144), height],
            [cos(  72), sin(  72), height]],
        faces = [
            [1, 2, 3, 4, 5],
            [2, 1, 0],
            [3, 2, 0],
            [4, 3, 0],
            [5, 4, 0],
            [1, 5, 0]]);
}

//$fn=40;

minkowski() {
    difference() {
        cylinder(r=18, h=0.1, $fn=3*$fn);
        cylinder(r=6, h=2, center=true);
    }
    intersection() {
        cylinder(r=2, h=2);
        sphere(r=1.9);
    }
}

difference() {
    for (i = [0:4]) {
        rotate(72*i) translate([15, 0, 0]) {
            cylinder(r=3.5, h=20);
            translate([0,0,13]) sphere(r=6);
        }
    }
    translate([0,0,1.5]) scale(50) icoso_slice();
}
