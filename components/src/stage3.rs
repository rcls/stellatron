use stl_io::{Triangle, Vertex};

use components::nipple;
use components::normal::{self, radius};

struct SquareSkew {
    top_r: f32,
    bot_r: f32,
    lft_x: f32,
    rgt_x: f32,
    // lft_dx: f32,
    rgt_dx: f32,
}

impl SquareSkew {
    fn mapv(&self, v: &mut Vertex) {
        let r = radius(v);
        let x = v[0];
        if r >= self.bot_r && r <= self.top_r
            && x >= self.lft_x && x <= self.rgt_x
        {
            // let xl_ratio = (self.rgt_x - x) / (self.rgt_x - self.lft_x);
            let xr_ratio = (x - self.lft_x) / (self.rgt_x - self.lft_x);
            let rt_ratio = (r - self.bot_r) / (self.top_r - self.bot_r);
            let dx = self.rgt_dx * xr_ratio * rt_ratio;
            *v = Vertex::new([v[0] + dx, v[1], v[2]]);
        }
    }
    fn mapt(&self, t: &mut Triangle) {
        self.mapv(&mut t.vertices[0]);
        self.mapv(&mut t.vertices[1]);
        self.mapv(&mut t.vertices[2]);
    }
}

pub fn main() {
    let mut mesh = normal::read_mesh("jet/files/LPT_Stage_3_No_Supports.stl");

    let ss = SquareSkew{
        top_r: 51.01,
        bot_r: 37.1,
        lft_x: 288.39,
        rgt_x: 294.66,
        rgt_dx: 0.494,
    };
    for t in mesh.iter_mut() {
        ss.mapt(t);
    }
    nipple::reduce(&mut mesh);

    normal::write_mesh("lp_stage3.stl", &mut mesh);
}
