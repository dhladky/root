use <scad-commons/holes.scad>
use <scad-commons/2D/dice_symbol_2D.scad>
use <scad-commons/utilities.scad>

wholeBoxSizeX = 276;
wholeBoxSizeY = 212;

$holes_bottom_part_top = 36;
$line_width = 0.5;
$holes_bottom_thickness = 1;

standard_sleeve_x = 90;
standard_sleeve_y = 66;

card_finger_hole_width = 22;
card_finger_hole_length = 15;

dice_hole_x = 35;
dice_hole_y = 55;
dice_hole_z = 23;

small_wall = 1;
wall = 1.3;
thick_wall = 6;

// item cover data
cover_space = 0.4;
item_size = 20; // item size with reserve
item_organizer_height = $holes_bottom_part_top-2*wall;
cover_size = 5*small_wall+2*item_size+2*cover_space;
cover_size_outer = cover_size-2*cover_space-2*small_wall;


map_holder_top = $holes_bottom_part_top + 17;


// calculated
card_part_x = 2*wall+standard_sleeve_x;
card_part_y = wholeBoxSizeY;


big_part();
small_part([-150, 0]);


module big_part(position=[0,0], $holes_finger_hole_radius=10, $holes_finger_hole_extend=10) {
    big_size_x = wholeBoxSizeX - card_part_x;
    translate([position[0], position[1], 0]) {
        difference() {
            union() {
                cube([big_size_x, wholeBoxSizeY, $holes_bottom_part_top]);
                translate([0, wholeBoxSizeY - thick_wall,0 ])
                    cube([big_size_x, thick_wall, map_holder_top]);
            }
            
            // ------------------------------------------------------------------
            // clearing holders
            clearing_size_x = 52;
            clearing_depth = 34;
            
            clearing_sizes_y = [9, 9, 9, 9, 10, 10, 10, 10, 12, 12, 12, 12];
            
            assert(clearing_depth < $holes_bottom_part_top+1.5);
           
            clearing_holes = cummulative_vector(clearing_sizes_y, start=wall+$holes_finger_hole_extend, distance=wall);

            clearing_holes_size_y = 2*$holes_finger_hole_extend+cummulative_vector_size(clearing_sizes_y, distance=wall);
                            
            // [clearing size y, position y] 
            for(hole = clearing_holes) {
                cubic_hole_with_finger_holes(position=[wall, hole[1]], size=[clearing_size_x, hole[0]]);
            };
            
            echo(clearing_holes=clearing_holes);
            echo(cummulative_vector_size(clearing_sizes_y, distance=wall));
            echo($holes_finger_hole_extend=$holes_finger_hole_extend);
            echo(clearing_holes_size_y=clearing_holes_size_y);
            
            // big unorganized area
            ytop=clearing_holes_size_y+2*wall;
            xtop=clearing_size_x+2*wall;
            cubic_hole(position=[wall, ytop], size=[big_size_x-2*wall, wholeBoxSizeY-thick_wall-ytop]);
            cubic_hole(position=[xtop, wall], size=[big_size_x-xtop-wall, clearing_holes_size_y+2*wall]);            
         
        }
    }
}

// small part
module small_part(position=[0,0]) {
    translate([position[0], position[1], 0]) {
        difference() {
            union() {
                cube([card_part_x, card_part_y, $holes_bottom_part_top]);
                translate([0, wholeBoxSizeY - thick_wall,0 ])
                cube([card_part_x, thick_wall, map_holder_top]);
            }
            // cards 1
            cubic_hole(position=[wall,thick_wall], size=[standard_sleeve_x, standard_sleeve_y]);
            // cards 2
            cubic_hole(position=[wall,thick_wall+wall+standard_sleeve_y], size=[standard_sleeve_x, standard_sleeve_y]);
            
            // cards finger holes
            cards2top = thick_wall+wall+2*standard_sleeve_y;
            finger_hole_center_x = wall+dice_hole_x+(standard_sleeve_x - dice_hole_x)/2;
            cubic_hole(position=[finger_hole_center_x, cards2top-1], size=[card_finger_hole_width, card_finger_hole_length+1], centerX=true); 
            cubic_hole(position=[finger_hole_center_x, wall+standard_sleeve_y], size=[card_finger_hole_width, card_finger_hole_length+1], center=true); 
            
            // item organizer
            cover_size_hole=cover_size_outer+2*cover_space;
            cover_mid = cards2top+cover_size_hole/2+card_finger_hole_length-0.01;
            
            cubic_hole(position=[finger_hole_center_x,cover_mid], size=[cover_size_hole,cover_size_hole], center=true);
            cubic_hole(position=[finger_hole_center_x,cover_mid], size=[cover_size_hole-card_finger_hole_length,cover_size_hole-card_finger_hole_length], center=true, depth=50);
            
            cubic_hole(position=[finger_hole_center_x, cards2top+card_finger_hole_length+cover_size_hole-1], size=[card_finger_hole_width, card_finger_hole_length+1], centerX=true, $holes_bottom_part_top=map_holder_top);
            
            // dice
            over_cards_center=wholeBoxSizeY-thick_wall-(wholeBoxSizeY-thick_wall - cards2top)/2;
            hole(position=[wall,over_cards_center], size=[dice_hole_x, dice_hole_y], depth=dice_hole_z, bury=false, centerY=true);
        }

        item_organizer([0, -50]);
    }
}

module item_organizer(position){
    $holes_bottom_part_top=item_organizer_height;
    $holes_bottom_thickness=small_wall;
    mini_hole=14;
    mini_cover_height = 15;

    translate([50+position[0], position[1], 0]) {
        difference() {
            cube([small_wall*3+item_size*2, small_wall*3+item_size*2, $holes_bottom_part_top]);
            
            cubic_hole(position=[small_wall, small_wall], size=[item_size, item_size]);
            cubic_hole(position=[2*small_wall+item_size, small_wall], size=[item_size, item_size]);
            cubic_hole(position=[small_wall, 2*small_wall+item_size], size=[item_size, item_size]);
            cubic_hole(position=[2*small_wall+item_size, 2*small_wall+item_size], size=[item_size, item_size]);
                        
            translate([small_wall+item_size/2,small_wall+item_size/2,-1])
                cylinder(d=mini_hole, h=10);
            translate([2*small_wall+3*item_size/2,small_wall+item_size/2,-1])
                cylinder(d=mini_hole, h=10);
            translate([small_wall+item_size/2,2*small_wall+3*item_size/2,-1])
                cylinder(d=mini_hole, h=10);
            translate([2*small_wall+3*item_size/2,2*small_wall+3*item_size/2,-1])
                cylinder(d=mini_hole, h=10);
            
        }
    }
    
    translate([position[0], position[1], 0]) {
        difference() {
            cube([cover_size, cover_size, mini_cover_height]);
            translate([small_wall+cover_space, small_wall+cover_space, small_wall]) 
               cube([cover_size_outer, cover_size_outer, $holes_bottom_part_top]);
        }
    }
}

