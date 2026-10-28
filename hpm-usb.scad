// Power strip holder for HPM 4 way powerstrip with USB connectors
$fn=360;
stripLength=254; // Probably 10 inches
stripWidth=75; // Probably 3 inches
stripFeet=2;
stripDepth=27+stripFeet-3; // 27mm plus "feet"
stripCableWidth=16;  // Clearance for cable at the base
wallThickness=1.6;
plateThickness=2;
usbWidth=40; // 37, but use 40
clearance=0.25;
bracketOverhang=15;

module roundedCube(width=1,length=1,height=1,diameter=1,fn=4) {
    minkowski() {
        cube([width-(diameter*.75),length-(diameter*0.75),height-(diameter*.75)], true);
        sphere(d=diameter, $fn=fn);
    }
}


module endBracket(usbEnd=false) {
    bracketWallThickness=(wallThickness+clearance);
    difference() {
        roundedCube(stripWidth+(bracketWallThickness*2), stripDepth+(wallThickness*4),bracketOverhang+(bracketWallThickness*2), 2, 6);
        if(usbEnd) {
            translate([0,-wallThickness/2,bracketWallThickness])
                roundedCube(stripWidth+(clearance*2), stripDepth+(clearance*2), (bracketOverhang*2)+(bracketWallThickness*2), 2, 6);
        } else {
            translate([0,-wallThickness/2,bracketWallThickness])
                roundedCube(stripWidth+(clearance*2), stripDepth+(clearance*2), bracketOverhang+(bracketWallThickness*2), 2, 6);
        }
    }
    //translate([0,0,1]) {
    //    cube([stripWidth+(clearance*2), stripDepth+(clearance*2), bracketOverhang+(bracketWallThickness*2)], true);
    //}
}

module screwHole() {
    screwHeadDiameter=8;
    screwHeadHeight=3;
    screwShaftDiameter=3.5;
    screwHeadEdgeDepth=1;
    rotate([0,90,90]) {
        cylinder(d=screwHeadDiameter, h=screwHeadEdgeDepth);
        translate([0,0,screwHeadEdgeDepth]) {
            cylinder(d1=screwHeadDiameter, d2=screwShaftDiameter, h=screwHeadHeight);
            cylinder(d=screwShaftDiameter, h=wallThickness+screwHeadHeight);
        }
    }
}

module screwDriverHole() {
    screwHeadDiameter=bracketOverhang*.75;
    rotate([0,270,90]) {
        cylinder(d=screwHeadDiameter, h=wallThickness*3, $fn=4);
    }
}


module screwHoles() {
    spacing=40/2;
    translate([0,((stripDepth+clearance*2)/2)-wallThickness/2,0]) {
        translate([-spacing,0,0]) {
            screwHole();
        }
        translate([spacing,0,0]) {
            screwHole();
        }
    }
    translate([0,-(stripDepth+clearance*2)/2,bracketOverhang*0]) {
        hull() {
            translate([-spacing,0,0]) {
                screwDriverHole();
            }
            translate([spacing,0,0]) {
                screwDriverHole();
            }
            translate([-spacing,0,bracketOverhang]) {
                screwDriverHole();
            }
            translate([spacing,0,bracketOverhang]) {
                screwDriverHole();
            }
            translate([-spacing/3,0,-(bracketOverhang/6)+clearance*20]) {
                screwDriverHole();
            }
            translate([spacing/3,0,-(bracketOverhang/6)+clearance*20]) {
                screwDriverHole();
            }
        }
    }
}

module cordHole() {
    cutoutHeight=bracketOverhang+wallThickness*4;
    translate([0,0,-cutoutHeight/2])
    rotate([0,0,0])
    hull() {
        cylinder(d=stripCableWidth, h=cutoutHeight);
        translate([0,-10,cutoutHeight/2])
            cube([stripCableWidth,stripCableWidth,cutoutHeight],true);
    }
}

module cordBracket() {
    difference() {
        endBracket();
        screwHoles();
        cordHole();
    }
    #translate([0,(stripDepth/2)+wallThickness*1.99,0])
        cube([stripWidth,0.25,bracketOverhang], true);
}

module usbHoles() {
    spacing=40/2;
    howDeep=10;
    translate([0,-(stripDepth+clearance*2)/2,-bracketOverhang*1]) {
        hull() {
            translate([-spacing,0,0]) {
                screwDriverHole();
            }
            translate([spacing,0,0]) {
                screwDriverHole();
            }
            translate([-spacing,0,bracketOverhang]) {
                screwDriverHole();
            }
            translate([spacing,0,bracketOverhang]) {
                screwDriverHole();
            }
        }
    }
}

module usbBracket() {
    difference() {
        endBracket(usbEnd=true);
        screwHoles();
        usbHoles();
    }
    #translate([0,(stripDepth/2)+wallThickness*1.99,0])
        cube([stripWidth,0.25,bracketOverhang], true);
}

if(false){
    cordBracket();
} else {
    usbBracket();
}