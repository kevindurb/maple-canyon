# Teardrop Camper Development TODO

## Priority Legend
- **P0**: Critical path, blocking other tasks
- **P1**: High priority, core functionality  
- **P2**: Medium priority, important features
- **P3**: Low priority, polish and extras

## Status Legend
- ⚪ Not Started
- 🟡 In Progress  
- ✅ Complete
- 🔴 Blocked

---

## Phase 0: Project Configuration & Setup

### P0-001: Core Configuration Files
- ⚪ **Create `src/config/dimensions.scad`**
  - Overall dimensions: 120" total length, 108" body, 60" width, 78-84" height
  - Interior: 60"×80" sleeping, 46" headroom, 12" headboard depth
  - Platform: 4" raised bed, 2-3" wall thickness
  - Openings: 30"×36" doors, 12"×16" door windows, 24"×30" stargazing window
  - MaxxFan: 14"×14" roof opening
  - Harbor Freight trailer: 96"×48" deck

- ⚪ **Create `src/config/materials.scad`**
  - Color definitions (aluminum, composite, glass, steel)
  - Material properties for rendering
  - Transparency settings for cutaway views

- ⚪ **Create `src/config/tolerances.scad`**
  - Manufacturing clearances
  - Fit tolerances for hardware
  - Assembly gaps

### P0-002: File Structure Setup
- ⚪ **Create component directory structure**
  ```
  src/components/
  ├── shell/
  ├── chassis/
  ├── interior/
  ├── doors_windows/
  ├── electrical/
  └── hardware/
  ```

- ⚪ **Create assembly directory structure**
  ```
  src/assemblies/
  ├── complete_camper.scad
  ├── shell_assembly.scad
  ├── chassis_assembly.scad
  └── interior_assembly.scad
  ```

- ⚪ **Update `main.scad`** to use new structure and include all configs

---

## Phase 1: Core Geometry & Mathematics

### P0-003: Teardrop Profile Generation
- ⚪ **Create `src/components/shell/teardrop_profile.scad`**
  - Mathematical function for teardrop curve
  - 108" total body length (96" trailer + 12" overhang)
  - 60" maximum width at front
  - Aerodynamic taper to rear point
  - Parametric control for width and length scaling

- ⚪ **Create profile validation function**
  - Verify curve smoothness
  - Check for manufacturing feasibility
  - Validate aerodynamic properties

### P0-004: Harbor Freight Trailer Base
- ⚪ **Create `src/components/chassis/hf_trailer.scad`**
  - Exact Harbor Freight 8×4 trailer dimensions
  - Steel frame representation
  - Wood deck (0.75" plywood)
  - Wheel well locations and dimensions
  - Mounting points for body attachment

---

## Phase 2: Shell Construction

### P1-005: Exterior Shell
- ⚪ **Create `src/components/shell/exterior_shell.scad`**
  - Use teardrop profile to generate 3D shell
  - Wall thickness: 2-3" insulated construction
  - Smooth curves from front to rear
  - Proper overhang beyond trailer edges (6" each side)

- ⚪ **Add structural elements**
  - Frame attachment points
  - Reinforcement around openings
  - Roof load distribution for MaxxFan

### P1-006: Interior Shell
- ⚪ **Create `src/components/shell/interior_shell.scad`**
  - Interior surface offset from exterior by wall thickness
  - Smooth interior surfaces
  - Proper headroom calculations (46" from bed surface)
  - Integration with floor platform

### P1-007: Roof System
- ⚪ **Create `src/components/shell/roof.scad`**
  - Curved roof following teardrop profile
  - MaxxFan mounting surface (flat area)
  - Proper drainage slope
  - Structural mounting points

---

## Phase 3: Floor & Platform System

### P1-008: Floor Layers
- ⚪ **Create `src/components/interior/floor_system.scad`**
  - Harbor Freight trailer deck (base layer)
  - Insulation layer (1-2" thick)
  - Subfloor (0.75" plywood)
  - Vapor barrier representation

- ⚪ **Model wheel well accommodation**
  - Exact wheel well dimensions and positions
  - Clearance calculations
  - Impact on interior space

### P1-009: Raised Bed Platform
- ⚪ **Create `src/components/interior/bed_platform.scad`**
  - 4" high platform structure
  - Frame construction (2×4 lumber representation)
  - Platform top (0.75" plywood)
  - Clears wheel wells with 2-3" margin
  - Access panels for under-bed storage
  - Support for 60"×80" queen mattress

---

## Phase 4: Doors & Windows

### P1-010: Side Doors
- ⚪ **Create `src/components/doors_windows/side_doors.scad`**
  - Two doors: 30"×36" each
  - Door thickness: 1.5-2" insulated
  - Frame integration with shell
  - Proper swing clearance
  - Weather sealing grooves

### P1-011: Door Windows
- ⚪ **Create `src/components/doors_windows/door_windows.scad`**
  - Size: 12"×16" per door (2 total)
  - Tempered glass representation
  - Frame integration
  - Basic sliding or fixed operation

### P1-012: Stargazing Window
- ⚪ **Create `src/components/doors_windows/stargazing_window.scad`**
  - Size: 24"×30"
  - Location: Front curved section above bed heads
  - Tempered glass or acrylic
  - Weather-tight frame
  - Optional opening mechanism

### P1-013: MaxxFan Opening
- ⚪ **Create roof opening for MaxxFan**
  - 14"×14" cutout in roof
  - Proper flashing and sealing
  - Mounting surface preparation
  - Structural reinforcement

---

## Phase 5: Interior Storage & Layout

### P1-014: Headboard Storage
- ⚪ **Create `src/components/interior/headboard_storage.scad`**
  - 12" depth from wall
  - Three sections across 60" width:
    - Left: 18" wide personal storage + reading light + USB ports
    - Center: 24" wide EcoFlow compartment
    - Right: 18" wide personal storage + reading light + USB ports
  - Access doors/panels
  - Internal organization

### P1-015: Foot Cabinets
- ⚪ **Create `src/components/interior/foot_cabinets.scad`**
  - Location: Above foot of bed in 12" space
  - Configuration:
    - Left cabinet: 18" wide with hinged door
    - Center shelf: 24" wide open access
    - Right cabinet: 18" wide with hinged door
  - USB ports on front faces of cabinets
  - Full depth utilization (no foot clearance needed)

### P1-016: Under-Bed Storage
- ⚪ **Create under-bed storage access system**
  - Hinged bed platform sections (30"×40" typical)
  - Access around wheel wells
  - Organization bins/dividers
  - 4" height available minus framing

### P1-017: Interior Panels
- ⚪ **Create `src/components/interior/interior_panels.scad`**
  - Wall panels: 1/4" FRP (easy clean)
  - Ceiling panels: 1/4" luan plywood (wood-look)
  - Trim strips for finished edges
  - Integration with storage components

---

## Phase 6: Chassis & Running Gear

### P2-018: Wheels & Axle
- ⚪ **Create `src/components/chassis/wheels.scad`**
  - Standard trailer wheels (typical size for weight)
  - Tire representation
  - Hub and bearing assembly
  - Brake components (electric brakes)

- ⚪ **Create `src/components/chassis/axle.scad`**
  - Single axle configuration
  - Suspension system (leaf springs)
  - Mounting to trailer frame
  - Proper load distribution

### P2-019: Tongue & Hitch
- ⚪ **Create `src/components/chassis/tongue.scad`**
  - A-frame tongue design
  - Coupler and safety chains
  - Breakaway system
  - Jack wheel
  - Tongue box mounting

### P2-020: Frame Assembly
- ⚪ **Create complete chassis assembly**
  - Integration of all chassis components
  - Body mounting points
  - Proper weight distribution
  - Tongue weight calculations (10-15% of total)

---

## Phase 7: Electrical System

### P2-021: Power Distribution
- ⚪ **Create `src/components/electrical/power_system.scad`**
  - EcoFlow River III model (11.4"×7.3"×8.3")
  - Mounting in headboard center compartment
  - Ventilation clearances (1-2" all around)
  - Cable pass-through access

- ⚪ **Create fuse block and distribution**
  - 6-circuit 12V fuse block
  - Wire routing and management
  - Circuit protection for all loads

### P2-022: Interior Lighting
- ⚪ **Create `src/components/electrical/interior_lights.scad`**
  - Reading lights: 3W LED spots (2 units)
  - Positions: Left and right headboard at 42" height
  - Wall switches: 40" height in headboard
  - Wire routing from EcoFlow

### P2-023: USB Charging System
- ⚪ **Create `src/components/electrical/usb_outlets.scad`**
  - Headboard outlets: 2-3 ports each side at 38" height
  - Foot cabinet outlets: 2 ports each cabinet at 46" height
  - Flush-mount installation
  - 12V to 5V conversion modules

### P2-024: Exterior Electrical
- ⚪ **Create `src/components/electrical/exterior_system.scad`**
  - Entry lights: 5W LED near each door with integral switches
  - Tongue light: 5W LED at front with integral switch
  - Power panel: Shore power + solar inputs on passenger side
  - Weather-proof connections and enclosures

---

## Phase 8: Hardware & Mechanical Components

### P2-025: Door Hardware
- ⚪ **Create `src/components/hardware/door_hardware.scad`**
  - Hinges: 3" stainless steel marine grade (3 per door)
  - Latches: RV-style compression latches
  - Handles: Exterior and interior pulls
  - Weather stripping integration

### P2-026: Storage Hardware
- ⚪ **Create cabinet and storage hardware**
  - Headboard storage: Hinged doors with magnetic catches
  - Foot cabinets: Hinged doors with compression latches
  - Bed platform: Heavy-duty hinges for access panels
  - Under-bed organization: Slides and dividers

### P2-027: MaxxFan Installation
- ⚪ **Create `src/components/hardware/maxxfan.scad`**
  - MaxxFan unit model (14"×14" standard)
  - Mounting flange and hardware
  - Electrical connection (12V, 3A max)
  - Variable speed control integration

---

## Phase 9: Assembly & Integration

### P1-028: Shell Assembly
- ⚪ **Create `src/assemblies/shell_assembly.scad`**
  - Exterior shell + interior shell + roof
  - All doors and windows installed
  - Proper material assignments
  - Cutaway views for interior visibility

### P1-029: Chassis Assembly
- ⚪ **Create `src/assemblies/chassis_assembly.scad`**
  - Complete running gear
  - Trailer frame + axle + wheels + tongue
  - All mounting points and hardware
  - Tongue box and accessories

### P1-030: Interior Assembly
- ⚪ **Create `src/assemblies/interior_assembly.scad`**
  - Floor system + bed platform + storage
  - All interior panels and ceiling
  - Electrical system integration
  - Hardware and accessories

### P1-031: Complete Camper Assembly
- ⚪ **Create `src/assemblies/complete_camper.scad`**
  - Integration of all sub-assemblies
  - Proper spacing and clearances
  - Material and color assignments
  - Multiple view modes (complete, exploded, cutaway)

---

## Phase 10: Testing & Validation

### P2-032: Dimension Validation
- ⚪ **Create validation script**
  - Check all critical dimensions against specifications
  - Verify clearances and fits
  - Test for manufacturing feasibility
  - Generate dimension report

### P2-033: STL Export Testing
- ⚪ **Test STL export for all components**
  - Individual component export
  - Assembly export capability
  - Check for manifold errors
  - Validate for 3D printing (scale models)

### P2-034: Rendering & Visualization
- ⚪ **Create rendering presets**
  - Complete camper views
  - Exploded assembly views
  - Cross-section views
  - Interior layout views
  - Material and lighting setup

### P2-035: Documentation Generation
- ⚪ **Create automated documentation**
  - Component list generation
  - Dimension tables
  - Assembly instructions
  - Material specifications

---

## Phase 11: Advanced Features & Polish

### P3-036: Parametric Controls
- ⚪ **Add customization parameters**
  - Overall length scaling
  - Width adjustments
  - Storage configuration options
  - Door and window variations

### P3-037: Alternative Configurations
- ⚪ **Create design variants**
  - Different trailer base options
  - Alternative door configurations
  - Storage layout variations
  - Electrical system upgrades

### P3-038: Manufacturing Aids
- ⚪ **Generate construction templates**
  - 2D cutting patterns
  - Drilling templates
  - Assembly jigs
  - Hardware schedules

### P3-039: Cost Analysis
- ⚪ **Material quantity calculations**
  - Automatic material takeoffs
  - Cost estimation integration
  - Weight calculations
  - Center of gravity analysis

---

## Dependencies Matrix

### Critical Path
1. P0-001, P0-002 → P0-003, P0-004 → P1-005, P1-006 → P1-010, P1-011 → P1-028 → P1-031

### Parallel Development Tracks
- **Shell**: P0-003 → P1-005 → P1-006 → P1-007
- **Interior**: P0-004 → P1-008 → P1-009 → P1-014 → P1-015 → P1-029
- **Electrical**: P2-021 → P2-022 → P2-023 → P2-024
- **Hardware**: P2-025 → P2-026 → P2-027

### Integration Points
- P1-028 requires: P1-005, P1-006, P1-007, P1-010, P1-011, P1-012
- P1-029 requires: P0-004, P1-008, P1-009, P2-018, P2-019
- P1-030 requires: P1-014, P1-015, P1-016, P1-017, P2-021, P2-022
- P1-031 requires: P1-028, P1-029, P1-030

---

## Success Criteria

### Phase Completion Requirements
- **Phase 0**: All configuration files created and validated
- **Phase 1**: Basic geometry renders correctly with proper proportions
- **Phase 2**: Shell components fit together with proper clearances
- **Phase 3**: Floor system integrates with trailer and shell
- **Phase 4**: All openings properly sized and positioned
- **Phase 5**: Interior storage meets design requirements
- **Phase 6**: Chassis components integrate and support load
- **Phase 7**: Electrical system layout is realistic and functional
- **Phase 8**: All hardware properly sized and positioned
- **Phase 9**: Complete assembly renders without errors
- **Phase 10**: All tests pass and STL export works

### Quality Gates
- ✅ All dimensions within ±1" of specifications
- ✅ No overlapping geometry in assemblies
- ✅ All clearances maintained (minimum 0.25")
- ✅ STL export generates valid meshes
- ✅ Rendering performance acceptable (<30 seconds)
- ✅ Materials and colors correctly applied

---

## Notes
- Each task should be implemented with proper documentation
- Use existing utility libraries where applicable
- Follow OpenSCAD best practices for modularity
- Test frequently with `task build` to catch errors early
- Update this TODO as tasks are completed or modified