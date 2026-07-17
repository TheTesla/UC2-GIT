//UC2 Cube and Lid 

/* [User Parameters] */
// Which part would you like to print?
part = "first"; // [first:Both - Cube Body AND Lid,second:Cube Body ONLY,third:Lid ONLY]

/* [Hiden] */
$fn=80;
eps=.002;

a=34.4; //Edge length
b=7.7; //Edge width
c=3.625; //Chamfer

crv=2; //Curvature
scoff=4.9; //Screw offset from outside (cube width (49,8)-screw pitch(40))/2
scr_d=2.8; // Screw hole diameter (M3)
scr_l=8; // Screw length (hole length)
scr_hd=5.5; // Screw head diameter (M3)
scr_hl=3.1; // Screw head length (M3)

pin = 4.7; //screw hole diameter default
s1 = 2.7; //screw hole to side distance 1 (x,y)
s2 = 4.1; //screw hole to side distance 2 (x,y)

tol = 0.2;

t_side = 2;
t_base = 2.5;
ang_cut = 32;

//Comment or uncomment the following three lines, depending on which part you want to print OR use the Customizer window
%print_part();
//basecube();
//lid();

translate([0,(a+b*2-12.4)/2,b])%cube([40,3.4,5.9]);
translate([(a+b*2-12.2)/2,(a+b*2-12.4)/2,1.7]) %cube([12.2,12.4,5.9]);

// holder for stirrer
difference(){
    union(){
        translate([b,b,0]) cube([a,a,t_base]);
        for (i = [0:3]) translate([a/2+b,a/2+b,0]) rotate([0,0,i*90]) translate([b+tol/2-a/2-b,tol/2+a+c-a/2-b,0]) rotate([45,0,0]) cube([a-tol,b/cos(45),t_side]);
}
        for (i = [0:3]) translate([a/2+b,a/2+b,0]) rotate([0,0,i*90]) translate([b+tol/2-a/2-b,tol/2+a+c-a/2-b,0]) rotate([45,0,0]) translate([0,0,-t_side-b])cube([a-tol,b/cos(45),t_side+b]);
        for (i = [0,2]) translate([a/2+b,a/2+b,b]) rotate([0,0,i*90]) translate([b+tol/2-a/2-b,tol/2+a+b+c-a/2-b,0]) rotate([180+ang_cut,0,0]) translate([-b,0,-tol-t_side])cube([a+2*b,a,t_side+b]);
    translate([0,0,b]) cube([a+b*2,a+b*2,b]);
    translate([(a+b*2-12.2-tol)/2,(a+b*2-12.4-tol)/2,1.7]) cube([12.2+tol,12.4+tol,5.9]);

}



module print_part() {   //choose part to print cube body/lid/both
	if (part == "first") {
		basecube();
        lid();
	} else if (part == "second") {
		basecube();
	} else if (part == "third") {
		lid();
	} 
}

module basecube() {
    union() {
        tripod();
        translate([a+2*b,0,0])rotate([0,0,90])tripod();
        translate([a+2*b,a+2*b,0])rotate([0,0,180])tripod();
        translate([0,a+2*b,0])rotate([0,0,270])tripod();
    }
}

module lid() {
    translate([55,0,0]){
        translate([0,0,b])mirror([0,0,1]) {
            union() {
                corner();
                translate([0,b,0])edge_y();
                translate([b,0,0])edge_x();
                translate([a+2*b,0,0])rotate([0,0,90]) {
                    corner();
                    translate([b,0,0])edge_x();
                }
                translate([a+2*b,a+2*b,0])rotate([0,0,180]) {
                    corner();
                    translate([b,0,0])edge_x();
                }
                translate([0,a+2*b,0])rotate([0,0,270])corner();
            }
        }
    }
}

module tripod() {
    union() {
        corner();
        translate([0,0,b])edge_z();
        translate([0,b,0])edge_y();
        translate([b,0,0])edge_x();
    }
}

//Edge
module edge_z() {
    difference() {
        union() {
            translate([crv,crv,0])cylinder(r=crv,h=a);
            translate([crv,0,0])cube([b-crv,b,a]);
            translate([0,crv,0])cube([b,b-crv,a]);
        }
        //Inner chamfer
        translate([b,c,-eps])rotate([0,0,45])cube([1.5*b,1.5*b,a+2*eps]);
        //Holes for screws
        translate([scoff,scoff,-eps])cylinder(d=scr_d,h=scr_l); //bottom
        translate([scoff,scoff,a-scr_l+eps])cylinder(d=scr_d,h=scr_l); //top
    }
}

module edge_x() {
    difference () {
        rotate([0,0,90])rotate([90,0,0])edge_z();
        translate([s1,s2,-eps/2]){cylinder(b+eps,d=pin);} //hole for snap fit
        translate([a-s1,s2,-eps/2]){cylinder(b+eps,d=pin);} //hole for snap fit
    }
}

module edge_y() {
    difference () {
        translate([0,a,0])rotate([90,0,0])edge_z();
        translate([s2,s1,-eps/2]){cylinder(b+eps,d=pin);} //hole for snap fit
        translate([s2,a-s1,-eps/2]){cylinder(b+eps,d=pin);} //hole for snap fit
    }
}

//Corner
module corner() {
    difference() {
        union() {
            translate([crv,crv,crv])sphere(r=crv);
            translate([crv,crv,crv])cylinder(r=crv,h=b-crv);
            translate([crv,0,crv])cube([b-crv,b,b-crv]);
            translate([0,crv,crv])cube([b,b-crv,b-crv]);
            translate([crv,crv,crv])rotate([0,90,0])cylinder(r=crv,h=b-crv);
            translate([crv,crv,crv])rotate([-90,0,0])cylinder(r=crv,h=b-crv);
            translate([crv,crv,0])cube([b-crv,b-crv,b]);
        } 
        //Holes for Screws
        translate([scoff,scoff,-eps])cylinder(d=scr_d,h=b+2*eps); //z direction
        rotate([90,0,0])translate([scoff,scoff,-b-eps])cylinder(d=scr_d,h=b+2*eps); //y direction
        rotate([0,90,0])translate([-scoff,scoff,-eps])cylinder(d=scr_d,h=b+2*eps); //x direction
        
        //Screw heads
        translate([scoff,scoff,-eps])cylinder(d=scr_hd,h=scr_hl);
    }
}