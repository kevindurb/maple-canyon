// =============================================================================
// Hardware Components (Hinges, Brackets, etc.)
// =============================================================================

use <math.scad>
use <fasteners.scad>

// =============================================================================
// HINGES
// =============================================================================

// Standard butt hinge
module butt_hinge(length = 60, width = 30, thickness = 2, pin_diameter = 3, knuckles = 3) {
    knuckle_length = length / knuckles;
    leaf_width = (width - thickness) / 2;
    
    union() {
        // Hinge leaves
        for (side = [0, 1]) {
            translate([side * (leaf_width + thickness), 0, 0]) {
                difference() {
                    // Leaf body
                    cube([leaf_width, length, thickness]);
                    
                    // Screw holes (typically 2-3 per leaf)
                    screw_spacing = length / 4;
                    for (i = [1:3]) {
                        translate([leaf_width/2, i * screw_spacing, -0.1]) {
                            cylinder(h = thickness + 0.2, d = 4); // M4 clearance
                        }
                    }
                }
            }
        }
        
        // Hinge knuckles
        for (i = [0:knuckles-1]) {
            y_pos = i * knuckle_length + knuckle_length/2;
            
            // Alternate sides for interlocking knuckles
            side = i % 2 == 0 ? 0 : 1;
            x_pos = side * (leaf_width + thickness/2);
            
            translate([x_pos, y_pos, thickness/2]) {
                rotate([90, 0, 0]) {
                    difference() {
                        cylinder(h = knuckle_length * 0.8, d = thickness * 2, center = true);
                        cylinder(h = knuckle_length, d = pin_diameter, center = true);
                    }
                }
            }
        }
        
        // Hinge pin
        translate([leaf_width/2, length/2, thickness/2]) {
            rotate([90, 0, 0]) {
                cylinder(h = length * 1.1, d = pin_diameter, center = true);
            }
        }
    }
}

// Piano hinge (continuous hinge)
module piano_hinge(length = 100, width = 25, thickness = 1.5, pin_diameter = 2) {
    leaf_width = (width - thickness) / 2;
    
    union() {
        // Continuous leaves
        for (side = [0, 1]) {
            translate([side * (leaf_width + thickness), 0, 0]) {
                difference() {
                    cube([leaf_width, length, thickness]);
                    
                    // Screw holes along length
                    hole_spacing = 15;
                    holes = floor(length / hole_spacing);
                    for (i = [1:holes-1]) {
                        translate([leaf_width/2, i * hole_spacing, -0.1]) {
                            cylinder(h = thickness + 0.2, d = 2.5); // M2.5 clearance
                        }
                    }
                }
            }
        }
        
        // Continuous knuckle
        translate([leaf_width/2, length/2, thickness/2]) {
            rotate([90, 0, 0]) {
                difference() {
                    cylinder(h = length, d = thickness * 2, center = true);
                    cylinder(h = length * 1.1, d = pin_diameter, center = true);
                }
            }
        }
        
        // Pin
        translate([leaf_width/2, length/2, thickness/2]) {
            rotate([90, 0, 0]) {
                cylinder(h = length * 1.1, d = pin_diameter, center = true);
            }
        }
    }
}

// Strap hinge
module strap_hinge(length1 = 80, length2 = 80, width = 20, thickness = 2) {
    pin_diameter = 4;
    knuckle_diameter = 8;
    
    union() {
        // First strap
        difference() {
            hull() {
                cylinder(h = thickness, d = knuckle_diameter);
                translate([length1, 0, 0]) {
                    cube([width, width, thickness], center = true);
                }
            }
            
            // Pin hole
            cylinder(h = thickness * 1.1, d = pin_diameter, center = true);
            
            // Mounting holes
            for (i = [1:3]) {
                translate([length1 - i * 15, 0, -0.1]) {
                    cylinder(h = thickness + 0.2, d = 4);
                }
            }
        }
        
        // Second strap
        rotate([0, 0, 180]) {
            difference() {
                hull() {
                    cylinder(h = thickness, d = knuckle_diameter);
                    translate([length2, 0, 0]) {
                        cube([width, width, thickness], center = true);
                    }
                }
                
                // Pin hole
                cylinder(h = thickness * 1.1, d = pin_diameter, center = true);
                
                // Mounting holes
                for (i = [1:3]) {
                    translate([length2 - i * 15, 0, -0.1]) {
                        cylinder(h = thickness + 0.2, d = 4);
                    }
                }
            }
        }
        
        // Pin
        cylinder(h = thickness * 1.1, d = pin_diameter, center = true);
    }
}

// =============================================================================
// BRACKETS AND ANGLES
// =============================================================================

// L-bracket (angle bracket)
module l_bracket(width1 = 40, width2 = 40, thickness = 3, height = 30) {
    difference() {
        union() {
            // Horizontal leg
            cube([width1, thickness, height]);
            
            // Vertical leg  
            cube([thickness, width2, height]);
        }
        
        // Mounting holes in horizontal leg
        for (i = [1:2]) {
            translate([width1/3 * i, thickness/2, height/2]) {
                rotate([90, 0, 0]) {
                    cylinder(h = thickness * 1.1, d = 4, center = true);
                }
            }
        }
        
        // Mounting holes in vertical leg
        for (i = [1:2]) {
            translate([thickness/2, width2/3 * i, height/2]) {
                rotate([0, 90, 0]) {
                    cylinder(h = thickness * 1.1, d = 4, center = true);
                }
            }
        }
    }
}

// T-bracket
module t_bracket(width = 60, height = 40, thickness = 3, depth = 30) {
    difference() {
        union() {
            // Horizontal base
            translate([-width/2, 0, 0]) {
                cube([width, thickness, depth]);
            }
            
            // Vertical back
            translate([-thickness/2, 0, 0]) {
                cube([thickness, height, depth]);
            }
        }
        
        // Mounting holes in base
        for (i = [-1, 1]) {
            translate([i * width/3, thickness/2, depth/2]) {
                rotate([90, 0, 0]) {
                    cylinder(h = thickness * 1.1, d = 4, center = true);
                }
            }
        }
        
        // Mounting holes in back
        for (i = [1:2]) {
            translate([0, height/3 * i, depth/2]) {
                rotate([0, 90, 0]) {
                    cylinder(h = thickness * 1.1, d = 4, center = true);
                }
            }
        }
    }
}

// Corner bracket (3-way)
module corner_bracket(size = 30, thickness = 3) {
    difference() {
        // Three faces meeting at corner
        union() {
            cube([size, thickness, size]);
            cube([thickness, size, size]);
            cube([size, size, thickness]);
        }
        
        // Mounting holes on each face
        hole_pos = size * 0.3;
        
        // X-face holes
        translate([hole_pos, thickness/2, hole_pos]) {
            rotate([90, 0, 0]) cylinder(h = thickness * 1.1, d = 4, center = true);
        }
        translate([size - hole_pos, thickness/2, size - hole_pos]) {
            rotate([90, 0, 0]) cylinder(h = thickness * 1.1, d = 4, center = true);
        }
        
        // Y-face holes
        translate([thickness/2, hole_pos, hole_pos]) {
            rotate([0, 90, 0]) cylinder(h = thickness * 1.1, d = 4, center = true);
        }
        translate([thickness/2, size - hole_pos, size - hole_pos]) {
            rotate([0, 90, 0]) cylinder(h = thickness * 1.1, d = 4, center = true);
        }
        
        // Z-face holes
        translate([hole_pos, hole_pos, thickness/2]) {
            cylinder(h = thickness * 1.1, d = 4, center = true);
        }
        translate([size - hole_pos, size - hole_pos, thickness/2]) {
            cylinder(h = thickness * 1.1, d = 4, center = true);
        }
    }
}

// =============================================================================
// LATCHES AND CATCHES
// =============================================================================

// Barrel bolt latch
module barrel_bolt(length = 100, diameter = 8) {
    housing_length = length * 0.4;
    bolt_travel = length * 0.6;
    
    union() {
        // Housing/guide
        difference() {
            cylinder(h = housing_length, d = diameter * 2);
            cylinder(h = housing_length * 1.1, d = diameter + 0.5, center = true);
            
            // Mounting holes
            for (angle = [45, 135]) {
                rotate([0, 0, angle]) {
                    translate([diameter, 0, housing_length/2]) {
                        rotate([0, 90, 0]) {
                            cylinder(h = diameter * 0.5, d = 3, center = true);
                        }
                    }
                }
            }
        }
        
        // Bolt
        translate([0, 0, -bolt_travel/2]) {
            cylinder(h = housing_length + bolt_travel, d = diameter);
        }
        
        // Handle
        translate([0, 0, housing_length + 5]) {
            difference() {
                cylinder(h = 10, d = diameter * 1.5);
                translate([0, 0, 5]) {
                    cylinder(h = 6, d = diameter + 0.5);
                }
            }
        }
    }
}

// Toggle latch
module toggle_latch(base_length = 60, arm_length = 40, thickness = 3) {
    pivot_diameter = 6;
    
    union() {
        // Base plate
        difference() {
            hull() {
                cylinder(h = thickness, d = pivot_diameter * 2);
                translate([base_length, 0, 0]) {
                    cylinder(h = thickness, d = 12);
                }
            }
            
            // Pivot hole
            cylinder(h = thickness * 1.1, d = pivot_diameter, center = true);
            
            // Mounting holes
            translate([base_length, 0, -0.1]) {
                cylinder(h = thickness + 0.2, d = 4);
            }
        }
        
        // Toggle arm
        translate([0, 0, thickness]) {
            difference() {
                hull() {
                    cylinder(h = thickness, d = pivot_diameter * 1.5);
                    translate([arm_length, 0, 0]) {
                        cylinder(h = thickness, d = 8);
                    }
                }
                
                // Pivot hole
                cylinder(h = thickness * 1.1, d = pivot_diameter, center = true);
            }
        }
        
        // Pivot pin
        cylinder(h = thickness * 2 + 2, d = pivot_diameter - 0.5, center = true);
    }
}

// =============================================================================
// HANDLES AND PULLS
// =============================================================================

// Cabinet pull handle
module cabinet_pull(length = 96, diameter = 12, standoff = 25) {
    mount_spacing = length - 20;
    
    union() {
        // Handle bar
        rotate([0, 90, 0]) {
            cylinder(h = length, d = diameter, center = true);
        }
        
        // Mounting posts
        for (side = [-1, 1]) {
            translate([side * mount_spacing/2, 0, 0]) {
                translate([0, 0, -standoff/2]) {
                    cylinder(h = standoff, d = diameter * 0.7, center = true);
                }
                
                // Mounting screw
                translate([0, 0, -standoff]) {
                    cylinder(h = 10, d = 4);
                }
            }
        }
    }
}

// Door handle (lever style)
module door_handle(length = 120, rise = 15, thickness = 20) {
    // Handle lever
    hull() {
        sphere(d = thickness);
        translate([length, rise, 0]) {
            sphere(d = thickness * 0.7);
        }
    }
    
    // Mounting collar
    rotate([0, 90, 0]) {
        difference() {
            cylinder(h = 30, d = thickness * 2, center = true);
            cylinder(h = 35, d = 8, center = true); // Square shaft would be better
        }
    }
}

// =============================================================================
// SLIDING HARDWARE
// =============================================================================

// Drawer slide (simplified representation)
module drawer_slide(length = 300, width = 12, thickness = 2) {
    // Outer rail (cabinet mount)
    difference() {
        cube([length, width, thickness]);
        
        // Ball bearing race (groove)
        translate([0, width/2, thickness/2]) {
            hull() {
                sphere(d = 2);
                translate([length, 0, 0]) sphere(d = 2);
            }
        }
        
        // Mounting holes
        for (i = [1:4]) {
            translate([length/5 * i, width/2, -0.1]) {
                cylinder(h = thickness + 0.2, d = 3);
            }
        }
    }
    
    // Inner rail (drawer mount) - shown extended
    translate([0, 0, -thickness - 1]) {
        difference() {
            cube([length * 0.8, width, thickness]);
            
            // Mounting holes
            for (i = [1:3]) {
                translate([length * 0.8/4 * i, width/2, -0.1]) {
                    cylinder(h = thickness + 0.2, d = 3);
                }
            }
        }
    }
    
    // Ball bearings (representation)
    for (i = [0:10:length-10]) {
        translate([i + 5, width/2, thickness/2]) {
            sphere(d = 1.5);
        }
    }
}

// Sliding door track
module sliding_track(length = 500, track_width = 20, track_depth = 10) {
    difference() {
        // Track body
        cube([length, track_width, track_depth]);
        
        // Door groove
        translate([0, track_width/2, track_depth/2]) {
            cube([length * 1.1, 6, track_depth], center = true);
        }
        
        // Mounting holes
        hole_spacing = 50;
        holes = floor(length / hole_spacing);
        for (i = [1:holes-1]) {
            translate([i * hole_spacing, track_width/2, -0.1]) {
                cylinder(h = track_depth + 0.2, d = 4);
            }
        }
    }
}

// =============================================================================
// EXAMPLES AND TESTS
// =============================================================================

// Uncomment to test hardware
// butt_hinge(60, 30, 2);
// translate([50, 0, 0]) l_bracket(40, 40, 3, 30);
// translate([100, 0, 0]) cabinet_pull(96, 12, 25);