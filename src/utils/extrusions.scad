// =============================================================================
// Advanced Extrusion Utilities
// =============================================================================

use <math.scad>
use <geometry.scad>

// =============================================================================
// LINEAR EXTRUSIONS
// =============================================================================

// Tapered extrusion - linear_extrude with different top/bottom scaling
module tapered_extrude(height, scale_top = 1, scale_bottom = 1, center = false, twist = 0) {
    translate([0, 0, center ? -height/2 : 0]) {
        hull() {
            linear_extrude(height = 0.01, scale = scale_bottom)
                children();
            translate([0, 0, height - 0.01])
                linear_extrude(height = 0.01, scale = scale_top)
                    children();
        }
    }
}

// Stepped extrusion with multiple levels
module stepped_extrude(heights, scales = undef, center = false) {
    steps = len(heights);
    step_scales = scales != undef ? scales : [for (i = [0:steps-1]) 1];
    total_height = sum(heights);
    
    translate([0, 0, center ? -total_height/2 : 0]) {
        current_height = 0;
        for (i = [0:steps-1]) {
            translate([0, 0, sum([for (j = [0:i-1]) heights[j]])])
                linear_extrude(height = heights[i], scale = step_scales[i])
                    children();
        }
    }
}

// Rounded extrusion - extrude with rounded top/bottom
module rounded_extrude(height, radius = 1, center = false) {
    r = min(radius, height/2);
    h = height - 2*r;
    
    translate([0, 0, center ? -height/2 : 0]) {
        hull() {
            translate([0, 0, r])
                linear_extrude(height = max(0.01, h))
                    children();
            translate([0, 0, r])
                linear_extrude(height = 0.01, scale = 0.01)
                    offset(r = -r) children();
            translate([0, 0, height - r])
                linear_extrude(height = 0.01, scale = 0.01)
                    offset(r = -r) children();
        }
    }
}

// =============================================================================
// PATH-BASED EXTRUSIONS
// =============================================================================

// Extrude along a path (sweep)
module path_extrude(path, scale_along_path = 1, twist_along_path = 0) {
    steps = len(path) - 1;
    
    for (i = [0:steps-1]) {
        p1 = path[i];
        p2 = path[i+1];
        
        // Calculate direction vector and rotation
        dir = p2 - p1;
        length = vector_length(dir);
        
        if (length > EPSILON) {
            // Calculate rotation to align with path direction
            up = [0, 0, 1];
            normal_dir = normalize_vector(dir);
            
            // Simple rotation for now - could be improved with proper 3D rotation
            angle_z = atan2(normal_dir[1], normal_dir[0]);
            angle_y = -asin(normal_dir[2]);
            
            // Current scale and twist
            t = i / steps;
            current_scale = is_list(scale_along_path) ? 
                lerp(scale_along_path[0], scale_along_path[1], t) : scale_along_path;
            current_twist = twist_along_path * t;
            
            translate(p1) {
                rotate([0, angle_y, angle_z]) {
                    linear_extrude(height = length, scale = current_scale, twist = current_twist) {
                        children();
                    }
                }
            }
        }
    }
}

// Circular path extrusion (revolve around path)
module circular_path_extrude(radius, angle = 360, steps = 32) {
    step_angle = angle / steps;
    
    for (i = [0:steps-1]) {
        current_angle = i * step_angle;
        next_angle = (i + 1) * step_angle;
        
        rotate([0, 0, current_angle]) {
            translate([radius, 0, 0]) {
                rotate([0, 0, step_angle]) {
                    linear_extrude(height = 0.1, center = true, twist = step_angle) {
                        children();
                    }
                }
            }
        }
    }
}

// Helical extrusion (spiral path)
module helical_extrude(radius, pitch, turns, twist_per_turn = 0) {
    steps = max(16, turns * 16);
    height_per_step = (pitch * turns) / steps;
    angle_per_step = (360 * turns) / steps;
    twist_per_step = twist_per_turn * turns / steps;
    
    for (i = [0:steps-1]) {
        angle = i * angle_per_step;
        height = i * height_per_step;
        twist = i * twist_per_step;
        
        translate([0, 0, height]) {
            rotate([0, 0, angle]) {
                translate([radius, 0, 0]) {
                    rotate([0, 0, twist]) {
                        linear_extrude(height = height_per_step, twist = twist_per_step) {
                            children();
                        }
                    }
                }
            }
        }
    }
}

// =============================================================================
// MORPHING EXTRUSIONS
// =============================================================================

// Morph between two 2D shapes
module morph_extrude(height, steps = 10, center = false) {
    // Requires two children - bottom and top shapes
    step_height = height / steps;
    
    translate([0, 0, center ? -height/2 : 0]) {
        for (i = [0:steps-1]) {
            t = i / (steps - 1);
            z = i * step_height;
            
            translate([0, 0, z]) {
                hull() {
                    linear_extrude(height = step_height) {
                        // This is a simplified version - true morphing requires
                        // interpolating between point sets
                        if (t < 0.5) {
                            children(0); // Bottom shape
                        } else {
                            children(1); // Top shape  
                        }
                    }
                }
            }
        }
    }
}

// Variable cross-section extrusion
module variable_extrude(height, scale_function, steps = 20, center = false) {
    step_height = height / steps;
    
    translate([0, 0, center ? -height/2 : 0]) {
        for (i = [0:steps-1]) {
            t = i / (steps - 1);
            z = i * step_height;
            scale_factor = scale_function(t);
            
            translate([0, 0, z]) {
                linear_extrude(height = step_height, scale = scale_factor) {
                    children();
                }
            }
        }
    }
}

// =============================================================================
// SPECIALIZED EXTRUSIONS
// =============================================================================

// Pipe/tube extrusion with wall thickness
module pipe_extrude(height, wall_thickness, center = false) {
    translate([0, 0, center ? -height/2 : 0]) {
        linear_extrude(height = height) {
            difference() {
                children();
                offset(r = -wall_thickness) children();
            }
        }
    }
}

// Ribbed extrusion (with periodic ribs)
module ribbed_extrude(height, rib_height = 1, rib_spacing = 5, center = false) {
    translate([0, 0, center ? -height/2 : 0]) {
        // Base extrusion
        linear_extrude(height = height) {
            children();
        }
        
        // Add ribs
        rib_count = floor(height / rib_spacing);
        for (i = [0:rib_count]) {
            z = i * rib_spacing;
            if (z <= height) {
                translate([0, 0, z]) {
                    linear_extrude(height = min(rib_height, height - z)) {
                        offset(r = rib_height) children();
                    }
                }
            }
        }
    }
}

// Perforated extrusion (with holes)
module perforated_extrude(height, hole_size = 2, hole_spacing = 5, center = false) {
    translate([0, 0, center ? -height/2 : 0]) {
        difference() {
            linear_extrude(height = height) {
                children();
            }
            
            // Create hole pattern
            hole_layers = floor(height / hole_spacing);
            for (layer = [1:hole_layers]) {
                z = layer * hole_spacing;
                translate([0, 0, z]) {
                    linear_extrude(height = hole_size, center = true) {
                        // Simple grid of holes - could be more sophisticated
                        for (x = [-20:hole_spacing*2:20]) {
                            for (y = [-20:hole_spacing*2:20]) {
                                translate([x, y]) {
                                    circle(d = hole_size);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

// =============================================================================
// UTILITY FUNCTIONS FOR EXTRUSIONS
// =============================================================================

// Generate a simple sine wave path
function sine_wave_path(length, amplitude, frequency, steps = 50) =
    [for (i = [0:steps])
        let(
            t = i / steps,
            x = t * length,
            y = amplitude * sin(frequency * t * 360),
            z = 0
        )
        [x, y, z]
    ];

// Generate a circular path
function circular_path(radius, height = 0, angle = 360, steps = 32) =
    [for (i = [0:steps])
        let(
            a = i * angle / steps,
            x = radius * cos(a),
            y = radius * sin(a),
            z = height * i / steps
        )
        [x, y, z]
    ];

// Generate a helical path
function helical_path(radius, pitch, turns, steps = undef) =
    let(actual_steps = steps != undef ? steps : max(16, turns * 16))
    [for (i = [0:actual_steps])
        let(
            t = i / actual_steps,
            angle = t * turns * 360,
            x = radius * cos(angle),
            y = radius * sin(angle),
            z = t * pitch * turns
        )
        [x, y, z]
    ];

// =============================================================================
// EXAMPLES AND TESTS  
// =============================================================================

// Uncomment to test extrusions
// tapered_extrude(10, scale_top = 0.5) square([5, 5]);
// translate([15, 0, 0]) rounded_extrude(10, radius = 2) square([5, 5]);
// translate([30, 0, 0]) pipe_extrude(10, wall_thickness = 1) circle(d = 8);