
// Radial distance of 10 of the 12 icosohedral vertexes from the axis through
// the other two.  I.e., standing on point, it fits in a vertical tube with
// this radius.
radius = 75;

// Side of pentagon through 5 vertexes.
side = 2 * radius * sin(36);

// Height from a vertex to nearest ring of five.
z1 = sqrt(side * side - radius * radius);

// Calculate height between two parallel pentagons.
dx = radius * (1 - cos(36));
dy = radius * sin(36);
z22 = sqrt(side * side - dx * dx - dy * dy);

// Height from pentagon to center.
z2 = z22 / 2;

// Height from vertex to center.
z12 = z1 + z2;

p1 = [0, 0, -z12];
function r1(i) = [radius * cos(72 * i), radius * sin(72 * i), -z2];
function r2(i) = [radius * cos(72 * i + 36), radius * sin(72 * i + 36), z2];
p2 = [0, 0, z12];

module face(a,b,c) {
    p = -0.05 * (a + b + c);
    polyhedron(
        points = [p, a, b, c],
        faces = [
            [1, 2, 3],
            [2, 1, 0],
            [3, 2, 0],
            [1, 3, 0]]);
}

module great_icoso() {
    for (i = [0:4]) {
        face(p1, r2(i), r2(i+2));
        face(p2, r1(i+2), r1(i));
        face(r1(i+4), r2(i+2), r2(i));
        face(r1(i), r1(i+2), r2(i+3));
    }
}

// "star" is attached to "main". To guide it into position, we place a
// joiner between them.  The joiner is just five separate pieces of 1.75mm
// filament.  We leave an indentation of diameter 2mm to place the joiner
// segments into.
// "joiner" returns the shape which is removed from the two pieces.
module joiner() {
        for (i = [0:4])
            rotate(72 * i)
                translate([-radius/7, 0, 0])
                cylinder(r=1.15, h=20, center=true, $fn=40);
}

module main() {
    difference() {
        intersection() {
            translate([0,0,z2-0.2]) great_icoso();
            translate([0,0,100]) cube(200, center=true);
        }
        joiner();
    }
}

module spike() {
    difference() {
        intersection() {
            translate([0,0,-z2-1e-5]) great_icoso();
            translate([0,0,100]) cube(200, center=true);
        }
        rotate(180) joiner();
    }
}

module half() {
    difference() {
        intersection() {
            great_icoso();
            translate([0,0,radius*2]) cube(radius * 4, center=true);
        }
        for (i = [0:4])
            rotate(72 * i)
                rotate([90, 0, 0]) cylinder(r=1.1, h = radius/sqrt(3) - 5);
    }
}

module stand() {
    $fn = 20;
    rad = radius / 6;
    difference() {
        for (i = [0:4]) {
            rotate(i * 72)
                translate([rad, 0, 0]) cylinder(r=3.75, h=z1+z2, $fn=$fn*2);
        }
        translate([0, 0, (z1+z2)+2]) great_icoso();
    }
    minkowski() {
        difference() {
            cylinder(h=0.1, r=rad + 5, $fn=$fn * 6);
            cylinder(h=1, r=5, center=true);
        }
        intersection() {
            sphere(r=1.9);
            cylinder(r=2, h=3);
        }
    }
}

//main();
//spike();
//half();
stand();

