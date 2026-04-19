//// Motor Wire Shield - square tube

$fn = 50;

// Inner dimensions
inner = 8.1;
// Wall thickness
wall = 1.5;

// Length
length = 70;

// Extra depth on the clip legs (beyond square) for better grip
clip_extra = 2;

// Retention lip — inward triangle at each leg tip to hold cables
lip = 1.2;

outer   = inner + 2 * wall;        // 11.2 — width
outer_h = outer + clip_extra;      // 14.2 — leg depth (taller than wide)
corner_r = 1.5;

difference() {
    // Outer — rectangular body with semicircular rounded top
    linear_extrude(length)
        hull() {
            offset(r=corner_r) offset(delta=-corner_r)
                square([outer, outer_h - outer/2]);
            translate([outer/2, outer_h - outer/2])
                circle(r = outer/2);
        };

    // Inner cutout — uniform wall thickness, mirrors outer curve
    translate([0, 0, -0.1])
        linear_extrude(length + 0.2)
            offset(delta = -wall)
                hull() {
                    offset(r=corner_r) offset(delta=-corner_r)
                        square([outer, outer_h - outer/2]);
                    translate([outer/2, outer_h - outer/2])
                        circle(r = outer/2);
                };

    // Open one long side (remove a wall)
    translate([-0.1, -0.1, -0.1])
        cube([outer + 0.2, wall + 0.2, length + 0.2]);
}

// Retention lips — trapezoids anchored in leg body, nub extends inward below opening
linear_extrude(length)
    union() {
        // Left leg: overlaps 0.5mm into leg body so it attaches
        translate([0, wall])
            polygon([[0, 0.5], [wall, 0.5], [wall+lip, -lip], [0, -lip]]);
        // Right leg: mirror
        translate([outer-wall, wall])
            polygon([[0, 0.5], [wall, 0.5], [wall, -lip], [-lip, -lip]]);
    }
