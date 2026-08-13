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
w_cuv = 12+0.05;
h_cuv = 45;
dist_cuv = 1;
z_cuv = -4;

l_heatspreader = 12;
w_heatspreader = 12+0.05;
t_heatspreader = 0.4;
xo_heatspreader = t_heatspreader;
yo_heatspreader = t_heatspreader;

l_therm = 3-tol;
h_therm = 20;
w_therm = 20;

l_holder = 20;
w_holder = 20;
h_holder = 30;
l_frame = 3;
l_pin = 2;

l_lum = 7.5+1.5;
r_lum = 30.5/2;
r_lum_in = w_cuv/4;
l_lum_in = 0;
l_wall_lum = 0;
l_stand_lum = 0.8;
xo_stand_lum = l_stand_lum;
l_stab_lum = 1; // support 
w_stab_lum = 2;

twt = 2;

h_open = 18;

gap = 0.5;
prss_angl = 1;

h_top = h_holder-h_open;

IM_offset = 0.2;


tec_tol = 0.8;
w_wc2 = 3+2*tec_tol;

tec2w_tol = 0;
l_tec1 = 15 + tec_tol;
w_tec1 = 3.7 - tec_tol + w_wc2;
w_tec1_conn = 3+1;
h_tec1 = 18 + tec_tol+1;
x_tec2 = 2.5;
z_tec2 = 4.5;
l_tec2 = 10 + tec_tol;
w_tec2 = 2.6 - tec2w_tol;
h_tec2 = 12 + tec_tol+1;
z_tec = -1.5;

wc_tol = 0.5;
r_wc = w_tec1_conn/2;
x_wc = 6;
y_wc = -(-w_cuv/2-w_tec1-w_tec2);

r_wc2 = (5 + wc_tol)/2;
x_wc2 = 12;
y_wc2 = 13;

w_wc_clmp = 3;
y_wc_clmp = y_wc+r_wc+2;
h_wc_clmp = h_tec1/2; 
r_wc_clmp = 3;


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

    
    translate([l_holder/2-0.01,0,b/2-h/2]) {
        rotate(a=[0,90,0]) {
            difference() {
                union(){
                    translate([0,-r_lum_in-twt,a/2-l_holder/2-l_lum-l_stand_lum+xo_stand_lum]) cube([b/2,(r_lum_in+twt)*2,l_stand_lum]);
                    cylinder(h=(a/2-l_holder/2-l_lum_in), r=r_lum_in+twt);
                }
                translate([0,0,-0.01])cylinder(h=a/2+0.02, r=r_lum_in);
            }}
        
    }


    //translate([-a/2,-w_therm/2,h/2]) {color([0,0,1]) %cube([l_therm, w_therm, h_therm]); };
  

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
                
                // Cuvette holder
               translate([-l_holder/2,-w_holder/2,h/2]) {cube([l_holder, w_holder, h_holder]); }

                // Luminometer holder
                translate([a/2-l_lum,-b/2,-h/2]) { 
                
                    cube([l_lum, b, b]);
                    rotate([prss_angl,0,0]) cube([l_lum, b/2, b]);
                    translate([0,b,0]) rotate([-prss_angl,0,0]) translate([0,-b/2,0]) cube([l_lum, b/2, b]);
                };

        translate([-l_tec1/2,-w_wc_clmp-y_wc_clmp,0]) {
            cube([l_tec1, w_wc_clmp, h_wc_clmp]);
            translate([0,r_wc_clmp,h_wc_clmp]) rotate([0,90,0]) cylinder(h=l_tec1,r=r_wc_clmp);
            }

            }
        
        translate([0,0,h/2+z_cuv]) {trunc_pyramid(l_cuv+2*tol, w_cuv+2*tol, l_cuv+2*dist_cuv, w_cuv+2*dist_cuv, -z_cuv+0.01);}
        
        
            translate([0,0,h/2]) {trunc_pyramid(l_cuv+2*dist_cuv, w_cuv+2*dist_cuv, l_cuv+2*tol, w_cuv+2*tol, h_holder-h_top+tol); }
  


    
        translate([-dist_cuv-l_holder/2,l_pin-w_cuv/2,h/2]) {cube([l_holder/2+2*dist_cuv, w_cuv-2*l_pin, h_holder+tol]); }
        translate([l_pin-l_cuv/2,-dist_cuv-w_holder/2,h/2]) {cube([l_cuv-2*l_pin, w_holder+dist_cuv*2, h_holder+tol]); }
        
        
        translate([0,0,h/2+h_holder-h_top]) {trunc_pyramid(l_cuv+2*tol, w_cuv+2*tol, l_cuv+2*dist_cuv, w_cuv+2*dist_cuv, h_top+tol);}

       // heat spreader
      translate([xo_heatspreader-l_heatspreader+l_cuv/2,-yo_heatspreader-w_cuv/2,h/2+z_cuv]) {cube([l_heatspreader, w_heatspreader, h_cuv]); } 
        
        // Luminometer openings
        translate([a/2-l_lum-0.01,0,b/2-h/2]) {  
            rotate(a=[0,90,0]) {
                translate([0,0,l_wall_lum]) difference(){               cylinder(h=l_lum+0.02, r=r_lum);
                   translate([-r_lum,-r_lum,0])cube([2*r_lum,w_stab_lum,l_stab_lum]);
                   translate([-r_lum,r_lum-w_stab_lum,0])cube([2*r_lum,w_stab_lum,l_stab_lum]);
                }            
                translate([0,0,-a/2+l_lum]) cylinder(h=a/2+0.02, r=r_lum_in);
                translate([-(b-(b-2*r_lum)/2)/2,0,0]){
                difference(){
                     cylinder(r=(b-2*r_lum)/4+gap, h=l_lum+0.02);
                     cylinder(r=(b-2*r_lum)/4, h=l_lum+0.02);
                     translate([-b/2,0,0]) cube([b,b,l_lum]);
                     
                }
                }
                }
           }
    
        // Peltier pocket
        translate([-l_tec1/2,-w_cuv/2-w_tec1-w_tec2,z_tec]) {
            cube([l_tec1, w_tec1, h_tec1]);
            translate([-x_wc2+l_tec1/2,0,0]) cube([x_wc2*2, w_wc2, h_tec1]);
            translate([0,0,-c+0.01]) {
                cube([w_tec1_conn, w_tec1, c+0.02]);
                translate([l_tec1-w_tec1_conn,0,0]) cube([w_tec1_conn, w_tec1, c+0.02]);
            }

            translate([x_tec2, w_tec1-0.01, z_tec2]) cube([l_tec2, w_tec2+0.01, h_tec2]);
        }
        
        // Water cooler holes
        translate([0,-y_wc,-c/2-0.01]) cylinder(r=r_wc, h=c+0.02);
        translate([x_wc,-y_wc,-c/2-0.01]) cylinder(r=r_wc, h=c+0.02);
        translate([-x_wc,-y_wc,-c/2-0.01]) cylinder(r=r_wc, h=c+0.02);
        
        translate([x_wc2,-y_wc2,-c/2-0.01]) cylinder(r=r_wc2, h=c+0.02);
        translate([-x_wc2,-y_wc2,-c/2-0.01]) cylinder(r=r_wc2, h=c+0.02);
        
        // Stirrer Pocket
        //translate([-12.2/2,-12.4/2,-h/2-0.01]) cube([12.2,12.4,0.5]);

        }
        


}




