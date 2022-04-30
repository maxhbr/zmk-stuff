angle=35;
lowerDrop=[0,0,-1.6-11];
lowerOffset=[-0.0005,-43.357,0];


// ############################################################################
// ## lib #####################################################################
// ############################################################################

module limitCube() {
    translate([0,0,-2])
        rotate([0,angle,0])
        translate([-20,-50,0])
        cube([200,150,100]);
}

module tent() {
    t=[-10,0,0];
    a=-35;
    translate(-t)
        rotate([0,a,0])
        translate(t)
        children();
}

module edge(h=3, top=true) {
    linear_extrude(height = h, convexity = 10)
        if (top) {
            import (file = "../mykeeb/mykeeb-Edge_Cuts.svg");
        } else {
            translate(lowerOffset)
                import (file = "../mykeeb-adapter/mykeeb-adapter-Edge_Cuts.svg");
        };
}

module screwHoles(h=10, top=true) {
    minkowski() {
        intersection() {
            linear_extrude(height = h, convexity = 10)
                if (top) {
                    import (file = "../mykeeb/mykeeb-Nutzer_1.svg");
                } else {
                    translate(lowerOffset)
                        import (file = "../mykeeb-adapter/mykeeb-adapter-Nutzer_1.svg");
                }
            edge(h=h,top=top);
        }
        children();
    }
}

module keyCutout(top=true) {
    translate([0,0,-5]) {
        minkowski() {
            intersection() {
                union() {
                    linear_extrude(height = 8.5, convexity = 10)
                        if (top) {
                            import (file = "../mykeeb/mykeeb-Nutzer_2.svg");
                            import (file = "../mykeeb/mykeeb-Nutzer_3.svg");
                        } else {
                            translate(lowerOffset) {
                                import (file = "../mykeeb-adapter/mykeeb-adapter-Nutzer_2.svg");
                                import (file = "../mykeeb-adapter/mykeeb-adapter-Nutzer_3.svg");
                            }
                        };
                }
                edge(h=8.5,top=top);
            }
            translate([0,0,-1.5]) cylinder(d1=1,d2=0,h=1.5,$fn=8);
        }
        intersection() {
            linear_extrude(height = 10, convexity = 10)
                if (top) {
                    import (file = "../mykeeb/mykeeb-Nutzer_2.svg");
                } else {
                    translate(lowerOffset)
                        import (file = "../mykeeb-adapter/mykeeb-adapter-Nutzer_2.svg");
                };
            edge(h=10, top=top);
        }
    }
}

// ############################################################################
// ## bottom ##################################################################
// ############################################################################

module bottomBoundary() {
    rotate([0,angle,0])
        linear_extrude(height = 100, convexity = 10)
        projection(cut = false)
        rotate([0,-angle,0]) {
            edge(top=true);
            edge(top=false);
        }
}
module bottom() {
    color("green")
        render(convexity = 2)
        difference() {
            intersection() {
                union() {
                    difference() {
                        translate([0,0,-1.6-2]) {
                            rotate([-90,0,0])
                                rotate_extrude(angle=angle, convexity=10) 
                                import (file = "../mykeeb/mykeeb-Edge_Cuts.svg");
                            linear_extrude(height = 2, convexity = 10)
                                import (file = "../mykeeb/mykeeb-Nutzer_4.svg");
                            screwHoles(h=0.5, top=true)
                                cylinder(d1=5, d2=4, h=1.5, $fn=20);
                        }
                        minkowski() {
                            translate(lowerDrop + [0,0,-3])
                                edge(h=40, top=false);
                            cylinder(d=2, h=1, $fn=8);
                        }
                        screwHoles(h=0.5, top=true)
                            translate([0,0,-8])
                            cylinder(d1=2, h=1.5+8, $fn=20);
                    }
                    translate(lowerDrop) {
                        difference() {
                            translate([0,0,-1.6-2]) {
                                rotate([-90,0,0])
                                    rotate_extrude(angle=angle, convexity=10) 
                                    translate(lowerOffset)
                                    import (file = "../mykeeb-adapter/mykeeb-adapter-Edge_Cuts.svg");
                                linear_extrude(height = 2, convexity = 10)
                                    translate(lowerOffset)
                                    import (file = "../mykeeb-adapter/mykeeb-adapter-Nutzer_4.svg");
                                screwHoles(h=0.5, top=false)
                                    cylinder(d1=5, d2=4, h=1.5, $fn=20);
                            }
                            screwHoles(h=0.5, top=false)
                                translate([0,0,-8])
                                cylinder(d1=2, h=1.5+8, $fn=20);
                        }
                    }
                }
                limitCube();
                rotate([0,angle,0])
                    translate([5,-50,-50])
                    cube([200,150,150]);
            }
            minkowski() {
                translate([0,0,-16-16])
                    linear_extrude(height = 16, convexity = 10)
                    translate(lowerOffset)
                    import (file = "../mykeeb-adapter/mykeeb-adapter-Nutzer_7.svg");
                cylinder(d=2, h=1, $fn=8);
            }

            translate([67,70,-36])
                cube([20,50,15]);
        }
}

// ############################################################################
// ## top #####################################################################
// ############################################################################

module plate(top=true) {
    difference(){
        union() {
            translate([0,0,2])
                difference() {
                    edge(h=3,top=top);
                    screwHoles(top=top) cylinder(d=0.2,h=1, $fn=20);
                    screwHoles(top=top) translate([0,0,1]) cylinder(d=3,h=1,$fn=20);
                }
        }
        keyCutout(top=top);
        if (! top) {
            edge(h=10,top=true);
        }
    }
}

module shroud(top=true) {
    addH=5;
    difference() {
        minkowski() {
            difference() {
                translate([0,0,-addH])
                    edge(h=5,top=top);
                if (! top) {
                    translate([0,0,-addH])
                        edge(h=10,top=true);
                }
            }
            cylinder(d1=4.5,d2=1,h=addH);

        }
        keyCutout(top=top);
        difference() {
            translate([0,0,-addH])
                edge(h=5+addH,top=top);
            difference() {
                    minkowski() {
                        union() {
                            linear_extrude(height = 2, convexity = 10)
                                if (top) {
                                    import (file = "../mykeeb/mykeeb-Nutzer_4.svg");
                                } else {
                                    translate(lowerOffset)
                                        import (file = "../mykeeb-adapter/mykeeb-adapter-Nutzer_4.svg");
                                };
                            screwHoles(h=1,top=top)
                                cylinder(h=1, d=4, $fn=8);
                        }
                        cylinder(h=2, d1=0.7, d2=2, $fn=8);
                    }

                    screwHoles(top=top) cylinder(d=0.2,h=1, $fn=20);
            }
        }
        minkowski() {
            translate([0,0,-addH])
                edge(h=addH-1, top=top);
            cylinder(d=0.5, h=1, $fn=8);
        }

        if (top) {
            translate([0,0,-10])
                minkowski() {
                    linear_extrude(height = 20, convexity = 10)
                    translate(lowerOffset)
                    import (file = "../mykeeb-adapter/mykeeb-adapter-Nutzer_8.svg");
                cylinder(d=0.5, h=1, $fn=8);
            }
        }
    }

}


module top(top=true) {
    difference() {
        if (top) {
            color("blue")
                render(convexity = 2) {
                    intersection() {
                        union() {
                            plate();
                            shroud();
                        }
                        limitCube();
                    }
                }
        } else {
            color("red")
                translate(lowerDrop)
                render(convexity = 2) {
                    plate(top=false);
                    shroud(top=false);
                }
        }
        for(t=[[0.2,0.2,0],[-0.2,0.2,0],[-0.2,-0.2,0],[0.2,-0.2,0]]){
            bottom();
        }
    }
}

// ############################################################################
// ## adapter ###################################################################
// ############################################################################

module adapterPlate() {
    difference(){
        union() {
            translate([0,0,2])
                difference() {
                    adapterEdge(h=3);
                    adapterScrewHoles() cylinder(d=0.2,h=1, $fn=20);
                    adapterScrewHoles() translate([0,0,1]) cylinder(d=3,h=1,$fn=20);
                }
        }
        keyCutout();
    }
}

// ############################################################################
// ## compose #################################################################
// ############################################################################



rotate([0,-angle,0]) {
    top();
    top(top=false);

    bottom();

    if($preview) {
        translate([86.99,38.175,-1.6])
            color("gray")
            import("../mykeeb/mykeeb.stl");
        translate([86.99,38.175,-1.6 *2-11])
            color("darkgray")
            import("../mykeeb-adapter/mykeeb-adapter.stl");
    }
}
translate([0,200,0]){
    top();
    top(top=false);
};

translate([200,0,0])
    bottom();
