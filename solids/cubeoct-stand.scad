
function r(theta, v) = [
    v.x * cos(theta) - v.y * sin(theta),
    v.x * sin(theta) + v.y * cos(theta),
    v.z];

minkowski() {
    difference() {
        union() {
            rotate(  45) translate([8,0,0]) cylinder(r=2.5,h=30, $fn=60);
            rotate( -45) translate([8,0,0]) cylinder(r=2.5,h=30, $fn=60);
            rotate( 135) translate([8,0,0]) cylinder(r=2.5,h=30, $fn=60);
            rotate(-135) translate([8,0,0]) cylinder(r=2.5,h=30, $fn=60);
        }
        translate([0,0,2.5]) cylinder(r1=0, r2=50, h=50, $fn=4);
    }
    intersection() {
        cylinder(r=1, h=2, $fn=20);
        sphere(r=1, $fn = 20);
    }
}
minkowski() {
    cylinder(r=14, h=0.001, $fn=120);
    intersection() {
        cylinder(r=2, h=2, $fn=40);
        sphere(r=2, $fn=40);
    }
}
