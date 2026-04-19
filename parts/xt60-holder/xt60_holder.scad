// XT60 Male Connector Holder

$fn = 50;

// Base dimensions
base_x = 41.92;
base_y = 14.92;
base_z = 3;

// Mounting holes
hole_spacing = 32.75;  // center to center
hole_d = 3.2;          // M3 clearance

// XT60 cutout
xt60_x = 15.50;
xt60_y = 8.10;

// Corner radius
corner_r = 2;

difference() {
    // Base with rounded corners
    linear_extrude(base_z)
        offset(r=corner_r)
        offset(r=-corner_r)
        square([base_x, base_y]);

    // Mounting holes - centered along long side
    for (dx = [-1, 1]) {
        translate([base_x/2 + dx * hole_spacing/2, base_y/2, -0.1])
            cylinder(d=hole_d, h=base_z + 0.2);
    }

    // XT60 rectangular cutout - centered
    translate([(base_x - xt60_x)/2, (base_y - xt60_y)/2, -0.1])
        cube([xt60_x, xt60_y, base_z + 0.2]);
}
