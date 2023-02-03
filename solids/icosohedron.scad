
radius = 60;

base = radius * 2 * sin(36) / sqrt(3);
echo(base);

phi = (1 + sqrt(5)) / 2;
r = (1 + sqrt(5)) / 2;
epsilon = 0.00001;

module g(p) {
    translate(p) cube([epsilon, epsilon, epsilon], center=true);
}

scale(base) hull() {
    for (i = [0 : 3]) {
        rotate(i * 120) {
            g([1, 0, 0]);
            g([r, 0, phi]);
            rotate(60) g([phi, 0, 1]);
            rotate(60) g([1, 0, phi + 1]);
        }
    }
}

