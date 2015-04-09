//Profile Glider
//Moritz Keller
//Variables
profileSize = 20;
tolerance = 0.18;
gliderY = 10;
gliderB = 5;
gliderD = 10;
shell = 0.2;
height = 10;

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
    linear_extrude(height=height) {
        support(shell)glider();
        difference() {
            glider();
            offset(r=-shell)glider();
        }
    }
}

extrusion();

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