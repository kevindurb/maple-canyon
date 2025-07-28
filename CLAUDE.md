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

## OpenSCAD Development Notes

- Global parameters like `$fn` are set in main.scad
- Use `src/utils/common.scad` for reusable functions/modules
- Break complex models into components under `src/components/`
- Always test syntax with `task check` before building STL files