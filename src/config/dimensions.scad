// =============================================================================
// Teardrop Camper Dimensions & Parameters
// =============================================================================

// =============================================================================
// OVERALL DIMENSIONS
// =============================================================================

// Basic camper dimensions
trailer_length = 2438.4;           // 96" (8') - Harbor Freight trailer bed length
trailer_width = 1219.2;            // 48" (4') - Harbor Freight trailer bed width
body_length = 2743.2;              // 108" (9') - Total body length (includes 12" overhang)
body_width = 1524.0;               // 60" (5') - Total body width (extends 6" beyond each side)
overall_height = 2032.0;           // 80" - Height from ground to roof (to be adjusted)

// Trailer and ground parameters
ground_clearance = 609.6;          // 24" - Standard trailer height from ground
wheel_well_height = 254.0;         // 10" - Height of wheel wells above trailer deck
wheel_well_width = 457.2;          // 18" - Width of wheel wells
wheel_well_length = 762.0;         // 30" - Length of wheel wells

// Wall and construction thicknesses
wall_thickness = 63.5;             // 2.5" - Outer wall thickness with insulation
floor_thickness = 38.1;            // 1.5" - Floor insulation thickness
roof_thickness = 63.5;             // 2.5" - Roof thickness with insulation
platform_height = 101.6;           // 4" - Height of raised bed platform

// =============================================================================
// INTERIOR DIMENSIONS
// =============================================================================

// Derived interior dimensions
interior_length = body_length - (2 * wall_thickness);  // Interior cabin length
interior_width = body_width - (2 * wall_thickness);    // Interior cabin width
interior_height = 1168.4;          // 46" - Interior height from bed surface to ceiling

// Sleeping area dimensions
sleeping_width = 1524.0;           // 60" - Queen mattress width
sleeping_length = 2032.0;          // 80" - Queen mattress length

// Storage dimensions
headboard_depth = 304.8;           // 12" - Headboard storage depth
foot_cabinet_length = 304.8;       // 12" - Foot cabinet storage length

// =============================================================================
// DOOR & WINDOW DIMENSIONS
// =============================================================================

// Door dimensions
door_width = 762.0;                // 30" - Door width
door_height = 914.4;               // 36" - Door height
door_thickness = 44.45;            // 1.75" - Door panel thickness

// Window dimensions
door_window_width = 304.8;         // 12" - Door window width
door_window_height = 406.4;        // 16" - Door window height
stargazing_window_width = 609.6;   // 24" - Front window width
stargazing_window_height = 762.0;  // 30" - Front window height
glass_thickness = 4.0;             // 0.16" - Glass thickness

// Ventilation dimensions
maxfan_width = 355.6;              // 14" - MaxxFan standard size
maxfan_length = 355.6;             // 14" - MaxxFan standard size
maxfan_height = 101.6;             // 4" - MaxxFan height above roof

// =============================================================================
// STORAGE COMPARTMENT DIMENSIONS
// =============================================================================

// Headboard storage breakdown
headboard_left_width = 457.2;      // 18" - Left personal storage width
headboard_center_width = 609.6;    // 24" - EcoFlow compartment width
headboard_right_width = 457.2;     // 18" - Right personal storage width
headboard_height = 508.0;          // 20" - Storage height

// Foot cabinet breakdown
foot_left_width = 457.2;           // 18" - Left cabinet width
foot_center_width = 609.6;         // 24" - Center open shelf width
foot_right_width = 457.2;          // 18" - Right cabinet width
foot_cabinet_height = 304.8;       // 12" - Cabinet height

// Electrical dimensions
ecoflow_length = 289.56;           // 11.4" - EcoFlow River III length
ecoflow_width = 185.42;            // 7.3" - EcoFlow River III width
ecoflow_height = 210.82;           // 8.3" - EcoFlow River III height
ecoflow_clearance = 25.4;          // 1" - Clearance around EcoFlow unit

// =============================================================================
// DESIGN CONSTRAINTS & DISPLAY SETTINGS
// =============================================================================

// Precision & quality settings
$fn = 50;                          // Default curve segment count

// Design constraints
max_total_length = 3657.6;         // 144" (12') - Maximum length for easy towing
max_total_width = 2590.8;          // 102" (8.5') - Maximum width for legal towing
max_total_height = 2743.2;         // 108" (9') - Maximum height for clearance
max_weight = 453.59;               // 1000 lbs - Target weight

// =============================================================================
// CALCULATED VALUES
// =============================================================================

// Interior usable space calculations
usable_length = interior_length - headboard_depth - foot_cabinet_length;
usable_width = interior_width;
usable_height = interior_height;

// Total estimated dimensions 
total_length = body_length + 304.8;  // Body + tongue extension
total_width = body_width;
total_height = ground_clearance + floor_thickness + platform_height + interior_height + roof_thickness;

// Validity checks
length_valid = total_length <= max_total_length;
width_valid = total_width <= max_total_width;
height_valid = total_height <= max_total_height;

// Debug checks
echo("Interior dimensions: ", interior_length, "mm x ", interior_width, "mm x ", interior_height, "mm");
echo("Total dimensions: ", total_length, "mm x ", total_width, "mm x ", total_height, "mm");
echo("Dimensional validity: Length=", length_valid, ", Width=", width_valid, ", Height=", height_valid);