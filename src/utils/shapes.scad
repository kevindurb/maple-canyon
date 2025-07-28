// =============================================================================
// Shape Creation Utilities
// =============================================================================

use <math.scad>
use <geometry.scad>

// =============================================================================
// 2D SHAPE MODULES
// =============================================================================

// Rounded rectangle
module rounded_rect(size, radius, center = false) {
    w = size[0];
    h = size[1];
    r = min(radius, min(w, h) / 2);
    
    translate(center ? [-w/2, -h/2] : [0, 0]) {
        hull() {
            translate([r, r]) circle(r);
            translate([w-r, r]) circle(r);
            translate([w-r, h-r]) circle(r);
            translate([r, h-r]) circle(r);
        }
    }
}

// Regular polygon
module regular_polygon(sides, radius, center = true) {
    points = [for (i = [0:sides-1])
        let(angle = i * 360 / sides)
        [radius * cos(angle), radius * sin(angle)]
    ];
    polygon(points);
}

// Star shape
module star(outer_radius, inner_radius, points = 5) {
    vertices = [for (i = [0:2*points-1])
        let(
            angle = i * 180 / points,
            r = (i % 2 == 0) ? outer_radius : inner_radius
        )
        [r * cos(angle), r * sin(angle)]
    ];
    polygon(vertices);
}

// Teardrop shape (useful for the camper!)
module teardrop(length, width, center = false) {
    translate(center ? [-length/2, -width/2] : [0, 0]) {
        hull() {
            // Front circular section
            translate([width/2, width/2]) 
                circle(d = width);
            // Rear point
            translate([length, width/2]) 
                circle(d = 0.1); // Very small circle for sharp point
        }
    }
}

// Oval/ellipse
module oval(width, height, center = true) {
    scale([width/height, 1]) 
        circle(d = height, center = center);
}

// Chamfered rectangle
module chamfered_rect(size, chamfer, center = false) {
    w = size[0];
    h = size[1];
    c = min(chamfer, min(w, h) / 2);
    
    translate(center ? [-w/2, -h/2] : [0, 0]) {
        polygon([
            [c, 0],
            [w-c, 0],
            [w, c],
            [w, h-c],
            [w-c, h],
            [c, h],
            [0, h-c],
            [0, c]
        ]);
    }
}

// Bezier curve as 2D shape
module bezier_curve_2d(control_points, width = 1, segments = 20) {
    points = bezier_points(control_points, segments);
    for (i = [0:len(points)-2]) {
        hull() {
            translate(points[i]) circle(d = width);
            translate(points[i+1]) circle(d = width);
        }
    }
}

// =============================================================================
// 3D SHAPE MODULES  
// =============================================================================

// Rounded cube/box
module rounded_cube(size, radius, center = false) {
    w = size[0];
    h = size[1]; 
    d = size[2];
    r = min(radius, min(w, h, d) / 2);
    
    translate(center ? [-w/2, -h/2, -d/2] : [0, 0, 0]) {
        hull() {
            translate([r, r, r]) sphere(r);
            translate([w-r, r, r]) sphere(r);
            translate([w-r, h-r, r]) sphere(r);
            translate([r, h-r, r]) sphere(r);
            translate([r, r, d-r]) sphere(r);
            translate([w-r, r, d-r]) sphere(r);
            translate([w-r, h-r, d-r]) sphere(r);
            translate([r, h-r, d-r]) sphere(r);
        }
    }
}

// Chamfered cube
module chamfered_cube(size, chamfer, center = false) {
    w = size[0];
    h = size[1];
    d = size[2];
    c = min(chamfer, min(w, h, d) / 2);
    
    translate(center ? [-w/2, -h/2, -d/2] : [0, 0, 0]) {
        hull() {
            translate([c, c, c]) cube([w-2*c, h-2*c, d-2*c]);
            translate([0, c, c]) cube([w, h-2*c, d-2*c]);
            translate([c, 0, c]) cube([w-2*c, h, d-2*c]);
            translate([c, c, 0]) cube([w-2*c, h-2*c, d]);
        }
    }
}

// Cylinder with rounded ends
module rounded_cylinder(h, r, end_radius = 1, center = false) {
    er = min(end_radius, min(r, h/2));
    translate([0, 0, center ? -h/2 : 0]) {
        hull() {
            translate([0, 0, er]) 
                cylinder(h = h - 2*er, r = r);
            translate([0, 0, er]) 
                sphere(er);
            translate([0, 0, h - er]) 
                sphere(er);
        }
    }
}

// Truncated cone (frustum)
module frustum(h, r1, r2, center = false) {
    translate([0, 0, center ? -h/2 : 0]) {
        cylinder(h = h, r1 = r1, r2 = r2);
    }
}

// Torus
module torus(major_radius, minor_radius) {
    rotate_extrude() {
        translate([major_radius, 0]) 
            circle(minor_radius);
    }
}

// Helix/spring shape
module helix(radius, pitch, height, thickness = 1, turns = undef) {
    actual_turns = turns != undef ? turns : height / pitch;
    steps = max(16, actual_turns * 16);
    
    for (i = [0:steps-1]) {
        t = i / steps;
        z = t * height;
        angle = t * actual_turns * 360;
        
        hull() {
            translate([radius * cos(angle), radius * sin(angle), z])
                sphere(thickness/2);
            
            if (i < steps - 1) {
                t_next = (i + 1) / steps;
                z_next = t_next * height;
                angle_next = t_next * actual_turns * 360;
                translate([radius * cos(angle_next), radius * sin(angle_next), z_next])
                    sphere(thickness/2);
            }
        }
    }
}

// =============================================================================
// SPECIALIZED SHAPES
// =============================================================================

// Gear outline (2D)
module gear_2d(teeth, pitch_radius, tooth_height = 2) {
    tooth_angle = 360 / teeth;
    
    points = [for (i = [0:teeth*2-1])
        let(
            angle = i * tooth_angle / 2,
            r = (i % 2 == 0) ? pitch_radius + tooth_height : pitch_radius - tooth_height
        )
        [r * cos(angle), r * sin(angle)]
    ];
    polygon(points);
}

// Involute gear tooth profile (simplified)
module involute_gear_2d(teeth, module_size, pressure_angle = 20) {
    pitch_radius = teeth * module_size / 2;
    gear_2d(teeth, pitch_radius, module_size);
}

// Honeycomb cell
module hexagon(size, center = true) {
    regular_polygon(6, size, center);
}

// Honeycomb pattern (2D difference mask)
module honeycomb_pattern(size, cell_size, wall_thickness = 1) {
    spacing = cell_size * sqrt(3);
    rows = ceil(size[1] / (spacing * 0.75));
    cols = ceil(size[0] / spacing);
    
    for (row = [0:rows]) {
        for (col = [0:cols]) {
            x = col * spacing + (row % 2) * spacing / 2;
            y = row * spacing * 0.75;
            
            if (x < size[0] && y < size[1]) {
                translate([x, y]) 
                    difference() {
                        hexagon(cell_size);
                        hexagon(cell_size - wall_thickness);
                    }
            }
        }
    }
}

// =============================================================================
// CONSTRUCTION HELPERS
// =============================================================================

// Fillet between two intersecting rectangles
module fillet_2d(radius, angle = 90) {
    r = abs(radius);
    a = angle;
    
    if (radius > 0) {
        // External fillet (rounds outside corner)
        difference() {
            translate([-r, -r]) square([r, r]);
            translate([-r, -r]) circle(r);
        }
    } else {
        // Internal fillet (rounds inside corner)  
        intersection() {
            translate([0, -abs(radius)]) square([abs(radius), abs(radius)]);
            translate([0, 0]) circle(abs(radius));
        }
    }
}

// Shell/hollow out a 2D shape
module shell_2d(thickness) {
    difference() {
        children();
        offset(r = -thickness) children();
    }
}

// =============================================================================
// EXAMPLES AND TESTS
// =============================================================================

// Uncomment to test shapes
// rounded_rect([20, 10], 2);
// translate([30, 0]) regular_polygon(6, 5);
// translate([0, 20]) teardrop(30, 15);
// translate([0, 0, 20]) rounded_cube([10, 10, 10], 2);