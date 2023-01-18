
radius = 50;

a = [1, 0, 0];
b = [cos(120), sin(120), 0];
c = [cos(120), -sin(120), 0];

function hypot(x,y) = sqrt(x * x + y * y);
side = hypot(a[0] - b[0], a[1] - b[1]);
height = sqrt(side * side - 1);
echo(a);
echo(b);
echo(side);
d = [0, 0, height];

scale(radius) polyhedron(points=[a,b,c,d], faces=[[0,1,2],[1,0,3],[2,1,3],[0,2,3]]);
