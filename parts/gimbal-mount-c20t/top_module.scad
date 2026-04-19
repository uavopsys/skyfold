/**
 * SKY-FOLD-10 — GM2 Gimbal Mount
 * ================================
 * Mounts GM2 gimbal to the foldable frame rear standoffs.
 *
 * Standoff screw pattern (2x M3):
 *   Left:  X = -31
 *   Right: X = +32
 */

include <../openscad_libraries/eazl.scad>

// =============================================================================
// >>> PARAMETERS — adjust these to fit your build <<<
// =============================================================================

$fn = 60;

// --- Frame standoff specs ---
STANDOFF_BASE_INNER_SPACING = 56;    // 56mm inside-to-inside
STANDOFF_BASE_DIAMETER = 5.2;        // M3 + clearance
STANDOFF_BASE_HEIGHT = 26;           // 26mm — the actual standoff hardware height (DO NOT change to lift gimbal — use GIMBAL_RISE)
STANDOFF_C2C = 62;                   // center-to-center distance between standoffs
STANDOFF_X_LEFT  = -STANDOFF_C2C/2;  // left standoff X (-31)
STANDOFF_X_RIGHT =  STANDOFF_C2C/2;  // right standoff X (+31)

// --- Triangle base ---
TRI_CORNER_R = 5;

// --- GM2 gimbal plate ---
GIMBAL_RISE     = 52;                                      // additional height above standoff platform for the gimbal mount
SHELF_THICKNESS = 6;                                       // thickness of the front shelf where gimbal hangs
GM2_PLATE_W     = STANDOFF_BASE_INNER_SPACING + (2*STANDOFF_BASE_DIAMETER) + 6;  // plate width (X)
GM2_PLATE_D     = 120;                                     // plate depth (Y)
GM2_PLATE_H     = STANDOFF_BASE_HEIGHT + GIMBAL_RISE;      // total plate height (= 26 + rise)
GM2_TOP_R       = 12;                                      // top edge rounding radius (curve top to sides)

// --- Stepped cuts (back platform / riser / front shelf) ---
// Standoffs sit at world Y = 0; BACK_STEP_Y is distance from standoff to mast.
// MUST be at least 15mm to clear the drone body. Currently 20mm.
BACK_STEP_Y    = 30;     // world Y where the back cube ends (riser starts) — keep >= 15
FRONT_STEP_Y   = 45;     // world Y where the front cube starts (riser ends)
STEP_FILLET_R  = 8;      // smooth fillet radius at the two concave corners

// --- CT20D gimbal mounting holes (4x M2, copied from ct20d_gimbal.scad) ---
TOP_HOLE_D = 2.2;                    // M2 + clearance (CT20D)
TOP_HOLE_X_SPACING = 41;             // X distance c2c (was GIMBAL_HOLE_Y in CT20D)
TOP_HOLE_Y_SPACING = 8.5;            // Y distance c2c (was GIMBAL_HOLE_X in CT20D)
TOP_HOLE_Y_CENTER = 75;              // Y offset of the 4-hole pattern center

// --- Front curve cut (intersection with a cylinder, like CT20D) ---
FRONT_CURVE_R       = 80;   // cylinder radius — bigger = gentler curve
FRONT_CURVE_Y_WORLD = 20;   // cylinder center Y in world coords (in front of M3, behind front edge)

// --- Back cover (the piece that was cut away by back_step_cut) ---
// Built by intersecting the full original gm2_plate() with a bounding box
// over the back cover region, so it perfectly matches the main plate's
// profile at the mast seam.
// NAMING: BACK_COVER_H = Y length, BACK_COVER_LENGTH = Z height.
// Y length = BACK_STEP_Y - plate's back edge in world Y.
// Plate back edge world Y = -GM2_PLATE_D/2 + (GM2_PLATE_D/2 - 20) = -20.
// So the length of the back_step_cut = BACK_STEP_Y + 20.
BACK_COVER_EXTEND_BACK = 0;           // extra mm past the plate's back edge (extends the cover further back without moving M3 holes)
BACK_COVER_H      = BACK_STEP_Y + 20 + BACK_COVER_EXTEND_BACK;  // length = back_step_cut length + extension
BACK_COVER_LENGTH = GIMBAL_RISE-3;       // Z height (default = GIMBAL_RISE so top matches main plate)
BACK_COVER_W      = GM2_PLATE_W;       // X width (default = match main plate; reduce to trim sides)
BACK_COVER_WALL   = 3;   // wall thickness (default = SHELF_THICKNESS)
BACK_COVER_TOP_R  = GM2_TOP_R;         // top corner rounding (smaller = more usable interior, thinner walls possible)

// --- SMA antenna holes (side walls, near back corners, angled toward the rear) ---
// 9mm diameter matches SMA_ANTENNA_RADIUS = 4.5 from the sama_series config.
// Two angles control the cylinder axis:
//   SMA_HOLE_ANGLE = yaw in X-Y (0 = straight sideways, positive = swoop back)
//   SMA_HOLE_PITCH = pitch in X-Z (0 = horizontal, positive = antenna points up)
// Both sides are mirrored automatically.
SMA_HOLE_D           = 7;            // SMA connector hole diameter
SMA_HOLE_ANGLE       = 0;            // yaw — degrees of rear tilt
SMA_HOLE_PITCH       = 90;           // pitch — degrees of up tilt
SMA_HOLE_Y_FROM_BACK = 10;            // Y offset from the cover's back edge
SMA_HOLE_Z_FROM_BOT  = GIMBAL_RISE/2; // Z offset from the cover bottom
SMA_HOLE_X_INSET     = 20;           // inward X offset from the side wall (increase to pull holes toward center)

// --- Back cover wire pass-through (cuts through the front wall) ---
WIRE_CUT_W = 62;   // width (X)
WIRE_CUT_L = 95;   // length (Y)
WIRE_CUT_H = 40;   // height (Z)
WIRE_CUT_Y = 20;   // Y center position
WIRE_CUT_Z = 49;   // Z center position

// --- MTF01P lidar holder (copied from sama_series/gps_holders.scad) ---
// Uses the same eazl holder() module. Defaults match the original MTF01P tray.
MTF01P_LENGTH    = 34;     // MTF01P X dimension
MTF01P_WIDTH     = 22;     // MTF01P Y dimension
MTF01P_HEIGHT    = 9.6;    // MTF01P Z (thickness)
MTF01P_OPEN_PCT  = 60;     // cable-side opening (%)
MTF01P_WALL      = 1.2;    // holder wall thickness
MTF01P_SPACING   = 0.2;    // print clearance
MTF01P_HOLDER_X  = 0;      // X position (world)
MTF01P_HOLDER_Y  = 35;      // Y position (world)
MTF01P_HOLDER_Z  = MTF01P_HEIGHT;      // Z position (world) — tune after first render

// --- DJI O4 Pro mounting shelf (integrated into the back cover floor) ---
O4_SHELF_W = BACK_COVER_W;                    // shelf width (X) — matches back cover
O4_SHELF_D = BACK_COVER_H;                    // shelf depth (Y) — full length of back cover
O4_SHELF_T = SHELF_THICKNESS / 2;             // shelf thickness (Z)
O4_SHELF_Y = BACK_STEP_Y - BACK_COVER_H/2;    // Y center — centered in back cover span
O4_SHELF_Z = STANDOFF_BASE_HEIGHT + 4.5;      // Z center

// --- DJI O4 Pro antenna holder (imported STL, sits on the shelf in the back chamber) ---
DJI_HOLDER_STL = "dji_o4_pro_antenna_holder.stl";
DJI_HOLDER_X   = 0;                                     // X offset from shelf center
DJI_HOLDER_Y   = 0;                                     // Y offset from shelf center
DJI_HOLDER_Z   = 51;                                     // Z offset above shelf top face
DJI_HOLDER_ROT = [0, 0, 0];                             // [pitch, roll, yaw]

// --- Stock DJI antenna holder (replaces their imported STL — mirror for other side) ---
DJI_ANT_BODY_D   = 3.5;   // antenna body diameter (mm)
DJI_ANT_HOLD_L   = 30;    // length of antenna body held
DJI_ANT_WALL     = 2;     // socket wall thickness
DJI_ANT_BASE_W   = 20;    // mounting base width  (along local X)
DJI_ANT_BASE_L   = 20;    // mounting base length (along local Y)
DJI_ANT_BASE_H   = 3;     // mounting base thickness

// placement (one side — other will be mirrored)
DJI_ANT_X        = 10;    // X position
DJI_ANT_Y        = -21;     // Y position
DJI_ANT_Z        = 73;     // Z position
DJI_ANT_TILT     = 0;     // pitch (rotation around X) — outward lean
DJI_ANT_YAW      = 0;     // yaw   (rotation around Z) — rotate around vertical
DJI_ANT_ROLL     = 30;     // roll  (rotation around Y) — rotate socket-axis

// --- Back cover side vents (turbo-style angled slots for air intake) ---
VENT_COUNT     = 5;     // number of slots per side
VENT_LENGTH    = 28;    // slot length (along Y)
VENT_HEIGHT    = 3;     // slot height (along Z)
VENT_ANGLE     = 20;    // tilt angle of each slot in Y-Z (turbo look)
VENT_Z_MARGIN  = 8;     // Z margin from top and bottom of cover to the vent area
VENT_Y_OFFSET  = 0;     // shift the vent group along Y (0 = centered in the cover)

// --- Back cover mounting screws (M3, aligned with the frame standoffs) ---
// Screw passes from top of cover straight down into the standoff below.
// A 6mm counterbore from the top leaves 6mm of narrow M3 hole at the bottom,
// so the shoulder of the counterbore is what the screw head presses against
// to clamp the cover down onto the base.
BACK_COVER_SCREW_D      = 3.4;   // M3 clearance through-hole
BACK_COVER_SCREW_HEAD_D = 6;     // counterbore diameter
BACK_COVER_SCREW_LIP    = 6;     // mm of narrow M3 hole remaining at the bottom

// --- DJI O4 air unit opening (cut through the back platform) ---
O4_OPENING_W       = 40;    // opening width (X)
O4_OPENING_D       = 20;    // opening depth (Y)
O4_OPENING_H       = 40;    // opening height (Z) — tall enough to go through the full back platform
O4_OPENING_Y_START = 10;    // world Y where the opening starts (back edge)
O4_OPENING_Z_START = 0;     // Z where the opening starts (plate bottom)

// --- DJI O4 Pro channel cut (runs front-to-back through the riser for unit positioning) ---
O4_CHANNEL_W = 50;                           // channel width (X)
O4_CHANNEL_D = 200;                          // channel depth (Y) — oversized to cut full length
O4_CHANNEL_H = 40;                           // channel height (Z)
O4_CHANNEL_Y = 10;                           // Y center
O4_CHANNEL_Z = STANDOFF_BASE_HEIGHT + 4.5;  // Z center (sits just above back platform)

// --- Cutter plate (lower platform cavity) ---
// Width is constrained by M3 hole positions — must leave wall around X = ±31.
// Current 51mm gives ~10mm side walls, hole fully in wall material.
CUT_PLATE_W = 51;                                 // cutter width (X)
CUT_PLATE_D = 130;                                // cutter depth (Y, full length)
CUT_PLATE_H = STANDOFF_BASE_HEIGHT - SHELF_THICKNESS + 3;  // 23 → cavity Z=-3..20, 6mm top cap
CUT_PLATE_X = 0;                                  // X position
CUT_PLATE_Y = 0;                                  // Y position
CUT_PLATE_Z = 0;                                  // Z position

// =============================================================================
// MODULES
// =============================================================================

// Triangle base — exact copy from o4pro_cage_mount
module tri_base(inner_spacing, diameter, height, corner_r=TRI_CORNER_R) {
    center_x = (inner_spacing)/2 + 2*1.5 - 0.1;
    side = center_x * 2;
    tri_h = side * sqrt(3) / 2;

    v1 = [-center_x, 0];
    v2 = [ center_x, 0];
    v3 = [0, tri_h];

    difference() {
        linear_extrude(height=height)
            offset(r=corner_r)
                offset(delta=-corner_r)
                    polygon(points=[v1, v2, v3]);

        // Left standoff hole (negated due to triangle's 180° rotation in assembly)
        translate([-STANDOFF_X_LEFT, 0, -1])
            cylinder(h=height+2, d=diameter, $fn=30);

        // Right standoff hole
        translate([-STANDOFF_X_RIGHT, 0, -1])
            cylinder(h=height+2, d=diameter, $fn=30);
    }
}

// gm2_plate — rectangular box with rounded top edges (curves down to sides).
// The curved top is external/cosmetic. The plate is a hull of a flat bottom
// slice and two circles at the top corners, extruded along Y.
module gm2_plate() {
    translate([0, GM2_PLATE_D/2, 0])
    rotate([90, 0, 0])
    linear_extrude(height = GM2_PLATE_D)
        hull() {
            translate([-GM2_PLATE_W/2, 0])
                square([GM2_PLATE_W, 0.01]);
            translate([-GM2_PLATE_W/2 + GM2_TOP_R, GM2_PLATE_H - GM2_TOP_R])
                circle(r = GM2_TOP_R);
            translate([GM2_PLATE_W/2 - GM2_TOP_R, GM2_PLATE_H - GM2_TOP_R])
                circle(r = GM2_TOP_R);
        }
}

// Cutter plate — subtract this from gm2_plate to carve out a cavity
module cut_plate() {
    translate([CUT_PLATE_X - CUT_PLATE_W/2, CUT_PLATE_Y - CUT_PLATE_D/2, CUT_PLATE_Z])
        linear_extrude(height = CUT_PLATE_H)
            offset(r = TRI_CORNER_R) offset(delta = -TRI_CORNER_R)
                square([CUT_PLATE_W, CUT_PLATE_D]);
}

// Riser cavity — hollows the riser block. The BACK side keeps a 6mm wall
// between the cavity and the back step cut. The FRONT side has NO wall —
// the cavity extends to FRONT_STEP_Y so the area behind the gimbal is open
// (more interior space, gimbal/electronics can sit there).
// 6mm wall in Z (top, connecting to the front shelf bottom).
module riser_cavity() {
    WALL    = SHELF_THICKNESS;      // 6mm
    Y_START = BACK_STEP_Y + WALL;   // 26 (keep back wall)
    Y_END   = FRONT_STEP_Y;         // 45 (NO front wall — opens to area below front shelf)
    Z_START = STANDOFF_BASE_HEIGHT - WALL;       // 20  (continuous with cut_plate cavity top)
    Z_END   = GM2_PLATE_H - WALL;                // 60  (front shelf bottom)

    translate([-CUT_PLATE_W/2, Y_START, Z_START])
        cube([CUT_PLATE_W, Y_END - Y_START, Z_END - Z_START]);
}

// Back step cut — removes everything above STANDOFF_BASE_HEIGHT in the back
// area (Y < BACK_STEP_Y). SHARP 90° corner (no fillet) so the back platform
// top stays flat — the drone body mates flush against it here.
module back_step_cut() {
    XW   = 200;
    YEND = BACK_STEP_Y;
    ZBOT = STANDOFF_BASE_HEIGHT;
    YHI  = 200;

    translate([-XW/2, YEND - YHI, ZBOT])
        cube([XW, YHI, GM2_PLATE_H + 50]);
}

// SMA cutter bodies — two long cylinders that pierce the side walls near the
// back corners of the cover. Each cylinder is rotated around Z by
// (-side * SMA_HOLE_ANGLE) so its axis tilts backward (toward -Y) on the
// outside of the wall. Used both to subtract holes from the cover AND
// rendered in the assembly (semi-transparent) so you can see the cut bodies.
module sma_cutters() {
    Y_BACK_LOCAL = BACK_STEP_Y - BACK_COVER_H;
    Z_BOT_LOCAL  = STANDOFF_BASE_HEIGHT;
    for (side = [-1, 1])
        translate([side * (BACK_COVER_W/2 - SMA_HOLE_X_INSET),
                   Y_BACK_LOCAL + SMA_HOLE_Y_FROM_BACK,
                   Z_BOT_LOCAL + SMA_HOLE_Z_FROM_BOT])
            rotate([0, 0, -side * SMA_HOLE_ANGLE])         // yaw: swoop back
                rotate([0, 90 - side * SMA_HOLE_PITCH, 0]) // pitch: 90° to X + up tilt
                    cylinder(h = 100, d = SMA_HOLE_D, center = true, $fn = 40);
}

// Back cover — this is literally the portion of the ORIGINAL (uncut) plate
// body that the back_step_cut removed, hollowed into a shell with walls on
// back/top/left/right and open at the front (mast side) and bottom.
//
// The inner cavity follows the outer curvature (offset(r=-WALL) on the
// same 2D profile) so wall thickness is uniform even at the rounded top
// corners — you can reduce BACK_COVER_WALL without the cavity poking
// through the curve.
module back_cover() {
    Y_FRONT = BACK_STEP_Y;                            // flush with mast
    Y_BACK  = BACK_STEP_Y - BACK_COVER_H;             // BACK_COVER_H = Y length
    Z_BOT   = STANDOFF_BASE_HEIGHT;                   // sits on back platform top
    Z_TOP   = STANDOFF_BASE_HEIGHT + BACK_COVER_LENGTH; // BACK_COVER_LENGTH = Z height
    WALL    = BACK_COVER_WALL;
    R       = BACK_COVER_TOP_R;

    // 2D X-Z outer profile, shared between outer shell and inner cavity.
    module outer_profile_2d() {
        hull() {
            // Flat bottom slice at Z_BOT
            translate([-BACK_COVER_W/2, Z_BOT])
                square([BACK_COVER_W, 0.01]);
            // Top-left rounded corner
            translate([-BACK_COVER_W/2 + R, Z_TOP - R])
                circle(r = R);
            // Top-right rounded corner
            translate([BACK_COVER_W/2 - R, Z_TOP - R])
                circle(r = R);
        }
    }

    // O4 Pro mounting shelf — horizontal floor integrated into the cover.
    module o4_shelf() {
        translate([0, O4_SHELF_Y, O4_SHELF_Z])
            cube([O4_SHELF_W, O4_SHELF_D, O4_SHELF_T], center = true);
    }

    difference() {
        union() {
            // Outer shell — extrude 2D profile along Y from Y_BACK to Y_FRONT.
            translate([0, Y_FRONT, 0])
                rotate([90, 0, 0])
                    linear_extrude(height = Y_FRONT - Y_BACK)
                        outer_profile_2d();
            // Integrated O4 Pro shelf
            o4_shelf();
        }

        // Inner cavity — same 2D profile offset inward by WALL (uniform wall
        // thickness, follows the curved top). Extruded along Y from
        // Y_BACK + WALL (back wall) to Y_FRONT + 10 (extended past the front
        // so the front face stays open). Shelf is subtracted from the cavity
        // so the floor survives when the cavity is carved out.
        difference() {
            translate([0, Y_FRONT + 10, 0])
                rotate([90, 0, 0])
                    linear_extrude(height = (Y_FRONT - Y_BACK) - WALL + 10)
                        offset(r = -WALL)
                            outer_profile_2d();
            o4_shelf();
        }

        // M3 screw holes + 6mm counterbores centered on the frame standoffs.
        // The counterbore stops BACK_COVER_SCREW_LIP above the cover bottom,
        // leaving a shoulder of narrow M3 hole that the screw head clamps onto.
        for (sx = [STANDOFF_X_LEFT, STANDOFF_X_RIGHT]) {
            // Narrow clearance hole — through the cover bottom
            translate([sx, 0, Z_BOT - 1])
                cylinder(h = (Z_TOP - Z_BOT) + 2,
                         d = BACK_COVER_SCREW_D,
                         $fn = 30);
            // 6mm counterbore from the top, stops BACK_COVER_SCREW_LIP above Z_BOT
            translate([sx, 0, Z_BOT + BACK_COVER_SCREW_LIP])
                cylinder(h = (Z_TOP - Z_BOT) - BACK_COVER_SCREW_LIP + 1,
                         d = BACK_COVER_SCREW_HEAD_D,
                         $fn = 30);
        }

        // Wire pass-through — cavity that follows the outer profile offset
        // inward by WALL (smooth curved top). Spans the original WIRE_CUT Y
        // range so the front still opens into the riser cavity.
        translate([0, WIRE_CUT_Y + WIRE_CUT_L/2, 0])
            rotate([90, 0, 0])
                linear_extrude(height = WIRE_CUT_L)
                    offset(r = -WALL)
                        outer_profile_2d();

        // Antenna cable pass-throughs — tilted to match each antenna's axis.
        // Positioned in back_cover local coords. Since the antenna assembly
        // is translated by the same seperate_y/seperate_z as the back cover,
        // we use DJI_ANT_* directly (no subtraction) so the holes stay locked
        // to the antenna sockets when the cover moves.
        // Right side
        translate([DJI_ANT_X, DJI_ANT_Y + DJI_ANT_LOCAL_Y, DJI_ANT_Z])
            rotate([DJI_ANT_TILT, DJI_ANT_ROLL, DJI_ANT_YAW])
                translate([0, 0, -CABLE_PIERCE_DOWN])
                    cylinder(h = CABLE_PIERCE_DOWN + CABLE_PIERCE_UP,
                             d = CABLE_HOLE_D, $fn = 30);
        // Left side (mirrored, same as antenna_assembly mirror)
        mirror([1, 0, 0])
            translate([DJI_ANT_X, DJI_ANT_Y + DJI_ANT_LOCAL_Y, DJI_ANT_Z])
                rotate([DJI_ANT_TILT, DJI_ANT_ROLL, DJI_ANT_YAW])
                    translate([0, 0, -CABLE_PIERCE_DOWN])
                        cylinder(h = CABLE_PIERCE_DOWN + CABLE_PIERCE_UP,
                                 d = CABLE_HOLE_D, $fn = 30);

        // Cable cut for the O4 air unit — passes through the cover front wall
        translate([3.5, 28, 80])
            cube([11, 4, 30], center = true);

    }

    // DJI O4 Pro antenna holder — imported STL, sits on the shelf inside the
    // back chamber. Same offset-profile wire cut is subtracted, plus a cube
    // that removes the stock antennas that came with the STL.
    color("DimGray", 0.9)
        difference() {
            translate([DJI_HOLDER_X,
                       O4_SHELF_Y + DJI_HOLDER_Y,
                       O4_SHELF_Z + O4_SHELF_T/2 + DJI_HOLDER_Z])
                rotate(DJI_HOLDER_ROT)
                    import(DJI_HOLDER_STL, convexity = 10);

            translate([0, WIRE_CUT_Y + WIRE_CUT_L/2, 0])
                rotate([90, 0, 0])
                    linear_extrude(height = WIRE_CUT_L)
                        offset(r = -WALL)
                            outer_profile_2d();

            // Cube cut — removes the stock antennas from the STL
            translate([0, -16, 92])
                cube([40, 8, 35], center = true);

            // Cable cut for the O4 air unit — also cuts through the STL body
            translate([3.5, 28, 80])
                cube([11, 4, 30], center = true);
        }


}

// Stock DJI antenna holder — cylindrical socket on a flat mounting base.
// Position and rotate externally, then mirror on the opposite side.
// Local frame: socket axis along +Z, base centred on XY plane at Z=0.
DJI_ANT_SLIT_W = 1.3;     // slit width — lets the antenna snap/slide in

// Builds the socket + through-hole as an unrotated assembly.
module _dji_ant_body() {
    difference() {
        cylinder(h = DJI_ANT_HOLD_L, d = DJI_ANT_BODY_D + 2*DJI_ANT_WALL);
        translate([0, 0, -0.1])
            cylinder(h = DJI_ANT_HOLD_L + 0.2, d = DJI_ANT_BODY_D);
    }
}

// Holder: apply tilt/roll/yaw INTERNALLY, then slice the bottom flat at Z=0
// so the socket sits flat on its mounting surface regardless of tilt.
module dji_antenna_holder() {
    INF = 500;
    color("magenta")
    intersection() {
        rotate([DJI_ANT_TILT, DJI_ANT_ROLL, DJI_ANT_YAW])
            _dji_ant_body();
        // Keep only material above Z=0 (flat bottom face)
        translate([0, 0, INF/2])
            cube(INF, center = true);
    }
}

// MTF01P mount — lidar holder tray (from eazl) plus two hold-down cubes
// that anchor it to the frame on either side of the sensor.
module mtf01p_mount() {
    // The lidar tray itself, flipped 180° around X so the opening faces down
    translate([MTF01P_HOLDER_X, MTF01P_HOLDER_Y, MTF01P_HOLDER_Z])
        rotate([180, 0, 0])
            holder(
                dim_length = MTF01P_LENGTH,
                dim_width  = MTF01P_WIDTH,
                dim_height = MTF01P_HEIGHT,
                open_pct   = MTF01P_OPEN_PCT,
                thickness  = MTF01P_WALL,
                spacing    = MTF01P_SPACING,
                lips       = true
            );

    // Hold-down cube on the +X side of the sensor
    translate([17, 30, 0])
        cube(MTF01P_HEIGHT);

    // Hold-down cube on the -X side of the sensor
    translate([-17 - MTF01P_HEIGHT, 30, 0])
        cube(MTF01P_HEIGHT);
}

// Front step cut — removes everything below (GM2_PLATE_H - SHELF_THICKNESS) in
// the front area (Y > FRONT_STEP_Y), with the inside concave corner at
// (FRONT_STEP_Y, GM2_PLATE_H - SHELF_THICKNESS) rounded by STEP_FILLET_R.
module front_step_cut() {
    R    = STEP_FILLET_R;
    XW   = 200;
    YSTA = FRONT_STEP_Y;
    ZTOP = GM2_PLATE_H - SHELF_THICKNESS;
    YLEN = 300;

    difference() {
        // Big cut block below Z = ZTOP, in front area
        translate([-XW/2, YSTA, -50])
            cube([XW, YLEN, ZTOP + 50]);

        // Subtract the fillet wedge = (R x R square) MINUS (quarter cylinder).
        // The wedge sits at the back-top corner of the front cut. The corner being
        // filleted is at local (Y=0, Z=R) (= world YSTA, ZTOP). The disc must be at
        // the FAR corner of the wedge rectangle, which is local (Y=R, Z=0).
        translate([-XW/2 - 1, YSTA, ZTOP - R])
            difference() {
                cube([XW + 2, R, R]);
                translate([0, R, 0])
                    rotate([0, 90, 0])
                        cylinder(h = XW + 4, r = R, $fn = 60);
            }
    }
}

// =============================================================================
// ASSEMBLY
// =============================================================================

// Triangle base plate (hollowed) — exact copy from o4pro


// Standoffs
translate([STANDOFF_X_LEFT, 0, 0])
    standoff(diameter=STANDOFF_BASE_DIAMETER, height=STANDOFF_BASE_HEIGHT);
translate([STANDOFF_X_RIGHT, 0, 0])
    standoff(diameter=STANDOFF_BASE_DIAMETER, height=STANDOFF_BASE_HEIGHT);

// GM2 gimbal plate (stepped: back platform / riser / front shelf)
//   - Standoff anchor area = back platform, height = STANDOFF_BASE_HEIGHT (26)
//   - Riser between BACK_STEP_Y and FRONT_STEP_Y, full height = 26 + GIMBAL_RISE
//   - Front shelf (Y > FRONT_STEP_Y) at top, thickness = SHELF_THICKNESS
//   - Smooth fillets at the two concave corners
color("SteelBlue", 0.7)
    intersection() {
        difference() {
            // Plate with lower cavity (cut_plate) and riser cavity removed
            translate([0, GM2_PLATE_D/2-20, 0])
                difference() {
                    gm2_plate();
                    translate ([0,0,-3])
                        cut_plate();
                    // Hollow the riser block (in plate-local coords; the
                    // riser_cavity uses world Y so we offset to compensate)
                    translate([0, -(GM2_PLATE_D/2-20), 0])
                        riser_cavity();
                }

            // Back step cut (with smooth fillet)
            back_step_cut();

            // Front step cut (with smooth fillet)
            front_step_cut();

            // CT20D M2 through-holes — 4x through the front shelf
            for (hx = [-TOP_HOLE_X_SPACING/2, TOP_HOLE_X_SPACING/2])
                for (hy = [-TOP_HOLE_Y_SPACING/2, TOP_HOLE_Y_SPACING/2])
                    translate([hx, TOP_HOLE_Y_CENTER + hy, -1])
                        cylinder(h = GM2_PLATE_H + 2, d = TOP_HOLE_D, $fn = 30);

            // M3 frame-standoff through-holes — through the back platform
            for (sx = [STANDOFF_X_LEFT, STANDOFF_X_RIGHT])
                translate([sx, 0, -1])
                    cylinder(h = STANDOFF_BASE_HEIGHT + 2, d = STANDOFF_BASE_DIAMETER, $fn = 30);

            // DJI O4 air unit opening — lets the O4 air unit pass through the
            // back platform.
            translate([-O4_OPENING_W/2, O4_OPENING_Y_START, O4_OPENING_Z_START])
                cube([O4_OPENING_W, O4_OPENING_D, O4_OPENING_H]);

            // Extra cutout cube
            translate([0, -30, 20])
                cube([100, 40, 50], center = true);

            // MTF01P cutout — opens space in the gimbal holder for the lidar
            rotate([90, 0, 0])
                translate([0, 30, -30])
                    cube([51, 25, 40], center = true);

            // DJI O4 Pro channel — front-to-back slot for unit positioning
            translate([0, O4_CHANNEL_Y, O4_CHANNEL_Z])
                cube([O4_CHANNEL_W, O4_CHANNEL_D, O4_CHANNEL_H], center = true);
        }

        // Front curve — round the front-corner sides
        translate([0, FRONT_CURVE_Y_WORLD, 0])
            cylinder(h = 400, r = FRONT_CURVE_R, center = true);
    }


seperate_z = 23;
seperate_y = -seperate_z;

    // Back cover — shell behind the mast, flush with main plate (rounded back corners)
color("SteelBlue", 0.7)
        rotate([0,0,0])
            translate([0,seperate_y,seperate_z])
                back_cover();

    // MTF01P lidar mount (tray + two hold-down cubes)
    color("Coral", 0.9)
        mtf01p_mount();

    // Full antenna assembly — anchored to the back cover's seperate offset so
    // the whole thing moves with the cover when seperate_y/seperate_z change.
    translate([0, seperate_y, seperate_z])
        translate([0, DJI_ANT_Y, DJI_ANT_Z])
            antenna_assembly();

    // Optional ghost visualisation of the cable cut path (magenta cylinders).
    // Also anchored to the back cover offset.
    if (SHOW_CABLE_GUIDE) {
        translate([0, seperate_y, seperate_z])
            for (m = [0, 1])
                mirror([m, 0, 0])
                    translate([DJI_ANT_X, DJI_ANT_Y + DJI_ANT_LOCAL_Y, DJI_ANT_Z])
                        rotate([DJI_ANT_TILT, DJI_ANT_ROLL, DJI_ANT_YAW])
                            translate([0, 0, -CABLE_PIERCE_DOWN])
                                %color("magenta")
                                    cylinder(h = CABLE_PIERCE_DOWN + CABLE_PIERCE_UP,
                                             d = CABLE_HOLE_D + 0.4, $fn = 30);
    }

CABLE_HOLE_D       = 2.5;  // antenna cable diameter
CABLE_PIERCE_DOWN  = 5;    // mm the cable hole extends below the antenna origin
                           // (into the cover — set just enough to clear the top wall)
CABLE_PIERCE_UP    = 15;   // mm the hole extends above the antenna origin
                           // (outside the cover, into the antenna socket)
SHOW_CABLE_GUIDE   = false; // true = render a magenta ghost cylinder so you can
                           // see where the cut goes (not part of final print)

PED_W           = 45;    // pedestal plate width  (X)
PED_L           = 25;    // pedestal plate length (Y)
PED_H           = 3;     // pedestal plate thickness (Z)
PED_R           = 2;     // pedestal plate corner radius
DJI_ANT_LOCAL_Y = 5;     // shift antennas + their cable holes along Y within the pedestal

module antenna_assembly() {
    // Pedestal plate (rounded) with cable pass-through holes
    *difference() {
        linear_extrude(PED_H, center = true)
            offset(r = PED_R) offset(delta = -PED_R)
                square([PED_W, PED_L], center = true);
        for (sx = [-DJI_ANT_X, DJI_ANT_X])
            translate([sx, DJI_ANT_LOCAL_Y, 0])
                cylinder(h = PED_H + 10, d = CABLE_HOLE_D, center = true);
    }

    // Antenna sockets — right side + mirrored copy on the left
    translate([DJI_ANT_X, DJI_ANT_LOCAL_Y, 0])
        dji_antenna_holder();
    mirror([1, 0, 0])
        translate([DJI_ANT_X, DJI_ANT_LOCAL_Y, 0])
            dji_antenna_holder();
}


