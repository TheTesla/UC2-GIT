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

l_therm = 3-tol;
h_therm = 20;
w_therm = 20;

l_holder = 20;
w_holder = 20;
h_holder = 20;
l_frame = 3;


h_open = 15;
z_open = 2;

IM_offset = 0.2;

insert();

module insert() {
    translate([-l_cuv/2,-w_cuv/2,h/2]) {%cube([l_cuv, w_cuv, h_cuv]); }
    translate([-a/2,-w_therm/2,h/2]) {color([0,0,1]) %cube([l_therm, w_therm, h_therm]); };
    
    difference() {
    translate([-l_holder/2,-w_holder/2,h/2]) {cube([l_holder, w_holder, h_holder]); }
    translate([-tol-l_cuv/2,-w_cuv/2,h/2]) {cube([l_cuv+2*tol, w_cuv+2*tol, h_cuv+2*tol]); }
    translate([-tol-l_holder/2,-w_cuv/2,h/2+z_open]) {cube([l_holder+2*tol, w_cuv+2*tol, h_open]); }
    translate([-l_cuv/2,-w_holder/2-tol,h/2+z_open]) {cube([l_cuv+2*tol, w_holder+2*tol, h_open]); }
    
    }

    union() {   //basic insert design
            cube([a,b+2*IM_offset,h], center=true);
            cube([b+2*IM_offset,a,h], center=true);
            rotate(a=[0,0,45]){
                cube([c,d+2*IM_offset,h], center=true);
            }
            rotate(a=[0,0,-45]){
                cube([c,d+2*IM_offset,h], center=true);
            }
        }
}
