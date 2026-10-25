# Heat: PETG MeshCore solar power-bank case

## Limits
- **Cell:** charge 0–45 °C, discharge −20–60 °C ([Hypercell](https://download.mikroe.com/documents/datasheets/Hypercell%20HPL402323-2C-3.7V-190mAh%20-%20datasheet.pdf)). Molicel gives the same charge range, ≤1.5 A at 60 °C and 65 mΩ max IR ([Molicel](https://www.rosebatteries.com/hubfs/ICP103450DA-V6-80075.pdf)).
- **bq24074:** I_CHG = 890 AΩ/R_ISET. It regulates current at T_J 125 °C and shuts down at 155 °C. TS bias is 75 µA; charging stops at 0/50 °C with a 10 k NTC ([TI](https://www.ti.com.cn/document-viewer/cn/BQ24073/datasheet/GUID-8C8AF29F-F402-45AC-A5BF-A2BFFEFDD045)). RθJA is 44.5 K/W ([TI](https://www.ti.com.cn/document-viewer/cn/lit/html/ZHCSIF0N/GUID-78E9A488-E3A2-4D56-B6F8-7B4102697051)).
- **Adafruit 4755:** 1.0 A by default. Bridge the 0.5 A or 1.5 A jumper, or fit 590 Ω–8.9 kΩ on ISET. **THERM is jumpered to GND, so there is no temperature protection until you fit an NTC.** DPM holds VIN at about 4.5 V ([Adafruit](https://learn.adafruit.com/adafruit-bq24074-universal-usb-dc-solar-charger-breakout.md?view=all)).
- **Boost:** datasheets give only peak efficiency: 96% ([IP5306](https://electrokit.com/upload/quick/12/91/662c_IP5306.pdf)), 97% ([TPS61235P](https://www.ti.com/product/TPS61235P)), "90%+" ([PowerBoost](https://thepihut.com/products/adafruit-powerboost-1000-charger-rechargeable-5v-lipo-usb-boost-1a)). *Assumed* 85–90% at 2 A.
- **Plastics:** PETG Tg 81 °C, HDT 73 °C (0.455 MPa); PLA Tg 60 °C, HDT 65 °C ([MakeItFrom](https://www.makeitfrom.com/compare/Glycol-Modified-Polyethylene-Terephthalate-PETG-PET-G/Polylactic-Acid-PLA-Polylactide)). Snapmaker gives PETG HDT as 65–75 °C ([Snapmaker](https://www.snapmaker.com/blog/petg-glass-transition-temperature/)). ASA Tg 98 °C, HDT 103 °C ([Polymaker](https://polymaker.com/wp-content/uploads/lana-downloads/PolyLite_ASA_TDS_EN_V5.4.pdf)).
- **Sun:** NOCT is 40–48 °C (800 W/m², 20 °C, open back). A closed back runs 10 °C or more hotter ([PVEducation](https://www.pveducation.org/node/177)). Dashboards in sun averaged 69 °C ([ASU](https://news.asu.edu/20180516-discoveries-asu-study-hot-cars-can-hit-deadly-temperatures-within-one-hour)).
- **Phones:** iPhone is rated for 0–35 °C ambient; when hot, "charging … slows or stops" ([Apple](https://support.apple.com/118431)). The JEITA handheld profile reduces charge voltage above 45 °C and stops above 60 °C ([TI](https://ti.com/lit/pdf/slyt365)).

## Calculation (mine; h and efficiency are assumptions)
- **Area:** 2(88·179 + 88·27 + 179·27) mm² = 0.046 m² (0.030 m² without the phone face).
- **h:** about 10 W/m²K (convection about 4, radiation 4σεT³ ≈ 6).
- **R_case:** 2.2–3.3 K/W.
- **2 mm PETG floor under the spreader:** 0.002/(0.2·0.00182) ≈ 5.5 K/W. The spreader's heat goes mostly into the phone.
- **Time constant:** about 15 min (about 300 J/K), so every mode reaches steady state.

| Mode | Internal heat | Avg ΔT |
|---|---|---|
| Sun charging, 1.5 W, about 0.27 A | (5.5−3.7)·0.27 ≈ 0.5 W | +1–2 K |
| Wall charging, 5 V, 1 A | (5.0−3.6)·1.0 ≈ 1.4 W (1.8 W at 3.2 V). T_J ≈ T_air + 62 K; it self-limits at 125 °C | +3–5 K |
| Phone charging, 10 W out | boost 1.1–1.8 W + I²R (3.1 A) 0.6 W ≈ 2–2.4 W, plus phone heat that can no longer leave its back | +5–8 K |
| Sun on lid | 1000·0.0094·0.9 − 1.5 ≈ **7 W** | panel ≈ T_amb + 35 (NOCT) + 10 (closed back) |

At 30–35 °C ambient the panel reaches about **75–80 °C**. With only 1.4 mm of PETG between them, the battery tracks it at about **60–75 °C**.

## Conclusion
- **Shade or indoors: no overheating.** The electronics add only 3–8 K, and the phone's own throttling comes first.
- **Direct sun: it overheats.** The battery exceeds its 45 °C charge limit and nears its 60 °C discharge limit.
- **Material in sun:** PETG at about 73 °C HDT can creep at the panel recess. PLA would fail.
- **Worst case:** sun while discharging into the phone.

## Changes
1. **Fit the NTC:** cut THERM and tape a 10 k NTC to the cell, so charging stops at 50 °C. A parallel resistor of about 22 kΩ moves the trip to about 45 °C but kills the cold trip (my calculation). Have the nRF read the NTC and disable boost EN above 55 °C.
2. **Insulate the panel from the battery:** a 3–5 mm air or foam gap, with foil facing the panel. Keep the battery off the spreader.
3. **Material:** ASA in a light colour.
4. **Spreader:** make it a U, a 65 × 28 mm base with 20 mm tabs up both side walls at the vents, so heat goes to the walls and the vents instead of the phone.
5. **Currents:** keep 1.0 A charging (0.5 A for cells under 2 Ah). Cap phone output at 1–1.5 A, which halves boost heat.
6. **Usage rules:** no phone charging in sun. Never leave it on a dashboard.

Unverified: the 2 A efficiency, h, and the 10 K closed-back adder.
