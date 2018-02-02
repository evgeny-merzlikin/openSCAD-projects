$fa = 0.5;
$fs = 0.5;

module hollowCylinder(outerD, innerD, h) {
	#difference () {
		cylinder(d=outerD, h=h);
		cylinder(d=innerD, h=h);
	}
}



module lensCap() {
    difference() {
        union() {
            hollowCylinder(20,17.5,5 + 2);
            hollowCylinder(20,13,2); 
        }
        //cylinder(d1=20, d2=13, h=1);
    }
}


lensCap();