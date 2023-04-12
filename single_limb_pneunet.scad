/***************************************************************************
* "Parametric Mold Generator for a Soft Robotic PneuNet Bending Actuator" *
*                                                                          *
*   Designed and coded by:                                                 *
*   Jonas Jørgensen (jonasjoergensen.org)                                  *
*   IT University of Copenhagen (itu.dk)                                   *
*                                                                          *
*   Shared under an Attribution-Non Commercial-ShareAlike CC BY-NC-SA      *
*   license (https://creativecommons.org/licenses/by-nc-sa/4.0/).          *
*                                                                          *
***************************************************************************/

$fn=30;

//Change parameters below to alter design and dimensions of the bending actuator:

Air_channel_length = 60; //length including connector piece 
Air_channel_width = 3;
Air_channel_height = 5;//Must be less than or equal to Rib_element_height
Air_connector_length = 10; //Length of the connector piece without ribs and air channel

Rib_element_width = 18;
Rib_element_depth = 1.5;
Rib_element_height = 12;
Rib_element_spacing = 5;

Robot_endwall_thickness=2;
Robot_sidewall_thickness=3;
Robot_topwall_thickness=2.5;

TwistAngle=0; //Angle to rotate the inner ribs (changing this to different form zero will also alter the width of the actuator)
Air_channel_pos_offset = 0;
Mold_bottom_thickness=3;
Mold_wall_thickness=2;


//The values below are calculated from the variables above:
Mold_length = Air_channel_length+Mold_wall_thickness*2+Robot_endwall_thickness*2;
Mold_width=Rib_element_width*cos(TwistAngle)+Mold_wall_thickness*2+Robot_sidewall_thickness*2; 
Mold_wall_height=Rib_element_height+Robot_topwall_thickness+1; //Mold is to be filled with silicone approx. 1mm below the wall height
Number_of_ribs=((Air_channel_length-Air_connector_length)/(Rib_element_depth+Rib_element_spacing))+1;

union() {

    
 //Generate inner parts of the mold: 
    
difference() {

    linear_extrude(height = Rib_element_height, center = true, convexity = 10, slices = 20, scale = 1.0) {
    for (i = [1:Number_of_ribs]){
    translate([0, Rib_element_spacing+(Rib_element_depth/2)+(i-1)*(Rib_element_depth+Rib_element_spacing),0]) rotate(a = TwistAngle, v = [0, 0, 1]) square(size = [Rib_element_width, Rib_element_depth], center = true); //Ribbing elements (The placement of these is used as a basis for calculating the other positions)
    }   
    }
    
    //Cut slanting ribs away at the ends inside the mold:
    translate([-(Mold_width-Mold_wall_thickness*2)/2, -Robot_endwall_thickness-(Rib_element_depth/2),-Mold_wall_height/2]) cube([Mold_width-Mold_wall_thickness*2,Robot_endwall_thickness,Mold_wall_height]); 
    translate([-(Mold_width-Mold_wall_thickness*2)/2, Air_channel_length-(Rib_element_depth/2),-Mold_wall_height/2]) cube([Mold_width-Mold_wall_thickness*2,Robot_endwall_thickness,Mold_wall_height]);

    translate([-(Mold_width-Mold_wall_thickness*2)/2, Air_channel_length-Air_connector_length,-Mold_wall_height/2]) cube([Mold_width-Mold_wall_thickness*2,Air_connector_length,Mold_wall_height]);//cut off ribs at air connector piece
    
    translate([-(Mold_width-Mold_wall_thickness*2)/2, -Mold_wall_thickness-Rib_element_width-Robot_endwall_thickness,-Mold_wall_height/2]) cube([Mold_width-Mold_wall_thickness*2,Rib_element_width,Mold_wall_height]);//In front of mold cut off 
    translate([-(Mold_width-Mold_wall_thickness*2)/2, Rib_element_width+Mold_length-Mold_wall_thickness-Rib_element_width-Robot_endwall_thickness,-Mold_wall_height/2]) cube([Mold_width-Mold_wall_thickness*2,Rib_element_width,Mold_wall_height]);//Behind mold cut off 

    }
     
translate([Air_channel_pos_offset, Air_channel_length/2-Air_connector_length/2,(Air_channel_height/2)-(Rib_element_height/2)]) cube([Air_channel_width, Air_channel_length-Air_connector_length, Air_channel_height], center = true); //Make air channel

//Create outer mold walls:
translate([0, Air_channel_length/2,((Mold_wall_height-Rib_element_height)/2)-Mold_bottom_thickness/2]) linear_extrude(height = (Mold_bottom_thickness+Mold_wall_height), center = true, convexity = 10, slices = 20, scale = 1.0) {
    difference(){
    square(size = [Mold_width, Mold_length], center = true); //Mold (complete volume)
    square(size = [Mold_width-Mold_wall_thickness*2, Mold_length-Mold_wall_thickness*2], center = true); //Mold (inner volume)
    }
    }

 //Generate the bottom of the mold:
 
 translate([0, Air_channel_length/2,(-Rib_element_height/2)-Mold_bottom_thickness/2]) linear_extrude(height = Mold_bottom_thickness, center = true, convexity = 10, slices = 20, scale = 1.0) {
    square(size = [Mold_width, Mold_length], center = true); //Mold (complete volume)
    }
    
}