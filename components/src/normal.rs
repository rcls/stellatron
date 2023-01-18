use std::fs::OpenOptions;

use stl_io::{IndexedMesh, Triangle, Vector, Vertex};

fn ssq(x: f32, y: f32, z: f32) -> f32 {
    x * x + y * y + z * z
}

pub fn radius(v: &Vertex) -> f32 {
    v[1].hypot(v[2])
}

fn renormal(t: &mut Triangle) {
    let a = &t.vertices[0];
    let b = &t.vertices[1];
    let c = &t.vertices[2];

    let ux = b[0] - a[0];
    let uy = b[1] - a[1];
    let uz = b[2] - a[2];

    let vx = c[0] - a[0];
    let vy = c[1] - a[1];
    let vz = c[2] - a[2];

    let (cx, cy, cz) = (
        uy * vz - uz * vy,
        uz * vx - ux * vz,
        ux * vy - uy * vx);

    let cn = ssq(cx, cy, cz);
    let tn = ssq(t.normal[0], t.normal[1], t.normal[2]);
    let dot = cx * t.normal[0] + cy * t.normal[1] + cz * t.normal[2];
    let ratio = (tn / cn).sqrt().copysign(dot);

    t.normal = Vector::new([cx * ratio, cy * ratio, cz * ratio]);
}

pub fn delta_xr(t : &mut Vertex, delta_x: f32, delta_r: f32) {
    let h = radius(t);
    let nh = h + delta_r;
    assert!(h > 0.0);
    assert!(nh >= 0.0);
    let ratio = nh / h;
    *t = Vector::new([t[0] + delta_x, t[1] * ratio, t[2] * ratio]);
}

pub fn set_r(t : &mut Vertex, r: f32) {
    let h = radius(t);
    assert!(h > 0.0);
    assert!(r >= 0.0);
    let ratio = r / h;
    *t = Vector::new([t[0], t[1] * ratio, t[2] * ratio]);
}

pub fn near_xr(t: &Vertex, x: f32, r: f32, delta: f32) -> bool {
    let tr = radius(t);
    let dist = (tr -r).hypot(x - t[0]);
    dist <= delta
}

pub fn reduce(m : &IndexedMesh) -> Vec<Triangle> {
    let mut r = Vec::new();
    for t in &m.faces {
        r.push(Triangle{
            normal: t.normal,
            vertices: [
                m.vertices[t.vertices[0]],
                m.vertices[t.vertices[1]],
                m.vertices[t.vertices[2]],
            ]})}
    r
}

pub fn read_mesh(path: &str) -> Vec<Triangle> {
    let mut file = OpenOptions::new().read(true).open(path).unwrap();
    let mesh = stl_io::read_stl(&mut file).unwrap();
    reduce(&mesh)
}

pub fn write_mesh(path: &str, mesh: &mut Vec<Triangle>) {
    for t in mesh.iter_mut() {
        renormal(t);
    }

    let mut file = OpenOptions::new().write(true).create(true).open(path).unwrap();
    stl_io::write_stl(&mut file, mesh.iter()).unwrap();
}

