$fn=60;

num_limbs = 7;
limb_width = 30;
limb_length = 90;
wall_height = 30;

bottom_wall_height = 15;

wall_thickness = 2;
bottom_thickness = 3;

central_area = 25;

channel_width = 4;
channel_height = 5;

limb_end_gap = 10;

//ribs
rib_width = 18;
rib_depth = 1.5;
rib_height = 12;
rib_spacing = 5;
rib_angle = 0;

connector_diameter = 2;

num_ribs = floor((limb_length - limb_end_gap - central_area)/(rib_depth + rib_spacing));
echo(num_ribs)


//inner tentacle

union () {
    difference(){
        
        //outside
        for (i = [0:num_limbs]){
            rotate([0, 0, i*360/num_limbs])translate([0, limb_length/2, wall_height/2])cube([limb_width, limb_length, wall_height], center=true);
        }


        //inside
        for (i = [0:num_limbs]){
            rotate([0, 0, i*360/num_limbs])translate([0, limb_length/2 - wall_thickness, wall_height/2+bottom_thickness])cube([limb_width - 2*wall_thickness, limb_length-wall_thickness, wall_height-bottom_thickness], center=true);
        }
        
    }

    //air channel
   for (i = [0:num_limbs]){
         rotate([0, 0, i*360/num_limbs])translate([0, limb_length/2 - limb_end_gap/2, channel_height/2 + bottom_thickness])cube([channel_width, limb_length - limb_end_gap, channel_height], center=true);
    }
        
    //ribs
    for (i = [0:num_limbs]){
      rotate([0, 0, i*360/num_limbs])translate([0, central_area, rib_height/2 + bottom_thickness])
        for (j = [0:num_ribs]){
           translate([0, j*(rib_depth + rib_spacing), 0])rotate([0, 0, rib_angle])cube([rib_width, rib_depth, rib_height], center=true);
        }
    }    
    
    translate([0, 0, wall_height/2])cylinder(wall_height, connector_diameter, connector_diameter, center = true);
    

}


// outer tentacle
/*
union () {
    difference(){
        
        //outside
        for (i = [0:num_limbs]){
            rotate([0, 0, i*360/num_limbs])translate([0, limb_length/2, bottom_wall_height/2])cube([limb_width, limb_length, bottom_wall_height], center=true);
        }

        //inside
        for (i = [0:num_limbs]){
            rotate([0, 0, i*360/num_limbs])translate([0, limb_length/2 - wall_thickness, bottom_wall_height/2+bottom_thickness])cube([limb_width - 2*wall_thickness, limb_length-wall_thickness, bottom_wall_height-bottom_thickness], center=true);
        }
        
    }

}
*/
