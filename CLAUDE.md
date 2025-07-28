# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build Commands

This project uses Task for build automation. Key commands:

- `task build` - Build STL from main.scad to dist/output.stl
- `task check` - Check OpenSCAD syntax without generating output
- `task preview` - Open main.scad in OpenSCAD GUI
- `task render` - High-quality STL render to dist/output.stl (slower than build)
- `task png` - Export PNG preview image to dist/preview.png
- `task clean` - Remove dist/ directory

Direct OpenSCAD CLI usage:
- `openscad -o dist/output.stl main.scad` - Quick STL build
- `openscad --check-syntax main.scad` - Syntax validation

## Project Structure

This is a basic OpenSCAD project for 3D modeling:

- `main.scad` - Primary entry point, contains the main model
- `src/components/` - Modular components for complex designs
- `src/utils/common.scad` - Shared utility functions and modules
- `Taskfile.yml` - Build automation tasks

## GitHub Project Management

This project uses GitHub Projects for task tracking. The "Maple Canyon" project board tracks all development tasks:

### Project Information
- **Project ID**: `PVT_kwHOACcjjs4A_D0e`
- **URL**: https://github.com/users/kevindurb/projects/5
- **Issues**: 35 tasks covering complete teardrop camper development

### Status Management
Available status columns:
- **Backlog** - Tasks not yet started
- **Ready** - Tasks ready to begin  
- **In progress** - Currently working on
- **In review** - Awaiting review/testing
- **Done** - Completed tasks

### Priority Levels
- **P0** - Critical path, blocking other tasks
- **P1** - High priority, core functionality
- **P2** - Medium priority, important features

### CLI Commands for Project Management

List all project items:
```bash
gh project item-list 5 --owner kevindurb
```

Move an issue to "In progress":
```bash
gh project item-edit --project-id PVT_kwHOACcjjs4A_D0e --id <ITEM_ID> --field-id PVTSSF_lAHOACcjjs4A_D0ezgyRpXs --single-select-option-id 47fc9ee4
```

Set priority to P0:
```bash
gh project item-edit --project-id PVT_kwHOACcjjs4A_D0e --id <ITEM_ID> --field-id PVTSSF_lAHOACcjjs4A_D0ezgyRpa4 --single-select-option-id 79628723
```

### Field IDs Reference
- **Status Field**: `PVTSSF_lAHOACcjjs4A_D0ezgyRpXs`
  - Backlog: `f75ad846`
  - Ready: `61e4505c`
  - In progress: `47fc9ee4`
  - In review: `df73e18b`
  - Done: `98236657`

- **Priority Field**: `PVTSSF_lAHOACcjjs4A_D0ezgyRpa4`
  - P0: `79628723`
  - P1: `0a877460`
  - P2: `da944a9c`

### Task Development Workflow
1. Move task from "Backlog" to "In progress" when starting
2. Set appropriate priority level (P0-P2)
3. Complete implementation following task acceptance criteria
4. Move to "In review" for testing/validation
5. Move to "Done" when fully complete

### Required GitHub CLI Scopes
Ensure your GitHub CLI has the necessary scopes:
```bash
gh auth refresh -s read:project,project
```

## OpenSCAD Development Notes

- Global parameters like `$fn` are set in main.scad
- Use `src/utils/common.scad` for reusable functions/modules
- Break complex models into components under `src/components/`
- Always test syntax with `task check` before building STL files