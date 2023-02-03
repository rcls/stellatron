
phi = (1 + sqrt(5)) / 2;
iphi = 1 / phi;

sq13 = sqrt(1/3);
sq23 = sqrt(2/3);

base = 60 * sqrt(3/8);

// Top, clockwise looking down.  ring1 is highest.
ring1 = [[1,1,1], [iphi, 0, phi], [-iphi, 0, phi], [-1, 1, 1], [0, phi, iphi]];

ring2 = [
    [phi, iphi, 0], [1, -1, 1], [-1, -1, 1], [-phi, iphi, 0], [0,phi,-iphi]];

ring3 = [[phi, -iphi, 0], [0, -phi, +iphi], [-phi, -iphi, 0],
         [-1, 1, -1], [1, 1, -1]];

ring4 = [[1, -1, -1], [0, -phi, -iphi], [-1, -1, -1], [-iphi, 0, -phi],
         [iphi, 0, -phi]];

function r1(i) = ring1[i % 5];
function r2(i) = ring2[i % 5];
function r3(i) = ring3[i % 5];
function r4(i) = ring4[i % 5];

module tetrahedron(a, b, c, d) {
    scale(base) polyhedron(
        points=[a, b, c, d],
        faces=[
            [0, 1, 2],
            [1, 0, 3],
            [0, 2, 3],
            [3, 2, 1]]);
}

module quint() {
    for (i = [0:4])
        tetrahedron(r1(i), r2(i+2), r3(i+3), r4(i));
}

module levelquint() {
    difference() {
        multmatrix(
            [
                [ sq13, 0, sq23, 0],
                [    0, 1,    0, 0],
                [-sq23, 0, sq13, base / sqrt(3) + 0.001]])
            rotate(-45) quint();
        for (i = [0:2])
            rotate(i*120+45) rotate([0,90,0])
                cylinder(r=1.1, h=base*phi - 15, $fn=20);
    }
}

module spikes() {
    rotate([180,0,0]) difference() {
        levelquint();
        translate([0,0,base*2]) cube(base * 4, center=true);
    }
}

module main() {
    intersection() {
        levelquint();
        translate([0,0,base*2]) cube(base * 4, center=true);
    }
}

quint();
//main();
//spikes();

