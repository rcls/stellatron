// 3mm dia question mark shape with rectangulare base.

outer=5;
width=2.5;
height=2.5;
cut=0.2;
gap=1.5;
base=5;
rise=1;
slope = 0;

$fn=20;
//$fn = 60;

radius = width/2;

x1 = outer - width + rise;

o_m_r = outer - rise;

intersection() {
    union() {
        difference() {
            rotate_extrude($fn = $fn * 3) {
                hull() {
                    translate([outer - radius, radius * sqrt(3) / 2]) circle(radius);
                    translate([outer - radius, height - radius]) circle(radius);
                }
            }
            translate([outer - width - gap, 0,-outer*0.5]) cube(2*outer);
        }

        hull() {
            for (z = [0, base - rise]) {
                for (y = (outer - rise) * [-1, 1])
                    translate([x1, y, z]) sphere(rise);
                if (slope != 0) {
                    y = o_m_r;
                    translate([x1 + 2 * y * sin(slope), y, z]) sphere(rise);
                }
            }
        }
    }

    #linear_extrude(1 * outer) polygon(
        [[x1 - 2 * outer, -1.5 * o_m_r],
         [x1 - 2 * outer, 1.5 * o_m_r],
         [x1 + 2.5 * sin(slope) * o_m_r, 1.5 * o_m_r],
         [x1 - 0.5 * sin(slope) * o_m_r, -1.5 * o_m_r]]);
}
