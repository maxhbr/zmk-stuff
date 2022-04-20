type="top"; // ["top","bottom"]


module bottom() {
    translate([0,0,-1.6 - 4]) {
        difference() {
            union() {
                linear_extrude(height = 2, convexity = 10)
                    import (file = "../pcb/mykeeb-Edge_Cuts.svg");
            }
        }
    }
}

module plate() {
    difference(){ 
        union() {
            translate([0,0,2])
                difference() {
                    linear_extrude(height = 3, convexity = 10)
                        import (file = "../pcb/mykeeb-Edge_Cuts.svg");
                    minkowski() {
                        union() {
                            linear_extrude(height = 1.5, convexity = 10)
                                import (file = "../pcb/mykeeb-Nutzer_2.svg");
                            linear_extrude(height = 1.5, convexity = 10)
                                import (file = "../pcb/mykeeb-Nutzer_3.svg");
                        }
                        translate([0,0,-1.5]) cylinder(d1=1,d2=0,h=1.5,$fn=8);
                    }

                }
        }
        linear_extrude(height = 5, convexity = 10)
            import (file = "../pcb/mykeeb-Nutzer_2.svg");
    }
}

module shroud() {
    addH=5;
    difference() {
        minkowski() {
            translate([0,0,-addH])
                linear_extrude(height = 5, convexity = 10)
                import (file = "../pcb/mykeeb-Edge_Cuts.svg");
            cylinder(d1=4,d2=1,h=addH);

        }
        translate([0,0,-addH])
            linear_extrude(height = 5+addH, convexity = 10)
            import (file = "../pcb/mykeeb-Edge_Cuts.svg");
        minkowski() {
            translate([0,0,-addH])
                linear_extrude(height = addH-1, convexity = 10)
                import (file = "../pcb/mykeeb-Edge_Cuts.svg");
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

if (type=="top") {
    mirror([0,0,1])
        top();
}
if (type=="bottom") {
    bottom();
}

if($preview) {
    translate([0,150,0]) {
        top();
        bottom();
    }
}

