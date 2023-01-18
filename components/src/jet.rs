mod stage1;
mod stage3;
mod spinner;
mod spool;

use components::{nipple, normal};

fn denipple(i: &str, o: &str) {
    let mut mesh = normal::read_mesh(i);
    nipple::reduce(&mut mesh);
    normal::write_mesh(o, &mut mesh);
}

fn main() {
    stage1::main();
    stage3::main();
    spinner::main();
    spool::main();
    denipple("jet/files/LPT_Stage_2_No_Supports.stl", "lp_stage2.stl");
    denipple("jet/files/LPT_Stage_4_No_Supports.stl", "lp_stage4.stl");
}

