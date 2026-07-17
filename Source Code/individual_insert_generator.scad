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

if (Split_In_Half) {
    create_split_plate();
} else {
    create_plate();
}

/* [Parameters] */

Insert_Pattern = 1; // [-1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39]
Insert_Color = "#D3B7A7"; // color
// Insert Thickness
Insert_Thickness = 4;
N_Components = 1;
Split_In_Half = false;
// Note: only needed for asymmetric inserts
Alternative_Cut = false;

/* [Frame Dimensions] */

// Thickness of frame
Grid_Thickness = 3;
// Pitch of triangles in frame
Grid_Pitch = 40; // .5
// Depth of frame
Frame_Depth = 10; // .5

/* [Magnet Parameters] */

Add_Magnet = false;
Magnet_Diameter = 10;
Embed_Magnet = false;
Magnet_Height = 2;
Fill_Object = false;

/* [Hidden] */
$fn = $preview ? 0 : 100;
$fa = 1;
$fs = 0.5;

// Background and insert depth
// background_thickness = 0.2;
// background_edge_thickness = 0.4;
// background_frame_support_depth = 0.4;
background_thickness = 0;
background_edge_thickness = 0;
background_frame_support_depth = 0.4;
support_edge_width = 0.8;

background_offset = background_thickness + background_frame_support_depth + background_edge_thickness;
insert_depth = Frame_Depth - background_offset;

// UNSORTED PARAMETERS
triangle_height = tan(60) * Grid_Pitch / 2;
path_to_mid = [-triangle_height/3, Grid_Pitch/2];

// REFERENCE POSITIONS and PATHS
inner_triangle_offset = opp_ang_to_adj(opp=Grid_Thickness/2, ang=30);
tl = [Grid_Thickness/2, -inner_triangle_offset]; // TOP LEFT
bl = [Grid_Thickness/2, -Grid_Pitch+inner_triangle_offset]; // BOTTOM LEFT
mr = [triangle_height-Grid_Thickness, -Grid_Pitch/2]; // MIDDLE RIGHT

// TRIANGLE MIDPOINTS
mm = [triangle_height/3, -Grid_Pitch/2]; // TRIANGLE_CENTERPOINT
tr_midpoint = midpoint(tl, mr); // TOP RIGHT MIDPOINT
br_midpoint = midpoint(bl, mr); // BOTTOM RIGHT MIDPOINT
l_midpoint = midpoint(bl, tl); // MIDDLE LEFT MIDPOINT

// TRIANGLE MIDPOINT OFFSETS
l = adj_ang_to_hyp(adj=Grid_Pitch/2-inner_triangle_offset, ang=15);
tr_midpoint_offset = get_newpos(mr, l, 165);
br_midpoint_offset = get_newpos(mr, l, -165);
l_midpoint_offset = get_newpos(bl, l, 75);

// HELPER FUNCTIONS
function get_newpos(xy, l, angle) = [xy[0]+l*cos(angle), xy[1]+l*sin(angle)];
function get_length(xy1, xy2) = sqrt((xy2[0]-xy1[0])^2+(xy2[1]-xy1[1])^2);
function midpoint(xy1, xy2) = [(xy1[0]+xy2[0])/2, (xy1[1]+xy2[1])/2];

// COMMON TRIANGLE PATHS
tl_mm = [tl, mm];
bl_mm = [bl, mm];
mr_mm = [mr, mm];
ml_mm = [l_midpoint, mm];

// ----------------------
// INSERT GENERATOR CODE
// ----------------------

module midtriangle() {
    polygon([l_midpoint, tr_midpoint, br_midpoint, l_midpoint]);
};

function flipped_midtriangle(s=0.5, points=[tl,bl,mr,tl]) = move(path_to_mid*-1, p=scale(s, p=move(path_to_mid, p=points)));

module flipped_midtriangle(s=0.5) {
    p = flipped_midtriangle(s);
    polygon(p);
};

module insert_triangle() {
    difference() {
    polygon([[0,0], [0, -Grid_Pitch], [triangle_height, -Grid_Pitch/2]]);
    difference() {
        polygon([[0,0], [0, -Grid_Pitch], [triangle_height, -Grid_Pitch/2]]);
        offset(delta=-Grid_Thickness/2) 
        polygon([[0,0], [0, -Grid_Pitch], [triangle_height, -Grid_Pitch/2]]);
    }
    };
};

module a() {
    translate(path_to_mid)
    intersection() {
        insert_triangle();
        stroke([tl, mm, bl, mm, mr], Insert_Thickness);
    }
};

module b() {
    module objs() {
        stroke([tr_midpoint_offset, tl, l_midpoint_offset, mr, tr_midpoint_offset, bl, l_midpoint_offset, bl, br_midpoint_offset, mr, br_midpoint_offset, tl], Insert_Thickness, endcaps="chisel");
    };
    translate(path_to_mid)
    intersection() {
        insert_triangle();
        objs();

    }

};
module c() {
    module objs() {
        mt = flipped_midtriangle(0.25);
        stroke([tr_midpoint_offset, tl, l_midpoint_offset, mt[2]], Insert_Thickness, endcaps="chisel");
        stroke([l_midpoint_offset, bl, br_midpoint_offset, mt[0]], Insert_Thickness, endcaps="chisel");
        stroke([br_midpoint_offset, mr, tr_midpoint_offset, mt[1]], Insert_Thickness, endcaps="chisel");
    };
    
    translate(path_to_mid)
    intersection() {
        insert_triangle();
        objs();

    }
};

module d() {
    module objs() {
        stroke([l_midpoint_offset, bl, br_midpoint_offset, mr, tr_midpoint_offset, tl, l_midpoint_offset, mm, br_midpoint_offset, mm, tr_midpoint_offset], Insert_Thickness, endcaps="chisel");
    };
    
    translate(path_to_mid)
    intersection() {
        insert_triangle();
        objs();
    };
};

module e() {
    module objs() {
        stroke([l_midpoint_offset, bl, br_midpoint_offset, mr, tr_midpoint_offset, tl, l_midpoint_offset, br_midpoint_offset, tr_midpoint_offset, l_midpoint_offset], Insert_Thickness, endcaps="chisel");
    };

    translate(path_to_mid)
    intersection() {
        insert_triangle();
        objs();

    };
};

module f() {
    module objs() {
        mt = flipped_midtriangle(0.25);
        stroke([mt[2], bl, mt[0], mr], Insert_Thickness, endcaps="square", endcap_angle=45);
        stroke([mt[1], tl, mt[2], bl], Insert_Thickness, endcaps="square", endcap_angle=15);
        stroke([mt[0], mr, mt[1]], Insert_Thickness, endcap2="round", endcap_angle=75, endcap1="square");
    };
    
    translate(path_to_mid)
    intersection() {
        insert_triangle();
        objs();
    };
};

module g() {
    module objs() {
        p1 = get_newpos(br_midpoint, Grid_Pitch, 75);
        p2 = get_newpos(br_midpoint, Grid_Pitch, 165);
        stroke([tl, br_midpoint, p1, br_midpoint, p2], Insert_Thickness);
    };
    
    translate(path_to_mid)
    intersection() {
        insert_triangle();
        objs();
    };
};

module h() {
    module objs() {
        stroke([
        tl, 
        [triangle_height/5.5, -Grid_Pitch/2],
        [triangle_height, -Grid_Pitch/2],
        [triangle_height/5.5, -Grid_Pitch/2],
        bl
        ], Insert_Thickness, endcaps="chisel");
    };
    
    rotate(120)
    translate(path_to_mid)
    intersection() {
        insert_triangle();
        objs();
    };
};

module i() {
    module objs() {
        stroke([tl, br_midpoint_offset], Insert_Thickness, endcaps="chisel");
        stroke([mr, l_midpoint_offset], Insert_Thickness, endcaps="chisel");
        stroke([bl, tr_midpoint_offset], Insert_Thickness, endcaps="chisel");
    };
    
    translate(path_to_mid)
    intersection() {
        insert_triangle();
        objs();
    };

};

module j() {
    module objs() {
        mt = flipped_midtriangle(0.25);
        stroke([l_midpoint, mt[2]], Insert_Thickness, endcaps="square");
        stroke([tr_midpoint, mt[1]], Insert_Thickness, endcaps="square");
        stroke([br_midpoint, mt[0]], Insert_Thickness, endcaps="square");
    };

    translate(path_to_mid)
    intersection() {
        insert_triangle();
        objs();
    };
};

module k() {
    module objs() {
        stroke([[0, -Grid_Pitch/4], [triangle_height/2, -Grid_Pitch/2], [0, -Grid_Pitch*(3/4)]],
        Insert_Thickness, endcaps="square");
    };

    intersection() {
        translate(path_to_mid)
        insert_triangle();
        rot_copies(n=3)
        translate(path_to_mid)
        objs();
    };
};

module l() {
    module objs() {
        stroke([[0, -Grid_Pitch/3], [triangle_height/3, -Grid_Pitch/2], [0, -Grid_Pitch+Grid_Pitch/3]], Insert_Thickness, endcaps="square");
        stroke([[triangle_height/2, -Grid_Pitch/2], [triangle_height/6, -Grid_Pitch/2]], Insert_Thickness, endcaps="chisel");
    };

    intersection() {
        translate(path_to_mid)
        insert_triangle();
        rot_copies(n=3)
        translate(path_to_mid)
        objs();
    };
};

module m() {
    module objs() {
        stroke([l_midpoint, 
        mr,
        [0, -Grid_Pitch/4],
        mr,
        [0, -Grid_Pitch*(3/4)]
        ],
        Insert_Thickness, endcaps="square");
    };

    rotate(120)
    translate(path_to_mid)
    intersection() {
        insert_triangle();
        objs();
    };
};

module n() {
    module objs() {
        path = turtle([
            "jump", tl,
            "turn", -45,
            "move", Grid_Pitch
        ]);
        stroke(path, Insert_Thickness, endcaps="square");
        path2 = turtle([
            "jump", [-Insert_Thickness*5, 0],
            "jump", [0, -Grid_Pitch],
            "jump", bl,
            "turn", 45,
            "move", Grid_Pitch
        ]);
        stroke(path2, Insert_Thickness, endcaps="square");
    };

    rotate(120)
    translate(path_to_mid)
    intersection() {
        insert_triangle();
        objs();
    };
};

module o() {
    module objs() {
        stroke([l_midpoint, l_midpoint_offset, tr_midpoint_offset, tr_midpoint, tr_midpoint_offset, br_midpoint_offset, br_midpoint, br_midpoint_offset, l_midpoint_offset], Insert_Thickness);
    };

    translate(path_to_mid)
    intersection() {
        insert_triangle();
        objs();
    };
};

module p() {
    module objs() {
        path1_p1 = [triangle_height/5.5, -Grid_Pitch/2];
        path1_p2 = get_newpos(path1_p1, Grid_Pitch/2, 75);
        path1 = [path1_p1, path1_p2];
        l = law_of_sines(a=triangle_height/2.5, A=45, B=15);
        p1 = [triangle_height-Grid_Thickness-triangle_height/2.5, -Grid_Pitch/2];
        p2 = get_newpos(p1, l, 120);
        path2 = [p1, p2, get_newpos(p2, l, 45)];
        path3 = [p2, get_newpos(p2, Grid_Pitch, 165)];
        stroke(path1, Insert_Thickness, endcaps=false);
        stroke(path2, Insert_Thickness*1.5, endcaps=false, joints="square");
        stroke(path3, Insert_Thickness, endcaps=false, joints="square");
        stroke([l_midpoint, mr], Insert_Thickness);
    };

    rotate(120)
    intersection() {
        translate(path_to_mid)
        insert_triangle();
        union() {
        translate(path_to_mid)
        objs();
        mirror([0,1,0])
        translate(path_to_mid)
        objs();
        };
    };
};

module q() {
    module objs() {
        mt = flipped_midtriangle();
        path1 = [[0,0], midpoint(mt[0], mt[1]), [0, -Grid_Pitch], midpoint(mt[1], mt[2]), [triangle_height, -Grid_Pitch/2], midpoint(mt[2], mt[0])];
        path_len = path_segment_lengths(path1,closed=true);
        halflen = min(path_len/2);

        difference() {
            polygon(round_corners(path1, method="smooth", joint=[0,halflen,0,halflen,0,halflen], k=1));
            offset(delta=-Insert_Thickness)
            polygon(round_corners(path1, method="smooth", joint=[0,halflen,0,halflen,0,halflen], k=1));
        };
    };

    translate(path_to_mid)
    intersection() {
        insert_triangle();
        objs();
    };
};

module r() {
    module objs() {
        path1 = [mm, tr_midpoint_offset, get_newpos(mr, Insert_Thickness*2, 0), br_midpoint_offset];
        path2 = [mm, br_midpoint_offset, get_newpos(bl, Insert_Thickness*2, -120), l_midpoint_offset];
        path3 = [mm, l_midpoint_offset, get_newpos(tl, Insert_Thickness*2, 120), tr_midpoint_offset];
        path_len = path_segment_lengths(path1,closed=true);
        halflen = min(path_len/2);

        difference() {
            offset(delta=0.01)
            polygon(round_corners(path1, method="smooth", joint=[halflen,halflen,0,halflen], k=1));
            offset(delta=-Insert_Thickness)
            polygon(round_corners(path1, method="smooth", joint=[halflen,halflen,0,halflen], k=1));
        };
        difference() {
            offset(delta=0.01)
            polygon(round_corners(path2, method="smooth", joint=[halflen,halflen,0,halflen], k=1));
            offset(delta=-Insert_Thickness)
            polygon(round_corners(path2, method="smooth", joint=[halflen,halflen,0,halflen], k=1));
        };
        difference() {
            offset(delta=0.01)
            polygon(round_corners(path3, method="smooth", joint=[halflen,halflen,0,halflen], k=1));
            offset(delta=-Insert_Thickness)
            polygon(round_corners(path3, method="smooth", joint=[halflen,halflen,0,halflen], k=1));
        };
    };
    translate(path_to_mid)
    intersection() {
        insert_triangle();
        objs();
    };
};

module s() {
    module objs() {
        path1 = [mm, tr_midpoint_offset, get_newpos(mr, Insert_Thickness*6, 0), br_midpoint_offset];
        path2 = [mm, br_midpoint_offset, get_newpos(bl, Insert_Thickness*6, -120), l_midpoint_offset];
        path3 = [mm, l_midpoint_offset, get_newpos(tl, Insert_Thickness*6, 120), tr_midpoint_offset];
        path_len = path_segment_lengths(path1,closed=true);
        halflen = min(path_len/2);

        difference() {
            offset(delta=0.01)
            polygon(round_corners(path1, method="smooth", joint=[halflen,halflen,0,halflen], k=1));
            offset(delta=-Insert_Thickness)
            polygon(round_corners(path1, method="smooth", joint=[halflen,halflen,0,halflen], k=1));
        };
        difference() {
            offset(delta=0.01)
            polygon(round_corners(path2, method="smooth", joint=[halflen,halflen,0,halflen], k=1));
            offset(delta=-Insert_Thickness)
            polygon(round_corners(path2, method="smooth", joint=[halflen,halflen,0,halflen], k=1));
        };
        difference() {
            offset(delta=0.01)
            polygon(round_corners(path3, method="smooth", joint=[halflen,halflen,0,halflen], k=1));
            offset(delta=-Insert_Thickness)
            polygon(round_corners(path3, method="smooth", joint=[halflen,halflen,0,halflen], k=1));
        };
    };
    translate(path_to_mid)
    intersection() {
        insert_triangle();
        objs();
    };
};

module t() {
    module objs() {
        l1 = [mr, get_newpos(mr, Grid_Pitch, 180-15)];
        l2 = [bl, get_newpos(bl, Grid_Pitch, 45)];
        p1 = line_intersection(l1, l2);

        stroke([bl, p1], Insert_Thickness);
    };

    intersection() {
        translate(path_to_mid)
        insert_triangle();
        rot_copies(n=3)
        translate(path_to_mid)
        objs();
    };
};

module u() {
    module objs() {
        p1 = [0, -Grid_Pitch/2.5];
        path = [p1, get_newpos(p1, Grid_Pitch, -30)];
        stroke(path, Insert_Thickness, endcaps="square");
    };

    intersection() {
        translate(path_to_mid)
        insert_triangle();
        rot_copies(n=3)
        translate(path_to_mid)
        objs();
    };
};

module v() {
    module objs() {
        p1 = [0, -Grid_Pitch/4];
        p2 = get_newpos(p1, Grid_Pitch, -60);
        p3 = line_intersection([p1, p2], bl_mm);
        p4 = get_newpos(p3, Grid_Pitch, 0);
        path1 = [p1, p3, p4];
        stroke(bl_mm, Insert_Thickness, endcaps="square");
        stroke(path1, Insert_Thickness, endcaps="square");
    };

    intersection() {
        translate(path_to_mid)
        insert_triangle();
        rot_copies(n=3)
        translate(path_to_mid)
        objs();
    };
};

module w() {
    module objs() {
        path1 = [bl, get_newpos(bl, Grid_Pitch/3, 60)];

        p1 = [0, -Grid_Pitch/4];
        p2 = get_newpos(p1, Grid_Pitch, -60);
        p_intersection = line_intersection([p1, p2], path1);
        p3 = get_newpos(p_intersection, Grid_Pitch, 0);
        path2 = [p1, p_intersection, p3];
        stroke(path2, Insert_Thickness, endcaps="square");
        stroke([bl, p_intersection], Insert_Thickness, endcaps="square");
    };

    intersection() {
        translate(path_to_mid)
        insert_triangle();
        rot_copies(n=3)
        translate(path_to_mid)
        objs();
    };
};

module x() {
    module objs() {
        p_mid = midpoint(mr_mm[0], mr_mm[1]+[-Insert_Thickness, 0]);
        p1 = get_newpos(p_mid, Grid_Pitch, 60);
        p2 = get_newpos(p_mid, Grid_Pitch, 300);

        path1 = [p1, p_mid, p2];
        stroke(path1, Insert_Thickness);
        difference() {
            flipped_midtriangle();
            offset(delta=-Insert_Thickness)
            flipped_midtriangle();
        };
        difference() {
            midtriangle();
            offset(delta=-Insert_Thickness)
            midtriangle();
        };
    };

    intersection() {
        translate(path_to_mid)
        insert_triangle();
        rot_copies(n=3)
        translate(path_to_mid)
        objs();
    };
};

module y() {
    module objs() {
        path = [mr, midpoint(mr_mm[0], mr_mm[1]+[-Insert_Thickness, 0])];
        stroke(path, Insert_Thickness, endcaps="square");

        difference() {
            flipped_midtriangle();
            offset(delta=-Insert_Thickness)
            flipped_midtriangle();
        };
        difference() {
            midtriangle();
            offset(delta=-Insert_Thickness)
            midtriangle();
        };
    };

    intersection() {
        translate(path_to_mid)
        insert_triangle();
        rot_copies(n=3)
        translate(path_to_mid)
        objs();
    };
};

module z() {
    module objs() {
        p1 = [0, -Grid_Pitch/2.25];
        path = [p1, get_newpos(p1, Grid_Pitch, 0)];
        p_intersection = line_intersection(path, tl_mm);
        p2 = get_newpos(p_intersection, Grid_Pitch, 60);
        p3 = get_newpos(p_intersection, -Grid_Pitch+(Grid_Pitch/3.5*2), 90);

        stroke([p1, p_intersection, p2], Insert_Thickness);
        translate([triangle_height/3, -Grid_Pitch/2])
        rotate(180)
        translate(path_to_mid)
        difference() {
            midtriangle();
            offset(delta=-Insert_Thickness)
            midtriangle();
        };
    };

    intersection() {
        translate(path_to_mid)
        insert_triangle();
        rot_copies(n=3)
        translate(path_to_mid)
        objs();
    };
};

module aa() {
    module objs() {
        p1 = [0, -Grid_Pitch/2.25];
        path = [p1, get_newpos(p1, Grid_Pitch, 0)];
        p_intersection = line_intersection(path, tl_mm);
        p2 = get_newpos(p_intersection, Grid_Pitch, 60);
        p3 = get_newpos(p_intersection, -Grid_Pitch+(Grid_Pitch/3.5*2), 90);
        stroke([p1, p_intersection, p2], Insert_Thickness);

        path2 = [mr, midpoint(mr_mm[0], mr_mm[1]+[-Insert_Thickness, 0])];
        stroke(path2, Insert_Thickness, endcaps="square");

        difference() {
            flipped_midtriangle();
            offset(delta=-Insert_Thickness)
            flipped_midtriangle();
        };
    };

    intersection() {
        translate(path_to_mid)
        insert_triangle();
        rot_copies(n=3)
        translate(path_to_mid)
        objs();
    };
};

module ab() {
    module objs() {
        stroke(mr_mm, Insert_Thickness, endcaps="square");

        difference() {
            midtriangle();
            offset(delta=-Insert_Thickness)
            midtriangle();
        };
    };

    intersection() {
        translate(path_to_mid)
        insert_triangle();
        rot_copies(n=3)
        translate(path_to_mid)
        objs();
    };
};

module ac() {
    module objs() {
        p1 = [0, -Grid_Pitch/3];
        path = [p1, get_newpos(p1, Grid_Pitch, 0)];
        p_intersection = line_intersection(path, tl_mm);
        p2 = get_newpos(p_intersection, Grid_Pitch, 60);
        p3 = get_newpos(p_intersection, -Grid_Pitch+(Grid_Pitch/3.5*2), 90);
        stroke([p1, p_intersection, p2], Insert_Thickness);

        stroke([p_intersection, mm], Insert_Thickness);

        difference() {
            flipped_midtriangle(0.75);
            offset(delta=-Insert_Thickness)
            flipped_midtriangle(0.75);
        };
    };

    intersection() {
        translate(path_to_mid)
        insert_triangle();
        rot_copies(n=3)
        translate(path_to_mid)
        objs();
    };
};

module ad() {
    module objs() {
        p1 = [0, -Grid_Pitch/3];
        path = [p1, get_newpos(p1, Grid_Pitch, 0)];
        p_intersection = line_intersection(path, tl_mm);
        p2 = get_newpos(p_intersection, Grid_Pitch, 60);
        p3 = get_newpos(p_intersection, -Grid_Pitch+(Grid_Pitch/3.5*2), 90);
        stroke([p1, p_intersection, p2], Insert_Thickness);

        stroke([l_midpoint, mm], Insert_Thickness);

        difference() {
            flipped_midtriangle(0.75);
            offset(delta=-Insert_Thickness)
            flipped_midtriangle(0.75);
        };
    };

    intersection() {
        translate(path_to_mid)
        insert_triangle();
        rot_copies(n=3)
        translate(path_to_mid)
        objs();
    };
};

module ae() {
    module objs() {
        ratio = 0.65;
        path = flipped_midtriangle(ratio);
        stroke([mr, path[2]-[Insert_Thickness, 0]], Insert_Thickness);

        difference() {
            flipped_midtriangle(ratio);
            offset(delta=-Insert_Thickness)
            flipped_midtriangle(ratio);
        };
    };

    intersection() {
        translate(path_to_mid)
        insert_triangle();
        rot_copies(n=3)
        translate(path_to_mid)
        objs();
    };
};

module af() {
    module objs() {
        ratio = 0.7;
        path = flipped_midtriangle(ratio);
        mp = path[2];
        stroke([mp, get_newpos(mp, Grid_Pitch, 90)], Insert_Thickness*2);
        stroke([mp, get_newpos(mp, Grid_Pitch, 270)], Insert_Thickness*2);

        difference() {
            flipped_midtriangle(ratio);
            offset(delta=-Insert_Thickness)
            flipped_midtriangle(ratio);
        };
    };

    intersection() {
        translate(path_to_mid)
        insert_triangle();
        rot_copies(n=3)
        translate(path_to_mid)
        objs();
    };
};

module az() {
    module objs() {
        ratio = 0.7;
        path = flipped_midtriangle(ratio);
        path2 = flipped_midtriangle(2.8, [l_midpoint, tr_midpoint, br_midpoint, l_midpoint]);

        difference() {
            offset(delta=0.1)
            offset(delta=Insert_Thickness)
            polygon(path2);
            offset(delta=-0.1)
            offset(delta=-Insert_Thickness)
            polygon(path2);

        };

        stroke([path[0], mm], Insert_Thickness);
        stroke([path[1], mm], Insert_Thickness);
        stroke([path[2], mm], Insert_Thickness);
    };

    intersection() {
        translate(path_to_mid)
        insert_triangle();
        translate(path_to_mid)
        objs();
    };
};

module ag() {
    module objs() {
        path = flipped_midtriangle(0.75);
        mp = path[2];
        mp_ = path[2]-[Insert_Thickness*3, 0];

        path2 = flipped_midtriangle((0.75/mp[0])*mp_[0]);
        mp2 = path2[2];
        p1 = get_newpos(mp, Grid_Pitch/4, 90);
        p2 = get_newpos(mp2, Grid_Pitch/4, 90);

        stroke([p1, get_newpos(p1, Grid_Pitch/2, 270)], Insert_Thickness);
        stroke([p2, get_newpos(p2, Grid_Pitch/2, 270)], Insert_Thickness);
        stroke([mp, l_midpoint], Insert_Thickness);

        mp3 = path[1];
        mp4 = path2[1];
        p3 = get_newpos(mp3, Grid_Pitch/4, 150);
        p4 = get_newpos(mp4, Grid_Pitch/4, 150);

        stroke([p3, get_newpos(p3, Grid_Pitch/2, 330)], Insert_Thickness);
        stroke([p4, get_newpos(p4, Grid_Pitch/2, 330)], Insert_Thickness);
        stroke([mp3, tr_midpoint], Insert_Thickness);

        mp5 = path[0];
        mp6 = path2[0];
        p5 = get_newpos(mp5, Grid_Pitch/4, 30);
        p6 = get_newpos(mp6, Grid_Pitch/4, 30);

        stroke([p5, get_newpos(p5, Grid_Pitch/2, 210)], Insert_Thickness);
        stroke([p6, get_newpos(p6, Grid_Pitch/2, 210)], Insert_Thickness);
        stroke([mp5, br_midpoint], Insert_Thickness);

    };

    intersection() {
        translate(path_to_mid)
        insert_triangle();
        translate(path_to_mid)
        objs();
    };
};

module ah() {
    module objs() {
        stroke([mr, mm], Insert_Thickness);
        stroke([tl, mm], Insert_Thickness);
        stroke([bl, mm], Insert_Thickness);
        stroke([br_midpoint, tr_midpoint, l_midpoint, br_midpoint], Insert_Thickness);
        p1 = tr_midpoint+[Insert_Thickness*3, 0];
        difference() {
            offset(delta=Insert_Thickness*3.5)
            midtriangle();
            offset(delta=Insert_Thickness*2.5)
            midtriangle();
        }
    };

    intersection() {
        translate(path_to_mid)
        insert_triangle();
        translate(path_to_mid)
        objs();
    };
};

module ai() {
    module objs() {
        p = flipped_midtriangle();
        stroke([tl, p[0], l_midpoint, p[1], bl, p[1], br_midpoint, p[2], mr, p[2], tr_midpoint, p[0]], Insert_Thickness);
    };

    translate(path_to_mid)
    intersection() {
        insert_triangle();
        objs();
    };
};

module aj() {
    module objs() {
        p1 = [0, -Grid_Pitch/3];
        path = [p1, get_newpos(p1, Grid_Pitch, 0)];
        p_intersection = line_intersection(path, tl_mm);
        p2 = get_newpos(p_intersection, Grid_Pitch, 60);
        p3 = get_newpos(p_intersection, -Grid_Pitch+(Grid_Pitch/3.5*2), 90);
        stroke([p1, p_intersection, p2], Insert_Thickness);
        stroke([p_intersection, mm], Insert_Thickness);
    };

    intersection() {
        translate(path_to_mid)
        insert_triangle();
        rot_copies(n=3)
        translate(path_to_mid)
        objs();
    };
};

module ak() {
    module objs() {
        mt = flipped_midtriangle(0.25);
        mt2 = flipped_midtriangle(-0.25);
        stroke([tl, mt[0], mt2[1], tr_midpoint, mt2[1], mt[2], mr, mt[2], mt2[0], br_midpoint, mt2[0], mt[1], bl, mt[1], mt2[2], l_midpoint, mt2[2], mt[0]], Insert_Thickness);
    };

    translate(path_to_mid)
    intersection() {
        insert_triangle();
        objs();
    };
};

module al() {
    module objs() {
        stroke([l_midpoint, mm, tr_midpoint, mm, br_midpoint], Insert_Thickness);
    };

    translate(path_to_mid)
    intersection() {
        insert_triangle();
        objs();
    };
};

module test_tube_holder() {
    mt = flipped_midtriangle(0.25);
    mt2 = flipped_midtriangle(-0.25);
    test_tube_d = 26;
    holder_t = 2;
    hex_height = (mt[0] - mt[1])[1];
    holder_h = 4;
    
    module create_insert() {
        intersection() {
            insert_triangle();
            stroke([tl, mt[0], mt2[1], tr_midpoint, mt2[1], mt[2], mr, mt[2], mt2[0], br_midpoint, mt2[0], mt[1], bl, mt[1], mt2[2], l_midpoint, mt2[2], mt[0]], Insert_Thickness);
        }
    }

    module holder() {
        linear_extrude(holder_h)
        difference() {
            hull() {
                translate([0, test_tube_d/2+holder_t])
                square([hex_height/1.75-Insert_Thickness/2, 4], center=true);
                circle(d=test_tube_d+holder_t*2);
            }
            circle(d=test_tube_d);
        }

        translate([0, insert_depth+test_tube_d/2+4-0.01, hex_height/2-Insert_Thickness/2-0.05])
        rotate([90,0])
        translate(path_to_mid)
        linear_extrude(insert_depth)
        offset(delta=-Insert_Thickness/2-0.1)
        polygon([mt[0], mt2[1], mt2[1], mt[2], mt2[0], mt2[0], mt[1], mt2[2]]);
    }

    linear_extrude(insert_depth)
    translate(path_to_mid)
    create_insert();

    translate([0, hex_height/2-Insert_Thickness/2, insert_depth*3+test_tube_d/2])
    rotate([90, 180, 0])
    holder();
}

module add_magnet() { 
    if (Add_Magnet) {
        magnet_h_cut = Embed_Magnet ? Magnet_Height+0.2 : insert_depth;

        difference() {
            children();
            translate([0,0,2])
            cylinder(h=magnet_h_cut, r=Magnet_Diameter/2+0.1);
        }
    } else {
        children();
    }
}

module fill_object() {
    if (Fill_Object) {
        fill() {
            children();
        }
    } else {
        children();
    }
}

module plot_inserts(pattern, id, quantity, split_insert, splits="both") {
    if (pattern == 0) {color(Insert_Color) line_copies([0, Grid_Pitch], quantity) prepare_splits(split_insert, splits) translate(path_to_mid) background(split_insert);}
    if (pattern == -1) {color(Insert_Color) test_tube_holder();}

    color(Insert_Color)
    line_copies([0, Grid_Pitch], quantity)
    add_magnet()
    linear_extrude(id)
    fill_object()
    prepare_splits(split_insert, splits)
    if (pattern == 1) {      a();} 
    else if (pattern == 2) { i();}
    else if (pattern == 3) { d();}
    else if (pattern == 4) { e();}
    else if (pattern == 5) { c();}
    else if (pattern == 6) { f();}
    else if (pattern == 7) { b();}
    else if (pattern == 8) { r();}
    else if (pattern == 9) { s();}
    else if (pattern == 10) {j();}
    else if (pattern == 11) {u();}
    else if (pattern == 12) {l();}
    else if (pattern == 13) {o();}
    else if (pattern == 14) {p();}
    else if (pattern == 15) {q();}
    else if (pattern == 16) {g();}
    else if (pattern == 17) {h();}
    else if (pattern == 18) {n();}

    else if (pattern == 19) {m();}

    else if (pattern == 20) {w();}
    else if (pattern == 21) {v();}
    else if (pattern == 22) {x();}
    else if (pattern == 23) {y();}
    else if (pattern == 24) {ab();}
    else if (pattern == 25) {z();}
    else if (pattern == 26) {aa();}
    else if (pattern == 27) {ad();}
    else if (pattern == 28) {ac();}
    else if (pattern == 29) {ah();}
    else if (pattern == 30) {t();}
    else if (pattern == 31) {ae();}
    else if (pattern == 32) {k();}
    else if (pattern == 33) {ag();}
    else if (pattern == 34) {az();}
    else if (pattern == 35) {af();}
    else if (pattern == 36) {ak();}
    else if (pattern == 37) {ai();}
    else if (pattern == 38) {aj();}
    else if (pattern == 39) {al();};
}

module split_insert(splitter_mask) {
    if (Insert_Pattern == 0) {
        intersection() {
            linear_extrude(background_thickness + background_edge_thickness)
            polygon(splitter_mask);
            children();
        }
    } else {
        intersection() {
            polygon(splitter_mask);
            children();
        }
    }
}

module prepare_splits(split_insert, splits="both") {
    top_splitter = [[-Grid_Pitch, 0], [-Grid_Pitch, Grid_Pitch], [Grid_Pitch, Grid_Pitch], [Grid_Pitch, 0]];
    bot_splitter = [[-Grid_Pitch, 0], [-Grid_Pitch, -Grid_Pitch], [Grid_Pitch, -Grid_Pitch], [Grid_Pitch, 0]];

    alternative_cut_rotation = Alternative_Cut && Insert_Pattern != 0 ? 60 : 0;
    alternative_mirror = Alternative_Cut && Insert_Pattern != 0 ? [1,0,0] : [0,0,0];

    if (split_insert) {
        if (splits == "top" || splits == "both") {
            translate([0,Grid_Thickness])
            mirror(alternative_mirror)
            split_insert(top_splitter)
            rotate(alternative_cut_rotation)
            children();

        }
        if (splits == "bottom" || splits == "both") {
            mirror(alternative_mirror)
            split_insert(bot_splitter)
            rotate(alternative_cut_rotation)
            children();
        }
    } else {
        children();
    }
}

module background(split_insert) {
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

module create_plate() {
    max_cols = ceil(ceil(sqrt(N_Components))/1.25);
    n_rows = ceil(N_Components/max_cols);

    total_position_shift = [-max_cols*triangle_height/2-triangle_height/3, n_rows/4*Grid_Pitch+Grid_Pitch/4];

    for (row = [1:1:n_rows]) {
        for (col = [1:1:max_cols]) {
            index = (row-1)*max_cols + col;
            row_A = row % 3 == 1;
            row_B = row % 3 == 2;
            row_C = row % 3 == 0;

            alt_mirror = ceil(row/3) % 2 == 0 ? [1,0,0] : [0,0,0];
            angle_temp = row_A ? 180 : 240;
            angle = row_C ? 300 : angle_temp;

            row_shift = row % 2 == 0 ? triangle_height/3 : 0;
            col_shift_1 = col % 2 == 0 && row % 2 != 0? triangle_height/3 : 0;
            col_shift_2 = col % 2 == 0 && row % 2 == 0? -triangle_height/3 : 0;

            if (index <= N_Components) {
                translate(total_position_shift)
                translate([triangle_height*col - row_shift - col_shift_1 - col_shift_2, -Grid_Pitch*row/2])
                mirror(alt_mirror)
                mirror([1-col%2,0,0])
                rotate(angle)
                plot_inserts(Insert_Pattern, insert_depth, 1, false);
            }
        }
    }
}

module create_split_plate() {
    split_components = ceil(N_Components/2);
    max_cols = ceil(ceil(sqrt(split_components))/1.25);
    n_rows = ceil(split_components/max_cols);

    total_position_shift = [-max_cols*triangle_height/2-triangle_height*(2/3), n_rows/4*Grid_Pitch+Grid_Pitch/2];

    for (row = [1:1:n_rows]) {
        for (col = [1:1:max_cols]) {
            index = (row-1)*max_cols + col;
            row_shift = (triangle_height/3)*(1-row%2);

            col_shift_1 = col % 2 == 0 && row % 2 != 0? triangle_height/3 : 0;
            col_shift_2 = col % 2 == 0 && row % 2 == 0? -triangle_height/3 : 0;

            split_type = N_Components % 2 == 1 && index == split_components ? "top" : "both";

            if (index <= split_components) {
                translate(total_position_shift)
                translate([triangle_height*col + row_shift, -(Grid_Pitch/2+Grid_Thickness)*row])
                mirror([1-row%2,0,0])
                plot_inserts(Insert_Pattern, insert_depth, 1, true, split_type);
            }
        }
    }
}
