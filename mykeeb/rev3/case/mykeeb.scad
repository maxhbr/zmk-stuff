type="top"; // ["top","bottom"]
brokenOff=false; // [true,false]

// ############################################################################
// ## lib #####################################################################
// ############################################################################

module tent() {
    t=[-10,0,0];
    a=-35;
    translate(-t)
    rotate([0,a,0])
    translate(t)
    children();
}

module edge(h=3) {
    if (brokenOff) {
        linear_extrude(height = h, convexity = 10)
            import (file = "../pcb/mykeeb-Nutzer_9.svg");
    } else {
        linear_extrude(height = h, convexity = 10)
            import (file = "../pcb/mykeeb-Edge_Cuts.svg");
    }
}

module screwHoles(h=10) {
    minkowski() {
        intersection() {
            linear_extrude(height = h, convexity = 10)
                import (file = "../pcb/mykeeb-Nutzer_1.svg");
            edge(h=h);
        }
        children();
    }
}

module keyCutout() {
    translate([0,0,-5]) {
        minkowski() {
            intersection() {
                union() {
                    linear_extrude(height = 8.5, convexity = 10)
                        import (file = "../pcb/mykeeb-Nutzer_2.svg");
                    linear_extrude(height = 8.5, convexity = 10)
                        import (file = "../pcb/mykeeb-Nutzer_3.svg");
                }
                edge(h=8.5);
            }
            translate([0,0,-1.5]) cylinder(d1=1,d2=0,h=1.5,$fn=8);
        }
        intersection() {
            linear_extrude(height = 10, convexity = 10)
                import (file = "../pcb/mykeeb-Nutzer_2.svg");
            edge(h=10);
        }
    }
}

// ############################################################################
// ## bottom ##################################################################
// ############################################################################

module bottom() {
    translate([0,0,-1.6 - 4]) {
        edge(h=2);
    }
}

// ############################################################################
// ## top #####################################################################
// ############################################################################

module plate() {
    difference(){
        union() {
            translate([0,0,2])
                difference() {
                    edge(h=3);
                    screwHoles() cylinder(d=0.2,h=1, $fn=20);
                    screwHoles() translate([0,0,1]) cylinder(d=3,h=1,$fn=20);
                }
        }
        keyCutout();
    }
}

module shroud() {
    addH=5;
    difference() {
        minkowski() {
            translate([0,0,-addH])
                edge(h=5);
            cylinder(d1=4.5,d2=1,h=addH);

        }
        keyCutout();
        difference() {
            translate([0,0,-addH])
                edge(h=5+addH);
            difference() {
                    minkowski() {
                        union() {
                            linear_extrude(height = 2, convexity = 10)
                                import (file = "../pcb/mykeeb-Nutzer_4.svg");
                            screwHoles(h=1)
                                cylinder(h=1, d=4, $fn=8);
                        }
                        cylinder(h=2, d1=0.7, d2=2, $fn=8);
                    }

                    screwHoles() cylinder(d=0.2,h=1, $fn=20);
            }
        }
        minkowski() {
            translate([0,0,-addH])
                edge(h=addH-1);
            cylinder(d=0.5, h=1, $fn=8);
        }
        for(t=[[-0.2,-0.2],[-0.2,0.2],[0.2,-0.2],[0.2,0.2]]) {
            translate(t) translate([0,0,0.2]) bottom();
        }
    }

}

module top() {
    plate();
    shroud();
}

module assembly() {
    tent()
        top();
    tent()
    bottom();
}

if (type=="top") {
    mirror([0,0,1])
        top();
}
if (type=="bottom") {
    bottom();
}

if($preview) {
    translate([0,150,0]) {
        assembly();
    }
    /* tent() */
    color("gray")
        tent()
        translate([96.5,228.2,-1.6])
        import("./mykeeb.stl");
}

