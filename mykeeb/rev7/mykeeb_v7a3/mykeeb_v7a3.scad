
svgs= [ "./svg/mykeeb_v7a3-Edge_Cuts.svg"
      , "./svg/mykeeb_v7a3-User_1.svg"
      , "./svg/mykeeb_v7a3-User_2.svg"
      , "./svg/mykeeb_v7a3-User_3.svg"
      , "./svg/mykeeb_v7a3-User_4.svg"
      , "./svg/mykeeb_v7a3-User_5.svg"
      , "./svg/mykeeb_v7a3-User_6.svg"
      , "./svg/mykeeb_v7a3-User_7.svg"
      , "./svg/mykeeb_v7a3-User_8.svg"
      , "./svg/mykeeb_v7a3-User_9.svg"
      ];
module svg_to_solid(idx=0,h=10) {
    minkowski() {
        linear_extrude(height = h, convexity = 10)
            import (file = svgs[idx]);
        children();
    }
}
