//Cube insert: Perpendicular 


/* [Hiden] */
$fn = 80;
eps = .002;
a = 49.8;
b = 33.6;
c = 6.28;
d = 53.8;
h = 5;

w_cuv = 10;
l_cuv = 10;
h_cuv = 30;

l_therm = 5;

IM_offset = 0.2;

insert();

module insert() {
    translate([l_therm-a/2,-w_cuv/2,0]) {%cube([l_cuv, w_cuv, h_cuv]); }
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
