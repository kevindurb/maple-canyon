// =============================================================================
// Maple Canyon Teardrop Camper
// =============================================================================

// Import configuration files
include <src/config/dimensions.scad>
include <src/config/materials.scad>
include <src/config/tolerances.scad>

// Import utility libraries
use <src/utils/math.scad>
use <src/utils/geometry.scad>
use <src/utils/shapes.scad>
use <src/utils/extrusions.scad>

// Set global parameters
// If quality not defined, use default
$fn = is_undef(quality) ? 50 : get_fn(quality);  // Set resolution based on quality setting

// Display simple preview
// This will be replaced by actual model components
color(color_aluminum)
  cube([body_width/10, body_length/10, overall_height/10], center=true);
echo("Teardrop camper config loaded successfully!");
echo("Use the component files to build the full model.");