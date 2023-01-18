use stl_io::Triangle;
use crate::normal::{self, radius};

fn max_radius(mesh: &Vec<Triangle>) -> f32 {
    fn maxr(t: &Triangle) -> f32 {
        t.vertices.iter().map(radius).fold(0.0, |a,b| a.max(b))
    }
    mesh.iter().map(maxr).fold(0.0, |a,b| a.max(b))
}

pub fn reduce(mesh: &mut Vec<Triangle>) {
    let maxr = max_radius(mesh) - 0.25;
    for t in mesh.iter_mut() {
        for v in t.vertices.iter_mut() {
            if radius(v) > maxr {
                normal::set_r(v, maxr);
            }
        }
    }
}
