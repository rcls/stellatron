handle = "slant";
hole = true;
gap = true;

difference() {
    union() {
        cylinder(r=8.5/2, h=5, $fn=30);
        if (handle == "flat")
            flat_handle();
        else if (handle == "side")
            side_handle();
        else if (handle == "slant")
            slant_handle();
        else if (handle == "crook")
            crook_handle();
    }
    cylinder(r=6.75/2, h=2*1, center=true, $fn=30);
    cylinder(r=6.2/2, h=2*3, center=true, $fn=6);

    if (hole || gap)
        cylinder(r=3/2, h=2*10, center=true, $fn=30);

    if (gap)
        translate([-8,-3/2,-2]) cube(size=[8,3,10]);
}

module flat_handle() {
    translate([20,0,3]) cube(size=[40,2,4], center=true);
}

module side_handle() {
    translate([10,0,2.5]) cube(size=[20,2,4], center=true);
    multmatrix([[1, 0, 0.5, 0], [0, 1, 0, 0], [0, 0, 1, 0], [0, 0, 0, 1]])
        translate([17,0,20.5]) cube(size=[6,2,40], center=true);
}

module slant_handle() {
    // Slanting 40mm handle.
    multmatrix([[1, 0, 0.5, 0], [0, 1, 0, 0], [0, 0, 1, 0], [0, 0, 0, 1]])
        translate([1,0,20]) cube(size=[6,2,40], center=true);
}

module crook_handle() {
    // Slanting 20mm handle then 40mm vertical.
    multmatrix([[1, 0, 0.5, 0], [0, 1, 0, 0], [0, 0, 1, 0], [0, 0, 0, 1]])
        translate([1,0,10]) cube(size=[6,2,20], center=true);
    translate([11,0,40]) cube(size=[6,2,40], center=true);
}

//difference() {
//cylinder(r=60, h=60);
//translate([0,0,-0.5]) cylinder(r=59, h=61);
//};

//#translate([0,0,3]) cylinder(r=61, h=30);
//#translate([0,0,43]) cylinder(r=61, h=30);

