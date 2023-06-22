// include lipo
var_type="case"; // ["case", "base","big-lipo-base","wip","wip-both","wip-big-lipo-base","wip-cuts"]
// which side
var_right=false; // [true,false]
// wireless?
var_lipo=true; // [true,false]
// tent?
var_tent=false; // [true,false]

/* [hidden] */

// tent_angle?
var_tent_angle=40; // [40]

$fn= $preview ? 32 : 64;

bottom_height=2.7;
height_below_pcb = 0.7;

svgs = ["svgs/mykeeb_v7a5-Edge_Cuts.svg"       // 0
       ,"svgs/mykeeb_v7a5-plate-Edge_Cuts.svg" // 1
       ,"svgs/mykeeb_v7a5-base-Edge_Cuts.svg"  // 2
       ,"svgs/mykeeb_v7a5-pcb.svg"             // 3
       ,"svgs/mykeeb_v7a5-no-holes.svg"        // 4
       ,"svgs/mykeeb_v7a5-no-no-holes.svg"     // 5
       ,"svgs/mykeeb_v7a5-holes.svg"           // 6
       ,"svgs/mykeeb_v7a5-cutout.svg"          // 7
       ,"svgs/mykeeb_v7a5-User_Comments.svg"   // 8
       ,"svgs/mykeeb_v7a5-User_1.svg"          // 9
       ,"svgs/mykeeb_v7a5-User_2.svg"          // 10
       ,"svgs/mykeeb_v7a5-User_3.svg"          // 11
       ,"svgs/mykeeb_v7a5-User_4.svg"          // 12
       ,"svgs/mykeeb_v7a5-User_5.svg"          // 13
       ,"svgs/mykeeb_v7a5-User_6.svg"          // 14
       ,"svgs/mykeeb_v7a5-User_7.svg"          // 15
       ,"svgs/mykeeb_v7a5-User_8.svg"          // 16
       ,"svgs/mykeeb_v7a5-User_9.svg"          // 17
       ,"svgs/mykeeb_v7a5-base-pcb.svg"        // 18
       ];

zOffset = [0,0,0];
fcadOffset = [-1.70619,-1.72682,0];
offsets = [zOffset
          ,zOffset
          ,zOffset
          ,fcadOffset
          ,fcadOffset
          ,fcadOffset
          ,fcadOffset
          ,fcadOffset
          ,zOffset
          ,zOffset
          ,zOffset
          ,zOffset
          ,zOffset
          ,zOffset
          ,zOffset
          ,zOffset
          ,zOffset
          ,zOffset
          ,fcadOffset
          ];

module svg(idx=0,height=1.6) {
    render()
        difference() {
            intersection() {
                cube([175,150,height]);
                linear_extrude(height = height)
                    translate(offsets[idx])
                    import(file = svgs[idx],  dpi = 96);
            }
            cube([20,20,height]);
            translate([160,120,0])
                cube([20,20,height]);
        };
}

module pcb(height=1.6) {
    svg(idx=3,height=height);
}

module base_pcb(height=1.6) {
    svg(idx=18,height=height);
}

module under_pcb_space(height=1) {
    svg(idx=9,height=height);
}
module next_to_pcb_space(height=1) {
    svg(idx=15,height=height);
}
module over_pcb_space(height=3) {
    svg(idx=11,height=height);
}
module switch_cutout(height=5) {
    svg(idx=12,height=height);
}

module m3_screw_holes(height, add_r=0) {
    // holes have a diam of 3.2
    if (add_r == 0) {
        svg(idx=17,height=height);
    } else {
        minkowski() {
            svg(idx=17,height=height-0.1);
            cylinder(r=add_r,h=0.1,$fn=12);
        };
    }
}

module m3_inserts(height) {
    m3_screw_holes(height, add_r=0.4);
}

module m3_support(height) {
    m3_screw_holes(height, add_r=1.8);
}

module quater_inch_insert() {
    translate([0,0,-bottom_height]) cylinder(d=8, h=12.7);
}

module quater_inch_support(){
    difference() {
        translate([0,0,-bottom_height]) cylinder(d=8+2*3.3, h=12.7+1);
        quater_inch_insert();
    }
}

module battery_space(height) {
    svg(idx=14,height=height);
}

module wiggle(d=0.2) {
    render()
    for (t = [[d,d,0],[0,d,0],[-d,d,0]
             ,[d,0,0],[0,0,0],[-d,0,0]
             ,[d,-d,0],[0,-d,0],[-d,-d,0]]) {
        translate(t) render() children();
    }
}

module battery_switch_subtract(force = false) {
    if (var_lipo && ! var_tent || force) {
        minkowski() {
            translate([103,37,-5])
                cube([6,10,8],center=true, $fn=20);
            sphere(2,$fn=20);
        }
    }
}

module actual_pcb() {
    color([0,1,0,0.4])
        translate([93.5,90.5,0])
        import("mykeeb_v7a5.stl", convexity=3);
}

module tent(angle=var_tent_angle) {
    dx=7.5;
    translate([dx,0,0])
        rotate([0,-angle,0])
        translate([-dx,0,0])
        children();
}


module maybe_tent(angle=var_tent_angle) {
    if (var_tent) {
        tent(angle=angle)
            children();
    } else {
        children();
    }
}

module tent_wedge(angle) {
    intersection() {
                tent(-angle)
                linear_extrude(height = 300)
                    tent(angle)
                    translate(offsets[18])
                    import(file = svgs[18],  dpi = 96);
        translate([0,0,-200])
        cube([200,300,200]);
    }
}

module top_outer_hull() {
    h_over_zero = 5 + 1.6;
    h_below_zero = bottom_height;
    mink=2;
    render()
        minkowski() {
            translate([0,0,-bottom_height + mink])
                base_pcb(height=5 + 1.6 + bottom_height - mink);
            translate([0,0,- mink])
                cylinder($fn = 6, h=mink, r1=mink, r2=0.3);
        }
}

module top_inner_subtract() {
    space_over_pcb = 1;
    color("red") {
        translate([0,0,1.6])
            switch_cutout();
        translate([0,0,-10]) {
            difference() {
                minkowski() {
                    union() {
                        if (var_lipo) {
                            intersection_for(t=[[0,0,0],[0,-2.5,0],[-3,-1.5,0]]) {
                                translate(t)
                                    battery_space(height = 3.5 + 1.6 + 10);
                            }
                        }
                        over_pcb_space(height = 3.5 + 1.6 + 10);
                    }
                    translate([0,0,-1]) cylinder($fn = 6, h=1, r1=0.3, r2=0.2);
                }
                m3_support(height = 3.5 + 1.6 + 10);
            }
            difference() {
                wiggle(d=0.4)
                    pcb(height = 1.6 + 10 + space_over_pcb);
                m3_support(height = 1.6 + 10 + space_over_pcb);
            }
            intersection () {
                m3_screw_holes(height=10, add_r=6);
                base_pcb(height = 10);
            }
            wiggle(d=0.3) base_pcb(height = 10-height_below_pcb);
            next_to_pcb_space(height = 10+1.6+1);
            under_pcb_space(height = 10);
        }

        battery_switch_subtract();
    }
}

module top() {
    difference() {
        top_outer_hull();
        top_inner_subtract();
        translate([0,0,-10])
            m3_inserts(16.3);
        if(var_tent) {
            thickness_of_feed = 2;
            tent(-var_tent_angle)
                translate([0,0,-50-thickness_of_feed])
                cube([500,150,50]);
        }
    }
}

module bottom_m3_studs() {
    mink_h=0.6;
    translate([0,0,-bottom_height]) {
        minkowski() {
            m3_screw_holes(bottom_height-mink_h, add_r=1.3);
            cylinder($fn = 6, h=mink_h, r1=mink_h/2, r2=0);
        }
    }
}

module bottom_outer_hull() {
    translate([0,0,-bottom_height])
        base_pcb(height = bottom_height - height_below_pcb);
    bottom_m3_studs();
}

module tent_bottom_outer_hull(angle = var_tent_angle, inner_cutoff=10, add_h=0,over_tent=0) {
    intersection() {
        union() {
            bottom_outer_hull();
            translate([0,0,-bottom_height])
            tent_wedge(angle+over_tent);
            if(over_tent != 0) {
                mink_h = 1;
                minkowski() {
                    translate([0,0,-40-bottom_height - mink_h + 0.15 ]) m3_screw_holes(40, add_r=1.9);
                    cylinder(r1=0.5, r2=0, h=mink_h);
                }
            }
        }
        tent(-angle)
            translate([inner_cutoff,0,-add_h])
            cube([300,300,300]);
        cylinder(r=200,400, center=true);
    }
}

module common_bottom_inner_subtract() {
    difference() {
        union() {
            mink_h = 0.5;
            minkowski() {
                translate([0,0,-2.25]) {
                    under_pcb_space(height = 2.5);
                    if (var_lipo && !  var_tent) {
                        battery_space(height = 2.5);
                    }
                }
                cylinder(r1=0, r2=mink_h * 0.75, h=mink_h, $fn=12);
            }
            minkowski() {
                translate([0,0,-height_below_pcb-0.3]) {
                    under_pcb_space(height = height_below_pcb);
                    if (var_lipo && !  var_tent) {
                        battery_space(height = height_below_pcb);
                    }
                }
                cylinder(r1=mink_h * 0.75, r2=mink_h * 0.75+0.3, h=0.3, $fn=12);
            }
        }
        bottom_m3_studs();
    }
}

module bottom_inner_subtract() {
    common_bottom_inner_subtract();
    translate([0,0,-10])
        m3_screw_holes(height = 10);
    translate([0,0,- (1 + 1 + 1 + height_below_pcb)+0.3 -100])
        minkowski() {
            m3_screw_holes(height=101);
            cylinder(r1=1.5, r2=0, h=1.5, $fn=12);
        }
    translate([0,0,2])
        battery_switch_subtract();
}

module bottom_no_tent() {
    difference () {
        bottom_outer_hull();
        bottom_inner_subtract();
    }
}

module tent_bottom_hull_subtract() {
    tent(-var_tent_angle) {
        difference() {
            hull() {
                translate([70,0,0])
                    scale([1,1,1.3])
                    rotate([-90,0,0])
                    cylinder(r=30,h=150,$fn=100);
                tent(var_tent_angle)
                    translate([100,0,0])
                    tent(-var_tent_angle)
                    translate([70,0,0])
                    scale([1,1,1.3])
                    rotate([-90,0,0])
                    cylinder(r=30,h=150,$fn=100);
                translate([150,0,0])
                    scale([1,1,1.3])
                    rotate([-90,0,0])
                    cylinder(r=30,h=150,$fn=100);
            }
        }
    }
}

module tent_bottom_outer_hull_wedge_subtracted() {
    tent()
    difference () {
        tent_bottom_outer_hull();
        tent_bottom_hull_subtract();
    }
}

module tent_bottom_column(height) {
   translate([13,9,0]) cube([14,2,height]);
}

module tent_bottom_column_support(height,mink_r) {
    minkowski() {
        hull() {
            cube([40,20,height - 0.1]);
            children();
        }
        cylinder(r=mink_r,h=0.1);
    }
}

module tent_bottom() {
    column_positions=[[[80,95,0],[0,0,20]]
                     ,[[105,28,0],[0,0,-60]]
                     ];
    mink_r=3.5;
    tent()
        difference () {
            tent_bottom_outer_hull();
            bottom_inner_subtract();
            difference() {
                tent_bottom_hull_subtract();
                tent(-var_tent_angle) {
                    for(trans=column_positions) {
                        translate(trans[0])
                            rotate(trans[1])
                            minkowski() {
                                tent_bottom_column(trans[0][0]*0.4);
                                // cube([40,20,150]);
                                cylinder(r=mink_r,h=1);
                            }
                        hull() {
                            translate(trans[0])
                                rotate(trans[1])
                                minkowski() {
                                    translate([0,0,trans[0][0]*0.4]) tent_bottom_column(10);
                                    cylinder(r=3.5,h=1);
                                }
                            intersection() {
                                translate(trans[0])
                                    rotate(trans[1])
                                    tent_bottom_column_support(150, mink_r);
                                tent_bottom_outer_hull_wedge_subtracted();
                            }
                        }
                    }
                }
            }
            tent(-var_tent_angle)
                        translate([130,120,-50])
                            cube([300,300,300]);
        };
    for(trans=column_positions) {
        translate(trans[0])
            rotate(trans[1]) {
                tent_bottom_column_support(1, mink_r-1) {
                    tent_bottom_column(11);
                };
                if ($preview) {
                    color("gray")
                        translate([0,0,-2.5])
                        tent_bottom_column_support(2.5, 0);
                }
            };
    }
    if ($preview) {
        translate([34,60,0])
            rotate([0,0,90])
            color("gray")
            translate([0,0,-2.5])
            tent_bottom_column_support(2.5, 0);
    }
}

module big_lipo(add_h) {
    /*
     place for a lipo LP502245
     with e.g. 480mAh
       | W | 22.5mm |
       | H |  5.4mm |
       | L |   47mm |
     */
    size = [22.5, 47, 5.4];
    translate([0,0,add_h/2])
    hull() {
        cube(size + [add_h,0,0], center=true);
        cube(size + [0,add_h,0], center=true);
        cube(size + [0,0,add_h], center=true);
    }
}

module big_lipo_bottom() {
    // WIP
    angle=5;
    tent(angle=angle)
        difference() {
            tent_bottom_outer_hull(angle=angle, add_h=2, inner_cutoff=0, over_tent=30);
            bottom_inner_subtract();
            translate([0,0,2])
                battery_switch_subtract(force = true);
            tent(angle=-angle) {
                difference() {
                    translate([106.5,90,1.5]) {
                        intersection() {
                            hull() {
                                big_lipo(add_h=1);
                                translate([-10,-7,10]) big_lipo(add_h=2);
                                translate([-10,-2,10]) big_lipo(add_h=2);
                            }
                            hull() {
                                big_lipo(add_h=1);
                                translate([-3,-7,10]) big_lipo(add_h=2);
                                translate([-2,-2,10]) big_lipo(add_h=2);
                            }
                        }
                        translate([-2,-1,7]) big_lipo(add_h=1.4);
                        translate([-2,-1.9,7]) big_lipo(add_h=1.4);
                        color("red")
                            rotate([0,0,90])
                            translate([0,0,-3])
                            linear_extrude(0.31)
                            text("LP502245",
                                    font = "Roboto Condensed:style=bold",
                                    size = 6.5,
                                    halign = "center");
                    }
                    
                    // Latch
                    translate([92,102,3])
                        intersection() {
                            difference() {
                                translate([0,-4,0]) cube([4,9,4]);
                                translate([5,0,-1]) rotate([90,0,0]) cylinder(r=4, h=10, center=true);
                                translate([2,-4,1.3]) rotate([0,45,0]) cube([4,9,4]);
                            };
                            translate([0,0,4]) rotate([90,0,0]) cylinder(r=4, h=10, center=true);
                        }
                }
                // Cable
                minkowski(){
                    translate([70,54,0]){
                        translate([-1,0.7,0])
                        rotate([0, 0, 20]) 
                            hull() {
                                cube([40,3,2]);
                                translate([0,1.45,0])
                                cube([40,0.1,7.5]);
                            }
                        translate([-14,-6.5,0]) cube([17,10,10]);

                    }
                    cylinder(r1=0, r2=1, h=1);
                }

                // translate([77.6,66,0.7])
                //     quater_inch_insert();
            }
        }
}

module bottom() {
    if (var_tent) {
        tent_bottom();
    } else {
        bottom_no_tent();
    }
}

if(var_type=="case"){
    mirror(var_right == false ? [0,0,0] : [1,0,0])
        top();
    if($preview) {
        translate([0,150,0]) top_outer_hull();
        translate([0,-150,0]) top_inner_subtract();
    }
}else if(var_type=="base"){
    mirror(var_right == false ? [0,0,0] : [1,0,0])
        bottom();
    if($preview) {
        translate([0,150,0]) bottom_outer_hull();
        translate([0,-150,0]) bottom_inner_subtract();
    }
}else if(var_type=="big-lipo-base"){
    mirror(var_right == false ? [0,0,0] : [1,0,0]) {
        big_lipo_bottom();
        if($preview) {
            color("gray")
            translate([106.5,90,1.5])
            big_lipo(add_h=0.7);
        }
    }
}else if(var_type=="wip-big-lipo-base"){
    // big_lipo_bottom();
    if($preview) {
        color("gray")
        translate([106.5,90,1.5])
        big_lipo(add_h=0.7);
    }
    tent(angle=5) {
        top();
        actual_pcb();
    }
}else if(var_type=="wip-both"){
    maybe_tent() {
        top();
        actual_pcb();
    }
        bottom();
}else if(var_type=="wip-cuts"){
    maybe_tent() {
        intersection() {
            top();
            sphere(100);
        }
        intersection() {
            actual_pcb();
            sphere(115);
        }
    }
        intersection() {
            bottom();
            difference() {
                sphere(131);
                sphere(85);
            }
        }
}else{
    intersection() {
        union() {
    big_lipo_bottom();
    color("gray")
        translate([103.5,90,1.5])
        big_lipo(add_h=0.7);
        }
        translate([0,0,-5])
        cube([100,200,30]);
    }
}