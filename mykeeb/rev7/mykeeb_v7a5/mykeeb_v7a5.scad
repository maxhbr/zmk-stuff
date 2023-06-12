// include lipo
var_type="case"; // ["case", "base","wip"]
// which side
var_right=false; // [true,false]

/* [hidden] */

height_below_pcb = 1.5;

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
            svg(idx=17,height=height-1);
            cylinder(r=add_r,h=1,$fn=12);
        };
    }
}

module m3_inserts(height) {
    m3_screw_holes(height, add_r=0.4);
}

module m3_support(height) {
    m3_screw_holes(height, add_r=1.8);
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

module battery_switch_subtract() {
        minkowski() {
            translate([103,37,-5-2])
                cube([4,10,10],center=true, $fn=20);
            sphere(2);
        }
}

module top_outer_hull() {
    mink=1.5;
    height_below_pcb = 3.5;
    render()
        minkowski() {
            translate([0,0,-height_below_pcb + mink])
                base_pcb(height=5 + 1.6 + height_below_pcb - mink);
            translate([0,0,- mink/2])
                cylinder($fn = 6, h=mink, r1=mink, r2=0.3, center=true);
        }
}

module top_inner_subtract() {
    height_below_pcb = 1.5;
    space_over_pcb = 1;
    color("red") {
        translate([0,0,1.6])
            switch_cutout();
        translate([0,0,-10]) {
            difference() {
                minkowski() {
                    union() {
                        difference() {
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
                wiggle()
                    pcb(height = 1.6 + 10 + space_over_pcb);
                m3_support(height = 1.6 + 10 + space_over_pcb);
            }
            difference() {
                wiggle(d=0.4)
                    pcb(height = 10);
            }
            intersection () {
                m3_screw_holes(height=10, add_r=6);
                base_pcb(height = 10);
            }
            wiggle(d=0.4) base_pcb(height = 10-height_below_pcb);
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
    }
}

module bottom_m3_studs() {
    translate([0,0,-height_below_pcb]) {
        minkowski() {
            m3_screw_holes(height_below_pcb, add_r=1.3);
            translate([0,0,- 1/2])
                cylinder($fn = 6, h=1, r1=0.5, r2=0, center=true);
        }
    }
}

module bottom_outer_hull() {
    bottom_m3_studs();
    translate([0,0,-height_below_pcb - 2])
        base_pcb(height = 2);
}

module bottom_inner_subtract() {
    difference() {
        minkowski() {
            translate([0,0,-2.5]) {
                under_pcb_space(height = 2.5);
                battery_space(height = 2.5);
            }
            cylinder(r1=0,r2=1.5,h=2,$fn=12);
        }
        bottom_m3_studs();
    }
    translate([0,0,-10])
        m3_screw_holes(height = 10);
    translate([0,0,- (1 + 1 + 2.5)])
        minkowski() {
            m3_screw_holes(height=1);
            cylinder(r1=1.5, r2=0, h=1.5, $fn=12);
        }
    battery_switch_subtract();
    // translate([0,0,-2])
    //     bottom_m3_studs();
}

module bottom() {
    difference () {
        bottom_outer_hull();
        bottom_inner_subtract();
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
}else{
    intersection() {
        top();
        sphere(100);
    }
    intersection() {
        bottom();
        difference() {
            sphere(130);
            sphere(85);
        }
    }
    intersection() {
        color([0,1,0,0.4])
            translate([93.5,90.5,0])
            import("mykeeb_v7a5.stl", convexity=3);
        sphere(115);
    }
}
