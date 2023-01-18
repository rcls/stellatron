base = 50;

h1 = 1.64319023;
h2 = 0.97251288;
r1 = 1.54765487;
r2 = 1.64202395;
epsilon = 0.00001;

module g(p) {
    translate(p) cube([epsilon, epsilon, epsilon], center=true);
}

scale(base) hull() {
    for (i = [0 : 3]) {
        rotate(i * 120) {
            g([1, 0, 0]);
            g([r1, 0, h1]);
            rotate(60) g([r2, 0, h2]);
            rotate(60) g([1, 0, h1 + h2]);
        }
    }
}

