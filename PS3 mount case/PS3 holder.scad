use <quickthread.scad>

caseThickness = 2;
caseWidth = 70;
caseHeight = 25;
caseLength = 70;



$fa=0.5;  // default minimum facet angle
$fs=0.5; // default minimum facet size

module mountThread(h=5) {
    // 1/4 inch iso inner thread, 20 threads per inch
    difference() {
        d = 1/4*25.4;
        echo(d=d);
        l = d*2;
        translate([-l/2,-l/2,-h/2]) cube([l,l,h]);
        //translate([0,0,-h/2]) cylinder(h=h, d=d);
    }
}

module cableHole(d, h, thickness) {
    translate([0,-d/2,0]) cube([thickness,d, h]);
    translate([0,0,0]) rotate([0,90,0]) cylinder(h=thickness,d=d);
    
}

module cameraSupports(h=5) {
    translate([-20,20,0]) 
        support(innerD = 1.5, outerD = 3, h = h);
    translate([20,20,0]) 
        support(innerD = 1.5, outerD = 3, h = h);
    translate([-25,10,0]) 
        support(innerD = 1.5, outerD = 3, h = h); 
    translate([25,10,0]) 
        support(innerD = 1.5, outerD = 3, h = h);    
}

module LEDSupports(h=12) {
    translate([-15,-10,0]) 
        support(innerD = 1.5, outerD = 3, h = h);
    translate([15,-10,0]) 
        support(innerD = 1.5, outerD = 3, h = h);
    translate([0,-22,0]) 
        support(innerD = 1.5, outerD = 3, h = h); 

}


module support(innerD, outerD, h){
    difference() {
        cylinder(h=h,d=outerD);
        cylinder(h=h,d=innerD);
    }
}

module cameraCase() {
    difference() {
        #case(boxWidth = caseWidth, boxLength = caseLength, boxHeight = caseHeight, thickness = caseThickness);
        translate([caseWidth/2-caseThickness,0,10]) cableHole(d=9, h=15, thickness = caseThickness);
    }
    translate([0,-caseWidth/2+5/2,10]) rotate([90,0,0]) mountThread(h=5);
}

module case(boxWidth = 70, boxLength = 70, boxHeight = 30, thickness = 2)
{
    difference() 
    {
        translate([-boxWidth/2,-boxLength/2,-thickness]) cube([boxWidth, boxLength, boxHeight]);
        translate([-boxWidth/2+thickness,-boxLength/2+thickness,0]) cube([boxWidth - thickness*2, boxLength - thickness*2, boxHeight-thickness]);
    }
    
}

difference() {
    cameraCase();
    // thread 1/4', pitch = 20 TPI
    translate([0,-caseWidth/2+6,10]) rotate([90,0,0]) isoThread(d=1/4*25.4, h=10, pitch=25.4/20, internal=true, $fn=5); //cylinder(h=10, d=1/4*25.4);
}
cameraSupports(h=5);
LEDSupports(h=12);

//translate([0,-caseWidth/2+5/2,10]) rotate([90,0,0]) mountThread(h=5);
//rotate([90,0,0]) isoThread(d=6, h=70, internal=true, $fn=5);
