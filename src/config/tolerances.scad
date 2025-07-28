// =============================================================================
// Teardrop Camper Tolerances & Manufacturing Settings
// =============================================================================

// =============================================================================
// MANUFACTURING CLEARANCES
// =============================================================================

// Basic clearance values
clearance_tight = 0.25;      // 0.01" - Very tight fit for precision parts
clearance_normal = 0.5;      // 0.02" - Standard clearance for most parts
clearance_loose = 1.0;       // 0.04" - Loose fit for moving parts
clearance_slide = 1.5;       // 0.06" - Sliding parts clearance

// Specific component clearances
door_perimeter_gap = 3.0;     // 1/8" - Door perimeter gap 
window_perimeter_gap = 3.0;   // 1/8" - Window perimeter gap
panel_edge_gap = 1.0;         // 0.04" - Gap between adjacent panels
floor_wall_gap = 0.5;         // 0.02" - Gap between floor and wall panels

// Hardware installation clearances
bolt_hole_clearance = 1.0;    // 0.04" - Standard bolt hole clearance
screw_pilot_reduction = 0.5;  // 0.02" - Pilot hole reduction from screw diameter
hinge_placement_tolerance = 1.0; // 0.04" - Hinge placement tolerance

// Thermal expansion allowances
aluminum_expansion_gap = 2.0;   // Gap to allow for aluminum thermal expansion
wood_expansion_gap = 3.0;       // Gap to allow for wood moisture expansion

// =============================================================================
// FIT CLASSES
// =============================================================================

// ISO fit classes for mechanical components (mm)
// Naming: fit_[part]_[fit_type]

// Sliding fits
fit_slide_loose = 0.75;      // Loose sliding fit
fit_slide_normal = 0.5;      // Normal sliding fit
fit_slide_precise = 0.3;     // Precision sliding fit

// Press fits
fit_press_light = 0.1;       // Light press fit
fit_press_medium = 0.2;      // Medium press fit
fit_press_heavy = 0.3;       // Heavy press fit

// Clearance fits
fit_clear_close = 0.2;       // Close clearance fit
fit_clear_normal = 0.5;      // Normal clearance fit
fit_clear_loose = 1.0;       // Loose clearance fit

// =============================================================================
// POSITION TOLERANCES
// =============================================================================

// Positional tolerances for construction
position_precise = 0.5;      // 0.02" - Precise positioning tolerance
position_standard = 1.0;     // 0.04" - Standard positioning tolerance
position_rough = 2.5;        // 0.10" - Rough positioning tolerance

// Alignment tolerances
alignment_critical = 0.25;   // Critical alignment (hinges, latches)
alignment_standard = 1.0;    // Standard alignment (most components)
alignment_rough = 2.5;       // Rough alignment (non-critical components)

// =============================================================================
// THREAD SPECIFICATIONS
// =============================================================================

// Common thread specifications
thread_m3_tap_drill = 2.5;   // M3 tap drill diameter
thread_m4_tap_drill = 3.3;   // M4 tap drill diameter
thread_m5_tap_drill = 4.2;   // M5 tap drill diameter
thread_m6_tap_drill = 5.0;   // M6 tap drill diameter
thread_m8_tap_drill = 6.8;   // M8 tap drill diameter

// Thread engagement lengths (rule of thumb: 1-2× diameter)
thread_engagement_minimum = 0.8;  // Minimum thread engagement factor
thread_engagement_standard = 1.5; // Standard thread engagement factor
thread_engagement_maximum = 2.0;  // Maximum thread engagement factor

// =============================================================================
// TOLERANCE FUNCTIONS
// =============================================================================

// Function to apply specified clearance to dimension
function apply_clearance(dimension, clearance_type = "normal") =
    clearance_type == "tight" ? dimension + clearance_tight :
    clearance_type == "normal" ? dimension + clearance_normal :
    clearance_type == "loose" ? dimension + clearance_loose :
    clearance_type == "slide" ? dimension + clearance_slide :
    dimension + clearance_normal;  // Default to normal

// Function to apply fit tolerance to a shaft/hole dimension
function apply_fit(base_dimension, part_type, fit_type) =
    // For holes, add clearance
    part_type == "hole" ? (
        fit_type == "slide_loose" ? base_dimension + fit_slide_loose :
        fit_type == "slide_normal" ? base_dimension + fit_slide_normal :
        fit_type == "slide_precise" ? base_dimension + fit_slide_precise :
        fit_type == "clear_close" ? base_dimension + fit_clear_close :
        fit_type == "clear_normal" ? base_dimension + fit_clear_normal :
        fit_type == "clear_loose" ? base_dimension + fit_clear_loose :
        fit_type == "press_light" ? base_dimension - fit_press_light :
        fit_type == "press_medium" ? base_dimension - fit_press_medium :
        fit_type == "press_heavy" ? base_dimension - fit_press_heavy :
        base_dimension + fit_clear_normal  // Default to normal clearance
    ) :
    // For shafts, subtract clearance
    part_type == "shaft" ? (
        fit_type == "slide_loose" ? base_dimension - fit_slide_loose :
        fit_type == "slide_normal" ? base_dimension - fit_slide_normal :
        fit_type == "slide_precise" ? base_dimension - fit_slide_precise :
        fit_type == "clear_close" ? base_dimension - fit_clear_close :
        fit_type == "clear_normal" ? base_dimension - fit_clear_normal :
        fit_type == "clear_loose" ? base_dimension - fit_clear_loose :
        fit_type == "press_light" ? base_dimension + fit_press_light :
        fit_type == "press_medium" ? base_dimension + fit_press_medium :
        fit_type == "press_heavy" ? base_dimension + fit_press_heavy :
        base_dimension - fit_clear_normal  // Default to normal clearance
    ) :
    // Default return base dimension if part_type is unspecified
    base_dimension;

// Function to calculate correct pilot hole size for a screw
function pilot_hole_size(screw_diameter, material) =
    material == "softwood" ? screw_diameter * 0.7 :
    material == "hardwood" ? screw_diameter * 0.8 :
    material == "plywood" ? screw_diameter * 0.75 :
    material == "metal" ? screw_diameter * 0.9 :
    material == "plastic" ? screw_diameter * 0.85 :
    screw_diameter * 0.75;  // Default to plywood

// Function to calculate correct thread engagement depth
function thread_engagement(screw_diameter, material) =
    material == "aluminum" ? screw_diameter * thread_engagement_standard :
    material == "steel" ? screw_diameter * thread_engagement_minimum :
    material == "plastic" ? screw_diameter * thread_engagement_maximum :
    material == "wood" ? screw_diameter * 2.0 :
    screw_diameter * thread_engagement_standard;  // Default

// =============================================================================
// HELPER MODULES
// =============================================================================

// Module to create a clearance hole for a bolt
module clearance_hole(diameter, depth = 20, clearance_type = "normal") {
    adjusted_diameter = apply_clearance(diameter, clearance_type);
    cylinder(h = depth, d = adjusted_diameter);
}

// Module to create a countersunk hole
module countersunk_hole(diameter, head_diameter, depth = 20, head_depth = 3, clearance_type = "normal") {
    adjusted_diameter = apply_clearance(diameter, clearance_type);
    adjusted_head = apply_clearance(head_diameter, clearance_type);
    
    union() {
        cylinder(h = depth, d = adjusted_diameter);
        cylinder(h = head_depth, d1 = adjusted_diameter, d2 = adjusted_head);
    }
}

// Module to add a tolerance gap between parts
module tolerance_gap(width, length, depth, gap_size = clearance_normal) {
    cube([width + gap_size*2, length + gap_size*2, depth]);
}