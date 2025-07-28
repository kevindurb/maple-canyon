// =============================================================================
// Teardrop Camper Materials & Visual Properties
// =============================================================================

// =============================================================================
// COLOR DEFINITIONS
// =============================================================================

// Basic material colors
color_aluminum = [0.9, 0.9, 0.92, 1.0];        // Aluminum exterior
color_aluminum_dark = [0.8, 0.8, 0.83, 1.0];   // Darker aluminum accents
color_steel = [0.7, 0.7, 0.7, 1.0];            // Steel frame components
color_galvanized = [0.8, 0.82, 0.85, 1.0];     // Galvanized steel components
color_wood_deck = [0.8, 0.7, 0.5, 1.0];        // Wood trailer deck
color_rubber = [0.2, 0.2, 0.2, 1.0];           // Rubber components (tires, seals)
color_plastic_black = [0.2, 0.2, 0.22, 1.0];   // Black plastic components
color_plastic_white = [0.98, 0.98, 0.98, 1.0]; // White plastic components

// Interior colors
color_frp_white = [0.98, 0.98, 0.97, 1.0];     // Fiberglass reinforced panels
color_wood_ceiling = [0.82, 0.7, 0.55, 1.0];   // Wood-look ceiling panels
color_mattress = [0.7, 0.75, 0.8, 1.0];        // Mattress color
color_upholstery = [0.6, 0.65, 0.7, 1.0];      // Upholstery fabric

// Window & transparent materials
color_glass = [0.9, 0.95, 1.0, 0.5];           // Glass with transparency
color_glass_tinted = [0.7, 0.7, 0.8, 0.5];     // Tinted glass
color_plexiglass = [0.9, 0.95, 1.0, 0.7];      // Plexiglass/acrylic

// Insulation & invisible materials
color_insulation = [0.9, 0.85, 0.6, 0.7];      // Insulation material
color_frame = [0.7, 0.8, 0.8, 0.8];            // Framing (semi-transparent for visualization)

// Hardware colors
color_hinge_steel = [0.8, 0.8, 0.8, 1.0];      // Steel hinges
color_latch_chrome = [0.9, 0.9, 0.9, 1.0];     // Chrome latches
color_handle_aluminum = [0.95, 0.95, 0.95, 1.0]; // Aluminum handles
color_wire_black = [0.1, 0.1, 0.1, 1.0];       // Black electrical wiring
color_wire_red = [0.8, 0.2, 0.2, 1.0];         // Red electrical wiring

// =============================================================================
// MATERIAL PROPERTIES
// =============================================================================

// Structural materials
aluminum_thickness = 1.27;         // 0.050" aluminum sheet
frp_thickness = 2.38;              // 3/32" FRP panels
plywood_thickness = 12.7;          // 1/2" plywood
plywood_floor_thickness = 19.05;   // 3/4" floor plywood
insulation_thickness = 38.1;       // 1.5" foam insulation
frame_aluminum_size = 25.4;        // 1" aluminum angle/tube
frame_steel_size = 38.1;           // 1.5" steel tube/angle

// Hardware dimensions
hinge_length = 76.2;               // 3" hinge
hinge_width = 50.8;                // 2" hinge width
hinge_thickness = 3.175;           // 1/8" hinge material
screw_size_small = 4.0;            // #8 screws
screw_size_large = 6.35;           // 1/4" bolts

// =============================================================================
// RENDERING QUALITY PARAMETERS
// =============================================================================

// Define different quality levels for rendering
function get_fn(quality) =
    quality == "preview" ? 20 :     // Fast preview quality
    quality == "medium" ? 50 :      // Medium quality for development
    quality == "high" ? 100 :       // High quality for final renders
    quality == "export" ? 150 :     // Maximum quality for exports
    20;                             // Default to preview quality

// Function to set material transparency for different visualization modes
function get_transparency(material, mode) =
    mode == "normal" ? 1.0 :                          // Normal rendering
    mode == "cutaway" && (material == "frame" ||      
                          material == "insulation") ? 0.4 :  // Make structure visible
    mode == "xray" ? 0.3 :                            // X-ray mode
    mode == "ghosted" ? 0.6 :                         // Ghosted mode
    1.0;                                              // Default to normal

// =============================================================================
// VISUALIZATION MODES
// =============================================================================

// Render modes for visualization
render_mode = "normal";       // "normal", "cutaway", "xray", "ghosted"
quality = "preview";          // "preview", "medium", "high", "export"

// Set $fn based on quality setting
// $fn is set in main.scad to prevent circular reference

// =============================================================================
// MATERIAL APPLICATION FUNCTIONS
// =============================================================================

// Apply aluminum exterior finish
module apply_aluminum_exterior() {
    color(color_aluminum) children();
}

// Apply interior wall finish
module apply_interior_wall() {
    color(color_frp_white) children();
}

// Apply interior ceiling finish
module apply_interior_ceiling() {
    color(color_wood_ceiling) children();
}

// Apply insulation material
module apply_insulation() {
    color(color_insulation) children();
}

// Apply glass material (for windows)
module apply_window_material(tinted = false) {
    if (tinted)
        color(color_glass_tinted) children();
    else
        color(color_glass) children();
}

// Apply steel frame material
module apply_frame_material() {
    color(color_steel) children();
}

// Apply wood deck material
module apply_wood_deck() {
    color(color_wood_deck) children();
}