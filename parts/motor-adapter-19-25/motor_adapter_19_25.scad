// 2812 Motor Adapter
// 4× M3 holes on a 19mm bolt-circle diameter, in a 39mm cylinder.

$fn = 60;

// =============================================================================
// PARAMETERS
// =============================================================================

ADAPTER_D   = 39;    // outer diameter
ADAPTER_H   = 6;     // height

MOTOR_BCD    = 19;   // bolt-circle diameter (all 4 holes lie on this circle)
MOTOR_HOLE_D = 3.2;  // M3 clearance

RECESS_D     = 6.5;  // counterbore diameter (M3 head = ~5.5mm, +1mm clearance)
RECESS_H     = 2;    // counterbore depth — screw head sits flush at this depth

// --- Bottom pattern (mount side) ---
MOUNT_BCD    = 30;   // bolt-circle diameter
MOUNT_HOLE_D = 3.2;  // M3 clearance

// M3 hex nut trap (bottom face)
// M3 nut: 5.5mm across flats, 2.4mm thick.
// $fn=6 cylinder d = across-corners = across-flats / cos(30°)
NUT_AF       = 5.9;              // across flats + 0.4mm clearance
NUT_D        = NUT_AF / cos(30); // across corners — fed to cylinder($fn=6)
NUT_H        = 2.3;              // depth — slightly over 2.4mm nut thickness

// =============================================================================
// ASSEMBLY
// =============================================================================

difference() {
    cylinder(d = ADAPTER_D, h = ADAPTER_H);

    // Center hole (motor shaft clearance)
    translate([0, 0, -1])
        cylinder(d = 9, h = ADAPTER_H + 2);

    // 4× M3 through-holes — motor side (top, 19mm BCD)
    for (a = [45, 135, 225, 315]) {
        translate([MOTOR_BCD/2 * cos(a), MOTOR_BCD/2 * sin(a), -1])
            cylinder(d = MOTOR_HOLE_D, h = ADAPTER_H + 2);

        // Counterbore on top face — screw head sits flush
        translate([MOTOR_BCD/2 * cos(a), MOTOR_BCD/2 * sin(a), ADAPTER_H - RECESS_H])
            cylinder(d = RECESS_D, h = RECESS_H + 1);
    }

    // 4× M3 through-holes — mount side (bottom, 30mm BCD), rotated 45° to avoid alignment with top holes
    for (a = [0, 90, 180, 270]) {
        translate([MOUNT_BCD/2 * cos(a), MOUNT_BCD/2 * sin(a), -1])
            cylinder(d = MOUNT_HOLE_D, h = ADAPTER_H + 2);

        // Hex nut trap on bottom face — nut drops in and stays fixed
        translate([MOUNT_BCD/2 * cos(a), MOUNT_BCD/2 * sin(a), -1])
            cylinder(d = NUT_D, h = NUT_H + 1, $fn = 6);
    }
}
