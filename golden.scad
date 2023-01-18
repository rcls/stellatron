
fraction = (sqrt(5) - 1) / 2;
//fraction = sqrt(2) - 1;
//fraction = 2 - sqrt(5);
fraction = 1/3;

radius = 10;
levels = 3;
height = 50;
points = 4;

plane_angle = 360 / points;
level_angle = plane_angle * fraction;

vertexes = [
    for (i = [0: levels])
        for (j = [0: points - 1])
            [ radius * cos(i * level_angle + j * plane_angle),
              radius * sin(i * level_angle + j * plane_angle),
              height * i / levels ]
    ];

triangles = [
    for (i = [1 : levels])
        for (j = [1 : points])
            [ (i - 1) * points + (j % points),
              (i - 1) * points + j - 1,
              i * points + j - 1 ],
    for (i = [1 : levels])
        for (j = [1 : points])
            [ i * points + j - 1,
              i * points + (j % points),
              (i - 1) * points + (j % points) ],
    [ for (i = [0 : points - 1]) i ],
    [ for (i = [1 : points]) levels * points + points - i ],

    ];

scale([15/2,10/2]) rotate(45) polyhedron(points = vertexes, faces = triangles, convexity = 2);

