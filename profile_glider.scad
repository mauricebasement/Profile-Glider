//Profile Glider
//Moritz Keller
//Variables
$fn=50;
profileSize = 20;
tolerance = 0.18;
gliderY = 10;
gliderB = 5;
gliderD = 10;
shell = 0.2;
height = 20;
screwRadius = 1.5;
screwShell = 0.5;
screwTolerance = 1.05;
screwDistance = 5;
nutRadius = 3.4;
nutHeight = 3;

//Profile_Reduced Module
module profile() {
    import("dxf/profile_reduced.dxf");
}

module glider(tolerance=tolerance,gliderY=gliderY,gliderB=gliderB) {
    offset(r=-tolerance)difference() {
        union() {
            translate([0,gliderD/2])square([gliderB,gliderD],center=true);
            translate([0,-gliderY/2])square([profileSize,gliderY],center=true);
        }
        translate([0,profileSize/2])profile();
    }
}
module extrusion(height=height) {
    difference() {
        translate([0,0,-height/2])linear_extrude(height=height)glider();        
        screw_tr()scale([0.99,0.99,1.01])screw_hull();
    }
    screw_tr()screw();
}
difference() {
    extrusion();
    support_cut();
}
module support_cut() {
    translate([0,0,-height/2])linear_extrude(height=height)intersection() {
        offset(r=-shell)glider();
        negativ_sq()support()offset(r=-shell)glider();
    }
}
module screw_tr() {
    for(i=[-1,1])translate([0,-gliderY/2,i*(height/2-screwDistance)])rotate([0,90,0])children();
}
module screw_hull() {
    union() {
            cylinder(h=profileSize-2*tolerance,r=screwRadius*screwTolerance+screwShell,center=true);
            translate([0,0,-profileSize/2+(nutHeight+screwShell)/2+tolerance])cylinder(h=nutHeight+screwShell,r=nutRadius+screwShell,center=true);
    }
}
module screw() {
    difference() {
        screw_hull();
        cylinder(h=profileSize-2*tolerance,r=screwRadius*screwTolerance,center=true);
        translate([0,0,-profileSize/2+nutHeight/2+tolerance])cylinder(h=nutHeight,r=nutRadius,center=true,$fn=6);
    }
}
module support(shell) {
    intersection() {
        honeycomb();
        offset(r=-shell)children();
    }
}
module honeycomb(x=10,y=10,r=1,d=0.1,fn=6,fac=1) {
    for(k=[-1,1])for(l=[0:2*(r+r*sin(30)-d):x]){
        for(i=[1,-1])for(j=[0:2*r*cos(30)-d:y]) {
            translate([k*l,i*j])comb(r,d*fac,fn);
            translate([k*(l+r+r*sin(30)-d),i*(j+cos(30)*r-0.5*d)])comb(r,d*fac,fn);
        }
    }
}
module comb(r,d,fn) {
    difference() {
        circle(r=r,$fn=fn);
        circle(r=r-d,$fn=fn);
    }
}
module negativ_sq() {
    difference() {
        hull()children();
        children();
    }
}