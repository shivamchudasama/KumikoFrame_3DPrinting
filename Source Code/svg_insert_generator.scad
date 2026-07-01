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
The following instructions are also available here (with images): https://docs.google.com/document/d/19o8Xd_KaTCOf8iYQQnmPdljipetqtiDV3wMY0SX3PGU/edit?tab=t.w1258cfzzugh

----------
BACKGROUND
----------

This file will let you generate the background inserts and designs made using kumikodesigner.com

------------
REQUIREMENTS
------------

1. Your frame parameters (it's important this is inputted correctly to orient and trim the inserts)
2. SVG export file from kumikodesigner.com

-----
STEPS
-----

STEP 0: Complete the following before starting:

    0.1) Finalize your frame via the frame generator. 
        * IMPORTANT: Make sure to note down the frame parameters used.
    
    0.2) Design your panel using kumikodesigner.com. 
        * IMPORTANT: Make sure you selected the correct frame type in kumikodesigner (depends on if your triangle width is odd or even).
            If you select the wrong frame, your design cannot be replicated 1:1. Refer to the instructions for "modular_kumiko_panels.scad"
            to select the correct frame in kumikodesigner and understand if the frame you see in kumikodesigner is the correct one.

    0.3) : Export the SVG from kumikodesigner.com

STEP 1: Prepare the SVG file

    1.1) Head over to https://colab.research.google.com/drive/1pITXvWZ6GxTM8J1czQcOMe9PSDG2r2xx?usp=sharing
    1.2) Run the code
    1.3) Click "Choose Files" and select the SVG file downloaded from kumikodesigner.com
        Note: make sure to only upload one SVG at a time since your browser will block additional downloads (at least mine does...).
    1.4) Download the modified SVG file and add it to the same folder as this file.
    1.5) Come back here for the next step.

STEP 2: Edit the "Frame Dimensions" parameters below to exactly match the frame you generated.
    NOTE: If you forgot to save the dimensions, you can click "p" on your keyboard when looking at your design on kumikodesigner.com
        and the parameters will show up. Ignore the "Frame_Depth" parameter since it'll always be set to 12 on kumikodesigner.com.
        The website creator was very kind to add this option to their site so please consider donating to support their work.

STEP 3: Update the "Insert Components" parameters. See below for details about the parameters:

    3.a) Pattern_Background_Inserts (true or false): Whether to print the background inserts that go behind each kumiko insert.
    3.b) Pattern_Inserts (true or false): Whether to print the kumiko inserts using the SVG file
    3.c) Kumiko_Designer_SVG (path): Path to the prepared SVG file from STEP 1.

STEP 4: Render and Export file as STL (binary).

STEP 5: Open stl in your slicer, split the stl to parts, assign the color, arrange objects, set the print parameters, and print!

* How to split to objects: https://wiki.bambulab.com/en/software/bambu-studio/split-to-objects-parts
* How to assign colors: https://wiki.bambulab.com/en/software/bambu-studio/multi-color-printing
    - I prefer the option of right clicking the object then clicking "Change Filament" and selecting the filament color.
* Recommended Print Parameters:
    * Note: I start with the "0.20mm Standard" preset and then make the following changes to the print profile and save the preset for future use.

    * Layer Height: 0.1 for background, 0.2 for patterns
    * Initial Layer Height: 0.1 for background, 0.2 for patterns
    * Wall Generator: Arachne

    * Wall Loops: 1
    * Top Shell Layers: 5
    * Bottom Shell Layers: 5

    * Sparse Infill: Lightning
    * Sparse Infill Density: 30%

----------

Message me on MakerWorld or Patreon if you have any questions, need help, or notice any bugs.
I'm quite responsive but if there's a lot of individuals contacting me it'll take me longer to respond, so your patience is appreciated.
*/

/* [Insert Components] */

// Generate all the background inserts for the panel
Pattern_Background_Inserts = true;

// Generate inserts designed in Kumiko Designer and Exported as an svg
Pattern_Inserts = true;

// IMPORTANT: Make sure to process the svg first before uploading or else it will not work. See instructions for complete details.
Kumiko_Designer_SVG = "openscad_input__FILENAME.svg";

/* [Frame Dimensions] */

// Select which generator to use for generating the frame.
Generator = "Triangles"; // [Triangles:Use triangles to generate frame., Dimensions:Use height & width dimensions to generate frame.]

// Uses triangles as dimensions (width, height)
Triangle_Generator = [18,24];

// Uses mm as dimensions (width, height). IMPORTANT: panel will be rounded down to fit these dimensions. Refer to Width and Height values under "PARAMETERS" on reference card for correct panel dimensions.
Millimeter_Generator = [1500, 2500];

// Adjusts the border thickness to obtain an exact thickness dimension. If true, the Border_Thickness variable is ignored. Otherwise, round the frame down to fit within the frame constraints.
Make_Exact_Dimensions = false;

// Distance between triangles in frame.
Grid_Pitch = 50;

// Depth of frame
Frame_Depth = 12;

// Thickness of frame
Grid_Thickness = 3;

// Thickness of border around frame. Must be larger than Grid_Thickness*2, otherwise border thickness will default to Grid_Thickness*2. 
Border_Thickness = 0;

// -------- END OF PARAMETERS ----------


// -------- START OF CODE --------------

/* [Hidden] */

$fn = $preview ? 0 : 100;
$fa = 1;
$fs = 0.5;

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

// CALCULATED FIELDS: FRAME DIMENSIONS
triangle_frame_width = n_triangles_width * triangle_height + Grid_Thickness;
triangle_frame_height = n_triangles_height * Grid_Pitch + Grid_Thickness*2;

frame_width = (Generator == "Triangles") ? triangle_frame_width : triangle_frame_width;
frame_height = (Generator == "Triangles") ? triangle_frame_height : triangle_frame_height;

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

// ----------------------------------------------------

module main() {
    // INSERTS
    if (Pattern_Inserts && Kumiko_Designer_SVG != "openscad_input__.svg") {
        color("#D3B7A7")
        translate([0, 0, Frame_Depth*5.5])
        plot_svg_inserts();
    }

    // BACKGROUND INSERTS
    if (Pattern_Background_Inserts) {
        color("white")
        translate([-frame_width/2+Grid_Thickness/2, frame_height/2-Grid_Thickness, Frame_Depth*4.5])
        plot_background_inserts();
    }
};

module plot_svg_inserts() {
    module diff_obj() {
        difference() {
            offset(delta=Grid_Pitch)
            create_mask();
            resize(newsize=[frame_width+selected_border_thickness_width*2+Grid_Thickness*2,frame_height-Grid_Thickness*2])
            create_mask();
        }
    }

    linear_extrude(insert_depth)
    difference() {
        translate([frame_width/2+triangle_height/2+0.33, frame_height/2+Grid_Pitch-Grid_Thickness])
        rotate(-90)
        offset(r=0.004)
        import(Kumiko_Designer_SVG, center=false);
        diff_obj();
    }
}

module plot_background_inserts() {
    module background(split_insert=false) {
        background_edge_width = 0.8;
        linear_extrude(background_thickness + background_edge_thickness)
        difference() {
            polygon([tl, bl, mr]);
            offset(delta=-background_edge_width) // Adjust this to change the width of the background piece
            polygon([tl, bl, mr]);
        };
        linear_extrude(background_thickness)
        polygon([tl, bl, mr]);

        if (split_insert) {
            linear_extrude(background_thickness + background_edge_thickness)
            stroke([l_midpoint, mr], background_edge_width*2, endcaps=false, trim2=background_edge_width*1.25);
        }
    };

    module split_background(split_insert) {
        top_splitter = [[-Grid_Pitch, 0], [-Grid_Pitch, Grid_Pitch], [Grid_Pitch, Grid_Pitch], [Grid_Pitch, 0]];
        bot_splitter = [[-Grid_Pitch, 0], [-Grid_Pitch, -Grid_Pitch], [Grid_Pitch, -Grid_Pitch], [Grid_Pitch, 0]];
        if (split_insert == "top") {
            intersection() {
                linear_extrude(background_thickness + background_edge_thickness)
                polygon(top_splitter);
                translate(path_to_mid)
                background(split_insert=split_insert);
            }

        }
        if (split_insert == "bottom") {
            intersection() {
                linear_extrude(background_thickness + background_edge_thickness)
                polygon(bot_splitter);
                translate(path_to_mid)
                background(split_insert=split_insert);
            }
        }
    };
    // MIDDLE BACKGROUND COMPONENTS
    for (row = [1:1:n_triangles_height*2-1]) {
        for (col = [1:1:n_triangles_width]) {
            row_A = row % 3 == 1;
            row_B = row % 3 == 2;
            row_C = row % 3 == 0;

            alt_mirror = ceil(row/3) % 2 == 0 ? [1,0,0] : [0,0,0];
            angle_temp = row_A ? 180 : 240;
            angle = row_C ? 300 : angle_temp;

            row_shift = row % 2 == 0 ? triangle_height/3 : 0;
            col_shift_1 = col % 2 == 0 && row % 2 != 0? triangle_height/3 : 0;
            col_shift_2 = col % 2 == 0 && row % 2 == 0? -triangle_height/3 : 0;

            translate([-triangle_height/3, 0])
            translate([triangle_height*col - row_shift - col_shift_1 - col_shift_2, -Grid_Pitch*row/2])
            mirror(alt_mirror)
            mirror([1-col%2,0,0])
            rotate(angle)
            translate(path_to_mid)
            background();
        }
    }

    // TOP/BOTTOM BACKGORUND COMPONENTS
    for (col = [1:1:n_triangles_width]) {
        alt_mirror = col % 2 == 0 ? [1,0,0] : [0,0,0];
        col_shift = col % 2 == 0 ? triangle_height/3 : 0;

        translate([(col*triangle_height)-triangle_height + col_shift, 0])
        translate([triangle_height/3, 0])
        mirror(alt_mirror)
        split_background(split_insert="bottom");


        translate([(col*triangle_height)-triangle_height + col_shift, -frame_height+Grid_Thickness*2])
        translate([triangle_height/3, 0])
        mirror(alt_mirror)
        split_background(split_insert="top");
    }
}

module create_mask() {
    p = [[-Grid_Thickness/2,Grid_Thickness], [frame_width-Grid_Thickness/2, Grid_Thickness], [frame_width-Grid_Thickness/2, -frame_height+Grid_Thickness], [-Grid_Thickness/2, -frame_height+Grid_Thickness]];
    translate([-frame_width/2+Grid_Thickness/2, frame_height/2-Grid_Thickness])
    polygon(p);
};