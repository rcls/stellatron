// 3mm dia question mark shape with rectangulare base.

outer=5;
width=2.5;
height=2.5;
cut=0.2;
gap=1.5;
base=5;
rise=1;

epsilon=1/3 * (1 - sqrt(3)/2);

//$fn=20;
$fn = 60;

radius = width/2;

intersection() {
    union() {
        difference() {
            rotate_extrude() {
                hull() {
                    translate([outer - radius, radius * sqrt(3) / 2]) circle(radius);
                    translate([outer - radius, height - radius]) circle(radius);
                }
            }
            translate([outer - width - gap, 0,-outer*0.5]) cube(2*outer);
        }

        hull() {
            for (z = [0, base - rise])
                for (y = (outer - rise) * [-1, 1])
                    translate([outer - width + rise, y, z]) sphere(rise);
        }
    }

    translate([-2 * outer - width + rise, -1.5 * outer, 0]) cube(3 * outer);
}
