scale(25/sqrt(2))
minkowski() {
    cube([2,2,2], center=true);
    scale(sqrt(2)) polyhedron(
        points=[
            [1,0,0],
            [-1,0,0],
            [0,1,0],
            [0,-1,0],
            [0,0,1],
            [0,0,-1]],
        faces=[
            [0,2,4],
            [2,0,5],
            [4,2,1],
            [0,4,3],
            [2,5,1],
            [4,1,3],
            [0,3,5],
            [5,3,1]]);
}


