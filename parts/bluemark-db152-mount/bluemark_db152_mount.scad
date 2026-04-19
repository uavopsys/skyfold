/**
 * SKY-FOLD-10 — Remote ID Mount
 */

$fn = 60;

// --- Remote ID box (interior dimensions) ---
RID_W = 30;          // interior width (X)
RID_D = 30;          // interior depth (Y)
RID_H = 7;           // interior height (Z)
RID_CORNER_R = 3;    // corner rounding
RID_WALL = 2;        // wall thickness

// Outer dimensions (derived)
RID_OW = RID_W + 2*RID_WALL;   // outer width
RID_OD = RID_D + 2*RID_WALL;   // outer depth
RID_OH = RID_H + RID_WALL;     // outer height (floor + interior)

// --- GPS_OUT hole (west side, -Y face) ---
GPS_OUT_W = 11;       // hole width
GPS_OUT_H = 4;        // hole height
GPS_OUT_X = -3;        // X offset along side (0 = centered)
GPS_OUT_Z = -1;        // Z offset along side (0 = centered)

// --- GPS_IN hole (south side, -X face) ---
GPS_IN_W = 11;        // hole width
GPS_IN_H = 4;         // hole height
GPS_IN_Y = 3;         // Y offset along side (0 = centered)
GPS_IN_Z = -1;         // Z offset along side (0 = centered)

// --- M3 mounting tabs ---
TAB_SIZE = 12;        // tab width & depth
TAB_SPACING = 49.5;              // center-to-center distance between tabs — matches bridge FORE_AFT_D
TAB_SHIFT_X = -12;                 // slide all tabs + mount holes along X
TAB1_X = 0;                      // tab 1 X position
TAB1_Y = -TAB_SPACING/2;
TAB2_X = 0;                      // tab 2 X position
TAB2_Y = TAB_SPACING/2;

// --- Antenna hole (north side, +X face) ---
ANTENNA_D = 8;            // hole diameter
ANTENNA_Y = -4;            // Y offset along side (0 = centered)
ANTENNA_Z = -1;            // Z offset along side (0 = centered)

// 12x12 mounting tab with M3 hole
module m3_tab() {
    difference() {
        translate([-TAB_SIZE/2, -TAB_SIZE/2, 0])
            linear_extrude(height = RID_WALL)
                offset(r = RID_CORNER_R) offset(delta = -RID_CORNER_R)
                    square([TAB_SIZE, TAB_SIZE]);
        translate([0, 0, -1])
            cylinder(h = RID_WALL + 2, d = 3.4, $fn = 30);
    }
}

// Body — flipped so open side faces down, floor on top at Z = RID_H
translate([0, 0, RID_OH])
rotate([180, 0, 0])
difference() {
    // Outer shell
    translate([-RID_OW/2, -RID_OD/2, 0])
        linear_extrude(height = RID_OH)
            offset(r = RID_CORNER_R) offset(delta = -RID_CORNER_R)
                square([RID_OW, RID_OD]);

    // Hollow out — open top (interior = 29x29x8)
    translate([-RID_W/2, -RID_D/2, RID_WALL])
        linear_extrude(height = RID_H + 1)
            offset(r = RID_CORNER_R) offset(delta = -RID_CORNER_R)
                square([RID_W, RID_D]);

    // GPS_OUT hole (west side, -Y face)
    translate([GPS_OUT_X - GPS_OUT_W/2, -RID_OD/2 - 1, RID_WALL + (RID_H - GPS_OUT_H)/2 + GPS_OUT_Z])
        cube([GPS_OUT_W, RID_WALL + 2, GPS_OUT_H]);

    // GPS_IN hole (south side, -X face)
    translate([-RID_OW/2 - 1, GPS_IN_Y - GPS_IN_W/2, RID_WALL + (RID_H - GPS_IN_H)/2 + GPS_IN_Z])
        cube([RID_WALL + 2, GPS_IN_W, GPS_IN_H]);

    // Antenna hole (north side, +X face)
    translate([RID_OW/2 - 1, ANTENNA_Y, RID_WALL + RID_H/2 + ANTENNA_Z])
        rotate([0, 90, 0])
            cylinder(h = RID_WALL + 2, d = ANTENNA_D, center = true);

    // M3 pass-through holes (aligned with tabs, Y negated due to flip)
    translate([TAB1_X + TAB_SHIFT_X, -TAB1_Y, -1])
        cylinder(h = RID_OH + 2, d = 3.4, $fn = 30);
    translate([TAB2_X + TAB_SHIFT_X, -TAB2_Y, -1])
        cylinder(h = RID_OH + 2, d = 3.4, $fn = 30);

    // 6mm counterbore — stops before tabs so screws can grip
    translate([TAB1_X + TAB_SHIFT_X, -TAB1_Y, -1])
        cylinder(h = RID_OH - RID_WALL + 1, d = 6, $fn = 30);
    translate([TAB2_X + TAB_SHIFT_X, -TAB2_Y, -1])
        cylinder(h = RID_OH - RID_WALL + 1, d = 6, $fn = 30);
}

// Mounting tabs — at Z=0, same height as body bottom
translate([TAB1_X + TAB_SHIFT_X, TAB1_Y, 0])
    m3_tab();
translate([TAB2_X + TAB_SHIFT_X, TAB2_Y, 0])
    m3_tab();

// Connecting wings — bridge the gap between body edge and tabs
for (side = [-1, 1])
    difference() {
        translate([TAB_SHIFT_X - TAB_SIZE/2,
                   side > 0 ? RID_OD/2 : -TAB_SPACING/2,
                   0])
            cube([TAB_SIZE, TAB_SPACING/2 - RID_OD/2, RID_WALL]);
        // M3 clearance hole through wing
        translate([TAB_SHIFT_X, side * TAB_SPACING/2, -1])
            cylinder(h = RID_WALL + 2, d = 3.4, $fn = 30);
    }

