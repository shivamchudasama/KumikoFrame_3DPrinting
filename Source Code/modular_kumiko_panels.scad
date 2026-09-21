/*
 * Copyright (c) 2025 Paper View. All Rights Reserved.
 *
 * This software is the confidential and proprietary information of Paper View
 * ("Confidential Information"). You shall not disclose such Confidential Information and
 * shall use it only in accordance with the terms of the license agreement you entered into with
 * Paper View.
 *
 * PROPRIETARY AND CONFIDENTIAL
 *
 * This file is subject to the terms and conditions of a license agreement you entered into with
 * Paper View. Unauthorized copying of this file, via any medium, is strictly prohibited.
 *
 * This software is provided "AS IS," without warranty of any kind, express or implied.
 * Paper View shall not be liable for any damages, including but not limited to,
 * direct, indirect, incidental, special, consequential, or exemplary damages,
 * even if advised of the possibility of such damages.
 */
include <BOSL2/std.scad>
include <BOSL2/rounding.scad>
include <BOSL2/joiners.scad>

main();

/* 

The following instructions are also available here (with images): https://docs.google.com/document/d/19o8Xd_KaTCOf8iYQQnmPdljipetqtiDV3wMY0SX3PGU/edit?tab=t.mi9ac7t4byea

----------
BACKGROUND
----------

    This file file lets you fully customize your panel. It will let you create panels that fit exact dimensions,
adjust the pitch size, change the frame depth, change the border thickness, and lets you generate all the components without having 
to go through the customizer on MakerWorld.

------------
REQUIREMENTS
------------

1. Download and install OpenScad. See OpenScad Quickstart (https://docs.google.com/document/d/19o8Xd_KaTCOf8iYQQnmPdljipetqtiDV3wMY0SX3PGU/edit?tab=t.qyu5vvx78vx1)

-----
STEPS
-----

STEP 0: Complete the following before starting:

    0.1) Determine the size of the panel you'd like to generate. You can either do this in the generator or if you have a specific
        height and width you want to hit, determine the mm's needed.

STEP 1: Understand what all the parameters do

        Before you change any parameters for the frame it's important to understand what each of the parameters do. Below I've
    outlined all the available parameters.

GENERAL OPTIONS

FRAME COMPONENTS

FRAME DIMENSIONS

STEP 2: Run the frame in "Reference Mode" (Only used for visualizing - NOT printing)

        This step is meant to help you quickly adjust parameters in the frame to quickly prototype and visualize what the frame will look like
    and how the components come together. Do NOT print components in this step. This step is only meant to aide you until you finalize your
    parameters.

    2.1) Change "Assembly_Option" to "Reference Mode". 
        Optionally: also change "All_Component_View" to false. This is the fastest generation method as it minimizes duplicate components.
    2.2) Adjust the "Frame Dimensions" parameters until you're satisfied with the frame output.
    2.3) Change "Hide_Text" to false and verify that the frame dimensions match your requirements.
    2.4) Save a screenshot of the text box so you can reference your frame parameters in future steps.

STEP 3: Run the frame in "Printable Mode", Render, and Export components

        Once you've determined the frame parameters you're happy with, we can generate the printable version of the frame.
    Below is my preferred method of preparing print profiles.

        This involves exporting ALL objects for EACH component separately. This means that subpanels, seams, borders, etc 
    will each get their own print profile. Doing this lets you arrange the objects faster in your print profile, and avoids having to 
    do any calculations to determine the # of each component you need to print.

    Key parameters to set:
        - Assembly_Option = "Printable Mode";
        - All_Component_View = true;
        - Render and Export each Frame Component separately

    3.1) Set the parameters to match the following
        - Assembly_Option = "Printable Mode";
        - All_Component_View = true;
        - Set only 1 "Frame Components" parameter to true and leave the rest as false. Repeat
            the below steps for each component available so you have 6 separate stl files, one
            for each component.
    3.2) Render the object
    3.3) Export as stl (binary)
        
STEP 4: Prepare the print profiles

    Finally we can prepare the print profiles for printing.

    4.1) Open stl in slicer
    4.2) Flip over seams and border components
    4.3) Split component to objects
    4.4) For Border_Background components select “Auto Orient”. This will reorient all the components EXCEPT for two
        components. It’s extremely important that you reorient these two remaining components to match the others or 
        else they will break and your frame will fall.
    4.5) Click “Auto Arrange”. Note if you have a large number of components (mainly subpanels), you may run 
        out of plates (Ex. Bambu Studio limits you to 36 plates), leaving leftover components in the corner. If this 
        happens, you’ll have to swap out components after you’ve printed them until you’ve printed the leftovers.
    4.6) Set the print parameters for the corresponding component. See below for details:

+-------------------+-------+-----------------------+-----------------------+----------------+------------------+---------------------+-----------------------------------------------+
| Component         | Walls | Sparse Infill Density | Sparse Infill Pattern | Wall Generator | Top shell Layers | Bottom Shell Layers |                      Other                    |
+-------------------+-------+-----------------------+-----------------------+----------------+------------------+---------------------+-----------------------------------------------+
| Subpanels         |   1   |          30%          |       Lightning       |    Arachne *   |       >= 5       |         >= 3        |    All other settings are defaults of the     |
+-------------------+       |                       |   (to save material)  |                |                  |                     |            “0.20mm Standard” Profile          |
| Seams             |       |                       |                       |                |                  |                     |            For a 0.4 diameter nozzle          |
+-------------------+       +-----------------------+-----------------------+                |                  |                     |                                               |
| Outer_Frame       |       |          10%          |         Gyroid        |                |                  |                     |                                               |
+-------------------+       |                       |     (for strength)    |                |                  |                     |                                               |
| Border            |       |                       |                       |                |                  |                     |                                               |
+-------------------+-------+-----------------------+                       |                |                  |                     |                                               |
| Border_Background |  >= 5 |          15%          |                       |                |                  |                     |                                               |
+-------------------+       |                       |                       |                |                  |                     |                                               |
| Hanger            |       |                       |                       |                |                  |                     |                                               |
+-------------------+-------+-----------------------+-----------------------+----------------+------------------+---------------------+-----------------------------------------------+

    4.7) Print all the plates.
    4.8) Repeat for the remaining components.

ALTERNATIVE TO STEPS 3 & 4: Run the frame in "Combined Mode" (one assembled stl)

        Steps 3 and 4 produce one stl per component, which is what you want for any frame too big to
    fit the print bed in one piece. If instead you want the whole frame as a single assembled model -
    to print a small frame in one go, or just to have one file of the finished thing - use Combined Mode.

        Combined Mode renders every component seated where it belongs in the finished frame rather
    than spread out for exporting. The "Frame Components" checkboxes are ignored: the subpanels,
    seams, outer frame, border and border background are always all included. Use the "Combined Frame"
    parameters to control the rest.

    A.1) Set Assembly_Option = "Combined Mode".
    A.2) Set the "Combined Frame" parameters:
        - Fuse_Components: leave true to get one solid. It converts the fit clearances between
            components into a slight interference so they overlap and boolean together. Set it to
            false if you would rather inspect the assembly with its real print tolerances.
        - Include_Hanger: adds the cleats on the back of the frame. Only the Wall Hanger
            (Hanger_Type 1) is built in - see the note below.
        - Include_Wall_Mount: also draws the wall-side cleat and drilling template in the hung
            position. These fasten to the wall, not the frame, so leave this off unless you are
            visualising how the frame hangs.
    A.3) Render (F6) and export as stl (binary).

    Notes:
        - Check the frame fits your bed before printing. Combined Mode does not split anything, so
            a frame larger than Print_Bed_Size simply will not fit - use steps 3 and 4 for those.
        - Only the Wall Hanger is built into the combined frame. The keyhole shelving hanger and the
            Ikea Fjallbo ledge hangers are clip-on assemblies with their own hand-fitted joints, so
            print those separately from "Printable Mode" with Hanger = true.
        - The reference text card is never included, so Hide_Text has no effect here. The frame
            dimensions are still printed to the console.
        - The assembled model contains small sealed cavities where the fit clearances used to be
            open (inside the seam grooves and above the dovetails). They are normal - slicers just
            leave them hollow.

STEP 5: Design your panel in kumikodesigner.com

        Before or while you start printing your frame components, start designing your panel on kumikodesigner.com
    It's important you follow these steps correctly or you risk having to redo your design with the correct
    settings. It's not a huge deal if you make a mistake, but you will lose some time correcting the mistakes.

    Note: Please consider donating to Douwe, the creator of the Kumiko Designer tool below. I truly couldn’t have 
    created this project without the help of their tool. Click the “Donate” button on their website.

    5.1) Head over to kumikodesigner.com. Click "Start designing", and select "Framed panel"
    5.2) Refer to the screenshot of the text box made in Step 2.4, and refer to Width triangles.
        - If N triangles width is even: select the top rectangle
        - If N triangles width is odd: select the bottom rectangle
    5.3) Referring to the text box, input the correct "Size A" (equivalent to height) and "Size B" (equivalent to width), 
        Frame width (equivalent to Border Thickness), Pitch, and Mitsuke (equivalent to Grid Thickness) into kumiko designer.
    5.4) Validate the frame.
        5.4.1: Validate that the correct frame was selected in step 5.2. To do this, compare the top left corner of both frames and make
            sure they are identical. See Google Doc instructions (link at the top) for image examples.
        5.4.2: Validate the correct parameters were inputted in step 5.3. To do this press "p" on your keyboard for the frame parameters
            you inputted. Compare what's on the screen to the parameters in your text box screenshot. Ignore Frame_Depth and compare everything else.
        5.4.3: If either 5.4.1 or 5.4.2 does not match, redo step 5 and re-verify.
    5.5) Design your frame. Using the tool you can customize the inserts and colors. Consider making an account to save your designs.
    5.6) Export the design SVG and head over to svg_insert_generator.scad to generate the inserts for your panel.

STEP 6: Follow SVG Insert Generator Instructions

    Once you’re done designing and have exported your design from kumikodesigner.com head over to the SVG Insert Generator instructions and using the
svg_insert_generator.scad file, quickly generate all the inserts needed for your panel. Once done, head back here to follow the assembly instructions.

SVG Generator Instructions available here: https://docs.google.com/document/d/19o8Xd_KaTCOf8iYQQnmPdljipetqtiDV3wMY0SX3PGU/edit?tab=t.w1258cfzzugh

STEP 7: Assembly

Once all the components are printed, you can follow the assembly instructions here: https://docs.google.com/document/d/19o8Xd_KaTCOf8iYQQnmPdljipetqtiDV3wMY0SX3PGU/edit?tab=t.0#heading=h.9xfsxyrjrsyy
*/

/* [General Options] */

// Whether reference mode, printing mode, or combined mode is selected.
Assembly_Option = "Combined Mode"; // [Reference Mode:Reference Mode (Do not print - use only as a reference), Printable Mode:Printable Mode, Combined Mode:Combined Mode (all components assembled into one model)]
// Assembly_Option = "Printable Mode"; // Earlier option
Hide_Colors = true;
// Select whether to plot all the components (slow to load) or a reduced number of components (faster)
All_Component_View = true;
Hide_Text = true;
// This limits the size of components to fit the print bed
Print_Bed_Size = 320; // [180:Small (180x180), 250:Medium (250x250), 320:Large (320x320)]

/* [Frame Components] */

// Only used in "Reference Mode" and "Printable Mode". "Combined Mode" always builds the whole frame, so these are ignored - use the "Combined Frame" parameters instead.
Subpanels = false;
Seams = false;
Outer_Frame = false;
Border = false;
Border_Background = true;
Hanger = true;

/* [Frame Dimensions] */

// Select which generator to use for generating the frame.
Generator = "Triangles"; // [Triangles:Use triangles to generate frame., Dimensions:Use height & width dimensions to generate frame.]

// Uses triangles as dimensions (width, height)
Triangle_Generator = [33, 28];

// Uses mm as dimensions (width, height). IMPORTANT: panel will be rounded down to fit these dimensions. Refer to Width and Height values under "PARAMETERS" on reference card for correct panel dimensions.
Millimeter_Generator = [500, 700];

// Adjusts the border thickness to obtain an exact thickness dimension. If true, the Border_Thickness variable is ignored. Otherwise, round the frame down to fit within the frame constraints.
Make_Exact_Dimensions = false;

// Distance between triangles in frame.
Grid_Pitch = 11;
// Grid_Pitch = 40; // Earlier dimension

// Depth of frame
Frame_Depth = 5;
// Frame_Depth = 10; // Earlier dimension

// Thickness of frame
Grid_Thickness = 1;
// Grid_Thickness = 3; // Earlier dimension

// Thickness of border around frame. Must be larger than Grid_Thickness*2, otherwise border thickness will default to Grid_Thickness*2. 
Border_Thickness = 0;

// Background Depth
Background_Depth = 0;
// Background_Depth = 10; // Earlier dimension

// Hanger Type
Hanger_Type = "1"; // ["1":Wall Hanger, "2":Keyhole Shelving Hanger, "3":Ikea Fjallbo Ledge Hanger]

// Number of hanger sets. Two sets adds hanger slots and cleats at the bottom of the frame as well (Wall Hanger only).
Hanger_Sets = 2; // [1:One Set (Top), 2:Two Sets (Top and Bottom)]

/* [Combined Frame] */
// All parameters below only apply when Assembly_Option is "Combined Mode".

// Turns the fit clearances between components into a slight interference so they overlap and weld together. Without it the components only meet face to face, which is fragile. Turn off to inspect the assembly with its real print tolerances.
Fuse_Components = true;

// Include the hanger cleats on the back of the frame. Only the Wall Hanger is built in; the keyhole and Ikea ledge hangers clip on by hand, so print those from "Printable Mode".
Include_Hanger = false;

// Also include the wall-side cleat and its drilling template, drawn in the hung position (Wall Hanger only). They fasten to the wall rather than the frame, so with Fuse_Components on they weld to the frame cleats - useful for visualising, not for printing.
Include_Wall_Mount = false;


/* [Hidden] */

$fn = $preview ? 0 : 100;
$fa = 1;
$fs = 0.5;

// This limits the size of pieces that are produced
Bed_Width = Print_Bed_Size;
Bed_Height = Print_Bed_Size;

// -------------------------------------
// ------------ MODE FLAGS -------------
// -------------------------------------
is_reference_mode = Assembly_Option == "Reference Mode";
is_combined_mode = Assembly_Option == "Combined Mode";

// Combined Mode reuses the printable geometry -- it only changes where the components are placed.
printable_geometry = !is_reference_mode;

// Combined Mode needs every component, not just the unique ones the print workflow gets away with.
show_all_components = All_Component_View || is_combined_mode;

// When fusing, the clearances that let the printed pieces slide together are inverted into a small
// interference instead, so neighbouring components overlap and boolean into a single closed solid.
fuse_components = is_combined_mode && Fuse_Components;
fuse_interference = 0.02;

// -------------------------------------
// -------- CALCULATED FIELDS ----------
// -------------------------------------
// Background and insert depth
background_thickness = 0.2;
background_edge_thickness = 0.4;
background_frame_support_depth = 0.4;
support_edge_width = 0.8;

background_offset = background_thickness + background_frame_support_depth + background_edge_thickness;
insert_depth = Frame_Depth - background_offset;

// CALCULATED FIELDS: INSERT DIMENSIONS
triangle_height = tan(60) * Grid_Pitch / 2;

// BORDER VARIABLES
minimum_border_thickness = Grid_Thickness*2;

// Below is only used if "Make_Exact_Dimensions" == true
exact_border_thickness_dimension_width_ = function(n=0) (Millimeter_Generator[0] - ((floor(Millimeter_Generator[0] / triangle_height)+n)*triangle_height + Grid_Thickness)) / 2;
exact_border_thickness_dimension_width = exact_border_thickness_dimension_width_() >= minimum_border_thickness ? exact_border_thickness_dimension_width_(0) : exact_border_thickness_dimension_width_(-1);
exact_border_thickness_dimension_height_ = function(n=0) (Millimeter_Generator[1] - ((floor(Millimeter_Generator[1] / Grid_Pitch)+n)*Grid_Pitch + Grid_Thickness*2)) / 2;
exact_border_thickness_dimension_height = exact_border_thickness_dimension_height_() >= minimum_border_thickness ? exact_border_thickness_dimension_height_(0) : exact_border_thickness_dimension_height_(-1);

selected_border_thickness_width = Make_Exact_Dimensions && Generator == "Dimensions" ? exact_border_thickness_dimension_width : max(minimum_border_thickness, Border_Thickness);
selected_border_thickness_height = Make_Exact_Dimensions && Generator == "Dimensions" ? exact_border_thickness_dimension_height : max(minimum_border_thickness, Border_Thickness);

// CALCULATED FIELDS: PANEL DIMENSIONS
n_triangles_width = (Generator == "Triangles") ? Triangle_Generator[0] : floor((Millimeter_Generator[0] - (selected_border_thickness_width*2)) / triangle_height);
n_triangles_height = (Generator == "Triangles") ? Triangle_Generator[1] : floor((Millimeter_Generator[1] - selected_border_thickness_height*2) / Grid_Pitch);
is_odd = n_triangles_width % 2;

// CALCULATED FIELDS: FRAME DIMENSIONS
triangle_frame_width = n_triangles_width * triangle_height + Grid_Thickness;
triangle_frame_height = n_triangles_height * Grid_Pitch + Grid_Thickness*2;

frame_width = (Generator == "Triangles") ? triangle_frame_width : triangle_frame_width;
frame_height = (Generator == "Triangles") ? triangle_frame_height : triangle_frame_height;

true_frame_width = triangle_frame_width + selected_border_thickness_width*2;
true_frame_height = triangle_frame_height + selected_border_thickness_height*2;

echo("width", true_frame_width, "height", true_frame_height, "border:", selected_border_thickness_width, selected_border_thickness_height);
echo("width t", n_triangles_width, "height t", n_triangles_height);

w_leftover = frame_width - triangle_frame_width;
h_leftover = frame_height - triangle_frame_height;

// REFERENCE POSITIONS and PATHS
inner_triangle_offset = opp_ang_to_adj(opp=Grid_Thickness/2, ang=30);
tl = [Grid_Thickness/2, -inner_triangle_offset]; // TOP LEFT
bl = [Grid_Thickness/2, -Grid_Pitch+inner_triangle_offset]; // BOTTOM LEFT
mr = [triangle_height-Grid_Thickness, -Grid_Pitch/2]; // MIDDLE RIGHT

// TRIANGLE MIDPOINT
function midpoint(xy1, xy2) = [(xy1[0]+xy2[0])/2, (xy1[1]+xy2[1])/2];
l_midpoint = midpoint(bl, tl); // MIDDLE LEFT MIDPOINT


path_to_mid = [-triangle_height/3, Grid_Pitch/2];

// Max number of triangles that can fix the bed horizontally and vertically
max_subpanel_t_width = floor(floor((Bed_Width - triangle_height)/triangle_height)/2);
max_subpanel_t_height = floor((Bed_Height - Grid_Pitch/2)/Grid_Pitch);

// This calculates the bottom- and right-side remainders so we can create
// the associates bottom-left, top-right, and bottom-right panels to the correct sizes
n_subpanels_width = ceil((n_triangles_width-is_odd) / (max_subpanel_t_width*2));
n_subpanels_height = ceil((n_triangles_height) / max_subpanel_t_height);

// Main panel dimensions (used for translating object)
tb_subpanels_width_mm = (max_subpanel_t_width*2)*triangle_height;
tb_subpanels_height_mm = (max_subpanel_t_height)*Grid_Pitch;

// Calculate height and width panel leftovers
full_subpanels_width = floor((n_triangles_width-is_odd) / (max_subpanel_t_width*2));
full_subpanels_height = floor((n_triangles_height) / max_subpanel_t_height);
leftover_subpanel_t_width = (n_triangles_width - (max_subpanel_t_width*full_subpanels_width*2)) - is_odd;
leftover_subpanel_t_height = n_triangles_height - (max_subpanel_t_height*full_subpanels_height) - 0.5;

// SEAM VARIABLES
seam_thickness = 0.8;
// Has the option to select between the major version and minor version
// major version: used for subtracting from objects
// minor version: used for the final object that is printed
seam_major_extrude = Frame_Depth*(3/4);
seam_minor_extrude = Frame_Depth/2;
seam_major_thickness = Grid_Thickness * 3/16;
seam_minor_thickness = Grid_Thickness * 3/16 - 0.1;
seam_major_trim = Grid_Pitch/5;
seam_minor_trim = Grid_Pitch/2.5;
seam_major_offset = fuse_components ? -fuse_interference : 0.05; // Affects: offset between seam and outer frame
seam_minor_offset = 0;
seam_major_diamond_t = 0; // Major diamond should not be subtracted
seam_minor_diamond_t = fuse_components ? -fuse_interference : 0.05; // Minor diamond is slightly larger so the seams don't overlap

// DOVETAIL VARIABLES
// The *_os values below are fit clearances: positive shrinks a tenon or grows a pocket. Fusing
// flips their sign so the tenon is slightly proud of its pocket and the two components merge.
subpanel_dt_add_os = 0; // Top/bottom dovetails attached to subpanels
subpanel_dt_sub_os = fuse_components ? -fuse_interference : 0.05; // Top/bottom dovetails subtracted from outer frame (on inside of outer frame)

border_dt_add_os = fuse_components ? -fuse_interference : 0.07; // Outer dovetails attached to outer border
border_dt_add_depth = Frame_Depth*0.9-0.05; // Outer dovetail depth

border_dt_sub_os = fuse_components ? -fuse_interference : 0.01; // Dovetails subtracted from border pieces
border_dt_sub_depth = Frame_Depth-border_dt_add_depth-0.2; // How deep the cut should be that there's a little bit of play to keep the pieces flat to each other)

border_background_dt_add_os = fuse_components ? -fuse_interference : 0.08; // Dovetails attached to background border pieces
border_background_dt_add_depth = Frame_Depth*0.85; // This should be slightly less than border_dt_sub_depth so the border background dovetails don't hit the bottom of the border

hanger_dt_add_os = fuse_components ? -fuse_interference : 0.1; // Dovetails attached to the hanger cleats

// Gap left between the split pieces of a component so they render as separate objects. Fusing
// turns it into an overlap instead, which is harmless because every piece is cut from the same solid.
split_piece_os = fuse_components ? -fuse_interference : 0.0001;

// Gap between the inner edge of the border (and border background) and the outer edge of the frame.
border_inner_os = fuse_components ? -fuse_interference : 0.001;

n_vertical_dovetails = Print_Bed_Size == 180 ? 2 : 3;

// ALTERNATING COLORS FOR DIFFERENTIATING COMPONENTS
Default_Color = "#D3B7A7";

color_inner_frame = Hide_Colors ? [Default_Color, Default_Color] : ["#98df8a", "#e377c2"]; //
color_subpanels = Hide_Colors ? [Default_Color, Default_Color] : ["#ff7f0e", "#17becf"]; //
color_horizontal_seams = Hide_Colors ? [Default_Color, Default_Color] :["#e377c2", "#98df8a"];
color_vertical_seams = Hide_Colors ? Default_Color : "#9467bd";
color_border = Hide_Colors ? [Default_Color, Default_Color] : ["#3a58ffff", "#ffcc3eff"];
color_border_background = Hide_Colors ? [Default_Color, Default_Color] : ["#ff7f0e", "#17becf"];
color_border_background_vertical = Hide_Colors ? [Default_Color, Default_Color] : ["#e377c2", "#98df8a"];
color_border_background_horizontal = Hide_Colors ? [Default_Color, Default_Color] : ["#ff7f0e", "#17becf"];
color_wall_hanger = Hide_Colors ? Default_Color : "#93d356ff";
color_frame_hanger = Hide_Colors ? Default_Color : "#5673d3ff";
color_wall_template = "#969696ff";

module reference_text() {
    if (is_combined_mode) {
        translate([0, 0])
        text("COMBINED (ASSEMBLED) VERSION", halign="center", valign="center", font="Liberation Sans:style=Bold", size=5);
    } else if (Assembly_Option == "Printable Mode") {
        translate([0, 0])
        text("PRINTABLE VERSION", halign="center", valign="center", font="Liberation Sans:style=Bold", size=5);
    } else {
        translate([0, 0])
        text("REFERENCE ONLY - DO NOT PRINT", halign="center", valign="center", font="Liberation Sans:style=Bold", size=5);
    }

    translate([0, -9])
    text("Please read the instructions carefully and completely before starting.", halign="center", valign="center", font="Liberation Sans:style=Regular", size=3);
    translate([0, -16])
    text("Important: write down the parameters below for design planning.", halign="center", valign="center", font="Liberation Sans:style=Regular", size=3);
    translate([0, -23])
    text("Zoom out to see full model.", halign="center", valign="center", font="Liberation Sans:style=Bold", size=3);
    translate([0, -32])
    text("PARAMETERS", halign="center", valign="center", font="Liberation Sans:style=Bold", size=4);

    t_list = [
        str("Width ", true_frame_width, " mm (", n_triangles_width, " triangles)", " - ", n_subpanels_width, " columns"),
        str("Height ", true_frame_height, " mm (", n_triangles_height, " triangles)", " - ", n_subpanels_height, " rows"),
        str("Pitch ", Grid_Pitch, " mm"),
        str("Grid Thickness ", Grid_Thickness, " mm"),
        str("Border Thickness ", round(selected_border_thickness_width*100)/100, " mm (width) & ", round(selected_border_thickness_height*100)/100, " mm (height)"),
        str("Background triangles needed: Full: ", (n_triangles_width*n_triangles_height*2)-n_triangles_width, " Half: ", n_triangles_width*2)
    ];

    for (i = [0:1:len(t_list)-1]) {
        translate([0, -40 - 6*i])
        text(t_list[i], halign="center", valign="center", font="Liberation Sans:style=Regular", size=3);
    }
}

module create_text_card() {
    color("white")
    polygon([[-70, 8], [70, 8], [70, -76], [-70, -76]]);

};

module main() {
    if (is_combined_mode) {
        combined_frame();
    } else {
        exploded_components();
    }
};

// Renders whichever "Frame Components" are enabled, each pushed to its own depth so the
// components stay visually separated for previewing and for exporting one stl at a time.
module exploded_components() {
    if (!Hide_Text) {
        translate([0, 0, Frame_Depth*7])
        color("black")
        linear_extrude(1.2)
        reference_text();

        translate([0, 0, Frame_Depth*7])
        linear_extrude(1)
        create_text_card();
    };

    // SUBPANELS
    if (Subpanels) {
        translate([-frame_width/2+Grid_Thickness/2, frame_height/2-Grid_Thickness, -Background_Depth])
        pattern_subpanels();
    };

    // SEAMS
    if (Seams) {
        translate([-frame_width/2+Grid_Thickness/2, frame_height/2-Grid_Thickness, Frame_Depth*3])
        create_all_seams("minor");
    };

    // OUTER FRAME / INNER BORDER (interchangeable names)
    if (Outer_Frame) {
        translate([-frame_width/2+Grid_Thickness/2, frame_height/2-Grid_Thickness, -Frame_Depth*1.5])
        split_outer_frame();
    };

    // BORDER
    if (Border) {
        translate([-frame_width/2+Grid_Thickness/2, frame_height/2-Grid_Thickness, Frame_Depth*1.5])
        final_border();
    };

    // BORDER BACKGROUND
    if (Border_Background) {
        translate([-frame_width/2+Grid_Thickness/2, frame_height/2-Grid_Thickness, -Frame_Depth*3.5])
        final_border_background();
    };

    if (Hanger) {
        translate([-frame_width/2+Grid_Thickness/2, frame_height/2-Grid_Thickness, -Frame_Depth*6-Background_Depth])
        create_both_cleats();
    }
};

// ------------------------------
// COMBINED (ASSEMBLED) FRAME
// ------------------------------
// Renders every component at the position it occupies in the finished frame, so a single
// render produces one assembled model rather than one file per component.
//
// The components already model themselves in assembled coordinates -- the per-component
// workflow only pulls them apart with the depth offsets in exploded_components() (plus the
// stacking shift inside pattern_subpanels). Dropping those offsets is therefore all that is
// needed to seat the frame, seams, border and border background against each other. The one
// component that genuinely has to move is the hanger: its cleats extrude upwards from z = 0,
// but they belong in the border background behind the frame, which occupies z = -Background_Depth
// to 0.
module combined_frame() {
    // The Wall Hanger cleat is the only hanger that fastens to the frame as a single piece. The
    // keyhole shelving hanger is a clip-together assembly with its own hand-fitted dovetails, and
    // the Ikea ledge hangers merely rest against the frame, so neither has a seated position in a
    // combined model -- both are left out and printed from "Printable Mode" instead.
    include_cleats = Include_Hanger && Hanger_Type == "1";

    if (Include_Hanger && !include_cleats) {
        echo("NOTE: only the Wall Hanger (Hanger_Type 1) is built into the combined frame. Export the selected hanger on its own with Assembly_Option = \"Printable Mode\" and Hanger = true.");
    }

    union() {
        translate([-frame_width/2+Grid_Thickness/2, frame_height/2-Grid_Thickness]) {
            pattern_subpanels();
            create_all_seams("minor");
            split_outer_frame();
            final_border();
            final_border_background();
        }

        if (include_cleats) {
            translate([-frame_width/2+Grid_Thickness/2, frame_height/2-Grid_Thickness, -Background_Depth])
            create_both_cleats();
        }
    }
};


// ------------------------------
// CREATE FRAME
// ------------------------------
module split_outer_frame() {
    if (printable_geometry) {
        divide_inner_frame()
        union() {
            difference() {
                linear_extrude(Frame_Depth)
                create_outer_frame();
                create_outer_seams();
            }
            linear_extrude(border_dt_add_depth)
            pattern_exterior_dovetails(border_dt_add_os, "inner");
            pattern_background_support_around_frame();
        };
    } else {
        divide_inner_frame()
        create_outer_frame();
    };
};

module create_outer_frame() {
    intersection() {
        difference() {
            union() {
                place_inserts_around_border()
                dovetail_triangle(path_to_mid);
                inner_border();
            };
            union() {
                pattern_dovetails()
                translate(path_to_mid)
                create_upper_dovetail(dovetail_offset=-subpanel_dt_sub_os);
            };
        };
        // Delete any sections that fall outside frame
        translate([-frame_width/2+Grid_Thickness/2, frame_height/2-Grid_Thickness]*-1)
        create_mask();
    };
};

module pattern_background_support_around_frame() {
    linear_extrude(background_frame_support_depth)
    place_inserts_around_border("vertical")
    translate(path_to_mid)
    difference() {
        polygon([tl, bl, mr]);
        offset(delta=-support_edge_width) // Adjust this to change the width of the support section
        polygon([tl, bl, mr]);
    }; 

    linear_extrude(background_frame_support_depth)
    place_inserts_around_border("horizontal")
    translate(path_to_mid)
    difference() {
        polygon([l_midpoint, bl, mr]);
        offset(delta=-support_edge_width) // Adjust this to change the width of the support section
        polygon([l_midpoint, bl, mr]);
    }; 
};

module double_triangle() {
    translate([triangle_height - triangle_height/3, -Grid_Pitch/2])
    rotate(180)
    dovetail_triangle(path_to_mid);
    translate([triangle_height/3+triangle_height, -Grid_Pitch/2])
    dovetail_triangle(path_to_mid);
};

module get_subpabel_seams(seam_type, row, col) {
    pattern_vertical_seams(seam_type, seam_position=[row,col]);
    pattern_vertical_seams(seam_type, seam_position=[row,col+1]);
    pattern_horizontal_seams(seam_type, seam_position=[row,col], extend_seam=true);
    pattern_horizontal_seams(seam_type, seam_position=[row+1,col], extend_seam=true);
}

module pattern_subpanels() {
    tl = [0,0];
    tr = n_subpanels_width >= 2 ? [0, n_subpanels_width-1] : false;
    bl = n_subpanels_height >= 2 ? [n_subpanels_height-1, 0] : false;
    br = n_subpanels_width >= 2 && n_subpanels_height >= 2 ? [n_subpanels_height-1, n_subpanels_width-1] : false;
    ml = n_subpanels_height >= 3 ? [1, 0] : false;
    mr = n_subpanels_height >= 3 && n_subpanels_width >= 2 ? [1, n_subpanels_width-1] : false;

    for (row = [0:1:n_subpanels_height-1]) {
        for (col = [0:1:n_subpanels_width-1]) {
            q = [row, col];
            
            bottom_subtractor = row == n_subpanels_height-1 && leftover_subpanel_t_height <= 0 ? leftover_subpanel_t_height : 0;
            subpanel_height_t = row == n_subpanels_height-1 && leftover_subpanel_t_height >= 0? leftover_subpanel_t_height : max_subpanel_t_height + bottom_subtractor;
            subpanel_width_t = col == n_subpanels_width-1 && leftover_subpanel_t_width != 0 ? leftover_subpanel_t_width/2 : max_subpanel_t_width;
            if (q == tl || q == tr || q == bl || q == br || q == ml || q == mr || show_all_components) {
                horizontal_panel_shift = col == 0 ? -max_subpanel_t_width*triangle_height*2-triangle_height*2 : max_subpanel_t_width*triangle_height*2+triangle_height*2;
                depth_panel_shift = row == 0 || row == 1 ? (-1*(row-1))*Frame_Depth*1.5+Frame_Depth*1.5 : 0;
                // Combined Mode is the only view that wants the panels left where they belong;
                // the other two spread them out so each one can be seen and exported on its own.
                panel_shift = is_combined_mode ? [0,0,0]
                    : All_Component_View ? [0,0,(row+col)*Frame_Depth*1.25-(n_subpanels_height-1+n_subpanels_width-1)*Frame_Depth*1.25-Frame_Depth*8]
                    : [horizontal_panel_shift, 0, depth_panel_shift];
                selected_color = row%2 == 0 ? color_subpanels[0] : color_subpanels[1];

                if (printable_geometry) {
                    color(selected_color)
                    translate(panel_shift)
                    difference() {
                        translate([col*tb_subpanels_width_mm, -row*tb_subpanels_height_mm])
                        create_subpanel(row, col, subpanel_width_t, subpanel_height_t);
                        get_subpabel_seams("major", row, col);
                    }
                
                    // ADD TOP AND BOTTOM DOVETAILS TO PANELS
                    if (row == 0) {
                        color(selected_color)
                        translate(panel_shift)
                        translate([col*tb_subpanels_width_mm, 0])
                        linear_extrude(Frame_Depth-seam_thickness)
                        create_subpanel_dovetails(subpanel_width_t, add_to="top");
                    }
                    if (row == n_subpanels_height-1) {
                        color(selected_color)
                        translate(panel_shift)
                        translate([col*tb_subpanels_width_mm, 0])
                        linear_extrude(Frame_Depth-seam_thickness)
                        create_subpanel_dovetails(subpanel_width_t, add_to="bottom");
                    }
                } else {
                    translate(panel_shift)
                    translate([col*tb_subpanels_width_mm, -row*tb_subpanels_height_mm])
                    create_subpanel(row, col, subpanel_width_t, subpanel_height_t, selected_color);
                
                    // ADD TOP AND BOTTOM DOVETAILS TO PANELS
                    if (row == 0) {
                        color(selected_color)
                        translate(panel_shift)
                        translate([col*tb_subpanels_width_mm, 0])
                        linear_extrude(5)
                        create_subpanel_dovetails(subpanel_width_t, add_to="top");
                    }
                    if (row == n_subpanels_height-1) {
                        color(selected_color)
                        translate(panel_shift)
                        translate([col*tb_subpanels_width_mm, 0])
                        linear_extrude(5)
                        create_subpanel_dovetails(subpanel_width_t, add_to="bottom");
                    }
                }
            }
        }
    }
};

module create_subpanel(row, col, subpanel_width_t, subpanel_height_t, selected_color) {
    for (h = [0: 0.5: subpanel_height_t-0.5]) {
        for (w = [0: 1: subpanel_width_t-1]) {
            w_shift = h % 1 == 0 ? 0 : triangle_height;

            q = is_odd == 0 && h%1 != 0 && w == subpanel_width_t-1 && col == n_subpanels_width-1;
            if (!q) {

                if (printable_geometry) {
                    color(selected_color)
                    translate([w*triangle_height*2+w_shift, h*-Grid_Pitch])
                    linear_extrude(Frame_Depth)
                    double_triangle();

                    color(selected_color)
                    translate([w*triangle_height*2+w_shift, h*-Grid_Pitch])
                    linear_extrude(background_frame_support_depth)
                    double_triangle_support();
                } else {
                    color(selected_color)
                    translate([w*triangle_height*2+w_shift, h*-Grid_Pitch])
                    linear_extrude(5)
                    double_triangle();
                };
            }
        }
    }
};

module double_triangle_support() {
    translate([triangle_height - triangle_height/3, -Grid_Pitch/2])
    rotate(180)
    translate(path_to_mid)
    difference() {
        polygon([tl, bl, mr]);
        offset(delta=-support_edge_width) // Adjust this to change the width of the support section
        polygon([tl, bl, mr]);
    }; 

    translate([triangle_height/3+triangle_height, -Grid_Pitch/2])
    translate(path_to_mid)
    difference() {
        polygon([tl, bl, mr]);
        offset(delta=-support_edge_width) // Adjust this to change the width of the support section
        polygon([tl, bl, mr]);
    }; 
};

// ------------------------------

module create_mask() {
    p = [[-Grid_Thickness/2,Grid_Thickness], [frame_width-Grid_Thickness/2, Grid_Thickness], [frame_width-Grid_Thickness/2, -frame_height+Grid_Thickness], [-Grid_Thickness/2, -frame_height+Grid_Thickness]];
    translate([-frame_width/2+Grid_Thickness/2, frame_height/2-Grid_Thickness])
    polygon(p);
};

// ---------------------------
// DOVETAIL FUNCTIONS 
// ---------------------------
module create_subpanel_dovetails(width, add_to="top") {
    // ADD DOVETAILS TO SUBPANELS
    if (add_to == "top") {
        for (i = [0: 1: width-1]) {
            translate([triangle_height+triangle_height*2*i, 0])
            create_upper_dovetail(dovetail_offset=subpanel_dt_add_os);
        }
    } else {
        for (i = [0: 1: width-1]) {
            translate([triangle_height+triangle_height*2*i, 0])
            translate([0, -frame_height+Grid_Thickness*2])
            rotate(180)
            create_upper_dovetail(dovetail_offset=subpanel_dt_add_os);
        }    
    };
};

module dovetail_cover_subtractor() {
    polygon([[-Grid_Thickness, Grid_Thickness], [-Grid_Thickness, Grid_Thickness*2], [Grid_Thickness, Grid_Thickness*2], [Grid_Thickness, Grid_Thickness]]);
};

module create_upper_dovetail(cover=false, dovetail_offset=0) {
    // GENERATE DOVETAIL
    // Creates the dovetail joint at the top and bottom of the frame
    difference() {
        translate([0,-dovetail_offset/1.75-0.03])
        hexagon(id=Grid_Thickness-dovetail_offset, realign=true);
        polygon([[-Grid_Thickness, Grid_Thickness/2],[-Grid_Thickness, Grid_Thickness],[Grid_Thickness, Grid_Thickness],[Grid_Thickness, Grid_Thickness/2]]); // Sometimes the hexagon 
    }
    
    trapezoid_h = (Grid_Thickness-dovetail_offset/8) / sqrt(3);

    translate([0, trapezoid_h/2])
    trapezoid(h=trapezoid_h, w1=Grid_Thickness-dovetail_offset, ang=120);

    if (cover) {
        // Creates the cover extension so the cover plate reaches the top/bottom borders
        difference() {
            translate([0, trapezoid_h*1.5])
            rotate(180)
            trapezoid(h=trapezoid_h, w1=Grid_Thickness-dovetail_offset, ang=120);
            dovetail_cover_subtractor();
        }
    }
};

module pattern_hanger_dovetails(os=0, repeat=3, side="both") {
    if (side == "left" || side == "both") {
        for (i = [1:1:repeat]) {
            translate([-Grid_Thickness/2, -Grid_Pitch*i])
            rotate(90)
            create_exterior_dovetail(os);
        }
    } 

    if (side == "right" || side == "both") {
        for (i = [1-is_odd:1:repeat-is_odd]) {
            translate([frame_width - Grid_Thickness/2, -Grid_Pitch*i - Grid_Pitch/2*is_odd])
            rotate(270)
            create_exterior_dovetail(os);
        }
    }
}

module pattern_exterior_dovetails(os=0, pattern=false) {
    if (pattern == "outer" || pattern == "both") {
        for (i = [0:1:n_triangles_width]) {
            translate([triangle_height*i, Grid_Thickness])
            create_exterior_dovetail(os);
        }
        for (i = [0:1:n_triangles_width]) {
            translate([triangle_height*i, -frame_height + Grid_Thickness])
            rotate(180)
            create_exterior_dovetail(os);
        }
        for (i = [0:1:n_triangles_height-1]) {
            translate([-Grid_Thickness/2, -Grid_Pitch*i - Grid_Pitch/2])
            rotate(90)
            create_exterior_dovetail(os);
        }
        for (i = [0:1:n_triangles_height-1+is_odd]) {
            translate([frame_width - Grid_Thickness/2, -Grid_Pitch*i - Grid_Pitch/2 + Grid_Pitch/2*is_odd])
            rotate(270)
            create_exterior_dovetail(os);
        }
    }
    
    if (pattern == "inner" || pattern == "both") {
        for (i = [0:1:n_triangles_width-1]) {
            translate([triangle_height/2 + triangle_height*i, Grid_Thickness])
            create_exterior_dovetail(os);
        }
        for (i = [0:1:n_triangles_width-1]) {
            translate([triangle_height/2 + triangle_height*i, -frame_height + Grid_Thickness])
            rotate(180)
            create_exterior_dovetail(os);
        }
        for (i = [0:1:n_triangles_height]) {
            translate([-Grid_Thickness/2, -Grid_Pitch*i])
            rotate(90)
            create_exterior_dovetail(os);
        }
        for (i = [0:1:n_triangles_height - is_odd]) {
            translate([frame_width - Grid_Thickness/2, -Grid_Pitch*i - Grid_Pitch/2*is_odd])
            rotate(270)
            create_exterior_dovetail(os);
        }
    }
}

module create_exterior_dovetail(os=0) {
    trapezoid_h = (Grid_Thickness-os) / sqrt(3);
    translate([0, trapezoid_h/2])
    trapezoid(h=trapezoid_h, w1=Grid_Thickness-os*1.5, ang=120);

};

// --------------------------------
// ---------- BORDER --------------

module final_border() {
    if (printable_geometry) {
        translate([0,0,Frame_Depth-border_dt_sub_depth])
        divide_outer_border(border_dt_sub_depth)
        create_border();

        divide_outer_border(Frame_Depth)
        difference() {
            create_border();
            pattern_exterior_dovetails(-border_dt_sub_os, pattern="both");
        }
    } else {
        divide_outer_border(5)
        create_border();
    }

}

module create_border() {
    translate([-frame_width/2+Grid_Thickness/2, frame_height/2-Grid_Thickness]*-1)
    difference() {
        resize(newsize=[frame_width+selected_border_thickness_width*2, frame_height+selected_border_thickness_height*2])
        create_mask();
        offset(delta=border_inner_os)
        create_mask();
    }
}

module final_border_background() {
    module create_border_background_mask(sub_height=false) {
        h_os = sub_height ? -0.01 : 0; // Subtract height from vertical border background to prevent overlap with horizontal border background
        translate([frame_width/2-Grid_Thickness/2, -frame_height/2+Grid_Thickness])
        resize(newsize=[frame_width+selected_border_thickness_width*2+Grid_Thickness*2,frame_height+h_os])
        create_mask();
    };

    // HORIZONTAL SECTIONS
    translate([0,0,-Background_Depth])
    divide_background("topbot", Background_Depth)
    difference() {
        create_border_background();
        create_border_background_mask();
    }

    divide_background("topbot", border_background_dt_add_depth)
    difference() {
        pattern_exterior_dovetails(border_background_dt_add_os, pattern="outer");
        create_border_background_mask();
    }

    // VERTICAL SECTIONS
    translate([0,0,-Background_Depth])
    divide_background("leftright", Background_Depth)
    intersection() {
        create_border_background();
        create_border_background_mask(true);
    }

    divide_background("leftright", border_background_dt_add_depth)
    intersection() {
        pattern_exterior_dovetails(border_background_dt_add_os, pattern="outer");
        create_border_background_mask(true);
    }
    
}

module create_border_background() {
    difference() {
        translate([-frame_width/2+Grid_Thickness/2, frame_height/2-Grid_Thickness]*-1)
        difference() {
            offset(delta=Grid_Thickness)
            create_mask();
            offset(delta=border_inner_os)
            create_mask();
        }
        pattern_hanger_dovetails(0, repeat=n_vertical_dovetails);
        if (Hanger_Sets == 2) {
            // The left/right edges are symmetric about the frame's horizontal centerline, so
            // mirroring the top slots about it lands them between the bottom strips' dovetails.
            // Only the bottom left/right border background strips gain slots; nothing else changes.
            translate([0, -n_triangles_height*Grid_Pitch])
            mirror([0,1,0])
            pattern_hanger_dovetails(0, repeat=n_vertical_dovetails, side="left");
            // On odd frames the mirrored right-side pattern would sit half a pitch lower and its
            // cleats would hang past the frame's bottom edge, so the right slots move up one pitch.
            translate([0, -(n_triangles_height - is_odd)*Grid_Pitch])
            mirror([0,1,0])
            pattern_hanger_dovetails(0, repeat=n_vertical_dovetails, side="right");
        }
    }
}

// --------------------------------
// -------- COVER PANEL -----------
module diamond(t) {
    p__ = sqrt(t^2+t^2 - (2*t*t*(cos(120))))/3;
    polygon([[0,0], [t, -p__], [t*2, 0], [t, p__]]);
};

module create_vertical_seam_component(h_triangles, seam_type, components=[true,true], c="blue") {
    selected_offset = seam_type == "major" ? seam_major_offset : seam_minor_offset;
    selected_width = Grid_Thickness + selected_offset;
    selected_diamond = seam_type == "major" ? selected_width+seam_major_diamond_t : selected_width+seam_minor_diamond_t;

    diamond_pos = h_triangles%1 != 0 ? 0 : triangle_height;

    module make_line(h_triangles) {
        difference() {
            difference() {
                stroke([for (i=[0:1:h_triangles*2-1]) [triangle_height*(i%2), -Grid_Pitch/2*(i-1)-Grid_Pitch]], selected_width, endcaps="butt", joints=false);
                translate([-selected_diamond, -Grid_Pitch/2])
                diamond(selected_diamond); // Subtract top
            };
            translate([-selected_diamond+diamond_pos, -Grid_Pitch/2*h_triangles*2])
            diamond(selected_diamond); // Subtract bottom
        };

        for (i=[1:1:h_triangles*2-2]) {
            translate([triangle_height*(i%2), -Grid_Pitch/2*(i-1)-Grid_Pitch])
            hexagon(id=selected_width, realign=true);
        }

    };

    module make_drop(h_triangles, seam_type) {
        selected_thickness = seam_type == "major" ? seam_major_thickness : seam_minor_thickness;
        selected_trim = seam_type == "major" ? seam_major_trim : seam_minor_trim;
        selected_extrude = seam_type == "major" ? seam_major_extrude : seam_minor_extrude;

        for (i=[1:1:h_triangles*2-1]) {
            translate([0, -Grid_Thickness/4])
            stroke([[triangle_height*((i-1)%2), -Grid_Pitch/2*(i-2)-Grid_Pitch], [triangle_height*(i%2), -Grid_Pitch/2*(i-1)-Grid_Pitch]], selected_thickness, trim=selected_trim, endcaps=false);
            translate([0, Grid_Thickness/4])
            stroke([[triangle_height*((i-1)%2), -Grid_Pitch/2*(i-2)-Grid_Pitch], [triangle_height*(i%2), -Grid_Pitch/2*(i-1)-Grid_Pitch]], selected_thickness, trim=selected_trim, endcaps=false);
        }
    };

    if (components[0]) {
        extrude_seam_children(seam_type, "line", c)
        make_line(h_triangles);
    }
    if (components[1]) {
        extrude_seam_children(seam_type, "drop", c)
        make_drop(h_triangles, seam_type);
    }
};

module pattern_vertical_seams(seam_type, seam_position=false, components=[true,true], outer_only=false) {
    for (h = [0:1:n_subpanels_height-1]) {
        for (w = [0:1:n_subpanels_width]) {
            is_outer = w == 0 || w == n_subpanels_width;
            if (([h,w] == seam_position || seam_position == false && outer_only == false) || (outer_only && is_outer)) {
                bottom_subtractor = h == n_subpanels_height-1 && leftover_subpanel_t_height <= 0 ? leftover_subpanel_t_height : 0;
                t = h == n_subpanels_height-1 && leftover_subpanel_t_height >= 0? leftover_subpanel_t_height : max_subpanel_t_height + bottom_subtractor;
                selected_color = color_vertical_seams;
                if (w == n_subpanels_width) {
                    translate([frame_width-Grid_Thickness-triangle_height*is_odd, -h*tb_subpanels_height_mm])
                    mirror([1-is_odd,0,0])
                    create_vertical_seam_component(t, seam_type, components=components, c=selected_color);
                } else {
                    translate([w*tb_subpanels_width_mm, -h*tb_subpanels_height_mm])
                    create_vertical_seam_component(t, seam_type, components=components, c=selected_color);
                }
            }
        };
    };
}

module create_horizontal_seam_component(row, w_triangles, seam_type, is_first_col, is_last_col, components=[true,true], c="blue") {
    selected_offset = seam_type == "major" ? seam_major_offset : seam_minor_offset;
    selected_width = Grid_Thickness + selected_offset;
    selected_diamond = seam_type == "major" ? selected_width+seam_major_diamond_t : selected_width+seam_minor_diamond_t;
    selected_extrude = seam_type == "major" ? seam_major_extrude : seam_minor_extrude;

    ttb = is_first_col || is_last_col ? [0, Grid_Pitch] : [0,0];

    module make_line() {
        if (is_first_col && is_last_col) {
            stroke([for (i=[1:1:w_triangles+1]) [triangle_height*i-triangle_height, -Grid_Pitch/2*(i%2)]], selected_width, endcaps="butt", joints=false);
            
            for (i=[1:1:w_triangles+1]) {
                translate([triangle_height*(i-1), -Grid_Pitch/2*(i%2)])
                hexagon(id=selected_width, realign=true);
            };
            if (is_odd == 1 && (row == 0 || row == n_subpanels_height)) {
                // If the panel is odd, then we need to add a diamond to the top and bottom panels since they
                // do not reach the end of the frame (hexagon alone won't work)
                translate([-selected_width+triangle_height*w_triangles, -Grid_Pitch/2])
                diamond(selected_width);
            }
        } else if (is_first_col) {
            stroke([for (i=[1:1:w_triangles+1]) [triangle_height*i-triangle_height, -Grid_Pitch/2*(i%2)]], selected_width, endcaps="butt", joints=false);
            translate([-selected_width+triangle_height*w_triangles, -Grid_Pitch/2])
            diamond(selected_width);

            for (i=[1:1:w_triangles]) {
                translate([triangle_height*(i-1), -Grid_Pitch/2*(i%2)])
                hexagon(id=selected_width, realign=true);
            };
        } else if (is_last_col) {
            difference() {
                stroke([for (i=[1:1:w_triangles+1]) [triangle_height*i-triangle_height, -Grid_Pitch/2*(i%2)]], selected_width, endcaps="butt", joints=false);
                translate([-selected_diamond, -Grid_Pitch/2])
                diamond(selected_diamond);
            }
            for (i=[2:1:w_triangles+1]) {
                translate([triangle_height*(i-1), -Grid_Pitch/2*(i%2)])
                hexagon(id=selected_width, realign=true);
            };
            if (is_odd == 1 && (row == 0 || row == n_subpanels_height)) {
                // If the panel is odd, then we need to add a diamond to the top and bottom panels since they
                // do not reach the end of the frame (hexagon alone won't work)
                translate([-selected_width+triangle_height*w_triangles, -Grid_Pitch/2])
                diamond(selected_width);
            }

        } else {
            union() {
                difference() {
                    stroke([for (i=[1:1:w_triangles+1]) [triangle_height*i-triangle_height, -Grid_Pitch/2*(i%2)]], selected_width, endcaps="butt", joints=false);
                    translate([-selected_diamond, -Grid_Pitch/2])
                    diamond(selected_diamond);
                };
                translate([-selected_width+triangle_height*w_triangles, -Grid_Pitch/2])
                diamond(selected_width);

                for (i=[2:1:w_triangles]) {
                    translate([triangle_height*(i-1), -Grid_Pitch/2*(i%2)])
                    hexagon(id=selected_width, realign=true);
                };
            }
        }
        // Make dovetail
        for (i=[1:1:w_triangles+1]) {
            if (row == 0 && (i%2) == 0) {
                translate([triangle_height*(i-1), 0])
                create_upper_dovetail(cover=true, dovetail_offset=-selected_offset);
            } else if (row == n_subpanels_height && (i%2) == 0) {
                translate([triangle_height*(i-1), 0])
                create_upper_dovetail(cover=true, dovetail_offset=-selected_offset);
            }
        }
    }

    module make_drop(w_triangles, seam_type="major") {
        selected_thickness = seam_type == "major" ? seam_major_thickness : seam_minor_thickness;
        selected_trim = seam_type == "major" ? seam_major_trim : seam_minor_trim;
        selected_extrude = seam_type == "major" ? seam_major_extrude : seam_minor_extrude;

        for (i=[1:1:w_triangles]) {
            translate([0, -Grid_Thickness/4])
            stroke([[triangle_height*(i)-triangle_height, -Grid_Pitch/2*((i)%2)], [triangle_height*(i+1)-triangle_height, -Grid_Pitch/2*((i+1)%2)]], selected_thickness, trim=selected_trim, endcaps=false);
            translate([0, Grid_Thickness/4])
            stroke([[triangle_height*(i)-triangle_height, -Grid_Pitch/2*((i)%2)], [triangle_height*(i+1)-triangle_height, -Grid_Pitch/2*((i+1)%2)]], selected_thickness, trim=selected_trim, endcaps=false);
        }
    };

    if (components[0]) {
        extrude_seam_children(seam_type, "line", c)
        make_line();
    }

    if (components[1]) {
        extrude_seam_children(seam_type, "drop", c)
        make_drop(w_triangles, seam_type);
    }
};

module extrude_seam_children(seam_type, component_type, c) {
    selected_extrude = seam_type == "major" ? seam_major_extrude : seam_minor_extrude;
    // When fusing, sink the printed (minor) seam a touch into the floor of its groove so it bites
    // into the panel vertically as well as sideways rather than resting on a coincident face.
    sink = fuse_components && seam_type != "major" ? fuse_interference : 0;

    if (component_type == "line") {
        translate([0,0,Frame_Depth-seam_thickness-sink])
        color(c)
        linear_extrude(seam_thickness+sink)
        children();
    } else if (component_type == "drop") {
        translate([0,0,Frame_Depth-selected_extrude])
        color(c)
        linear_extrude(selected_extrude)
        children();
    }

}

module pattern_horizontal_seams(seam_type, seam_position=false, extend_seam=false, components=[true,true], outer_only=false) {
    // extend_seam (bool) : if == true -- adds 2 additional sections to the seam and acts as though the seam is the first column (adds a hexagon to the start)
    seam_extension_addition = extend_seam ? 2 : 0;

    for (h = [0:1:n_subpanels_height]) {
        for (w = [0:1:n_subpanels_width-1]) {
            is_outer = h == 0 || h == n_subpanels_height || w == 0 || w == n_subpanels_width-1;
            if (([h,w] == seam_position || seam_position == false && outer_only==false) || (is_outer && outer_only)) {
                is_first_col = w == 0 ? true : false;
                is_last_col = w == n_subpanels_width-1 ? true : false;

                // Extend middle panels
                mid_extension = h != 0 && h != n_subpanels_height && w == n_subpanels_width-1 ? is_odd : 0;
                t = w == n_subpanels_width-1 && leftover_subpanel_t_width != 0? leftover_subpanel_t_width + mid_extension: max_subpanel_t_width*2 + mid_extension;
                selected_color = w % 2 == 0 ? color_horizontal_seams[0] : color_horizontal_seams[1];
                if (h == n_subpanels_height) {
                    // For the final row, create a custom seam with a custom shift
                    translate([w*tb_subpanels_width_mm, -frame_height+Grid_Thickness*2])
                    mirror([0,1,0])
                    create_horizontal_seam_component(h, t+seam_extension_addition, seam_type, is_first_col || extend_seam, is_last_col, components=components, c=selected_color);

                } else {
                    translate([w*tb_subpanels_width_mm, -h*tb_subpanels_height_mm])
                    create_horizontal_seam_component(h, t+seam_extension_addition, seam_type, is_first_col || extend_seam, is_last_col, components=components, c=selected_color);
                }
            }
        };
    };
}

module create_all_seams(seam_type) {
    if (printable_geometry) {
        union() {
            pattern_vertical_seams(seam_type);
            pattern_horizontal_seams(seam_type);
        };
    } else {
        union() {
            pattern_vertical_seams(seam_type, components=[true,false]);
            pattern_horizontal_seams(seam_type, components=[true,false]);
        };
    }
};

module create_outer_seams() {
    pattern_horizontal_seams("major", outer_only=true);
    pattern_vertical_seams("major", outer_only=true);
}

// ----------------------------------------
// ------- DIVIDING BORDER AND FRAME ------
function create_inner_frame_intersector(n_horizontal_subpanels, n_vertical_subpanels, horizontal_panel_i, vertical_panel_i) =
    // Calculates the number of triangles that are missing when tiling the subpanels
    let (height_leftovers = n_subpanels_height*max_subpanel_t_height - n_triangles_height - 1.5)

    // Horizontal Adjustments
    // Adjustment 1: First and last columns should be extended by 1 triangle
    let (h_adj_1_size = horizontal_panel_i == 0 || horizontal_panel_i == n_horizontal_subpanels ? triangle_height : 0)
    let (h_adj_1_shift = horizontal_panel_i != 0 ? triangle_height : 0)
    // Adjustment 2: Second last column must be subtracted if 
    let (h_adj_2_size = leftover_subpanel_t_width + is_odd == 3 && horizontal_panel_i == n_horizontal_subpanels-1 ? triangle_height*2 : 0)
    let (h_adj_2_shift = leftover_subpanel_t_width + is_odd == 3  && horizontal_panel_i == n_horizontal_subpanels ? triangle_height*2 : 0)

    // Vertical Adjustments
    // Adjustment 1: First row adjustment -- First row should be 1.5 triangles shorter than the rest of the panels
    let (v_adj_1_size = vertical_panel_i == 0 ? Grid_Pitch*1.5 : 0)
    let (v_adj_1_shift = vertical_panel_i != 0 ? Grid_Pitch*1.5 : 0)
    // Adjustment 2.0: Last column adjustment -- If odd, add 0.5 to top right and shift everything below down by 0.5 and last column is not also the first column (single col)
    let (v_adj_2_0_size = horizontal_panel_i == n_horizontal_subpanels && vertical_panel_i == 0 && is_odd == 1 && n_horizontal_subpanels != 0 ? Grid_Pitch/2 : 0)
    let (v_adj_2_0_shift = horizontal_panel_i == n_horizontal_subpanels && vertical_panel_i != 0 && is_odd == 1 && n_horizontal_subpanels != 0 ? Grid_Pitch/2 : 0)
    // Adjustment 2.1: Last column, second last row should be subtracted by 1 and shifted to correct for adjustment 2.0 OR
    // Width leftover == 0 && is_odd == 0 do the same thing (shown as leftover_subpanel_t_width+is_odd == 0)
    // !Important: make sure height_leftover != -0.5 before doing this
    let (q21 = leftover_subpanel_t_width%2 == 0 && height_leftovers == -1.5)
    let (v_adj_2_1_size = q21 && horizontal_panel_i == n_horizontal_subpanels && vertical_panel_i == n_vertical_subpanels-1 ? Grid_Pitch : 0)
    let (v_adj_2_1_shift = q21 && horizontal_panel_i == n_horizontal_subpanels && vertical_panel_i == n_vertical_subpanels ? Grid_Pitch : 0)
    // Adjustment 3: Extend final row by 0.5 if height_leftover is -0.5
    let (v_adj_3_size = vertical_panel_i == n_vertical_subpanels && height_leftovers == -0.5 ? Grid_Pitch/2 : 0)

    // CALCULATE HEIGHT AND WIDTH OF INTERSECTOR
    let (horizontal_size = triangle_height*(max_subpanel_t_width*2) + h_adj_1_size - h_adj_2_size)
    let (vertical_size = Grid_Pitch*(max_subpanel_t_height) - v_adj_1_size + v_adj_2_0_size - v_adj_2_1_size + v_adj_3_size)

    // CALCULATE POSITION OF INTERSECTOR
    let (horizontal_shift = tb_subpanels_width_mm*horizontal_panel_i + h_adj_1_shift - h_adj_2_shift)
    let (vertical_shift = -max_subpanel_t_height*Grid_Pitch*vertical_panel_i + v_adj_1_shift - v_adj_2_0_shift + v_adj_2_1_shift)

    [horizontal_size, vertical_size, horizontal_shift, vertical_shift];

module divide_inner_frame(debug=false) {
    // Calculates the number of triangles that are missing when tiling the subpanels
    height_leftovers = n_subpanels_height*max_subpanel_t_height - n_triangles_height - 1.5;

    // Add vertical subpanel if:
    // 1. leftover is <= -1.5
    add_vert_subpanel = height_leftovers <= -1.5 ? 1 : 0;

    // Subtract horizontal subpanel if:
    // 1. Maximum subpanel width size is 1 (3-triangle wide) and frame is not odd
    sub_hori_subpanel_1 = max_subpanel_t_width == 1 && is_odd == 0 ? 1 : 0;
    // 2. Subpanel width leftovers >= 2 - is_odd and frame doesn't have just a single panel column
    sub_hori_subpanel_2 = leftover_subpanel_t_width - is_odd == 2 && n_subpanels_width != 1? 1 : 0;

    // Calculate number of panels required
    n_horizontal_subpanels = n_subpanels_width-1 - sub_hori_subpanel_1 - sub_hori_subpanel_2;
    n_vertical_subpanels = n_subpanels_height-1 + add_vert_subpanel;

    // To speed things up, 1 unique version of each section should be generated
    tl_1right = create_inner_frame_intersector(n_horizontal_subpanels, n_vertical_subpanels, 1, 0);
    tr_1left = create_inner_frame_intersector(n_horizontal_subpanels, n_vertical_subpanels, n_horizontal_subpanels-1, 0);
    plot_tr_1left = tl_1right[0] == tr_1left[0] && tl_1right[1] == tr_1left[1] ? false : true;

    tl_1down = create_inner_frame_intersector(n_horizontal_subpanels, n_vertical_subpanels, 0, 1);
    tr_1down = create_inner_frame_intersector(n_horizontal_subpanels, n_vertical_subpanels, n_horizontal_subpanels, 1);
    plot_tr_1down = tl_1down[0] == tr_1down[0] && tl_1down[1] == tr_1down[1] ? false : true;
    bl_1up = create_inner_frame_intersector(n_horizontal_subpanels, n_vertical_subpanels, 0, n_vertical_subpanels-1);
    plot_bl_1up = tl_1down[0] == bl_1up[0] && tl_1down[1] == bl_1up[1] ? false : true;
    br_1up = create_inner_frame_intersector(n_horizontal_subpanels, n_vertical_subpanels, n_horizontal_subpanels, n_vertical_subpanels-1);
    plot_br_1up = tl_1down[0] == br_1up[0] && tl_1down[1] == br_1up[1] ? false : true;

    for (horizontal_panel_i = [0:1:n_horizontal_subpanels]) {
        for (vertical_panel_i = [0:1:n_vertical_subpanels]) {            
            intersector_details = create_inner_frame_intersector(n_horizontal_subpanels, n_vertical_subpanels, horizontal_panel_i, vertical_panel_i);
            
            // DETERMINE WHETHER INTERSECTOR SHOULD BE GENERATED
            pos = [vertical_panel_i, horizontal_panel_i];
            // Corners should always be drawn
            is_corner = pos == [0,0] || pos == [0,n_horizontal_subpanels] || pos == [n_vertical_subpanels,n_horizontal_subpanels] || pos == [n_vertical_subpanels,0];
            is_vertical_acc = (tl_1down == intersector_details) || (plot_tr_1down && tr_1down == intersector_details) || (plot_bl_1up && bl_1up == intersector_details) || (plot_br_1up && br_1up == intersector_details);
            is_horizontal_acc = (tl_1right == intersector_details) || (plot_tr_1left && tr_1left == intersector_details);

            if (is_corner || is_vertical_acc || is_horizontal_acc || show_all_components) {
                horizontal_size = intersector_details[0];
                vertical_size = intersector_details[1];
                horizontal_shift = intersector_details[2];
                vertical_shift = intersector_details[3];

                // OFFSETS
                // os = 0;
                os = (Grid_Thickness + max(selected_border_thickness_width, selected_border_thickness_height) + 0.1 + Grid_Pitch)*2;
                ol_os = split_piece_os; // overlap offset
                // Column 1 offsets (extend shapde left)
                col_1_offsets = horizontal_panel_i == 0 ? [[-os, -ol_os], [0,-ol_os], [0,ol_os], [-os, ol_os]] : [[0,0],[0,0],[0,0],[0,0]];
                // Row 1 offsets (extend shape up)
                row_1_offsets = vertical_panel_i == 0 ? [[ol_os, os], [-ol_os, os], [-ol_os,0], [ol_os,0]] : [[0,0],[0,0],[0,0],[0,0]];
                // Column -1 offsets (extend shape right)
                col_m1_offsets = horizontal_panel_i == n_horizontal_subpanels? [[0,-ol_os], [os,-ol_os], [os, ol_os], [0,ol_os]] : [[0,0],[0,0],[0,0],[0,0]];
                // Row -1 offsets (extend shape down)
                row_m1_offsets = vertical_panel_i == n_vertical_subpanels? [[ol_os,0], [-ol_os,0], [-ol_os,-os], [ol_os,-os]] : [[0,0],[0,0],[0,0],[0,0]];

                // SHIFTS
                horizontal_subpanel_shift = horizontal_panel_i == 0 ? -max_subpanel_t_width*triangle_height*2-triangle_height*2 : max_subpanel_t_width*triangle_height*2+triangle_height*2;
                depth_panel_shift_1 = vertical_panel_i == 0 || vertical_panel_i == 1 ? (-1*(vertical_panel_i-1))*Frame_Depth*1.5+Frame_Depth*1.5 : 0;
                depth_panel_shift_2 = vertical_panel_i == n_vertical_subpanels || vertical_panel_i == n_vertical_subpanels-1 ? (-1*(vertical_panel_i-n_vertical_subpanels))*Frame_Depth*1.5+Frame_Depth*1.5 : 0;
                
                subpanel_shift_intermediate = [horizontal_subpanel_shift, 0, (depth_panel_shift_1+depth_panel_shift_2)*-1];
                subpanel_shift_ = is_horizontal_acc && !is_corner ? [0, Grid_Pitch*1.5, (depth_panel_shift_1+depth_panel_shift_2)*-1] : subpanel_shift_intermediate;
                subpanel_shift = show_all_components ? [0,0] : subpanel_shift_;

                shape = [[0,0], [horizontal_size, 0], [horizontal_size, -vertical_size], [0, -vertical_size]] + col_1_offsets + row_1_offsets + col_m1_offsets + row_m1_offsets;
                
                vertical_color = (vertical_panel_i+1)%2 != 0 ? color_inner_frame[0] : color_inner_frame[1];
                horizontal_color = (horizontal_panel_i+1)%2 != 0 ? color_inner_frame[0] : color_inner_frame[1];
                selected_color = is_horizontal_acc && !is_corner ?  horizontal_color : vertical_color;
                if (debug) {
                    translate([horizontal_shift, vertical_shift])
                    %polygon(shape);
                } else {
                    if (printable_geometry) {
                        color(selected_color)
                        translate(subpanel_shift)
                        intersection() {
                            translate([horizontal_shift, vertical_shift])
                            linear_extrude(Frame_Depth)
                            polygon(shape);
                            children();
                        }
                    } else {
                        color(selected_color)
                        translate(subpanel_shift)
                        linear_extrude(5)
                        intersection() {
                            translate([horizontal_shift, vertical_shift])
                            polygon(shape);
                            children();
                        }
                    }
                } 
            }
        }
    }
};

module divide_outer_border(extrude_depth, debug=false) {
    // Calculates the number of triangles that are missing when tiling the subpanels
    height_leftovers = n_subpanels_height*max_subpanel_t_height - n_triangles_height - 2.5;

    // Add vertical subpanel if:
    // 1. leftover is <= -1.5
    add_vert_subpanel = height_leftovers <= -1.5 ? 1 : 0;

    // Subtract horizontal subpanel if:
    // 1. Maximum subpanel width size is 1 (3-triangle wide) and frame is not odd
    sub_hori_subpanel_1 = max_subpanel_t_width == 1 && is_odd == 0 ? 1 : 0;
    // 2. Subpanel width leftovers >= 2 - is_odd and frame doesn't have just a single panel column
    sub_hori_subpanel_2 = leftover_subpanel_t_width - is_odd == 2 && n_subpanels_width != 1 ? 1 : 0;

    // Calculate number of panels required
    n_horizontal_subpanels = n_subpanels_width-1 - sub_hori_subpanel_1 - sub_hori_subpanel_2;
    n_vertical_subpanels = n_subpanels_height-1 + add_vert_subpanel;

    for (horizontal_panel_i = [0:1:n_horizontal_subpanels]) {
        for (vertical_panel_i = [0:1:n_vertical_subpanels]) {
            if (horizontal_panel_i == 0 || horizontal_panel_i == n_horizontal_subpanels || vertical_panel_i == 0 || vertical_panel_i == n_vertical_subpanels) {
                // Horizontal Adjustments
                // Adjustment 1: First and last columns should be extended by 1 triangle
                h_adj_1_size = horizontal_panel_i == 0 || horizontal_panel_i == n_horizontal_subpanels ? triangle_height : 0;
                h_adj_1_shift = horizontal_panel_i != 0 ? triangle_height : 0;
                // Adjustment 2: Second last column must be subtracted if 
                h_adj_2_size = leftover_subpanel_t_width + is_odd == 3 && horizontal_panel_i == n_horizontal_subpanels-1 ? triangle_height*2 : 0;
                h_adj_2_shift = leftover_subpanel_t_width + is_odd == 3  && horizontal_panel_i == n_horizontal_subpanels ? triangle_height*2 : 0;

                // Vertical Adjustments
                // Adjustment 1: First row adjustment -- First row should be 1.5 triangles shorter than the rest of the panels
                v_adj_1_size = vertical_panel_i == 0 ? Grid_Pitch*2.5 : 0;
                v_adj_1_shift = vertical_panel_i != 0 ? Grid_Pitch*2.5 : 0;
                // Adjustment 2.0: Last column adjustment -- If odd, add 0.5 to top right and shift everything below down by 0.5 and last column is not also the first column (single col)
                v_adj_2_0_size = horizontal_panel_i == n_horizontal_subpanels && vertical_panel_i == 0 && is_odd == 1 && n_horizontal_subpanels != 0 ? Grid_Pitch/2 : 0;
                v_adj_2_0_shift = horizontal_panel_i == n_horizontal_subpanels && vertical_panel_i != 0 && is_odd == 1 && n_horizontal_subpanels != 0 ? Grid_Pitch/2 : 0;
                // Adjustment 2.1: Last column, second last row should be subtracted by 1 and shifted to correct for adjustment 2.0 OR
                // Width leftover == 0 && is_odd == 0 do the same thing (shown as leftover_subpanel_t_width+is_odd == 0)
                // !Important: make sure height_leftover != -0.5 before doing this
                q21 = leftover_subpanel_t_width%2 == 0 && height_leftovers == -1.5;
                v_adj_2_1_size = q21 && horizontal_panel_i == n_horizontal_subpanels && vertical_panel_i == n_vertical_subpanels-1 ? Grid_Pitch : 0;
                v_adj_2_1_shift = q21 && horizontal_panel_i == n_horizontal_subpanels && vertical_panel_i == n_vertical_subpanels ? Grid_Pitch : 0;
                // Adjustment 3: Extend final row by 0.5 if height_leftover is -0.5
                v_adj_3_size = vertical_panel_i == n_vertical_subpanels && height_leftovers == -0.5 ? Grid_Pitch/2 : 0;

                // CALCULATE HEIGHT AND WIDTH OF INTERSECTOR
                horizontal_size = triangle_height*(max_subpanel_t_width*2) + h_adj_1_size - h_adj_2_size;
                vertical_size = Grid_Pitch*(max_subpanel_t_height) - v_adj_1_size + v_adj_2_0_size - v_adj_2_1_size + v_adj_3_size;

                // CALCULATE POSITION OF INTERSECTOR
                horizontal_shift = tb_subpanels_width_mm*horizontal_panel_i + h_adj_1_shift - h_adj_2_shift;
                vertical_shift = -max_subpanel_t_height*Grid_Pitch*vertical_panel_i + v_adj_1_shift - v_adj_2_0_shift + v_adj_2_1_shift;

                // SHIFTS
                is_corner = (horizontal_panel_i == 0 && vertical_panel_i == 0) || (horizontal_panel_i == 0 && vertical_panel_i == n_vertical_subpanels) || (horizontal_panel_i == n_horizontal_subpanels && vertical_panel_i == 0) || (horizontal_panel_i == n_horizontal_subpanels && vertical_panel_i == n_vertical_subpanels);
                horizontal_subpanel_shift = horizontal_panel_i == 0 ? -max_subpanel_t_width*triangle_height*2-triangle_height*2 : max_subpanel_t_width*triangle_height*2+triangle_height*2;
                subpanel_shift = is_corner && show_all_components == false ? [horizontal_subpanel_shift, 0] : [0,0];

                // OFFSETS
                // os = 0;
                os = (Grid_Thickness + max(selected_border_thickness_width, selected_border_thickness_height) + 0.1 + Grid_Pitch)*2;
                ol_os = split_piece_os; // overlap offset (used so split components are separated from each other)
                // Column 1 offsets (extend shapde left)
                col_1_offsets = horizontal_panel_i == 0 ? [[-os, -ol_os], [0,-ol_os], [0,ol_os], [-os, ol_os]] : [[0,0],[0,0],[0,0],[0,0]];
                // Row 1 offsets (extend shape up)
                row_1_offsets = vertical_panel_i == 0 ? [[ol_os, os], [-ol_os, os], [-ol_os,0], [ol_os,0]] : [[0,0],[0,0],[0,0],[0,0]];
                // Column -1 offsets (extend shape right)
                col_m1_offsets = horizontal_panel_i == n_horizontal_subpanels? [[0,-ol_os], [os,-ol_os], [os, ol_os], [0,ol_os]] : [[0,0],[0,0],[0,0],[0,0]];
                // Row -1 offsets (extend shape down)
                row_m1_offsets = vertical_panel_i == n_vertical_subpanels? [[ol_os,0], [-ol_os,0], [-ol_os,-os], [ol_os,-os]] : [[0,0],[0,0],[0,0],[0,0]];

                shape = [[0,0], [horizontal_size, 0], [horizontal_size, -vertical_size], [0, -vertical_size]] + col_1_offsets + row_1_offsets + col_m1_offsets + row_m1_offsets;
                selected_color = (horizontal_panel_i+ vertical_panel_i)%2 == 0 ? color_border[0] : color_border[1];
                if (debug) {
                    translate([horizontal_shift, vertical_shift])
                    #polygon(shape);
                } else {
                    translate(subpanel_shift)
                    color(selected_color)
                    linear_extrude(extrude_depth)
                    intersection() {
                        translate([horizontal_shift, vertical_shift])
                        polygon(shape);
                        children();
                    }
                }
            }
        }
    }
};

module divide_background(section, extrude_depth, colors, debug=false) {
    // section options:
        // "topbot"
        // "leftright"
    for (horizontal_panel_i = [0:1:n_subpanels_width-1]) {
        for (vertical_panel_i = [0:1:n_subpanels_height-1]) {
            horizontal_size = triangle_height*(max_subpanel_t_width*2);
            vertical_size = Grid_Pitch*(max_subpanel_t_height);

            horizontal_shift = tb_subpanels_width_mm*horizontal_panel_i;
            vertical_shift = -max_subpanel_t_height*Grid_Pitch*vertical_panel_i;

            // OFFSETS
            // os = 0;
            os = (Grid_Thickness + max(selected_border_thickness_width, selected_border_thickness_height) + 0.1 + Grid_Pitch)*2;
            ol_os = split_piece_os; // overlap offset (used so split components are separated from each other)
            // Column 1 offsets (extend shapde left)
            col_1_offsets = horizontal_panel_i == 0 ? [[-os, -ol_os], [0,-ol_os], [0,ol_os], [-os, ol_os]] : [[0,0],[0,0],[0,0],[0,0]];
            // Row 1 offsets (extend shape up)
            row_1_offsets = vertical_panel_i == 0 ? [[ol_os, os], [-ol_os, os], [-ol_os,0], [ol_os,0]] : [[0,0],[0,0],[0,0],[0,0]];
            // Column -1 offsets (extend shape right)
            col_m1_offsets = horizontal_panel_i == n_subpanels_width-1? [[0,-ol_os], [os,-ol_os], [os, ol_os], [0,ol_os]] : [[0,0],[0,0],[0,0],[0,0]];
            // Row -1 offsets (extend shape down)
            row_m1_offsets = vertical_panel_i == n_subpanels_height-1? [[ol_os,0], [-ol_os,0], [-ol_os,-os], [ol_os,-os]] : [[0,0],[0,0],[0,0],[0,0]];

            shape = [[0,0], [horizontal_size, 0], [horizontal_size, -vertical_size], [0, -vertical_size]] + col_1_offsets + row_1_offsets + col_m1_offsets + row_m1_offsets;
            
            q_topbot = section == "topbot" && (vertical_panel_i == 0 || vertical_panel_i == n_subpanels_height-1);
            q_leftright = section == "leftright" && (horizontal_panel_i == 0 || horizontal_panel_i == n_subpanels_width-1);

            color_pos = (horizontal_panel_i+vertical_panel_i)%2 == 0 ? 0 : 1;
            selected_color = q_topbot ? color_border_background_horizontal[color_pos] : color_border_background_vertical[color_pos];

            if (q_topbot || q_leftright) {
                if (debug) {
                    translate([horizontal_shift, vertical_shift])
                    %polygon(shape);
                } else {
                    color(selected_color)
                    linear_extrude(extrude_depth)
                    intersection() {
                        translate([horizontal_shift, vertical_shift])
                        polygon(shape);
                        children();
                    }
                }
            }
        }
    }
};

module create_vertical_seam_drop(h_triangles, seam_type="major") {
    selected_thickness = seam_type == "major" ? seam_major_thickness : seam_minor_thickness;
    selected_trim = seam_type == "major" ? seam_major_trim : seam_minor_trim;
    selected_extrude = seam_type == "major" ? seam_major_extrude : seam_minor_extrude;

    for (i=[1:1:h_triangles*2-1]) {
        translate([0, -Grid_Thickness/4, Frame_Depth-selected_extrude])
        linear_extrude(selected_extrude)
        stroke([[triangle_height*((i-1)%2), -Grid_Pitch/2*(i-2)-Grid_Pitch], [triangle_height*(i%2), -Grid_Pitch/2*(i-1)-Grid_Pitch]], selected_thickness, trim=selected_trim, endcaps=false);
        translate([0, Grid_Thickness/4, Frame_Depth-selected_extrude])
        linear_extrude(selected_extrude)
        stroke([[triangle_height*((i-1)%2), -Grid_Pitch/2*(i-2)-Grid_Pitch], [triangle_height*(i%2), -Grid_Pitch/2*(i-1)-Grid_Pitch]], selected_thickness, trim=selected_trim, endcaps=false);
    }
};


// -------------END----------------

module place_inserts_around_border(pattern="both") {
    if (pattern == "horizontal" || pattern == "both") {
        for (i = [0: 1: n_triangles_width-1]) {
            translate([triangle_height/3 + triangle_height*i + triangle_height/3*(i%2), 0])
            mirror([1*(i%2),0,0])
            children();
        }
        for (i = [0: 1: n_triangles_width-1]) {
            translate([triangle_height/3 + triangle_height*i + triangle_height/3*(i%2), -n_triangles_height*Grid_Pitch])
            mirror([1*(i%2),0,0])
            mirror([0,1,0])
            children();
        }   
    }
    if (pattern == "vertical" || pattern == "both") {
        for (z = [1: 1: n_triangles_height-1]) {
            translate([triangle_height/3, -Grid_Pitch*z])
            children();
        }
        for (z = [1: 1: n_triangles_height-1+is_odd]) {
            translate([triangle_height/3*2 + triangle_height*(n_triangles_width-1), -Grid_Pitch*z + (Grid_Pitch/2)*is_odd])
            rotate(180)
            children();
        }
    }
};

module pattern_dovetails() {
    for (i = [2: 2: n_triangles_width-is_odd]) {
        translate([triangle_height/3 + triangle_height*i + triangle_height/3*(i%2) - triangle_height, -Grid_Pitch/2])
        children();
    }
    for (i = [1: 2: n_triangles_width-is_odd]) {
        translate([triangle_height/3 + triangle_height*i + triangle_height/3*(i%2) - triangle_height, -n_triangles_height*Grid_Pitch + Grid_Pitch/2])
        rotate(180)
        children();
    }
};

module dovetail_triangle(t=[0,0]) {
    translate([triangle_height/3*2 - (Grid_Thickness/1.5)/2, 0])
    translate(-1*path_to_mid + t)
    rotate(60)
    regular_ngon(id=Grid_Thickness/1.5+0.001, n=3);
    difference() {
        union() {
            triangle(t);
        }
        translate(t)
        union() {
            translate([(Grid_Thickness/1.5)/2, 0])
            regular_ngon(id=Grid_Thickness/1.5+0.001, n=3);
            translate([(Grid_Thickness/1.5)/2, -Grid_Pitch])
            regular_ngon(id=Grid_Thickness/1.5+0.001, n=3);
        };
    };
};

module triangle(t=[0,0]) {
    translate(t)
    difference() {
        polygon([[0,0], [0, -Grid_Pitch], [triangle_height, -Grid_Pitch/2]]);
        offset(delta=-Grid_Thickness/2) 
        polygon([[0,0], [0, -Grid_Pitch], [triangle_height, -Grid_Pitch/2]]);
    }
};

module inner_border() {
    // Inner border
    difference() {
        polygon([[-Grid_Thickness/2,Grid_Thickness], [frame_width-Grid_Thickness/2, Grid_Thickness], [frame_width-Grid_Thickness/2, -frame_height+Grid_Thickness], [-Grid_Thickness/2, -frame_height+Grid_Thickness]]);
        polygon([[0,0], [frame_width-Grid_Thickness, 0], [frame_width-Grid_Thickness, -frame_height+Grid_Thickness*2], [0, -frame_height+Grid_Thickness*2]]);
    };
};

module pattern_cleat(repeat) {
    for (i = [0: 1: repeat]) {
        translate([0, -20*i])
        children();
    }
}

module wall_cleat(repeat=6, shorten=0, position="top") {
    // Create the wall cleat from which the panel will hang
    module wall_pattern(extrude_by=3.6) {
        points = [[16-7.5, -14.54], [19, -14.54], [19, -24], [16-7.5, -18]];

        difference() {
            linear_extrude(extrude_by)
            polygon(points);

            translate([16, -14.54-1.999])
            rotate(180)
            wedge(size=[11.5, 2, 2], anchor=BACK+BOTTOM);
        }
    }

    module create_hanger_template(shorten, position) {
        // Top set: the template's top edge lines up with the panel's top outer edge.
        // Bottom set: the template's bottom edge lines up with the panel's bottom outer edge instead.
        template_top = position == "top" ? Grid_Pitch/2+Grid_Thickness+selected_border_thickness_height-shorten*Grid_Pitch/2 : 0;
        template_bottom = position == "top" ? -repeat*20 -14.54-9.5 : -Grid_Thickness-selected_border_thickness_height-Grid_Pitch*(n_vertical_dovetails+0.5)-shorten*Grid_Pitch/2;
        translate([-Grid_Thickness/2, -Grid_Pitch/2, -15])
        linear_extrude(0.4)
        difference() {
            polygon([[-selected_border_thickness_width, template_top], [41, template_top], [41, template_bottom], [-selected_border_thickness_width, template_bottom]]);
            drill_slots();
        }
    }

    module drill_slots() {
        union() {
           translate([30, -repeat*4-15])
            rect([4.2, repeat*8], rounding=4/2);
           translate([30, -repeat*20 -14.54-9.5+repeat*4 + 15])
            rect([4.2, repeat*8], rounding=4/2);
        }
    }

    color(color_wall_hanger)
    translate([-Grid_Thickness/2, -Grid_Pitch/2])
    pattern_cleat(repeat)
    wall_pattern();

    color(color_wall_hanger)
    translate([-Grid_Thickness/2, -Grid_Pitch/2])
    linear_extrude(3.6)
    difference() {
        polygon([[19-0.001, 0], [41, 0], [41, -repeat*20 -14.54-9.5], [19-0.001, -repeat*20 -14.54-9.5]]);
        drill_slots();
    }

    color(color_wall_template)
    create_hanger_template(shorten, position);
}

module creat_frame_cleat(repeat=6) {
    // Create the frame cleat which will grab onto the wall cleat
    module frame_pattern(extrude_by) {
        points = [[0,0], [5, 0], [16, -6.351], [16, -14.54], [16-7.5, -14.54], [5, -12.5], [0, -12.5]];
        linear_extrude(extrude_by)
        polygon(points);

        translate([14, -14.54-1.999])
        rotate(180)
        wedge(size=[4, 2, 2], anchor=BACK+BOTTOM);
    };
    
    module frame_pattern_tiled(extrude_by) {
        pattern_cleat(repeat)
        frame_pattern(extrude_by);

        linear_extrude(extrude_by)
        polygon([[0,0], [5, 0], [5, -repeat*20 -14.54-2], [0, -repeat*20 -14.54-2]]);
    }

    translate([-Grid_Thickness/2, -Grid_Pitch/2])
    frame_pattern_tiled(2);
    
    translate([-Grid_Thickness/2, -Grid_Pitch/2])
    intersection(){
        frame_pattern_tiled(Background_Depth);
        translate([0,-(repeat*20 +14.54+2)/2,2])
        fillet(l=repeat*20 +14.54+2, r=Background_Depth, ang=90, orient=FRONT);
    }

    linear_extrude(Background_Depth)
    pattern_hanger_dovetails(hanger_dt_add_os, repeat=n_vertical_dovetails, side="left");
}

module create_shelf_cleat() {
    difference() {
        translate([-Grid_Thickness-0.17, -Grid_Pitch-Grid_Thickness*0.8-5])
        cube([10,10,2]);
        translate([-Grid_Thickness/2.5, -Grid_Pitch-Grid_Thickness*0.8-3.01, 2.001])
        mirror([0,0,1])
        wedge(size=[20, 2, 2], anchor=BACK+BOTTOM);
    }   

    module wall_portion() {
        difference() {
            translate([-Grid_Thickness-0.17, -Grid_Pitch-Grid_Thickness*0.8-13])
            cube([10,10,2]);
            translate([-Grid_Thickness/2.5, -Grid_Pitch-Grid_Thickness*0.8-4.9999, 0])
            mirror([0,1,0])
            wedge(size=[20, 2, 2], anchor=BACK+BOTTOM);
        }
        
        translate([Grid_Thickness/2+0.17*2, -Grid_Pitch-Grid_Thickness*0.8-9])
        rotate(90)
        dovetail("female", width=3, height=2, slope=3, slide=10);
    }

    translate([0,0,1])
    resize([30, 0, 0])
    wall_portion();

    resize([7, 0, 0])
    translate([0,0,-2])
    difference() {
        difference() {
            translate([-Grid_Thickness-0.17, -Grid_Pitch*1.3-Grid_Thickness*0.8-13, -4])
            cube([10,Grid_Pitch+10,4]);
            translate([Grid_Thickness/2+0.17*2, -Grid_Pitch-Grid_Thickness*0.8-9])
            rotate(90)
            dovetail("female", width=3.1, height=2.01, slope=3, slide=10);
        }

        translate([Grid_Thickness/2+0.17*2, -Grid_Pitch-Grid_Thickness*0.8-9+Grid_Pitch/2])
        rotate(90)
        dovetail("female", width=3.1, height=2.01, slope=3, slide=10);
    }

    // Back clip
    module back_clip() {
        resize([7, 0, 0])
        translate([-Grid_Thickness-0.17, -Grid_Pitch*1.175-Grid_Thickness*0.8-13, -10.5])
        cube([10,Grid_Pitch/4,3]);

        resize([7, 0, 0])
        translate([-Grid_Thickness-0.17, -Grid_Pitch*1.175-Grid_Thickness*0.8-13+40, -10.5])
        cube([10,Grid_Pitch/4,3]);

        resize([7, 0, 0])
        translate([-Grid_Thickness-0.17, -Grid_Pitch*1.175-Grid_Thickness*0.8-13+48.5, -7.5])
        cube([10,4,3]);

        resize([7, 0, 0])
        translate([-Grid_Thickness-0.17, -Grid_Pitch*1.175-Grid_Thickness*0.8-13+8.5, -7.5])
        cube([10,4,3]);

    }
    back_clip();


    linear_extrude(Background_Depth)
    pattern_hanger_dovetails(hanger_dt_add_os, repeat=1, side="left");
}

module create_ikea_hangers() {
    metal_leg_t = 18.2;
    metalandwood_ledge_t = 31.4;
    metal_ledge_t = 19;

    module bottom_hanger(ledge_thickness) {
        cube([metal_leg_t,10,2]);
        translate([metal_leg_t, 0])
        cube([2,10,6]);

        translate([-2, 0])
        cube([2,10,ledge_thickness+4]);

        translate([-0.25, 0, ledge_thickness+2])
        cube([25,10,2]);

        translate([-Frame_Depth-2, 0, metal_leg_t])
        cube([Frame_Depth, 10, 2]);

        translate([-Frame_Depth-4, 0, metal_leg_t])
        cube([2,10,6]);
    }

    bottom_hanger(metalandwood_ledge_t);

    translate([50+Frame_Depth,0,0])
    bottom_hanger(metal_ledge_t);
}

module create_both_cleats() {
    repeat = Print_Bed_Size == 180 ? 5 : 6;

    // The wall cleat and its drilling template fasten to the wall rather than to the frame, so the
    // combined frame leaves them out unless they were asked for explicitly.
    show_wall_parts = !is_combined_mode || Include_Wall_Mount;

    if (Hanger_Type == "1") {
        color(color_frame_hanger)
        creat_frame_cleat(repeat);

        if (show_wall_parts) {
            translate([0,0,Background_Depth/3])
            wall_cleat(repeat);
        }

        color(color_frame_hanger)
        translate([frame_width-Grid_Thickness,is_odd*Grid_Pitch/2])
        mirror([1,0,0])
        creat_frame_cleat(repeat);

        if (show_wall_parts) {
            translate([0,0,Background_Depth/3])
            translate([frame_width-Grid_Thickness,is_odd*Grid_Pitch/2])
            mirror([1,0,0])
            wall_cleat(repeat, shorten=is_odd);
        }

        if (Hanger_Sets == 2) {
            // Bottom set: identical cleats shifted down so their dovetails land in the mirrored
            // bottom slots. The cleats are translated (not mirrored) so their teeth keep the same
            // orientation and both sets engage together when the panel slides down onto the wall cleats.
            // Both sides use the same shift so the cleats stay inside the frame outline; on odd
            // frames the right-side bottom slots are moved up one pitch to match (see create_border_background).
            bottom_shift = Grid_Pitch*(n_vertical_dovetails+1) - n_triangles_height*Grid_Pitch;

            color(color_frame_hanger)
            translate([0, bottom_shift])
            creat_frame_cleat(repeat);

            if (show_wall_parts) {
                translate([0, bottom_shift, Background_Depth/3])
                wall_cleat(repeat, position="bottom");
            }

            color(color_frame_hanger)
            translate([0, bottom_shift])
            translate([frame_width-Grid_Thickness, is_odd*Grid_Pitch/2])
            mirror([1,0,0])
            creat_frame_cleat(repeat);

            if (show_wall_parts) {
                translate([0, bottom_shift, Background_Depth/3])
                translate([frame_width-Grid_Thickness, is_odd*Grid_Pitch/2])
                mirror([1,0,0])
                wall_cleat(repeat, shorten=is_odd, position="bottom");
            }
        }
    } else if (Hanger_Type == "2") {
        color(color_wall_hanger)
        create_shelf_cleat();
        
        color(color_wall_hanger)
        translate([frame_width-Grid_Thickness,is_odd*Grid_Pitch/2])
        mirror([1,0,0])
        create_shelf_cleat();

    } else if (Hanger_Type == "3") {
        color(color_wall_hanger)
        translate([0, Grid_Pitch])
        create_ikea_hangers();

        color(color_wall_hanger)
        translate([0, Grid_Pitch])
        translate([frame_width-Grid_Thickness,is_odd*Grid_Pitch/2])
        mirror([1,0,0])
        create_ikea_hangers();
    }


}