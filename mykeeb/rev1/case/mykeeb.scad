screwsM3=[[71.45, 38.1]
        ,[44.396516, 43.963668]
        ,[194.111215, 108.536998]
        ,[164.30625, 121.44375]
        ,[61.005076, 144.019868]];

screwsM2=[[76.2, 83.34375]
        ,[194.066981, 78.224296]
        ,[174.831232, 50.681104]
        ,[133.35, 71.4375]
        ,[119.0625, 111.91875]];


difference(){ 
    union() {
    translate([0,0,2])
        difference() {
            linear_extrude(height = 3, convexity = 10)
                import (file = "../pcb/mykeeb-Edge_Cuts.svg");
            linear_extrude(height = 3, convexity = 10)
                import (file = "../pcb/mykeeb-Nutzer_2.svg");
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
        color("red")
            minkowski() {
                translate([-38,152])
                    mirror([0,1,0]) {
                        for (s=screwsM3) {
                            translate(s) cylinder(d=3.2,h=2,$fn=20);
                        }
                        for (s=screwsM2) {
                            translate(s) cylinder(d=2.2,h=2,$fn=20);
                        }
                    };
                cylinder(d=2.5,h=3,$fn=20);
            };
    }
    /* color("red") */
    /*     translate([-38,152]) */
    /*     mirror([0,1,0]) { */
    /*         for (s=screwsM3) { */
    /*             translate(s) cylinder(d=3.2,h=10,$fn=20); */
    /*         } */
    /*         for (s=screwsM2) { */
    /*             translate(s) cylinder(d=2.2,h=10,$fn=20); */
    /*         } */
    /*     } */
}

difference() {
    minkowski() {
        translate([0,0,-4])
            linear_extrude(height = 5, convexity = 10)
            import (file = "../pcb/mykeeb-Edge_Cuts.svg");
        cylinder(d1=4,d2=1,h=4);

    }
    translate([0,0,-4])
        linear_extrude(height = 9, convexity = 10)
        import (file = "../pcb/mykeeb-Edge_Cuts.svg");
}
