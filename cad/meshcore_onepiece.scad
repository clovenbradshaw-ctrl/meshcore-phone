// =====================================================================
// MeshCore dedicated phone, one-piece body
//
// Three printed parts, eight M2 screws:
//   body  phone pocket on the front, electronics cavity on the back,
//         one shared 2 mm floor between them. Side USB-C, switch,
//         antenna and vents are all in the body walls.
//   cap   closes the top end after the phone slides in. Two M2 x 16 screws
//         from the front, through the cap and floor into posts: the phone comes
//         out without opening the lid.
//   lid   back lid with the solar panel recessed flush. Six M2
//         self-tapping countersunk screws straight into the cavity posts.
//
//   phone = "a15" | "a16" | "gplay26" | "g25" | "pixel9a" | "pixel8a" | "pixel9" | "pixel10" | "pixel10a" | "custom"
//   One build: a 6000 mAh battery charges the phone through a 5 V boost
//   and runs the radio. The side USB-C and the solar panel charge the battery.
//
//   part = "body" | "cap" | "lid" | "fit_test" | "assembly"
//
// Print the body on its long side WITH tree supports inside the cavity and the phone
// pocket: the top side wall overhangs both. Supports come out through the open back.
// The lid and cap print with no supports.
//
// COORDINATES: x across the phone (screen up, +x right), y along the phone,
// y = 0 at the phone's bottom edge, z = 0 at the underside of the shared
// floor, +z toward the screen. The cavity and lid are at negative z.
//
// !! Phone length/width/thickness come from spec sheets. Corner radius,
// !! port offset, keys, camera and every bought-part size are placeholders
// !! until measured.
// =====================================================================

part  = "assembly";
phone = "a15";
version = "solar";       // "solar" = solar lid + battery that charges the phone, "phone" = no solar, no battery. The phone powers the radio in both.
cell = "large";          // solar only: "small" = 950 mAh, "large" = 6000 mAh. Same printed parts either way; only the fit check changes.
power = "bank";          // kept as a name only
show_ghosts = true;
$fn = 32;

// [ length, width, thickness, corner_r, port_x, key_side, key_from_top, key_len,
//   cam_w, cam_len, cam_from_top, cam_from_edge, cam_side (+1/-1 side, 0 = centred) ]
// key_from_top / key_len: one window from above the highest side button to below the lowest.
// Only the A15 is measured; the others cover the span where that maker puts its buttons. Measure yours.
custom = [160.0, 76.0, 8.5, 9,   0, 1, 24, 60,   34, 52, 3, 3, 1];
function profile(n) =
  n == "a15"     ? [160.1, 76.8, 8.4, 9,   0, 1, 28, 36,   24, 44, 4, 3, 1] :
  n == "a16"     ? [164.4, 77.9, 7.9, 9,   0, 1, 28, 50,   34, 52, 3, 3, 1] :
  n == "gplay26" ? [167.2, 76.4, 8.5, 9,   0, 1, 30, 68,   34, 52, 3, 3, 1] :
  n == "g25"     ? [167.1, 76.3, 8.2, 9,   0, 1, 30, 68,   34, 52, 3, 3, 1] :
  n == "pixel9a" ? [154.7, 73.3, 8.9, 10,  0, 1, 24, 56,   50, 30, 3, 0, 0] :
  n == "pixel8a" ? [152.1, 72.7, 8.9, 10,  0, 1, 24, 56,   50, 30, 3, 0, 0] :
  n == "pixel9"  ? [152.8, 72.0, 8.5, 10,  0, 1, 24, 56,   50, 30, 3, 0, 0] :   // also Pixel 9 Pro (same size)
  n == "pixel10" ? [152.8, 72.0, 8.6, 10,  0, 1, 24, 56,   50, 30, 3, 0, 0] :   // also Pixel 10 Pro (same size)
  n == "pixel10a"? [153.9, 73.0, 9.0, 10,  0, 1, 24, 56,   50, 30, 3, 0, 0] :
                   custom;
P = profile(phone);
ph_l = P[0];  ph_w = P[1];  ph_t = P[2];  ph_r = P[3];
port_x = P[4];
key_side = P[5]; key_from_top = P[6]; key_len = P[7];
cam_w = P[8]; cam_len = P[9]; cam_from_top = P[10]; cam_from_edge = P[11]; cam_side = P[12];
has_bat = version != "phone";
solar = version == "solar";
is_bank = has_bat;

// ---------------- bought parts ---------------------------------------------
// Sizes marked [spec] come from the maker's product page. [measure] = not
// published, placeholder until you put calipers on your board.
panel_w = 66; panel_l = 113; panel_t = 2.6;      // [spec] Voltaic P124 / Adafruit 5368, 6 V 1.35 W ETFE
tape_t  = 1.6;                                   // [spec] 3M 4016 foam tape, 1/16 in: the same roll as the floor and radio foam
chg_w = 36; chg_l = 25; chg_h = 6;               // [measure] Adafruit 4755 bq24074 charger, its own USB-C is the side port
chg_port_y = 12.5;                               // [measure] USB-C centre along the board edge that faces the +x wall
bst_w = 29; bst_l = 23; bst_h = 7.5;             // [spec] Adafruit PowerBoost 1000 Basic, 2 A, EN fully cuts the output (battery versions)
cut_w = 7; cut_l = 3.8; cut_h = 1.4;             // [measure] Bourns AD55 55 C thermal cut-out, on the boost input
rcp_w = 20.4; rcp_l = 14.2; rcp_h = 5.0;         // [spec] Adafruit 4090 USB-C socket breakout, side port of the phone-powered version
xiao_w = 23; xiao_l = 22; xiao_h = 8;            // [measure] XIAO nRF52840 on the Wio-SX1262 board, its USB-C facing +x
msw_w = 9; msw_l = 3.5; msw_h = 3.6;             // [spec] C&K JS202011CQN body; its 2 mm knob points out through the wall
knob_h = 2.0;                                    // [spec] knob height above the body
sw_gap = 0.5;                                    // seat between wall and switch: knob tip ends 0.3 mm inside the outer surface
dish_d = 0.8;                                    // fingernail dish around each slot
bat_w = cell == "small" ? 34.8 : 60.5; bat_l = cell == "small" ? 52.5 : 92; bat_h = cell == "small" ? 5.8 : 9.9; // [spec] Jauch LP523450JU+PCM 950 mAh or LP906090JH+PCM 6000 mAh, protected, 70 mm leads
spr_t = 1.0;                                     // aluminium spreader, L-shaped, tab down the -x wall at the vents
foam_floor = 1.0;                                // foam tape between spreader and floor: heat goes to the wall, not the phone
foam_lid = 2.0;                                  // closed-cell foam + foil between lid and battery: keeps panel heat off the cell
pb_len = 24.1; pb_w = 14.3; pb_t = 3.1;          // [spec] Adafruit 5978 USB-C plug breakout in the chin
sw_w = 4.5; sw_h = 2.4;                          // [measure] knob slot: knob width plus its travel
insert_hole = 1.7; insert_l = 6.5; post_d = 6.5;     // pilot hole for M2 self-tapping screws straight into the post (no inserts)                             // slide switch opening (C&K OS102011MS2QN1 class)

// ---------------- body dimensions -----------------------------------------
clr = 0.5;
side_min = 4.5;                 // thinnest side wall beside the phone
floor_t = 2.0;                  // the ONE layer between phone and electronics
lip = 1.6; lip_t = 1.2;         // screen-side lip that holds the phone
cap_seat = 9;
plug_in = 6.5; end_wall = 1.6;
cav_wall = 1.8;                 // electronics cavity walls
cav_h = has_bat ? 12.5 : 10.5;  // battery: lid foam + 9.9 mm cell; phone-powered: 1.6 mm foam + 8 mm radio stack + spare
lid_base = 1.4;
lid_t = solar ? lid_base + tape_t + panel_t : 2.4;

// ---------------- derived -------------------------------------------------
pk_w = ph_w + clr; pk_l = ph_l + clr; pk_h = ph_t + clr;     // phone pocket
body_w = max(pk_w + 2 * side_min, has_bat ? 82 : 0);         // one width front to back; battery versions need 82 for the boards
r_out = ph_r + side_min;
chin_l = pb_len - plug_in + end_wall;
y_bot = -chin_l;                                             // bottom end of the body
y_top = pk_l + cap_seat;                                     // top end of the body
body_l = y_top - y_bot;
top_z = floor_t + pk_h + lip_t;
port_z = floor_t + pk_h / 2;
lead_y = -chin_l * 0.35;
in_w = body_w - 2 * cav_wall;                                // cavity interior
in_l = body_l - 2 * cav_wall;
ix0 = -in_w / 2; iy0 = y_bot + cav_wall;                     // cavity interior origin
z_back = -cav_h;                                             // lid seats here
key_win_flare = 3;                                           // key windows open wider outside

// layout inside the cavity (x from the -x inner wall, y from the inner bottom wall)
spr_x = 0.2; spr_y = 13; spr_w = in_w - 0.4; spr_l = 26;
chg_x = in_w - chg_w; chg_y = 13;                            // charger against the +x wall, its USB-C in the side opening
bst_x = 3;  bst_y = 15;
port_y = has_bat ? chg_y + chg_port_y : 13 + rcp_l / 2;      // side USB-C opening centre (+x wall)
port_zc = has_bat ? -foam_floor - spr_t - 0.5 - 1.6 - 1.6 : -0.5 - 1.6 - 1.65;   // USB-C centre: board hangs PCB-up, connector below the PCB
sw_x = body_w/2 - 23;                                       // power switch, bottom wall, fixed 23 mm from the right edge for every phone
mode_x = -(body_w/2 - 23);                                   // mode switch (charge phone / USB link to radio), mirrored on the left
panel_y0 = 20;                                               // panel start from the inner bottom wall
lead_hole = [in_w / 2 + 12, panel_y0 + 4];                   // panel lead hole in the lid, near the charger
cap_scr_y = pk_l + cap_seat / 2;                             // reference for the radio position (unchanged)
cap_fx = pk_w/2 - 4.2; cap_fy = y_top - 5;                   // cap screws: from the front face, through the cap and floor into a post
xiao_y = cap_scr_y - iy0 - 6 - xiao_l - 2;                   // radio below the cap screws, near the antenna
bat_y = spr_y + spr_l + 4;
sma_x = -in_w / 2 + 8 + xiao_w / 2;                          // straight out the top wall above the radio
posts = [ [-(in_w/2 - 7), 3.2], [in_w/2 - 7, 3.2],                          // corner posts pulled inward, clear of the rounded corners
          [-(in_w/2 - 3.2), in_l / 2 + 10], [in_w/2 - 3.2, in_l / 2 + 10],      // beside the panel or battery (straight wall)
          [-(in_w/2 - 7), in_l - 3.2], [in_w/2 - 7, in_l - 3.2] ];

assert(!solar || panel_y0 + panel_l < in_l - 7, "Solar panel is too long for this phone");
assert(!has_bat || bat_y + bat_l < xiao_y - 2, "Not enough room for the battery");
assert(!solar || panel_w / 2 < in_w / 2 - 6, "Panel overlaps the side screw posts");

module rr(w, l, r) { translate([-w/2, 0]) offset(r = r) offset(delta = -r) square([w, l]); }
module outline() { translate([0, y_bot]) rr(body_w, body_l, r_out); }

// ---------------------------------------------------------------- body
module sw_cut(x) {
  zc = z_back + cav_h/2;
  translate([x - sw_w/2, y_bot - 1, zc - sw_h/2]) cube([sw_w, cav_wall + sw_gap + 2, sw_h]);         // knob slot
  translate([x, y_bot, zc]) scale([6.5, dish_d, 3.6]) sphere(1, $fn = 20);                          // fingernail dish
}
module sw_seat(x) {
  zc = z_back + cav_h/2;
  difference() {
    union() {
      translate([x - msw_w/2 - 1, iy0 - 0.01, zc - msw_h/2 - 0.2]) cube([msw_w + 2, sw_gap + 0.01, msw_h + 1.2]);          // seat frame
      for (sx = [-1, 1]) translate([x + sx * (msw_w/2 + 0.6) - 0.6, iy0, zc - msw_h/2 - 0.2]) cube([1.2, sw_gap + msw_l - 0.5, msw_h + 1.2]); // cheeks
      translate([x - msw_w/2 - 1, iy0, zc + msw_h/2 + 0.2]) cube([msw_w + 2, sw_gap + msw_l - 0.5, 0.8]);                    // floor-side stop
    }
    translate([x - sw_w/2, iy0 - 1, zc - sw_h/2]) cube([sw_w, sw_gap + 2, sw_h]);
  }
}
module body() {
  difference() {
    union() {
      translate([0, 0, z_back]) linear_extrude(top_z - z_back) outline();
    }
    // ---- front: phone pocket
    translate([0, 0, floor_t]) linear_extrude(pk_h) rr(pk_w, pk_l, ph_r);
    translate([0, 0, floor_t + pk_h - 0.01]) linear_extrude(lip_t + 1) {
      translate([0, lip, 0]) rr(pk_w - 2*lip, pk_l - lip, max(ph_r - lip, 1));
      translate([-(pk_w/2 - lip), pk_l - 6]) square([pk_w - 2*lip, cap_seat + 8]);
    }
    translate([-pk_w/2, pk_l, floor_t]) cube([pk_w, cap_seat + 1, top_z]);         // cap seat, open top end
    // no speaker or mic openings: the bottom end is solid apart from the plug channel
    // plug board channel, slides in from the pocket
    translate([port_x - pb_w/2 - 0.2, -(pb_len - plug_in) - 0.1, port_z - pb_t/2 - 0.2])
      cube([pb_w + 0.4, pb_len + 0.1, top_z]);
    // wire drop from the plug board through the shared floor into the cavity
    translate([port_x - 9 - 2.5, lead_y - 2, -1]) cube([18 + 5, 4, port_z + 1.5]);
    // side keys, windows flare outward so a fingertip reaches the button
    mirror([key_side < 0 ? 1 : 0, 0, 0])
      translate([pk_w/2 - 1, pk_l - key_from_top - key_len, floor_t + 1])
        hull() {
          cube([0.1, key_len, top_z]);
          translate([body_w/2 - pk_w/2 + 1.1, -key_win_flare, 0]) cube([0.1, key_len + 2 * key_win_flare, top_z]);
        }
    // camera window through the shared floor (opens into the cavity, the lid covers it)
    camx = cam_side == 0 ? -cam_w/2 : (cam_side > 0 ? pk_w/2 - cam_from_edge - cam_w : -(pk_w/2 - cam_from_edge));
    translate([camx, pk_l - cam_from_top - cam_len, -0.5]) cube([cam_w, cam_len, floor_t + 1]);

    // ---- back: electronics cavity
    translate([0, iy0, z_back - 1]) linear_extrude(cav_h + 1) rr(in_w, in_l, max(r_out - cav_wall, 2));
    // cap screws come in from the front: pilot through the floor and into the post below
    for (sx = [-1, 1]) translate([sx * cap_fx, cap_fy, -6]) cylinder(d = 1.7, h = floor_t + 6.5);
    // side USB-C charge port, +x wall
    // sized for a cable's moulded plug (about 12.5 x 7 mm) so the plug seats fully through the 1.8 mm wall
    translate([body_w/2 - cav_wall - 1, iy0 + port_y - 6.75, max(port_zc - 3.75, z_back + 0.6)]) cube([cav_wall + 2, 13.5, min(7.5, -0.01 - max(port_zc - 3.75, z_back + 0.6))]);
    // power switch, bottom wall (battery versions; the phone-powered radio is on whenever it has power)
    // mode switch, bottom wall, left: DPDT slide, charge phone / USB link to the radio
    sw_cut(mode_x);
    // SMA bulkhead, top wall, D-flat so it cannot spin; the antenna screws on outside
    translate([sma_x, y_top - cav_wall - 1, z_back + cav_h/2]) rotate([-90, 0, 0])
      intersection() { cylinder(d = 6.5, h = cav_wall + 2); translate([-3.25, -2.9, 0]) cube([6.5, 5.8, cav_wall + 2]); }
    // vents beside the charger (+x) and boost (-x): air in one side, out the other
    if (has_bat) for (sx = [-1, 1], i = [0:3])
      translate([sx > 0 ? body_w/2 - cav_wall - 1 : -body_w/2 - 1, iy0 + 42 + i * 4, z_back + 2.5])
        cube([cav_wall + 2, 2, cav_h - 5]);
  }
  // switch seats: a 0.5 mm frame against the wall plus side cheeks, so the knob sits below the surface
  sw_seat(mode_x);                                       // one switch: USE (phone powers the radio) / CHARGE (case charges the phone)
  // cap screw posts under the top corners of the floor (the screws drive in from the front)
  intersection() {
    translate([0, 0, z_back]) linear_extrude(cav_h) outline();
    for (sx = [-1, 1]) translate([sx * cap_fx, cap_fy, -7]) difference() {
      cylinder(d = 6, h = 7.01);
      translate([0, 0, 1]) cylinder(d = 1.7, h = 7);
    }
  }
  // lid posts
  intersection() {
    translate([0, 0, z_back]) linear_extrude(cav_h) outline();
    for (p = posts) translate([p[0], iy0 + p[1], z_back]) difference() {
      cylinder(d = post_d, h = cav_h);
      translate([0, 0, -1]) cylinder(d = insert_hole, h = insert_l + 1);        // pilot for an M2 self-tapping screw from the lid side
    }
  }
}

module cap() {
  intersection() {
  translate([0, 0, -1]) linear_extrude(top_z + 2) outline();
  difference() {
    union() {
      translate([-(pk_w - 0.4)/2, pk_l + 0.2, floor_t + 0.1]) cube([pk_w - 0.4, cap_seat - 0.4, top_z - floor_t - 0.2]);
      translate([-(pk_w/2 - ph_r), pk_l - lip, floor_t + pk_h + 0.1]) cube([pk_w - 2*ph_r, lip + 0.3, lip_t - 0.2]);
    }
    for (sx = [-1, 1]) translate([sx * cap_fx, cap_fy, 0]) {
      cylinder(d = 2.4, h = top_z + 1);                                          // clearance
      translate([0, 0, top_z - 0.1 - 1.3]) cylinder(d1 = 2.4, d2 = 4.6, h = 1.31); // countersink in the front face
    }
  }
  }
}

module lid() {
  // flat inner face, so it prints recess-up with no support; the six screws locate it
  translate([0, 0, z_back - lid_t]) difference() {
    linear_extrude(lid_t) outline();
    for (p = posts) translate([p[0], iy0 + p[1], -1]) {
      cylinder(d = 2.4, h = lid_t + 2);
      translate([0, 0, 0.99]) cylinder(d1 = 4.4, d2 = 2.4, h = 1.2);
      translate([0, 0, -1]) cylinder(d = 4.4, h = 2);
    }
    // solar panel recess in the outside face, and the lead hole into the cavity
    if (solar) {
      translate([-(panel_w + 0.6)/2, iy0 + panel_y0 - 0.3, -0.01]) cube([panel_w + 0.6, panel_l + 0.6, tape_t + panel_t + 0.01]);
      translate([ix0 + lead_hole[0], iy0 + lead_hole[1], -1]) cylinder(d = 4, h = lid_t + 2);
    }
  }
}

// ---------------------------------------------------------------- reference parts
module electronics() {
  zs = -foam_floor;                                                  // spreader top face, on foam tape under the floor
  if (has_bat) {
    translate([ix0 + spr_x, iy0 + spr_y, zs - spr_t]) cube([spr_w, spr_l, spr_t]);                   // spreader base
    translate([ix0 + spr_x, iy0 + spr_y, z_back + 1]) cube([spr_t, spr_l, zs - spr_t - z_back - 1]);  // tab down the -x wall, behind the vents
    translate([ix0 + chg_x, iy0 + chg_y, zs - spr_t - 0.5 - chg_h]) cube([chg_w, chg_l, chg_h]);      // charger
    translate([ix0 + bst_x, iy0 + bst_y, zs - spr_t - 0.5 - bst_h]) cube([bst_w, bst_l, bst_h]);      // boost
    translate([ix0 + bst_x + bst_w + 2, iy0 + bst_y, zs - spr_t - 0.5 - cut_h]) cube([cut_w, cut_l, cut_h]); // 55 C cut-out
    translate([ix0 + (in_w - bat_w)/2, iy0 + bat_y, z_back + foam_lid]) cube([bat_w, bat_l, bat_h]); // LiPo, on the lid foam
  } else {
    translate([ix0 + in_w - rcp_w, iy0 + port_y - rcp_l/2, -0.5 - rcp_h]) cube([rcp_w, rcp_l, rcp_h]); // USB-C socket board
    translate([ix0 + in_w - rcp_w - 14, iy0 + port_y - 2, -4]) cube([10, 3.5, 3.5]);                   // Schottky diode
  }
  for (x = [mode_x]) translate([x - msw_w/2, iy0 + sw_gap, z_back + cav_h/2 - msw_h/2]) cube([msw_w, msw_l, msw_h]); // switch bodies
  translate([ix0 + 8 + xiao_w, iy0 + xiao_y + (xiao_l - pb_w)/2, -1.6 - xiao_h/2 - pb_t/2]) cube([pb_len, pb_w, pb_t]); // USB-C plug board in the radio's port
  translate([ix0 + 8, iy0 + xiao_y, -1.6 - xiao_h]) cube([xiao_w, xiao_l, xiao_h]);                // XIAO + Wio-SX1262, on 1.6 mm foam under the floor
}
module ghosts() {
  %translate([0, clr/2, floor_t + clr/2]) linear_extrude(ph_t) rr(ph_w, ph_l, ph_r);
  %translate([port_x - pb_w/2, -(pb_len - plug_in), port_z - pb_t/2]) cube([pb_w, pb_len, pb_t]);
  %electronics();
  if (solar) %translate([-panel_w/2, iy0 + panel_y0, z_back - lid_t]) cube([panel_w, panel_l, panel_t]);
  %translate([sma_x, y_top, z_back + cav_h/2]) rotate([-90, 0, 0]) { cylinder(d = 9, h = 8, $fn = 6); cylinder(d = 7, h = 110); }
}

// ---------------------------------------------------------------- output
if (part == "assembly") {
  color("steelblue") body();
  color("tomato") cap();
  color("gray") lid();
  if (show_ghosts) ghosts();
}
// body on its long side (-x face down): floor and walls vertical, no support
if (part == "body") translate([0, 0, body_w/2]) rotate([0, -90, 0]) body();
if (part == "body_flat") body();
if (part == "cap") translate([0, 0, top_z]) rotate([180, 0, 0]) cap();
if (part == "lid") rotate([180, 0, 0]) translate([0, 0, -z_back]) lid();   // inner face down, recess up
// button test: a strip of the button-side wall with its window, outer face down, about 30 minutes
if (part == "side_test") translate([0, 0, body_w/2]) rotate([0, 90, 0]) mirror([key_side < 0 ? 1 : 0, 0, 0])
  intersection() { mirror([key_side < 0 ? 1 : 0, 0, 0]) body(); translate([pk_w/2 - 6, pk_l - key_from_top - key_len - 12, z_back - 1]) cube([body_w, key_len + 24, top_z - z_back + 2]); }
if (part == "fit_test") translate([0, 0, body_w/2]) rotate([0, -90, 0])
  intersection() { body(); translate([-100, y_bot - 1, z_back - 1]) cube([200, -y_bot + 31, top_z - z_back + 2]); }
