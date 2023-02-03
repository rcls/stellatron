
function tribo(n, a, b, c) = n == 0 ? c / b : tribo(n - 1, b, c, a + b + c);
t = tribo(20, 0, 0, 1);
echo(t);

epsilon = 0.00001;
scale = 25 * sqrt(2) / t;
module g(x, y, z) {
    translate(scale * [x, y, z])
        cube(epsilon, center=true);
}

module h(x, y, z) {
    g(x, y, z);
    g(z, x, y);
    g(y, z, x);
}

hull() {
    h( t,  1/t, -1);
    h(-1/t,  t, -1);
    h(-t, -1/t, -1);
    h( 1/t, -t, -1);

    h(-t,  1/t, 1);
    h( 1/t,  t, 1);
    h( t, -1/t, 1);
    h(-1/t, -t, 1);
}
