use stl_io::Vertex;

use components::normal::{delta_xr, near_xr, read_mesh, write_mesh};

fn munge(v: &mut Vertex) {
    if near_xr(v, 265.72113, 28.0701692088578, 0.1) {
        delta_xr(v, -2.0, -2.0);
    }
    else if near_xr(v, 260.6847 , 40.8171442799099, 0.1)
        ||  near_xr(v, 261.1936 , 41.1349851260917, 0.1)
        ||  near_xr(v, 264.88766, 43.4421881556437, 0.1)
        ||  near_xr(v, 265.39658, 43.7600289393084, 0.1)
    {
        delta_xr(v, 0.0, -0.25);
    }
}

pub fn main() {
    let mut mesh = read_mesh("jet/files/LPT_Stage_1_No_Supports.stl");

    for t in mesh.iter_mut() {
        munge(&mut t.vertices[0]);
        munge(&mut t.vertices[1]);
        munge(&mut t.vertices[2]);
    }

    write_mesh("lp_stage1.stl", &mut mesh);
}
