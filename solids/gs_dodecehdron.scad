
radius = 80;

phi = (1 + sqrt(5)) / 2;
base = radius / phi;
echo(base);

function vrot(theta, x, z) = [base * cos(theta) * x, base * sin(theta) * x,
                              base * z];

epsilon = 0.00001;

module g(p) {
    translate(p) cube([epsilon, epsilon, epsilon], center=true);
}

function r1(i) = vrot(i * 72,      1,  -(1 + phi) / 2);
function r2(i) = vrot(i * 72,      phi, (1 - phi) / 2);
function r3(i) = vrot(i * 72 + 36, phi, (phi - 1) / 2);
function r4(i) = vrot(i * 72 + 36, 1,   (1 + phi) / 2);

module segment(a, b, p) {
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

module gs_dodec() {
    face(r2(0), r2(1), r2(2), r2(3), r2(4));
    face(r3(4), r3(3), r3(2), r3(1), r3(0));
    for (i = [0:4]) {
        face(r1(i), r3(i), r4(i+1), r3(i+2), r1(i+3));
        face(r4(i+3), r2(i+3), r1(i+2), r2(i+1), r4(i));
    }
}

module joiner() {
    for (i = [0:4])
        rotate(i * 72) translate([base/2 - 3, 0, 0])
            cylinder(r=2.3/2, h=20, center=true, $fn=20);
}

module main() {
    difference() {
        intersection() {
            translate([0, 0, base * (phi - 1) / 2]) gs_dodec();
            translate([-2*base, -2*base, 0]) cube(4 * base);
        }
        joiner();
    }
}

module crown() {
    difference() {
        intersection() {
            translate([0, 0, base * (1 - phi) / 2 - 0.000001]) gs_dodec();
            translate([-2*base, -2*base, 0]) cube(4 * base);
        }
        rotate(36) joiner();
    }
}


spike_side = phi;
spike_base = 1;
spike_radius = spike_base / sqrt(3);
spike_height = sqrt(phi * phi - spike_radius * spike_radius);

module spike() {
    polyhedron(
        points=[
            [0, 0, 0],
            vrot(0, spike_radius, spike_height),
            vrot(120, spike_radius, spike_height),
            vrot(-120, spike_radius, spike_height)
            ],
        faces=[
            [3, 2, 1],
            [0, 1, 2],
            [0, 2, 3],
            [0, 3, 1]]);
}

$fn=20;

module stand() {
    minkowski() {
        difference() {
            cylinder(r=20, h=0.1, $fn=$fn*6);
            cylinder(r=4, h=1, center=true);
        }
        intersection() {
            sphere(r=1.9, $fn=$fn*2);
            cylinder(r=3, h=3);
        }
    }
    for (i = [0:2]) {
        minkowski() {
            difference() {
                rotate(i * 120) difference() {
                    translate([8, 0, 0]) cylinder(r=3, h=30, $fn=$fn*2);
                    translate([sqrt(3), 0, 2]) spike();
                }
            }
            intersection() {
                sphere(r=1, $fn=$fn);
                cylinder(r=2, h=2);
            }
        }
    }
}

//gs_dodec();
//main();
//crown();
stand();
