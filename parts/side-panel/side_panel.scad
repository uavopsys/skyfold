// SKY-FOLD-10 Side Panel — clip-on with M M X vent letters
// Mirror in slicer for the opposite side.
// Print orientation: panel face DOWN on build plate (clips pointing up).

$fn = 60;

// =============================================================================
// PARAMETERS
// =============================================================================

// --- Standoff spacing (consecutive distances, left to right) ---
S1_S2 = 49;   // standoff 1 → 2
S2_S3 = 49.5 ;   // standoff 2 → 3
S3_S4 = 60;   // standoff 3 → 4

// Derived standoff X positions
S1 = 0;
S2 = S1 + S1_S2;        // 48
S3 = S2 + S2_S3;        // 96
S4 = S3 + S3_S4;

// Measured end-to-end standoff span — used for panel width and clip positions.
// Section variables above are kept only for letter centering.
TOTAL_W = 159.5;
PANEL_W = TOTAL_W;

// --- Panel face ---
PANEL_H  = 26;   // height — matches frame standoff height
PANEL_T  = 1;    // face plate thickness
CORNER_R = 2;    // corner rounding radius

// --- Snap clips ---
// The C-clip mouth opens downward (-Y / bottom of panel).
// To install: align panel above standoffs, press down until clips snap on.
STANDOFF_OD = 5.5;   // metal standoff outer diameter (what the clip grips)
CLIP_WALL   = PANEL_T+0.5;   // C-clip wall thickness
CLIP_LENGTH  = 12;     // length of the clip cylinder (bore depth)
CLIP_GAP    = 4.5;   // C-clip mouth width — must be < STANDOFF_OD for snap fit
CLIP_ROTATE = 90;    // clip mouth direction: 0=down, 90=left, 180=up, 270=right
CLIP_INSET  = 3.5;   // Z position: how far clip is inset from panel back face (+ = into panel, - = proud)
CLIP_Y      = PANEL_H / 2 - CLIP_LENGTH / 2;   // Y position: centers clip on panel height

// --- Vent letters ---
// Sized to ~55% of section width, capped at 80% of panel height.
FONT      = "Liberation Sans:style=Bold";
LETTER_M1 = min(S1_S2 * 0.55, PANEL_H * 0.80);   // section 1-2
LETTER_M2 = min(S2_S3 * 0.55, PANEL_H * 0.80);   // section 2-3
LETTER_X  = min(S3_S4 * 0.55, PANEL_H * 0.80);   // section 3-4

// =============================================================================
// MODULES
// =============================================================================

// C-clip — wraps around a standoff shaft.
// Bore axis runs in Z (perpendicular to the panel face).
// Mouth opens in -Y so the panel slides down over the standoffs to clip on.
// Place at: translate([standoff_x, PANEL_H/2, -CLIP_LENGTH])
module clip_tab() {
    outer_r = STANDOFF_OD / 2 + CLIP_WALL;
    inner_r = STANDOFF_OD / 2;

    translate([0, 0, -CLIP_LENGTH])
    difference() {
        // Clip body — solid cylinder
        cylinder(h = CLIP_LENGTH, r = outer_r);

        // Inner bore — standoff sits here
        translate([0, 0, -1])
            cylinder(h = CLIP_LENGTH + 2, r = inner_r);

        // Mouth slot — opens in -Y direction (bottom of panel)
        // Narrower than STANDOFF_OD → flex-and-snap fit
        translate([-CLIP_GAP / 2, -(outer_r + 1), -1])
            cube([CLIP_GAP, outer_r + 2, CLIP_LENGTH + 2]);
    }
}

// Letter vent — cuts a character all the way through the panel face.
// center_x : X center of the text
// font_size : character size in mm
module letter_cut(char, center_x, font_size) {
    translate([center_x, PANEL_H / 2, -1])
        linear_extrude(PANEL_T + 2)
            text(char,
                 size   = font_size,
                 font   = FONT,
                 halign = "center",
                 valign = "center");
}

// =============================================================================
// ASSEMBLY
// =============================================================================

difference() {
    union() {
        // Panel face plate — rounded corners
        linear_extrude(PANEL_T)
            offset(r = CORNER_R) offset(delta = -CORNER_R)
                square([PANEL_W, PANEL_H]);

        // Snap clips — outer standoffs only, using measured span
        for (sx = [0, TOTAL_W])
            translate([sx, CLIP_Y, -CLIP_INSET])
                rotate([CLIP_ROTATE, 0, 0])
                    clip_tab();
    }

    // Vent letters — cut through the face in each section
    letter_cut("M", (S1 + S2) / 2, LETTER_M1);   // section 1-2 (48mm wide)
    letter_cut("M", (S2 + S3) / 2, LETTER_M2);   // section 2-3 (48mm wide)
    letter_cut("X", (S3 + S4) / 2, LETTER_X);    // section 3-4 (58mm wide)
}
