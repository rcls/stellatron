base = 50;

gold = (1 + sqrt(5)) / 2;
h1 = 1;
h2 = gold;
r = gold;
epsilon = 0.00001;

module g(p) {
    translate(p) cube([epsilon, epsilon, epsilon], center=true);
}

scale(base) hull() {
    for (i = [0 : 4]) {
        rotate(i * 72) {
            g([1, 0, 0]);
            g([r, 0, h1]);
            rotate(36) g([r, 0, h2]);
            rotate(36) g([1, 0, h1 + h2]);
        }
    }
}

