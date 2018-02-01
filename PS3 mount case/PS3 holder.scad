use <quickthread.scad> // для резьбы
use <roundedCube.scad> // для закругления углов


printerMarginForInnerD = 0.5; // поправка для 3d принтера для внутренних диаметров (увеличение внутреннего диаметра) 
caseThickness = 2; // толщина корпуса
cableHoleD = 5; // диаметр отверстия под кабель
caseWidth = 75; // ширина корпуса (ось X)
caseHeight = 25; // высота корпуса (ось Z)
caseLength = 75; // длина корпуса (ось Y)
ySupportsOffset = -3; // смещение всех ножек относительно (0,0,0) по оси Y

cameraSupportInnerD = 1.5 + printerMarginForInnerD; // внутренний диаметр стоек под камеру
cameraSupportOuterD = 4.5; // внешний диаметр стоек под камеру
cameraSupportH = 5.0; // высота стоек под камеру

LEDSupportInnerD = 3.0 + printerMarginForInnerD; // внутренний диаметр стоек под LED
LEDSupportOuterD = 6.5; // внешний диаметр стоек под LED
LEDSupportH = 12.0; // высота стоек под LED

$fa=0.5;  // default minimum facet angle
$fs=0.5; // default minimum facet size


module supportTriangle(width,height,depth) {
    
    translate([0,depth/2,0]) rotate([90,0,0]) triangle(width,height,depth);
}
    

module a_triangle(tan_angle, a_len, depth)
{
    linear_extrude(height=depth)
    {
        polygon(points=[[0,0],[a_len,0],[0,tan(tan_angle) * a_len]], paths=[[0,1,2]]);
    }
}

module triangle(o_len, a_len, depth)
{
    linear_extrude(height=depth)
    {
        polygon(points=[[0,0],[a_len,0],[0,o_len]], paths=[[0,1,2]]);
    }
}

module mountThread(h) {
    
    difference() {
        d = 1/4*25.4;
        //echo(d=d);
        l = d*3;
        translate([-l/2,-l/2,-h/2]) cube([l,l,h]);
    }
}

module cableHole(d, h, thickness) {
    translate([0,-d/2,0]) cube([thickness,d, h]);
    translate([0,0,0]) rotate([0,90,0]) cylinder(h=thickness,d=d);
    
}

module cameraSupports(h) {
    translate([-20,12+16+ySupportsOffset,caseThickness]) 
        support(innerD = cameraSupportInnerD, outerD = cameraSupportOuterD, h = cameraSupportH);
    translate([20,12+16+ySupportsOffset,caseThickness]) 
        support(innerD = cameraSupportInnerD, outerD = cameraSupportOuterD, h = cameraSupportH);
    translate([-30,16+ySupportsOffset,caseThickness]) 
        support(innerD = cameraSupportInnerD, outerD = cameraSupportOuterD, h = cameraSupportH); 
    translate([30,16+ySupportsOffset,caseThickness]) 
        support(innerD = cameraSupportInnerD, outerD = cameraSupportOuterD, h = cameraSupportH);    
}

module LEDSupports(h) {
    translate([-20,ySupportsOffset,caseThickness]) 
        support(innerD = LEDSupportInnerD, outerD = LEDSupportOuterD, h = LEDSupportH);
    translate([20,ySupportsOffset,caseThickness]) 
        support(innerD = LEDSupportInnerD, outerD = LEDSupportOuterD, h = LEDSupportH);
    translate([0,ySupportsOffset-20,caseThickness]) 
        support(innerD = LEDSupportInnerD, outerD = LEDSupportOuterD, h = LEDSupportH); 

}


module support(innerD, outerD, h){
    difference() {
        cylinder(h=h,d=outerD);
        cylinder(h=h,d=innerD);
    }
}

module cameraCase() {
    difference() {
        case(boxWidth = caseWidth, boxLength = caseLength, boxHeight = caseHeight, thickness = caseThickness);
        translate([caseWidth/2-caseThickness,10,5+caseThickness]) cableHole(d=cableHoleD, h=25, thickness = caseThickness);
    }
    #translate([0,-caseWidth/2+8/2,10+caseThickness]) rotate([90,0,0]) mountThread(h=8);
}

module case(boxWidth, boxLength, boxHeight, thickness)
{
    difference() 
    {
        translate([-boxWidth/2,-boxLength/2,0]) roundedCube(dim=[boxWidth, boxLength, boxHeight],r=5,x=false,y=false,z=true);
        translate([-boxWidth/2+thickness,-boxLength/2+thickness,thickness]) roundedCube(dim=[boxWidth - thickness*2, boxLength - thickness*2, boxHeight-thickness],r=5,x=false,y=false,z=true);
    }
    
}

difference() {
    cameraCase();
    // thread 1/4', pitch = 20 TPI
    translate([0,-caseWidth/2+10,10+caseThickness]) rotate([90,0,0]) isoThread(d=1/4*25.4 + printerMarginForInnerD, h=15, pitch=25.4/20, internal=true, $fn=10); 
    translate([0,0,0]) scale([0.5,0.5,1]) mirror([1,0,0]) linear_extrude(0.5) text("MADE IN CHINA", halign="center");
}
cameraSupports(h=5);
LEDSupports(h=12);

supportTriangle(10,10,5);