//Cube insert: Perpendicular 


/* [Hiden] */
$fn = 80;
eps = .002;
a = 49.8;
b = 33.6;
c = 6.28;
d = 53.8;
h = 5;

tol = 0.1;

l_cuv = 12;
w_cuv = 12;
h_cuv = 30;
dist_cuv = 1;
z_cuv = -4;

l_therm = 3-tol;
h_therm = 20;
w_therm = 20;

l_holder = 20;
w_holder = 20;
h_holder = 20;
l_frame = 3;
l_pin = 2;

l_lum = 5;
r_lum = 10;

h_open = 18;

h_top = h_holder-h_open;

IM_offset = 0.2;



insert();

module trunc_pyramid(la, wa, lb, wb, h) {
    la = la / 2;
    wa = wa / 2;
    lb = lb / 2;
    wb = wb / 2;

    polyhedron(
        points=[
            // bottom
            [ la,  wa, 0],   // 0
            [ la, -wa, 0],   // 1
            [-la, -wa, 0],   // 2
            [-la,  wa, 0],   // 3

            // top
            [ lb,  wb, h],   // 4
            [ lb, -wb, h],   // 5
            [-lb, -wb, h],   // 6
            [-lb,  wb, h]    // 7
        ],

        faces=[
            // bottom (außen zeigt nach -Z, also CCW von unten)
            [0,2,1],
            [0,3,2],

            // top (außen zeigt nach +Z, also CCW von oben)
            [4,6,7],
            [4,5,6],

            // sides (alle CCW von außen)
            [0,1,5], [0,5,4],
            [1,2,6], [1,6,5],
            [2,3,7], [2,7,6],
            [3,0,4], [3,4,7]
        ],

        convexity = 20
    );
}



module insert() {
    //translate([-l_cuv/2,-w_cuv/2,h/2]) {%cube([l_cuv, w_cuv, h_cuv]); }

    translate([-a/2,-w_therm/2,h/2]) {color([0,0,1]) %cube([l_therm, w_therm, h_therm]); };
  
    difference() {
    translate([-l_holder/2,-w_holder/2,h/2]) {cube([l_holder, w_holder, h_holder]); }
    
    
    translate([0,0,h/2]) {trunc_pyramid(l_cuv+2*dist_cuv, w_cuv+2*dist_cuv, l_cuv+2*tol, w_cuv+2*tol, h_holder-h_top+tol); }
  


    
    translate([-dist_cuv-l_holder/2,l_pin-w_cuv/2,h/2]) {cube([l_holder/2+2*dist_cuv, w_cuv-2*l_pin, h_holder+tol]); }
    translate([l_pin-l_cuv/2,-dist_cuv-w_holder/2,h/2]) {cube([l_cuv-2*l_pin, w_holder+dist_cuv*2, h_holder+tol]); }
    
    
    translate([0,0,h/2+h_holder-h_top]) {trunc_pyramid(l_cuv+2*tol, w_cuv+2*tol, l_cuv+2*dist_cuv, w_cuv+2*dist_cuv, h_top+tol);}

    
    }

    difference() {
        union() {   //basic insert design
                cube([a,b+2*IM_offset,h], center=true);
                cube([b+2*IM_offset,a,h], center=true);
                rotate(a=[0,0,45]){
                    cube([c,d+2*IM_offset,h], center=true);
                }
                rotate(a=[0,0,-45]){
                    cube([c,d+2*IM_offset,h], center=true);
                }
                translate([a/2-l_lum,-b/2,-h/2]) { cube([l_lum, b, b]); };

            }
        
        translate([0,0,h/2+z_cuv]) {trunc_pyramid(l_cuv+2*tol, w_cuv+2*tol, l_cuv+2*dist_cuv, w_cuv+2*dist_cuv, -z_cuv+0.01);}
        translate([a/2-l_lum-0.01,0,b/2-h/2]) rotate(a=[0,90,0]) cylinder(h=l_lum+0.02, r=r_lum);
    
        
        
        }
}
