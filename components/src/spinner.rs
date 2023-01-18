use components::normal;

// 369 - sets direction for 4183
// 4183 - out and along
// 4305 - up
// 4307 - up

fn munge(v: &mut stl_io::Vertex, delta_r: f32) {
    struct Point {x: f32, r: f32}
    let p369 = Point{x: 28.446085 , r: 7.38588387562047};
    let p4183 = Point{x: 54.5508  , r: 20.2960225413158};
    let p4305 = Point{x: 58.934315, r: 20.2960225413158};
    let p4307 = Point{x: 59.5     , r: 20.8617079587529};
    let x_per_r = (p4183.x - p369.x) / (p4183.r - p369.r);

    if normal::near_xr(v, p4183.x, p4183.r, 0.01) {
        normal::delta_xr(v, x_per_r * delta_r, delta_r);
    }
    else if normal::near_xr(v, p4305.x, p4305.r, 0.01) {
        normal::delta_xr(v, 0.0, delta_r);
    }
    else if normal::near_xr(v, p4307.x, p4307.r, 0.01) {
        normal::delta_xr(v, 0.0, delta_r);
    }
}

fn go(tag: &str, delta_r: f32) {
    let mut mesh = normal::read_mesh("jet/files/Spinner_Cone.stl");

    for t in mesh.iter_mut() {
        munge(&mut t.vertices[0], delta_r);
        munge(&mut t.vertices[1], delta_r);
        munge(&mut t.vertices[2], delta_r);
    }

    normal::write_mesh(&*(String::from("spinner") + tag + ".stl"), &mut mesh);
}

pub fn main() {
    go("1", 0.1);
    go("2", 0.2);
    go("3", 0.3);
    go("4", 0.4);
}
