// SKY-FOLD-10 — SkyRelay Conduit Holder
// Mount for the skyrelay conduit on the drone frame.

//include <../skyrelay/skyrelay_enclosure_v4-base-model.scad>

$fn = 60;

// --- holder() — from eazl.scad ---
module holder(
    dim_length=20,
    dim_width=10,
    dim_height=5,
    open_pct=80,
    thickness=1.5,
    spacing=0.1,
    lips=false
    ) {

    radius=2;
    print_spacing = spacing * 2;

    inner_length = dim_length + print_spacing;
    inner_width  = dim_width  + print_spacing;
    inner_dim_height = dim_height;

    outer_length = dim_length + 2*thickness;
    outer_width  = dim_width  + 2*thickness;
    outer_height = dim_height + thickness;

    open_width = inner_length * open_pct / 100;

    translate([0,0,0]) {
        difference() {
            // Outer tray shape
            hull() {
                for (x = [-outer_length/2 + radius, outer_length/2 - radius])
                    for (y = [-outer_width/2 + radius, outer_width/2 - radius])
                        translate([x,y,0])
                            cylinder(r=radius, h=outer_height, $fn=40);
            }

            // Inner cutout
            translate([-inner_length/2,-inner_width/2,thickness])
                cube([inner_length,inner_width,dim_height+0.1]);

            // Opening on one side
            translate([0, -outer_width/2+thickness/2 , outer_height/2])
                cube([open_width, thickness+0.1, dim_height-thickness], center=true);
        }
        if (lips) {
            rotate([0,0,90]) translate([0, (inner_length-1)/2, dim_height+thickness-0.5])
                cube([dim_width/2,1,1], center=true);
            rotate([0,0,90]) translate([0,-(inner_length-1)/2, dim_height+thickness-0.5])
                cube([dim_width/2,1,1], center=true);
        }
    }
}


// --- Frame standoff specs ---
STANDOFF_BASE_INNER_SPACING = 74;
STANDOFF_BASE_DIAMETER      = 5.4;
STANDOFF_BASE_HEIGHT        = 26;
STANDOFF_CENTER_X = STANDOFF_BASE_INNER_SPACING/2 + 2*1.5 - 0.1;  // 40.4mm

// --- Bar geometry ---
BAR_LENGTH     = 70;   // bar length along Y
BAR_WIDTH      = 11;   // bar width along X
HOLE_FROM_END  = 16;   // distance from the -Y end of the bar to the hole centre
                       //  (27 = centred; <27 puts hole closer to -Y end, >27 closer to +Y end)

// Shift so the standoff hole ends up at the standoff position, not bar centre
BAR_Y_SHIFT = BAR_LENGTH/2 - HOLE_FROM_END;
    // --- Case hull (simplified outline of the SkyRelay v4 enclosure) ---
    CASE_X = 122;   // outer length (box_inner_x=114 + 2*wall_thickness)
    CASE_Y = 40;    // outer width (board_width=33 + 2*pcb_tolerance + 2*wall_thickness)
    CASE_Z = 31.2;  // outer height (box_interior_height=28 + wall_bot + wall_top)
    CASE_R = 3;     // corner radius
    CASE_POS_Y = 35; // Y offset of case (relative to standoff line)
    CASE_POS_Z = 0;  // sits on top of the bars

difference(){
    union(){
        //port bar
        translate([-STANDOFF_CENTER_X, BAR_Y_SHIFT, 0])
            rotate([0,0,90])
                cube([BAR_LENGTH, BAR_WIDTH, STANDOFF_BASE_HEIGHT], center=true);

        //starboard bar
        translate([STANDOFF_CENTER_X, BAR_Y_SHIFT, 0])
            rotate([0,0,90])
                cube([BAR_LENGTH, BAR_WIDTH, STANDOFF_BASE_HEIGHT], center=true);
    }

    // Case hull cut
    translate([0, CASE_POS_Y, CASE_POS_Z])
        linear_extrude(CASE_Z)
            offset(r = CASE_R) offset(delta = -CASE_R)
                square([CASE_X, CASE_Y], center = true);

    // Standoff holes — cut through everything including the bars and any
    // overlapping structure above
    for (sx = [-STANDOFF_CENTER_X, STANDOFF_CENTER_X])
        translate([sx, 0, -STANDOFF_BASE_HEIGHT])
            cylinder(h = STANDOFF_BASE_HEIGHT * 3, d = STANDOFF_BASE_DIAMETER);
}


translate([0, CASE_POS_Y, CASE_POS_Z])
holder(CASE_X, CASE_Y, CASE_Z, open_pct=50, thickness=2, spacing=0.1, lips=true);