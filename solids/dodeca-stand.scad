
function hypot(a, b) = sqrt(a * a + b * b);

// Chord of a pentagon with side 1.
chord = hypot(1 + cos(72), sin(72));

// Radius of triangle with side chord.
radius = chord / sqrt(3);

// Height of the slice.
height = sqrt(1 - radius * radius);

minkowski() {
    difference() {
        cylinder(r=24, h=10, $fn=3);
        cylinder(r=14, h=30, $fn=3, center=true);
        translate([0,0,0.5]) cylinder(r1=0, r2=50*radius, h=50*height, $fn=3);
    }
    intersection() {
        sphere(1, $fn=40);
        cylinder(r=1, h=2, $fn=40);
    }
}
