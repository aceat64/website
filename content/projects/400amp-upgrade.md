---
status: new
icon: material/power-plug-battery-outline
description: Upgrading the electrical service for our home from 100A to 400A! Includes battery backup and prep for solar panels.
---

# 400 Amp Electrical Upgrade

<iframe width="560" height="315" src="https://www.youtube-nocookie.com/embed/videoseries?si=OEi2P9iBzgF4Pr1Z&amp;list=PLIxOsQj0SNoHhOJQMfSanrUpOVrKlCcSu" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

- Existing service is 100A, by overhead line, meter on the house.
- New service is 400A, delivered at the edge of the property at a meter pedestal.
- Meter pedestal has 2x 200A breakers, one for the house and one for the workshop.
    - Square D QDL22200
    - Best price I could find for the breakers was about $250 each, but an emergency disconnect which includes that same breaker was less than $200 each. So I bought two emergency disconnects and took the breakers out of them.
    - [Square D Emergency Disconnect model Q2200MRBE with QDL22200 breaker](https://www.homedepot.com/p/Square-D-QO-200-Amp-2-Pole-Outdoor-Circuit-Breaker-Enclosure-with-QDL22200-PowerPact-Q-Frame-Breaker-Q2200MRBE/315581960)
    - Bonus: That left me with two outdoor rated enclosures "for free".
- Wiring from the meter pedestal to the house and workshop was run underground using direct burial cable.
    - [4/0, 4/0 & 2/0 "Sweetbriar" Aluminum Triplex URD Direct Burial Cable](https://www.wireandcableyourway.com/4-0-4-0-2-0-sweetbriar-underground-secondary-distribution-cable) for `L1`, `L2` and `Neutral`.
    - [2 AWG Clemson URD Direct Burial Cable](https://www.wireandcableyourway.com/clemson-2-awg-single-aluminum-conductor-600v-urd) for `Ground`.
    - Signifigantly cheaper than copper wire, and didn't require conduit since it's direct burial.
- Code requires an Emergency Disconnect where power goes into a residential structure, I used the same model that I pulled the 200A breakers from for the meter pedestal.

## Workshop

- 200A Load Center (Main Panel)
    - Square D QO Plug-On Neutral
    - Model: QO30M200PC
- Wiring from Emergency Disconnect to Main Panel is three 2/0 AWG THHN/THWN-2 wires (Black for `L1`, Red `L2` and White for `Neutral`) and one 4 AWG wire (Green for `Ground`).
- Grounding via two methods:
    - A horiztonal ground rod laid in the trench, minimum depth of 30", connected with 4 AWG wire.
    - [Ufer ground](https://en.wikipedia.org/wiki/Ufer_ground), basically a connection to the rebar inside of the workshop's concrete foundation. Also connected with 4 AWG wire.
- Surge Protection Device installed in the panel
    - [Square D 80kA Universal Whole Home Surge Protection Device HEPD80](https://www.homedepot.com/p/Square-D-80kA-Universal-Whole-Home-Surge-Protection-Device-HEPD80-HEPD80/203540660)

## House

- Wiring from Emergency Disconnect to GridBoss is three 2/0 AWG THHN/THWN-2 wires (Black for `L1`, Red `L2` and White for `Neutral`) and one 4 AWG wire (Green for `Ground`)
- [EG4 GridBoss Microgrid Interconnect Device (MID)](https://eg4electronics.com/categories/inverters/eg4-gridboss/), also called a "power gateway", the central connection point for the electrical systems
- 2x [EG4 FlexBoss21 Inverters](https://eg4electronics.com/categories/inverters/eg4-flexboss-21/), provide power from batteries and solar.
    - Wired to the GridBoss with three 4 AWG THHN/THWN-2 wires (`L1`, `L2`, `N`) and one 8 AWG wire for ground
- 4x [EG4 WallMount 280Ah Indoor Batteries](https://eg4electronics.com/categories/batteries/eg4-wallmount-indoor-280ah-lithium-battery/), ~14.3 kWh for a total of 57.2 kWh
    - 48V, connected in parallel
    - Battery #2 is connected to Inverter #1
    - Battery #3 is connected to Inverter #2
    - All battery wires are 2/0 AWG, battery to inverter wiring is 2x positive (red) and 2x negative (black)
- 200A Load Center (Main Panel)
    - Square D QO Plug-On Neutral
    - Model: QO30M200PC
    - Connected to the Backup Loads output on the GridBoss
    - Same size wires as the connection from Emergency Disconnect to GridBoss (3x 2/0, 1x 4 AWG)
- Old 100A load center to be disconnected from existing 100A service and connected to the new 200A Main Panel
    - 100A breaker in the new Main Panel
    - Wiring is three 2 AWG THHN/THWN-2 wires (Black for `L1`, Red `L2` and White for `Neutral`) and one 8 AWG wire (Green for `Ground`)
    - Conduit is 1-1/4" Schedule 80 PVC
    - Later on the panel will be replaced with a new 100A Square D QO Plug-On Neutral with AFCI/GFCI breakers
- Surge protection at multiple levels:
    - GridBoss and inverters have built-in surge protection
    - Surge Protection Device installed in the main panel
    - [Square D 80kA Universal Whole Home Surge Protection Device HEPD80](https://www.homedepot.com/p/Square-D-80kA-Universal-Whole-Home-Surge-Protection-Device-HEPD80-HEPD80/203540660) on 200A Main Panel
    - (Future) [50kA Plug-On Neutral Whole Home Surge Protection Device](https://www.homedepot.com/p/Square-D-50kA-Plug-On-Neutral-Whole-Home-Surge-Protection-Device-for-Square-D-QO-Load-Centers-QO250PSPD-QO250PSPD/300716367) on 100A Sub-Panel
    - Surge Protection power strips or UPS for important/sensitive electronics (Computers, TV, etc)
- EVSE (Tesla) charger
    - 60A circuit connected to Smart Port #4 on the GridBoss
    - Two 6 AWG THHN/THWN-2 wires (`L1`, `L2`, no `Neutral`) and one 8 AWG wire (`Ground`)
    - Can be turned off automatically by the GridBoss based on conditions (e.g. grid is down and batteries are low)

## Costs

Prices are aproximate and include tax+shipping. There are alot of smaller things (conduit, fittings, etc) that are not on this list.

| Item | Price | Quantity | Total |
| - | - | - | - |
| Square D Emergency Disconnect model Q2200MRBE | $185 | 4 | $740 |
| Square D 200A Load Center | $237 | 2 | $474 |
| Square D 80kA Surge Protection Device HEPD80 | $139 | 2 | $278 |
| EG4 GridBoss MID | $1,810 | 1 | $1,810 |
| EG4 FlexBoss21 Inverter | $3,900 | 2 | $7,800 |
| EG4 WallMount 280Ah Indoor Battery | $3,500 | 4 | $14,000 |

### Wire

| Wire | $/ft | Length | Total |
| - | - | - | - |
| 4/0,4/0,2/0 URD | $3.39 | 500ft | $1,695 |
| 2 AWG URD | $0.74 | 500ft | $370 |
| 2/0 THHN/THWN-2 | $4.00 | 35ft x3 | $420 |
| 2 AWG THHN/THWN-2 | $2.29 | 100ft x3 | $687 |
| 4 AWG THHN/THWN-2 | $1.52 | 75ft | $114 |
| 8 AWG THHN/THWN-2 | $0.64 | 125ft | $80 |
