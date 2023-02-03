r = 50;

x0 = r * cos(0);
y0 = r * sin(0);

x1 = r * cos(120);
y1 = r * sin(120);

x2 = r * cos(-120);
y2 = r * sin(-120);

xa0 = r * cos(60);
ya0 = r * sin(60);

xa1 = r * cos(180);
ya1 = r * sin(180);

xa2 = r * cos(-60);
ya2 = r * sin(-60);

Lsq = (x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2);
sqsq = (x1 - xa1) * (x1 - xa1) + (y1 - ya1) * (y1 - ya1);
// Lsq = h * h + (x1 - xa1) * (x1 - xa1) + (y1 - ya1) * (y1 - ya1)
h = sqrt(Lsq - sqsq);

epsilon = 0.000002;

module th(a, b) translate(2/3 * a + b / 3)
    cube([epsilon, epsilon, epsilon], center=true);

octo_points = [
    [x0, y0, 0],
    [x1, y1, 0],
    [x2, y2, 0],
    [xa0, ya0, h],
    [xa1, ya1, h],
    [xa2, ya2, h]];

hull() {
    for (i = [0: 5])
        for (j = [0: 5])
            if (i != j)
                th(octo_points[i], octo_points[j]);
}
