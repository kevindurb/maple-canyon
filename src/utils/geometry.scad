// =============================================================================
// Geometry Calculation Utilities
// =============================================================================

use <math.scad>

// =============================================================================
// 2D GEOMETRY FUNCTIONS
// =============================================================================

// Calculate area of a polygon given vertices
function polygon_area(points) = 
    let(n = len(points))
    abs(sum([for (i = [0:n-1]) 
        let(j = (i + 1) % n)
        points[i][0] * points[j][1] - points[j][0] * points[i][1]
    ])) / 2;

// Calculate centroid of a polygon
function polygon_centroid(points) =
    let(
        n = len(points),
        area = polygon_area(points),
        cx = sum([for (i = [0:n-1])
            let(j = (i + 1) % n)
            (points[i][0] + points[j][0]) * 
            (points[i][0] * points[j][1] - points[j][0] * points[i][1])
        ]) / (6 * area),
        cy = sum([for (i = [0:n-1])
            let(j = (i + 1) % n)
            (points[i][1] + points[j][1]) *
            (points[i][0] * points[j][1] - points[j][0] * points[i][1])  
        ]) / (6 * area)
    )
    [cx, cy];

// Check if point is inside polygon (ray casting algorithm)
function point_in_polygon(point, vertices) =
    let(
        x = point[0],
        y = point[1],
        n = len(vertices),
        crossings = sum([for (i = [0:n-1])
            let(
                j = (i + 1) % n,
                xi = vertices[i][0],
                yi = vertices[i][1], 
                xj = vertices[j][0],
                yj = vertices[j][1]
            )
            ((yi > y) != (yj > y)) && 
            (x < (xj - xi) * (y - yi) / (yj - yi) + xi) ? 1 : 0
        ])
    )
    (crossings % 2) == 1;

// Distance from point to line segment
function point_to_line_distance(point, line_start, line_end) =
    let(
        A = point - line_start,
        B = line_end - line_start,
        dot_AB = dot_product_2d(A, B),
        dot_BB = dot_product_2d(B, B)
    )
    dot_BB < EPSILON ? distance_2d(point, line_start) :
    let(t = clamp(dot_AB / dot_BB, 0, 1))
    distance_2d(point, line_start + t * B);

// Find intersection of two line segments
function line_intersection(p1, p2, p3, p4) =
    let(
        x1 = p1[0], y1 = p1[1],
        x2 = p2[0], y2 = p2[1], 
        x3 = p3[0], y3 = p3[1],
        x4 = p4[0], y4 = p4[1],
        denom = (x1-x2)*(y3-y4) - (y1-y2)*(x3-x4)
    )
    abs(denom) < EPSILON ? undef : // Lines are parallel
    let(
        t = ((x1-x3)*(y3-y4) - (y1-y3)*(x3-x4)) / denom,
        u = -((x1-x2)*(y1-y3) - (y1-y2)*(x1-x3)) / denom
    )
    (t >= 0 && t <= 1 && u >= 0 && u <= 1) ?
        [x1 + t*(x2-x1), y1 + t*(y2-y1)] : undef;

// =============================================================================
// CIRCLE AND ARC FUNCTIONS
// =============================================================================

// Generate points for a circle
function circle_points(radius, segments = 32, center = [0, 0]) =
    [for (i = [0:segments-1])
        let(angle = i * 360 / segments)
        [center[0] + radius * cos(angle), center[1] + radius * sin(angle)]
    ];

// Generate points for an arc
function arc_points(radius, start_angle, end_angle, segments = 16, center = [0, 0]) =
    let(
        angle_range = end_angle - start_angle,
        step = angle_range / max(1, segments - 1)
    )
    [for (i = [0:segments-1])
        let(angle = start_angle + i * step)
        [center[0] + radius * cos(angle), center[1] + radius * sin(angle)]
    ];

// Find circle through three points
function circle_from_three_points(p1, p2, p3) =
    let(
        ax = p1[0], ay = p1[1],
        bx = p2[0], by = p2[1],
        cx = p3[0], cy = p3[1],
        d = 2 * (ax * (by - cy) + bx * (cy - ay) + cx * (ay - by))
    )
    abs(d) < EPSILON ? undef : // Points are collinear
    let(
        ux = ((ax*ax + ay*ay) * (by - cy) + (bx*bx + by*by) * (cy - ay) + (cx*cx + cy*cy) * (ay - by)) / d,
        uy = ((ax*ax + ay*ay) * (cx - bx) + (bx*bx + by*by) * (ax - cx) + (cx*cx + cy*cy) * (bx - ax)) / d,
        r = distance_2d([ux, uy], p1)
    )
    [ux, uy, r]; // [center_x, center_y, radius]

// =============================================================================
// 3D GEOMETRY FUNCTIONS
// =============================================================================

// Calculate normal vector for a triangle (3 points)
function triangle_normal(p1, p2, p3) =
    normalize_vector(cross_product(p2 - p1, p3 - p1));

// Calculate area of a triangle in 3D
function triangle_area_3d(p1, p2, p3) =
    vector_length(cross_product(p2 - p1, p3 - p1)) / 2;

// Distance from point to plane (defined by point and normal)
function point_to_plane_distance(point, plane_point, plane_normal) =
    dot_product(point - plane_point, normalize_vector(plane_normal));

// Project point onto plane
function project_point_to_plane(point, plane_point, plane_normal) =
    let(
        n = normalize_vector(plane_normal),
        d = point_to_plane_distance(point, plane_point, n)
    )
    point - d * n;

// =============================================================================
// BOUNDING BOX FUNCTIONS
// =============================================================================

// Calculate 2D bounding box from points
function bounding_box_2d(points) =
    len(points) == 0 ? [[0, 0], [0, 0]] :
    let(
        xs = [for (p = points) p[0]],
        ys = [for (p = points) p[1]]
    )
    [[min(xs), min(ys)], [max(xs), max(ys)]];

// Calculate 3D bounding box from points  
function bounding_box_3d(points) =
    len(points) == 0 ? [[0, 0, 0], [0, 0, 0]] :
    let(
        xs = [for (p = points) p[0]],
        ys = [for (p = points) p[1]],
        zs = [for (p = points) p[2]]
    )
    [[min(xs), min(ys), min(zs)], [max(xs), max(ys), max(zs)]];

// Expand bounding box by margin
function expand_bbox(bbox, margin) =
    [bbox[0] - [margin, margin, len(bbox[0]) > 2 ? margin : 0],
     bbox[1] + [margin, margin, len(bbox[1]) > 2 ? margin : 0]];

// =============================================================================
// TRANSFORMATION HELPERS
// =============================================================================

// Rotate point around origin in 2D
function rotate_point_2d(point, angle) =
    let(
        cos_a = cos(angle),
        sin_a = sin(angle)
    )
    [point[0] * cos_a - point[1] * sin_a,
     point[0] * sin_a + point[1] * cos_a];

// Rotate point around arbitrary center in 2D
function rotate_point_around_2d(point, center, angle) =
    rotate_point_2d(point - center, angle) + center;

// Scale point from origin
function scale_point(point, scale_factor) =
    is_list(scale_factor) ? 
        [for (i = [0:len(point)-1]) point[i] * scale_factor[i]] :
        point * scale_factor;

// =============================================================================
// CURVE FUNCTIONS
// =============================================================================

// Quadratic Bezier curve
function bezier_quadratic(p0, p1, p2, t) =
    let(
        u = 1 - t,
        tt = t * t,
        uu = u * u,
        ut2 = 2 * u * t
    )
    uu * p0 + ut2 * p1 + tt * p2;

// Cubic Bezier curve
function bezier_cubic(p0, p1, p2, p3, t) =
    let(
        u = 1 - t,
        tt = t * t,
        uu = u * u,
        ttt = tt * t,
        uuu = uu * u
    )
    uuu * p0 + 3 * uu * t * p1 + 3 * u * tt * p2 + ttt * p3;

// Generate points along a Bezier curve
function bezier_points(control_points, segments = 20) =
    len(control_points) == 3 ?
        [for (i = [0:segments]) bezier_quadratic(control_points[0], control_points[1], control_points[2], i/segments)] :
    len(control_points) == 4 ?
        [for (i = [0:segments]) bezier_cubic(control_points[0], control_points[1], control_points[2], control_points[3], i/segments)] :
        []; // Only support quadratic and cubic for now

// =============================================================================
// UTILITY FUNCTIONS
// =============================================================================

// Sum function for arrays
function sum(arr) = len(arr) == 0 ? 0 : len(arr) == 1 ? arr[0] : arr[0] + sum([for (i = [1:len(arr)-1]) arr[i]]);

// =============================================================================
// EXAMPLES AND TESTS
// =============================================================================

// Uncomment to test functions
// test_points = [[0,0], [10,0], [10,10], [0,10]];
// echo("Polygon area:", polygon_area(test_points)); // Should be 100
// echo("Polygon centroid:", polygon_centroid(test_points)); // Should be [5,5]
// echo("Point [5,5] in polygon:", point_in_polygon([5,5], test_points)); // Should be true