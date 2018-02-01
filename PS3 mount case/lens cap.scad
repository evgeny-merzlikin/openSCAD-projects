



module hollowCylinder(outerD, innerD, h) {
	difference () {
		cylinder(d=outerD, h=h);
		cylinder(d=innerD, h=h);
	}
}



hollowCylinder(8,7,1);
hollowCylinder(11,8,2);
hollowCylinder(10,8,8);
