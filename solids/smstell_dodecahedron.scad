
// Radial distance of 10 of the 12 icosohedral vertexes from the axis through
// the other two.  I.e., standing on point, it fits in a vertical tube with
// this radius.
radius = 60;

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

module segment(b, a, p) {
    pp = 1.1 * p - 0.1 * 0.5 * (a + b);
    polyhedron(
        points=[a, b, pp, -0.1 * p],
        faces=[
            [0, 1, 2],
            [0, 3, 1],
            [2, 3, 0],
            [3, 2, 1]]);
}

module face(a,b,c,d,e) {
    p = 0.2 * (a + b + c + d + e);
    segment(a, c, p);
    segment(b, d, p);
    segment(c, e, p);
    segment(d, a, p);
    segment(e, b, p);
}

module smstell_dodec() {
    face(r1(0), r1(1), r1(2), r1(3), r1(4));
    for (i = [0:4]) {
        face(p1, r1(i), r2(i), r2(i+1), r1(i+2));
        face(p2, r2(i+2), r1(i+2), r1(i+1), r2(i));
    }
    face(r2(4), r2(3), r2(2), r2(1), r2(0));
}

// "star" is attached to "main". To guide it into position, we place a
// joiner between them.  The joiner is just five separate pieces of 1.75mm
// filament.  We leave an indentation of diameter 2mm to place the joiner
// segments into.
// "joiner" returns the shape which is removed from the two pieces.
module joiner() {
        for (i = [0:4])
            rotate(72 * i)
                translate([-radius/5, 0, 0])
                cylinder(r=1.15, h=20, center=true, $fn=40);
}

module main() {
    difference() {
        intersection() {
            translate([0,0,z2]) smstell_dodec();
            translate([0,0,100]) cube(200, center=true);
        }
        joiner();
    }
}

module spike() {
    difference() {
        intersection() {
            translate([0,0,-z2-1e-5]) smstell_dodec();
            translate([0,0,100]) cube(200, center=true);
        }
        rotate(180) joiner();
    }
}

module stand() {
    // The pentagon that fits in the middle of a pentagram has radius 1/ϕ²
    // times the circumscribed pentagram.
    // $fn = 40;
    for (i = [0:4]) {
        rotate(i * 72) {
            difference() {
                translate([radius / 3.3, 0, 0]) {
                    cylinder(r=3, h=z1+1);
                    translate([0, 0, z1+1]) cylinder(r1=3, r2=1, h=2);
                }
                translate([-0.5, 0, (z1+z2)+2]) smstell_dodec();
            }
        }
    }
    minkowski() {
        difference() {
            cylinder(h=0.1, r=radius / 3.3 + 4, $fn=3 * $fn);
            cylinder(h=0.1, r=5);
        }
        intersection() {
            sphere(r=1.9, $fn = $fn / 2);
            cylinder(r=1.9, h=2, $fn = $fn / 2);
        }
    }
}

module small_stand() {
    $fn = 40;
    minkowski() {
        difference() {
            for (i = [0:4]) {
                rotate(i * 72) {
                    translate([radius / 6, 0, 0]) cylinder(r=3, h=z1);
                }
            }
            translate([0,0,z1+z2]) smstell_dodec();
        }
        intersection() {
            sphere(r=1, $fn=$fn / 4);
            cylinder(r=1, h=1, $fn=$fn/4);
        }
    }
    minkowski() {
        difference() {
            cylinder(h=0.1, r=radius / 6 + 5, $fn=3 * $fn);
            cylinder(h=0.1, r=5);
        }
        intersection() {
            sphere(r=1.9, $fn = $fn / 2);
            cylinder(r=1.9, h=2, $fn = $fn / 2);
        }
    }
}


//smstell_dodec();
//main();
//spike();
//stand();
small_stand();
