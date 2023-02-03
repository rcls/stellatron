size = 1;

scale(sqrt(3) * 25) union() {
    tetra();
    rotate(90) tetra();
};

module tetra() {
    polyhedron(
        points = [
            [ 1, 0, 0],
            [-1, 0, 0],
            [0,  1, sqrt(2)],
            [0, -1, sqrt(2)]],
        faces=[
            [0, 1, 2],
            [2, 1, 3],
            [2, 3, 0],
            [3, 1, 0]]);
}
