# CLAUDE.md

## Routine

After a **significant change** — one that makes something in this file wrong or incomplete (files added/renamed/reorganized, a new convention adopted, git/LFS setup changed) — say which section is affected and ask:

> Would you like to modify `CLAUDE.md` accordingly?

Do not ask on turns that change nothing here (questions, inspection, small edits that fit existing conventions). Keep this file lean — only what's needed to understand the repo.

## Repository nature

A **3D printing asset repository** built around a licensed third-party parametric OpenSCAD generator. No build system, no test runner, no dependency manifest — do not fabricate build/lint/test commands. Two kinds of work:

- **Parametric design** — editing the OpenSCAD generators in `Source Code/` and exporting STLs from them.
- **Asset curation** — organizing exported parts, slicer projects, and print profiles.

**Licensing: the contents of `Source Code/` are proprietary.** They come from the Paper View Patreon under a licence that forbids sharing, selling, or redistributing them — `.scad`, `.stl`, `.3mf`, and links alike (see `Source Code/README.md`). Never publish this code or its outputs outside the repo: no artifacts, gists, pastebins, issue attachments, or third-party services. Local files and terminal output are fine.

## Layout

- `Source Code/` — three hand-written OpenSCAD generators plus `README.md` (licence terms and links to the vendor's Google Docs instructions). Each `.scad` carries its own long instruction block in a header comment; read it before changing parameters.
  - `modular_kumiko_panels.scad` — the frame generator, and the file most work happens in. See **Frame generator** below.
  - `individual_insert_generator.scad` — one insert at a time, patterns `-1`–`40`, with clearance, press-fit and magnet options. See **Inserts** below.
  - `svg_insert_generator.scad` — turns a design exported from kumikodesigner.com into printable inserts. Its input SVG must be pre-processed by the vendor's Colab notebook first.
- `Print Profiles & STLs/` — five versioned variant folders (`V1 - Primary Panel`, `V1 - Secondary Panels`, `V2 - Primary Panel & Alternatives`, `V2 - Fjallbo Compatible`, `V2 - Gorilla Shelf Compatible`) plus a README.
- `Shivling/` — one built project: its exported `.stl`/`.3mf` parts and `Costing.xlsx`.
- Root — `Kumiko Frame Generator.docx`/`.pdf` (vendor documentation, 178 MB and 12 MB) and `Shivling.svg` (a kumikodesigner.com export).

## Frame generator

`modular_kumiko_panels.scad` builds a kumiko frame from six components — subpanels, seams, outer frame, border, border background, hanger — sized either by triangle count or by millimetres. `Assembly_Option` picks one of three modes:

- **Reference Mode** — fast, low-detail preview for dialling in dimensions. Not printable.
- **Printable Mode** — the print workflow. Components are spread apart on the Z axis so you enable one `Frame Components` checkbox at a time and export six separate STLs. This is the only path for a frame larger than `Print_Bed_Size`, since nothing else splits geometry to fit the bed.
- **Combined Mode** — every component seated in its finished position, exported as one assembled STL. Ignores the `Frame Components` checkboxes; driven by the `[Combined Frame]` parameters instead. Does not split anything, so the frame has to fit the bed to be printable.

The components already model themselves in assembled coordinates — Printable Mode is what pulls them apart. That is why Combined Mode is mostly a matter of dropping those offsets.

## Inserts

`individual_insert_generator.scad` fills the triangular cells of a frame built by `modular_kumiko_panels.scad`. Two things about that relationship are not visible from either file:

- **The cell is identical in all three `Assembly_Option` modes.** Combined Mode only relocates components, and every `Fuse_Components` offset lands on a joint *between* components — never on the triangle opening. Inserts therefore never need redesigning for a mode. Verified by seating real inserts in a real Combined Mode frame and measuring the intersection: 0 mm³, surface contact only.
- **Its `[Frame Dimensions]` are a hand-kept copy** of `Grid_Thickness`, `Grid_Pitch` and `Frame_Depth` from the frame generator. Nothing enforces the match. Change the frame and re-sync them, and rescale `Insert_Thickness` with the pitch — at an 11 mm pitch the 4 mm stroke left over from a 40 mm pitch fills 92% of the cell and erases the pattern.

Fit against the cell wall is decided in one place, `insert_triangle(fit=...)`. Normal patterns take `-Insert_Clearance`, which pulls them off the wall so they drop into a rigid one-piece frame; patterns 39/40 pass `Press_Fit` to bite into it instead. Patterns were originally cut to the exact size of the opening, which only seats after sanding.

Inserts rest on a 0.4 mm support ring at the back of each cell, so `insert_depth = Frame_Depth - 0.4` and they finish flush with the front face. The top and bottom rows of a frame are half cells and take `Split_In_Half` inserts. Pattern 0 (background) emits nothing: `background_thickness` and `background_edge_thickness` were deliberately zeroed in `5617d32`, giving an open frame with no backing sheet.

## OpenSCAD workflow

Requires OpenSCAD with the **BOSL2** library. On this machine: `C:\Program Files\OpenSCAD (Nightly)\openscad.exe` (2026.06.21, Manifold backend) and `~/Documents/OpenSCAD/libraries/BOSL2`.

Render headlessly rather than asking for a GUI round-trip. Override parameters with `-D` and use small frames to keep renders quick:

```bash
"/c/Program Files/OpenSCAD (Nightly)/openscad.exe" --export-format binstl -o out.stl \
  -D 'Assembly_Option="Combined Mode"' -D 'Triangle_Generator=[7,5]' -D 'Grid_Pitch=20' \
  "Source Code/modular_kumiko_panels.scad"
```

- Prefer `--export-format binstl`. The default STL export is ASCII, which truncates coordinates to ~6 significant figures — enough to hide sub-0.001 mm geometry problems.
- `-D` values containing spaces (`"Combined Mode"`) lose their quoting if passed through an unquoted shell variable. Write the flags out literally in loops.
- **Regression check:** neither generator has tests, but STL output is deterministic. To prove a change is additive, render the same configurations from `git show HEAD:<path>` and from the working tree and compare bytes with `cmp`. For the frame, sweep the modes, `All_Component_View`, hanger types, and each component; for inserts, sweep every pattern against both `Split_In_Half` values.
- **Checking insert fit:** `use <...>` imports modules without running a file's top-level geometry, so a scratch file can `use` both generators and intersect a frame against inserts placed with the frame's own cell math — a non-empty intersection with real volume is interference, while zero volume is just seating contact. Two traps: `-D` cannot override a `use`d file's globals (copy the file to the scratchpad and edit it instead), and BOSL2's `$`-specials are dynamically scoped, so the scratch file needs its own `include <BOSL2/std.scad>` or `stroke()` will assert. Always render the inserts alone first — `split_insert()` branches on the global `Insert_Pattern` rather than its argument, which can silently yield nothing and a falsely clean result.

## Git

Remote `github.com/shivamchudasama/KumikoFrame_3DPrinting`, default branch `main`. No `.gitignore`.

- `.gitattributes` routes `*.stl`, `*.3mf`, `*.pdf`, `*.docx` to **Git LFS**. A new binary extension needs an entry **before** its first commit, or it lands in history as a full blob.
- `*.png` is a **deliberate exception** — small doc images are cheaper as ordinary blobs than as LFS storage and bandwidth, which are the scarce resource (free tier: 1 GB storage, 1 GB/month).
- **The LFS rules arrived late.** Only the `.docx` is actually in LFS; ~298 MB of `.stl`, `.3mf`, and `.pdf` were committed as plain blobs before the rules existed and are permanently in history — `.git` is ~485 MB as a result. The rules only protect files added from now on. Fixing the past means rewriting history (`git lfs migrate import --everything`), which invalidates every existing clone, so do it only on explicit instruction.
- Because those extensions are now filtered, re-adding an *existing* tracked binary converts it to an LFS pointer in that commit. That is the desired direction, but it makes the diff look like a delete-and-replace — expected, not a mistake.
