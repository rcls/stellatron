
use stl_io::{IndexedMesh, Triangle, Vector, Vertex};

fn ssq(x: f32, y: f32, z: f32) -> f32 {
    x * x + y * y + z * z
}

pub fn renormal(t: &mut Triangle) {
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
    let h = t[1].hypot(t[2]);
    let nh = h + delta_r;
    assert!(h != 0.0);
    assert!(nh >= 0.0);
    let ratio = nh / h;
    *t = Vector::new([t[0] + delta_x, t[1] * ratio, t[2] * ratio]);
}

pub fn near_xr(t: &Vertex, x: f32, r: f32, delta: f32) -> bool {
    let tr = t[1].hypot(t[2]);
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
