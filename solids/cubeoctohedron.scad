
// The triangles for the cuboctodren were inscribed in a circle of radius
// 50.
p0 = 50;
qx = -p0 / 2;
qy = p0 * sqrt(3) / 2;
dx = p0 - qx;
side = sqrt(dx * dx + qy * qy) / 2;
echo(side);
h1 = side / sqrt(2);
h2 = side * sqrt(2);

r0 = side / 2;
r1 = r0 * 2;

polyhedron(
    points=[
        [ r0,  r0, 0],
        [-r0,  r0, 0],
        [-r0, -r0, 0],
        [ r0, -r0, 0],
        [  0,  r1, h1],
        [-r1,   0, h1],
        [  0, -r1, h1],
        [ r1,   0, h1],
        [ r0,  r0, h2],
        [-r0,  r0, h2],
        [-r0, -r0, h2],
        [ r0, -r0, h2]],
    faces = [
        [ 0, 3, 2, 1],
        [ 0, 1, 4],
        [ 1, 2, 5],
        [ 2, 3, 6],
        [ 3, 0, 7],
        [ 4, 1, 5,  9],
        [ 5, 2, 6, 10],
        [ 6, 3, 7, 11],
        [ 7, 0, 4,  8],
        [ 4,  9,  8],
        [ 5, 10,  9],
        [ 6, 11, 10],
        [ 7,  8, 11],
        [ 8, 9, 10, 11]]);

