# MeshCore phone

A 3D-printed case that turns an inexpensive phone into a dedicated [MeshCore](https://github.com/meshcore-dev/MeshCore) LoRa mesh messenger. The radio rides in a cavity on the back of the phone, a 915 MHz antenna screws onto the top, and an optional solar lid keeps a battery topped up.

**Status: design prototype, not yet built.** Everything here has been checked in CAD and on paper, but nobody has assembled one yet. See [What is not proven yet](#what-is-not-proven-yet).

## How it works

- **Radio:** a Seeed XIAO nRF52840 with a Wio-SX1262 LoRa board, running the MeshCore Bluetooth companion firmware. A u.FL pigtail runs to an SMA socket in the top wall, so a real antenna screws on outside.
- **Power:** the phone powers the radio through its own USB-C port. A small plug board in the case's bottom end connects the phone's port to the radio.
- **One switch** on the bottom end:
  - **USE:** the phone powers the radio. The phone is not charged.
  - **CHARGE:** the case charges the phone and keeps the radio running. With Bluetooth the app stays connected in both positions.
- **Removing the phone:** the phone slides in from the top under lips along both sides and the bottom, and a screwed-on cap closes the top end. Undo the two screws on the front of the cap, lift it off and slide the phone out. The lid and electronics stay closed.

## Versions

| Version | What charges the phone on CHARGE | Case battery | Notes |
|---|---|---|---|
| **Solar + battery** | Solar lid and a wall charger via the case battery | Jauch LP906090JH, 6000 mAh; phones shorter than 144.7 mm take the Jauch LP523450JU, 950 mAh | About one full phone charge on the 6000 mAh battery, about a sixth on the 950 mAh one. Same printed parts either way |
| **No solar** | A USB-C charger plugged into the side port | none | Cheapest and thinnest |

Rough parts cost per unit, phone not included: Solar + battery about $214 for one build and $110 each for 100 ($195 and $94 with the 950 mAh battery on a short phone); No solar about $123 and $39. The single-build prices are mostly supplies sold in packs (filament, tape, solder).

## What is in this repo

| Path | Contents |
|---|---|
| [`manual/index.html`](manual/index.html) | The full build manual as one offline page: 3D exploded view, step-by-step build, wiring diagram, parts list with prices and a DigiKey cart link, phone picker, and STL download. Open it in a browser. |
| [`cad/meshcore_onepiece.scad`](cad/meshcore_onepiece.scad) | Parametric OpenSCAD source for every printed part |
| [`stl/`](stl) | Print-ready STLs, already rotated for printing, for the nine ready-made phones |
| [`parts/parts_list.csv`](parts/parts_list.csv) | Every part with quantity, price, DigiKey number and link |
| [`docs/heat_research.md`](docs/heat_research.md) | Background notes on heat, batteries and sun exposure |

Ready-made phones: Galaxy A15, Galaxy A16 5G, Moto G Play (2026), Moto G (2025), Pixel 8a, Pixel 9 / 9 Pro, Pixel 9a, Pixel 10 / 10 Pro, Pixel 10a.

## Printing

Print in a light-coloured ASA. Each phone has five files:

- `*_body.stl`: on its long side, with tree supports inside the cavity and the phone pocket.
- `*_lid.stl`: flat, inside face down.
- `*_cap.stl`: lip down.
- `*_fit_test.stl`: the bottom 30 mm of the body. Print it first to check the phone plug and the pocket.
- `*_side_test.stl`: a strip of the button-side wall. Hold your phone against it to check that the power and volume buttons sit inside the window.

The `solar` files serve both batteries. The `no_solar` files are the No solar version.

### Other phones

The CAD takes any phone's measurements. Pick a phone in the manual to get the exact commands, or run:

```
openscad -D 'phone="custom"' -D 'version="solar"' -D 'cell="large"' \
  -D 'custom=[160.0, 76.0, 8.5, 9, 0, 1, 24, 60, 34, 52, 3, 3, 1]' \
  -D 'part="body"' -o body.stl cad/meshcore_onepiece.scad
```

The `custom` list is: length, width, thickness, corner radius, USB-C offset, button side, buttons from top, button window length, camera width, camera length, camera from top, camera from edge, camera side. Repeat with `part="cap"`, `"lid"`, `"fit_test"` and `"side_test"`. Use `version="phone"` for No solar. `cell="large"` is the 6000 mAh battery; use `cell="small"` (950 mAh) for a phone shorter than 144.7 mm.

## What is not proven yet

- **Button positions:** only the Galaxy A15 is measured. For the other phones the window covers where that maker usually puts the buttons. Print the button test first.
- **Board sizes and positions:** the charger board size and its USB-C position, and the radio stack height, are measured guesses.
- **Switch:** the slide switch's knob size against its 4.5 × 2.4 mm slot.
- **Power and heat:** phone battery drain while powering the radio (estimated at 5 to 10% a day), solar yield, and temperatures in sun.

Issues and pull requests with real measurements are very welcome.

## License

[MIT](LICENSE)
