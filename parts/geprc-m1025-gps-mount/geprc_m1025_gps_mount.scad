include <../../libs/eazl.scad>

$fn = 60;

// GPS module (30x30 body)
GPS_BODY_W      = 29;
GPS_CABLE_GAP   = 3;                          // extra space for cable exit
GPS_TRAY_H      = 15;
GPS_WALL_T      = 3;
GPS_FIT_GAP     = 0.1;                        // print fit clearance
GPS_HOLDER_D    = GPS_BODY_W + GPS_CABLE_GAP; // 32mm

// Bridge — arched shell spanning the standoffs
BRIDGE_SPAN_X     = 82;                       // standoff center-to-center, port-to-starboard
BRIDGE_DEPTH_Y    = GPS_HOLDER_D + GPS_WALL_T;
BRIDGE_H          = 85;                       // arch height above deck
BRIDGE_WALL_T     = 6;
BRIDGE_CORNER_R   = 8;
BRIDGE_BOTTOM_CUT = 8;                        // material removed from base

// Frame standoffs (S2 ↔ S3 fore-aft)
STANDOFF_PITCH_Y = 49.5;                      // S2-to-S3 center-to-center
STANDOFF_OD      = 5.5;                       // metal standoff hardware (informational)
STANDOFF_H       = 26;

// Foot
M3_HOLE_D = 3.2;
FOOT_R    = 2 * M3_HOLE_D;                    // 6.4mm

// Bridge centered between fore/aft standoffs
BRIDGE_Y_OFFSET = (STANDOFF_PITCH_Y - BRIDGE_DEPTH_Y) / 2;

module outer_profile() {
    offset(r = BRIDGE_CORNER_R) offset(delta = -BRIDGE_CORNER_R)
        square([BRIDGE_SPAN_X + BRIDGE_WALL_T, BRIDGE_H]);
}

module inner_profile() {
    offset(delta = -BRIDGE_WALL_T)
        outer_profile();
}

translate([-BRIDGE_WALL_T/2, BRIDGE_Y_OFFSET, BRIDGE_WALL_T - BRIDGE_BOTTOM_CUT]) {
    difference() {
        // Outer shell
        translate([0, BRIDGE_DEPTH_Y, 0])
        rotate([90, 0, 0])
        linear_extrude(BRIDGE_DEPTH_Y)
            outer_profile();

        // Inner cutout — open fore and aft
        translate([0, BRIDGE_DEPTH_Y + 1, 0])
        rotate([90, 0, 0])
        linear_extrude(BRIDGE_DEPTH_Y + 2)
            inner_profile();

        // Bottom cut
        translate([45, 20, -42])
            cube(100, center = true);
    }

    // GPS holder centered on top
    translate([BRIDGE_SPAN_X/2, BRIDGE_DEPTH_Y/2, BRIDGE_H])
        rotate([0, 0, 90])
            holder(GPS_BODY_W, GPS_HOLDER_D, GPS_TRAY_H,
                   40, GPS_WALL_T, GPS_FIT_GAP, true);
}

// Feet — port and starboard
for (sx = [0, BRIDGE_SPAN_X])
    translate([sx, 0, 0])
    difference() {
        translate([0, 0, BRIDGE_WALL_T/2])
            rotate([0, 90, 0])
            hull() {
                translate([0, 0, 0])
                    rotate([0, 90, 0])
                        cylinder(r = FOOT_R, h = BRIDGE_WALL_T, center = true);
                translate([0, STANDOFF_PITCH_Y, 0])
                    rotate([0, 90, 0])
                        cylinder(r = FOOT_R, h = BRIDGE_WALL_T, center = true);
            }

        // M3 holes at S2 and S3
        for (sy = [0, STANDOFF_PITCH_Y])
            translate([0, sy, -1])
                cylinder(r = M3_HOLE_D/2, h = BRIDGE_WALL_T + 2, $fn = 30);
    }
