// =============================================================================
// Mathematical Utility Functions
// =============================================================================

// Constants
PI = 3.14159265359;
EPSILON = 0.0001;

// =============================================================================
// TRIGONOMETRIC HELPERS
// =============================================================================

// Convert degrees to radians
function deg_to_rad(degrees) = degrees * PI / 180;

// Convert radians to degrees  
function rad_to_deg(radians) = radians * 180 / PI;

// Normalize angle to 0-360 degrees
function normalize_angle(angle) = 
    angle < 0 ? normalize_angle(angle + 360) :
    angle >= 360 ? normalize_angle(angle - 360) :
    angle;

// =============================================================================
// VECTOR OPERATIONS
// =============================================================================

// Vector magnitude/length
function vector_length(v) = sqrt(v[0]*v[0] + v[1]*v[1] + v[2]*v[2]);

// 2D vector magnitude
function vector_length_2d(v) = sqrt(v[0]*v[0] + v[1]*v[1]);

// Normalize vector to unit length
function normalize_vector(v) = 
    let(len = vector_length(v))
    len > EPSILON ? v / len : [0, 0, 0];

// 2D vector normalization
function normalize_vector_2d(v) = 
    let(len = vector_length_2d(v))
    len > EPSILON ? v / len : [0, 0];

// Dot product
function dot_product(v1, v2) = v1[0]*v2[0] + v1[1]*v2[1] + v1[2]*v2[2];

// 2D dot product
function dot_product_2d(v1, v2) = v1[0]*v2[0] + v1[1]*v2[1];

// Cross product (3D)
function cross_product(v1, v2) = [
    v1[1]*v2[2] - v1[2]*v2[1],
    v1[2]*v2[0] - v1[0]*v2[2], 
    v1[0]*v2[1] - v1[1]*v2[0]
];

// 2D cross product (returns scalar)
function cross_product_2d(v1, v2) = v1[0]*v2[1] - v1[1]*v2[0];

// Distance between two points
function distance(p1, p2) = vector_length(p2 - p1);

// 2D distance between two points
function distance_2d(p1, p2) = vector_length_2d(p2 - p1);

// =============================================================================
// INTERPOLATION FUNCTIONS
// =============================================================================

// Linear interpolation between two values
function lerp(a, b, t) = a + t * (b - a);

// Linear interpolation between two points
function lerp_point(p1, p2, t) = [
    lerp(p1[0], p2[0], t),
    lerp(p1[1], p2[1], t),
    len(p1) > 2 ? lerp(p1[2], p2[2], t) : 0
];

// Smoothstep interpolation (smooth start/end)
function smoothstep(t) = t * t * (3 - 2 * t);

// Smootherstep interpolation (smoother start/end)
function smootherstep(t) = t * t * t * (t * (t * 6 - 15) + 10);

// Clamp value between min and max
function clamp(value, min_val, max_val) = 
    min(max(value, min_val), max_val);

// Map value from one range to another
function map_range(value, from_min, from_max, to_min, to_max) =
    lerp(to_min, to_max, (value - from_min) / (from_max - from_min));

// =============================================================================
// UTILITY FUNCTIONS
// =============================================================================

// Sign function (-1, 0, or 1)
function sign(x) = x > 0 ? 1 : x < 0 ? -1 : 0;

// Check if value is approximately equal (within epsilon)
function approx_equal(a, b, epsilon = EPSILON) = abs(a - b) < epsilon;

// Round to nearest increment
function round_to_increment(value, increment) = 
    round(value / increment) * increment;

// Modulo that works with negative numbers
function mod(a, n) = a - n * floor(a / n);

// =============================================================================
// RANGE AND SEQUENCE FUNCTIONS
// =============================================================================

// Generate range of numbers
function range(start, end, step = 1) = 
    step > 0 && start <= end ? [for (i = [start : step : end]) i] :
    step < 0 && start >= end ? [for (i = [start : step : end]) i] :
    [];

// Generate linearly spaced numbers
function linspace(start, end, num) = 
    num <= 1 ? [start] :
    [for (i = [0 : num-1]) lerp(start, end, i / (num-1))];

// =============================================================================
// BOOLEAN AND COMPARISON HELPERS
// =============================================================================

// Check if point is inside 2D bounding box
function point_in_bbox_2d(point, bbox_min, bbox_max) =
    point[0] >= bbox_min[0] && point[0] <= bbox_max[0] &&
    point[1] >= bbox_min[1] && point[1] <= bbox_max[1];

// Check if point is inside 3D bounding box
function point_in_bbox_3d(point, bbox_min, bbox_max) =
    point[0] >= bbox_min[0] && point[0] <= bbox_max[0] &&
    point[1] >= bbox_min[1] && point[1] <= bbox_max[1] &&
    point[2] >= bbox_min[2] && point[2] <= bbox_max[2];

// =============================================================================
// EXAMPLES AND TESTS
// =============================================================================

// Uncomment to test functions
// echo("Vector length [3,4,5]:", vector_length([3, 4, 5])); // Should be ~7.07
// echo("Normalize [3,4,0]:", normalize_vector([3, 4, 0])); // Should be [0.6, 0.8, 0]
// echo("Lerp 0 to 10 at 0.5:", lerp(0, 10, 0.5)); // Should be 5
// echo("Range 0 to 10 step 2:", range(0, 10, 2)); // Should be [0,2,4,6,8,10]