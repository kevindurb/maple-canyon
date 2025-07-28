// =============================================================================
// Fasteners and Hardware Components
// =============================================================================

use <math.scad>

// =============================================================================
// STANDARD SCREW DIMENSIONS (ISO/Metric)
// =============================================================================

// Standard metric bolt head dimensions [diameter, height]
function bolt_head_dims(size) =
    size == "M3"  ? [5.5, 3.0] :
    size == "M4"  ? [7.0, 4.0] :
    size == "M5"  ? [8.0, 5.0] :
    size == "M6"  ? [10.0, 6.0] :
    size == "M8"  ? [13.0, 8.0] :
    size == "M10" ? [17.0, 10.0] :
    size == "M12" ? [19.0, 12.0] :
    [8.0, 5.0]; // Default M5

// Standard metric thread pitch
function thread_pitch(size) =
    size == "M3"  ? 0.5 :
    size == "M4"  ? 0.7 :
    size == "M5"  ? 0.8 :
    size == "M6"  ? 1.0 :
    size == "M8"  ? 1.25 :
    size == "M10" ? 1.5 :
    size == "M12" ? 1.75 :
    0.8; // Default

// Extract numeric diameter from size string
function bolt_diameter(size) =
    size == "M3"  ? 3.0 :
    size == "M4"  ? 4.0 :
    size == "M5"  ? 5.0 :
    size == "M6"  ? 6.0 :
    size == "M8"  ? 8.0 :
    size == "M10" ? 10.0 :
    size == "M12" ? 12.0 :
    5.0; // Default

// =============================================================================
// BOLT AND SCREW MODULES
// =============================================================================

// Standard hex head bolt
module hex_bolt(size = "M5", length = 20, head_height = undef) {
    dims = bolt_head_dims(size);
    head_dia = dims[0];
    actual_head_height = head_height != undef ? head_height : dims[1];
    shaft_dia = bolt_diameter(size);
    
    union() {
        // Hex head
        translate([0, 0, actual_head_height/2]) {
            rotate([0, 0, 30]) // Orient flat side forward
                cylinder(h = actual_head_height, d = head_dia/cos(30), $fn = 6, center = true);
        }
        
        // Threaded shaft
        translate([0, 0, -length]) {
            cylinder(h = length, d = shaft_dia);
        }
    }
}

// Socket head cap screw (Allen bolt)
module socket_head_screw(size = "M5", length = 20, head_height = undef) {
    dims = bolt_head_dims(size);
    head_dia = dims[0] * 1.2; // Socket heads are larger
    actual_head_height = head_height != undef ? head_height : dims[1];
    shaft_dia = bolt_diameter(size);
    socket_dia = shaft_dia * 0.8; // Allen key size approximation
    
    difference() {
        union() {
            // Cylindrical head
            cylinder(h = actual_head_height, d = head_dia);
            
            // Threaded shaft
            translate([0, 0, -length]) {
                cylinder(h = length, d = shaft_dia);
            }
        }
        
        // Allen key socket
        translate([0, 0, actual_head_height - socket_dia*0.4]) {
            cylinder(h = socket_dia*0.5, d = socket_dia, $fn = 6);
        }
    }
}

// Phillips head screw
module phillips_screw(size = "M5", length = 20, head_height = undef, head_style = "pan") {
    dims = bolt_head_dims(size);
    shaft_dia = bolt_diameter(size);
    
    // Head dimensions based on style
    head_dia = head_style == "pan" ? dims[0] * 1.8 :
               head_style == "flat" ? dims[0] * 2.0 :
               dims[0] * 1.5; // countersunk
    
    actual_head_height = head_height != undef ? head_height : 
                        head_style == "flat" ? dims[1] * 0.6 : dims[1];
    
    difference() {
        union() {
            // Head shape
            if (head_style == "pan") {
                // Pan head (rounded)
                hull() {
                    cylinder(h = actual_head_height * 0.1, d = head_dia);
                    translate([0, 0, actual_head_height * 0.9])
                        cylinder(h = actual_head_height * 0.1, d = head_dia * 0.8);
                }
            } else if (head_style == "flat") {
                // Flat/countersunk head
                cylinder(h = actual_head_height, d1 = head_dia, d2 = shaft_dia);
            } else {
                // Round head
                cylinder(h = actual_head_height, d = head_dia);
            }
            
            // Threaded shaft
            translate([0, 0, -length]) {
                cylinder(h = length, d = shaft_dia);
            }
        }
        
        // Phillips cross slot
        cross_depth = actual_head_height * 0.6;
        cross_width = shaft_dia * 0.2;
        
        // Horizontal slot
        translate([0, 0, actual_head_height - cross_depth/2]) {
            cube([head_dia * 1.1, cross_width, cross_depth], center = true);
        }
        
        // Vertical slot  
        translate([0, 0, actual_head_height - cross_depth/2]) {
            cube([cross_width, head_dia * 1.1, cross_depth], center = true);
        }
    }
}

// Wood screw (tapered thread)
module wood_screw(diameter = 5, length = 25, head_style = "flat") {
    head_dia = diameter * 2;
    head_height = diameter * 0.6;
    
    difference() {
        union() {
            // Head
            if (head_style == "flat") {
                cylinder(h = head_height, d1 = head_dia, d2 = diameter);
            } else {
                // Pan head
                cylinder(h = head_height, d = head_dia);
            }
            
            // Tapered threaded shaft
            translate([0, 0, -length]) {
                cylinder(h = length, d1 = diameter * 0.3, d2 = diameter);
            }
        }
        
        // Slot for flathead screwdriver
        translate([0, 0, head_height - diameter*0.3]) {
            cube([head_dia * 1.1, diameter * 0.1, diameter * 0.4], center = true);
        }
    }
}

// =============================================================================
// NUTS AND WASHERS
// =============================================================================

// Hex nut
module hex_nut(size = "M5", height = undef) {
    diameter = bolt_diameter(size);
    nut_height = height != undef ? height : diameter * 0.8;
    nut_width = diameter * 1.8; // Across flats
    
    difference() {
        // Hex outer shape
        rotate([0, 0, 30])
            cylinder(h = nut_height, d = nut_width/cos(30), $fn = 6, center = true);
        
        // Threaded hole
        cylinder(h = nut_height * 1.1, d = diameter, center = true);
    }
}

// Wing nut
module wing_nut(size = "M5", height = undef, wing_span = undef) {
    diameter = bolt_diameter(size);
    nut_height = height != undef ? height : diameter * 0.8;
    nut_width = diameter * 1.8;
    wing_width = wing_span != undef ? wing_span : diameter * 3;
    wing_thickness = diameter * 0.3;
    
    difference() {
        union() {
            // Center hex
            rotate([0, 0, 30])
                cylinder(h = nut_height, d = nut_width/cos(30), $fn = 6, center = true);
            
            // Wings
            for (angle = [0, 180]) {
                rotate([0, 0, angle]) {
                    translate([nut_width/2, 0, 0]) {
                        hull() {
                            cylinder(h = nut_height, d = wing_thickness, center = true);
                            translate([wing_width/2, 0, 0])
                                cylinder(h = nut_height, d = wing_thickness, center = true);
                        }
                    }
                }
            }
        }
        
        // Threaded hole
        cylinder(h = nut_height * 1.1, d = diameter, center = true);
    }
}

// Flat washer
module flat_washer(size = "M5", thickness = undef) {
    inner_dia = bolt_diameter(size);
    outer_dia = inner_dia * 2.5;
    washer_thickness = thickness != undef ? thickness : inner_dia * 0.2;
    
    difference() {
        cylinder(h = washer_thickness, d = outer_dia, center = true);
        cylinder(h = washer_thickness * 1.1, d = inner_dia, center = true);
    }
}

// Lock washer (split ring)
module lock_washer(size = "M5", thickness = undef) {
    inner_dia = bolt_diameter(size);
    outer_dia = inner_dia * 2;
    washer_thickness = thickness != undef ? thickness : inner_dia * 0.25;
    gap_width = inner_dia * 0.2;
    
    difference() {
        // Outer ring
        cylinder(h = washer_thickness, d = outer_dia, center = true);
        
        // Inner hole
        cylinder(h = washer_thickness * 1.1, d = inner_dia, center = true);
        
        // Split gap
        translate([outer_dia/2, 0, 0]) {
            cube([gap_width, outer_dia, washer_thickness * 1.1], center = true);
        }
    }
    
    // Add twist to show spring action
    rotate([0, 0, 10]) {
        translate([outer_dia/2 - gap_width/2, 0, washer_thickness/4]) {
            cube([gap_width/2, outer_dia/4, washer_thickness/2], center = true);
        }
    }
}

// =============================================================================
// HOLES AND CLEARANCES
// =============================================================================

// Clearance hole for bolts
module bolt_hole(size = "M5", length = 10, clearance = 0.2, countersink = false) {
    diameter = bolt_diameter(size) + clearance;
    
    union() {
        // Main clearance hole
        cylinder(h = length, d = diameter, center = true);
        
        // Countersink for flat head screws
        if (countersink) {
            head_dims = bolt_head_dims(size);
            countersink_dia = head_dims[0] + clearance;
            countersink_depth = head_dims[1];
            
            translate([0, 0, length/2 - countersink_depth/2]) {
                cylinder(h = countersink_depth, d1 = diameter, d2 = countersink_dia);
            }
        }
    }
}

// Pilot hole for wood screws
module pilot_hole(diameter, length, depth_ratio = 0.7) {
    pilot_dia = diameter * 0.7; // 70% of screw diameter
    pilot_depth = length * depth_ratio;
    
    union() {
        // Pilot hole for threads
        translate([0, 0, -pilot_depth/2]) {
            cylinder(h = pilot_depth, d = pilot_dia, center = true);
        }
        
        // Clearance hole for shaft
        translate([0, 0, length/2 - pilot_depth/2]) {
            cylinder(h = length - pilot_depth, d = diameter, center = true);
        }
    }
}

// Threaded hole (representation - not functional)
module threaded_hole(size = "M5", length = 10) {
    diameter = bolt_diameter(size);
    pitch = thread_pitch(size);
    threads = floor(length / pitch);
    
    difference() {
        cylinder(h = length, d = diameter * 1.1, center = true);
        
        // Thread representation (simplified)
        for (i = [0:threads-1]) {
            translate([0, 0, -length/2 + i * pitch]) {
                rotate([0, 0, i * 30]) {
                    translate([diameter/2 * 0.8, 0, 0]) {
                        cube([diameter * 0.2, diameter * 0.1, pitch * 0.8], center = true);
                    }
                }
            }
        }
    }
}

// =============================================================================
// SPECIALTY FASTENERS
// =============================================================================

// Rivet
module rivet(diameter = 4, length = 10, head_style = "dome") {
    head_dia = diameter * 2;
    head_height = diameter * 0.5;
    
    union() {
        // Head
        if (head_style == "dome") {
            sphere(d = head_dia);
            cylinder(h = head_height/2, d = head_dia);
        } else {
            // Flat head
            cylinder(h = head_height, d = head_dia);
        }
        
        // Shaft
        translate([0, 0, -length]) {
            cylinder(h = length, d = diameter);
        }
    }
}

// Toggle bolt (simplified)
module toggle_bolt(size = "M5", length = 20) {
    diameter = bolt_diameter(size);
    wing_length = diameter * 2;
    wing_thickness = diameter * 0.3;
    
    union() {
        // Standard bolt
        hex_bolt(size, length);
        
        // Toggle wings (shown in open position)
        translate([0, 0, -length + wing_length/2]) {
            for (angle = [45, -45]) {
                rotate([0, angle, 0]) {
                    translate([wing_length/2, 0, 0]) {
                        cube([wing_length, wing_thickness, wing_thickness], center = true);
                    }
                }
            }
        }
    }
}

// =============================================================================
// FASTENER ASSEMBLIES
// =============================================================================

// Complete bolt assembly (bolt + washer + nut)
module bolt_assembly(size = "M5", length = 20, washer = true, nut_offset = 0) {
    diameter = bolt_diameter(size);
    
    // Bolt
    hex_bolt(size, length);
    
    // Washer under head
    if (washer) {
        translate([0, 0, 1]) {
            flat_washer(size);
        }
    }
    
    // Nut at end
    translate([0, 0, -length + nut_offset]) {
        hex_nut(size);
        
        // Washer under nut
        if (washer) {
            translate([0, 0, -2]) {
                flat_washer(size);
            }
        }
    }
}

// =============================================================================
// EXAMPLES AND TESTS
// =============================================================================

// Uncomment to test fasteners
// hex_bolt("M6", 25);
// translate([15, 0, 0]) hex_nut("M6");
// translate([30, 0, 0]) flat_washer("M6");
// translate([0, 20, 0]) phillips_screw("M5", 20, head_style = "pan");