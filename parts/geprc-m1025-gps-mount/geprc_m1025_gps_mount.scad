include <../openscad_libraries/eazl.scad>

$fn = 60;

// GPS module (30x30)
GPS_BODY_SIZE    = 29;
GPS_CABLE_SPACE  = 3;
GPS_HOLDER_DEPTH = GPS_BODY_SIZE + GPS_CABLE_SPACE;  // 32mm
GPS_TRAY_HEIGHT  = 10;
GPS_WALL         = 2;
GPS_SPACING      = 0.1;

SPAN       = 82;               // standoff center-to-center, port-to-starboard
DEPTH      = GPS_HOLDER_DEPTH; // fore-aft (GPS holder width)
LEG_H      = 60;               // nominal arm height above deck
CORNER_R   = 8;                // corner rounding radius
WALL_T     = 6;                // wall thickness
BOTTOM_CUT = 8;                // material removed from bottom — effective arm height = LEG_H - BOTTOM_CUT = 52mm

// Frame standoffs
FORE_AFT_D  = 49.5;  // S2-to-S3 center-to-center
STANDOFF_OD = 5.5;   // metal standoff outer diameter
STANDOFF_H  = 26;    // standoff height (below bridge base)

// Foot
M3_D    = 3.2;        // M3 clearance hole
FOOT_R  = 2 * M3_D;  // foot cylinder radius = twice the M3 hole (6.4mm)

// Center bridge between standoffs in Y
Y_OFFSET = (FORE_AFT_D - DEPTH) / 2;

module outer_profile() {
    offset(r = CORNER_R) offset(delta = -CORNER_R)
        square([SPAN + WALL_T, LEG_H]);
}

module inner_profile() {
    offset(delta = -WALL_T)
        outer_profile();
}

translate([-WALL_T/2, Y_OFFSET, WALL_T - BOTTOM_CUT]) {
    difference() {
        // Outer shell
        translate([0, DEPTH, 0])
        rotate([90, 0, 0])
        linear_extrude(DEPTH)
            outer_profile();

        // Inner cutout — open fore and aft, WALL_T on port/starboard/top/bottom
        translate([0, DEPTH + 1, 0])
        rotate([90, 0, 0])
        linear_extrude(DEPTH + 2)
            inner_profile();

        // Bottom cut — removes BOTTOM_CUT mm from base (effective arm height = 52mm)
        translate([45, 20, -42])
            cube(100, center = true);
    }

    // GPS holder centered on top
    translate([SPAN/2, DEPTH/2, LEG_H])
        rotate([0, 0, 90])
            holder(GPS_BODY_SIZE, GPS_HOLDER_DEPTH, GPS_TRAY_HEIGHT,
                   40, GPS_WALL, GPS_SPACING, true);
}

// Feet — both sides
for (sx = [0, SPAN])
    translate([sx, 0, 0])
    difference() {
        translate([0, 0, WALL_T/2])
            rotate([0, 90, 0])
            hull() {
                translate([0, 0, 0])
                    rotate([0, 90, 0])
                        cylinder(r = FOOT_R, h = WALL_T, center = true);
                translate([0, FORE_AFT_D, 0])
                    rotate([0, 90, 0])
                        cylinder(r = FOOT_R, h = WALL_T, center = true);
            }

        // M3 holes at S2 and S3
        for (sy = [0, FORE_AFT_D])
            translate([0, sy, -1])
                cylinder(r = M3_D/2, h = WALL_T + 2, $fn = 30);
    }
