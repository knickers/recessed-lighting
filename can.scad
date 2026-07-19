// Inside diameter
socket_diameter = 28;
// Inside height
socket_height = 20;

// Outside diameter
cone_diameter = 95;
// Outside height
cone_height = 33;

// Outside diameter
trim_diameter = 150;

// Outer width of mounting tab
mount_width = 10;
// Distance between close screw holes
mount_separation = 70;
// Inside diameter
mount_hole = 5;

// Thickness
wall_thickness = 2;
wall_half = wall_thickness / 2;
wall_double = wall_thickness * 2;

$fa = $preview ? 15 : 1;
$fs = $preview ? 3 : 1;


body();
//mount();


module mount(wall = 0) {
	y = mount_width + wall*2;
	cylinder(d=y, h=cone_height);
	translate([0, -y/2, 0])
		cube([(cone_diameter-mount_separation)/2, y, cone_height]);
}

module mounts(wall = 0) {
	translate([mount_separation/2, 0, 0])
		mount(wall);
	rotate(180, [0,0,1])
		translate([mount_separation/2, 0, 0])
			mount(wall);
}

module mount_holes() {
	translate([mount_separation/2, 0, 0])
		cylinder(d1=mount_hole, d2=mount_hole+wall_thickness*2, h=wall_thickness);
		//cylinder(d=mount_hole, h=wall_thickness+1);
	rotate(180, [0,0,1])
		translate([mount_separation/2, 0, 0])
			cylinder(d1=mount_hole, d2=mount_hole+wall_thickness*2, h=wall_thickness);
			//cylinder(d=mount_hole, h=wall_thickness+1);
}

module mount_counter_sinks() {
	translate([mount_separation/2, 0, 0])
		cylinder(d1=mount_hole, d2=mount_hole+wall_thickness*2, h=wall_thickness);
	rotate(180, [0,0,1])
		translate([mount_separation/2, 0, 0])
			cylinder(d1=mount_hole, d2=mount_hole+wall_thickness*2, h=wall_thickness);
}

module body() {
	difference() {
		union() {
			// Socket
			cylinder(d=socket_diameter+wall_double, h=socket_height+wall_thickness);

			// Cone
			translate([0, 0, socket_height])
				cylinder(
					d1=socket_diameter+wall_double,
					d2=cone_diameter,
					h=cone_height
				);

			// Trim
			translate([0, 0, socket_height+cone_height-wall_thickness])
				difference() {
					cylinder(
						d1=trim_diameter+wall_double,
						d2=trim_diameter-wall_double,
						h=wall_thickness*2
					);
					cylinder(
						d1=trim_diameter,
						d2=trim_diameter-wall_double,
						h=wall_thickness
					);
				}
		}

		// Socket
		translate([0, 0, wall_thickness])
			cylinder(d=socket_diameter, h=socket_height+1);

		// Cone
		translate([0, 0, socket_height+wall_thickness])
			difference() {
				cylinder(
					d1=socket_diameter,
					d2=cone_diameter-wall_double,
					h=cone_height
				);
				mounts(wall_thickness);
			}

		translate([0, 0, socket_height]) {
			mounts();
			translate([0, 0, cone_height]) {
				mount_holes();
				//mount_counter_sinks();
			}
		}

		if ($preview) {
			// Helper
			translate([0, 0, socket_height+cone_height+wall_thickness-0.001])
				cylinder(d=cone_diameter-wall_double, h=1);
		}
	}
}
