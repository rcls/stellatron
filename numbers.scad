// The number we all love.
gold = (1 + sqrt(5)) / 2;

// Ratio of inner over outer circumscribed radii of the icosahedron.  The
// dodecahedron has the same ratio!
inscribe = sqrt(1/3 + 2/15 * sqrt(5));
// Ratio of face radius to icosahedron radius.
coscribe = sqrt(2/3 - 2/15 * sqrt(5));
// Ratio of dodecahedral mid-edge to vertex radii.  (This is the cosine of half
// the dihedral angle).
dodeca_midscribe = sqrt(1/2 + sqrt(5) / 6);
dodeca_comidscribe = sqrt(1/2 - sqrt(5) / 6);
// Ratio of icosahedral mid-edge to vertex radii.  (This is the cosine of half
// the dihedral angle).
icosa_midscribe = sqrt(1/2 + sqrt(5) / 10);
icosa_comidscribe = sqrt(1/2 - sqrt(5) / 10);

// Relative radii of the icosohedral stellation points.
raw_radius1 = 1;
raw_radius2 = sqrt(9 + 12 * gold) / 5;       // 1.0661408512011674
raw_radius3 = sqrt((3 + 4 * gold) / 5);      // 1.3763819204711734
raw_radius4 = sqrt(17/5 - 4/5 * gold);       // 1.451059202444919
raw_radius5 = sqrt(21 + 28 * gold) / 5;      // 1.6285570507046667
raw_radius6 = sqrt(9/5 + 12/5 * gold);       // 2.3839634168752983
raw_radius7 = 1 + 2 * gold;                  // 4.23607
raw_radius8 = sqrt(97 / 5 + 156 / 5 * gold); // 8.359584944780256
assert(abs(raw_radius3 - 1.3763819204711734) < 1e-10);
assert(abs(raw_radius5 - 1.6285570507046667) < 1e-10);
assert(abs(raw_radius8 - 8.359584944780256) < 1e-10);

// Radius of icosahedron with the vertex definitions we use.
ico_scale = sqrt(2 + gold);
// Actual radii in openscad units of the icosahedral stellation points.
radius1 = ico_scale;
radius2 = raw_radius2 * ico_scale;
radius3 = raw_radius3 * ico_scale;
radius4 = raw_radius4 * ico_scale;
radius5 = raw_radius5 * ico_scale;
radius6 = raw_radius6 * ico_scale;
radius7 = raw_radius7 * ico_scale;
radius8 = raw_radius8 * ico_scale;

identity = [[1,0,0],[0,1,0],[0,0,1]];

// Clockwise around [1,0,gold].
rot5 = [[1/2, gold/2, 1/2/gold],
        [-gold/2, 1/2/gold, 1/2],
        [1/2/gold, -1/2, gold/2]];

rot5_2 = rot5 * rot5;
rot5_3 = rot5_2 * rot5;
rot5_4 = rot5_2 * rot5_2;

rotate5 = [identity, rot5, rot5_2, rot5_3, rot5_4];
