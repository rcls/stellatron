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

radius1 = 1;
radius2 = 1.0661408512011674;
radius3 = 1.3763819204711734;
radius4 = 1.451059202444919;
radius5 = 1.6285570507046667;
radius6 = 2.3839634168752983;
radius7 = 1 + 2 * gold;
radius8 = 8.359584944780256;

// Radius of icosahedron with the vertex definitions we use.
ico_scale = sqrt(2 + gold);
// Actual radii in openscad units.
radius1_mm = ico_scale;
radius2_mm = radius2 * ico_scale;
radius3_mm = radius3 * ico_scale;
radius4_mm = radius4 * ico_scale;
radius5_mm = radius5 * ico_scale;
radius6_mm = radius6 * ico_scale;
radius7_mm = radius7 * ico_scale;
radius8_mm = radius8 * ico_scale;
