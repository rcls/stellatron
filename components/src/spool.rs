use stl_io::Vertex;

use components::normal;

fn munge(v: &mut Vertex) {
    if normal::near_xr(v, 265.7527, 28.0287204251542, 0.1) {
        normal::delta_xr(v, -2.0, -2.0);
    }
    else if normal::near_xr(v, 266.5, 26.0614291777741, 0.1) {
        normal::delta_xr(v, -2.0, -2.0);
    }
}

pub fn main() {
    let mut mesh = normal::read_mesh("jet/files/LPT_Spool.stl");

    for t in mesh.iter_mut() {
        munge(&mut t.vertices[0]);
        munge(&mut t.vertices[1]);
        munge(&mut t.vertices[2]);
    }

    normal::write_mesh("spool.stl", &mut mesh);
}
