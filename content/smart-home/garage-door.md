---
status: deprecated
icon: material/garage-lock
---

# Garage Door

!!! quote deprecated "Deprecated"

    I no longer use this setup and have moved over to using [Paul Wieland's](https://github.com/PaulWieland) [ratgdo](https://paulwieland.github.io/ratgdo/) device.

## Materials

- [Adafruit HUZZAH32 – ESP32 Feather Board](https://www.adafruit.com/product/3405)
- [Adafruit Non-Latching Mini Relay FeatherWing](https://www.adafruit.com/product/2895)
- Magnetic door sensor or reed switch. Some examples:
    - [Magnetic contact switch (door sensor)](https://www.adafruit.com/product/375)
    - [Heavy Duty Wired Alarm Garage Door Magnetic Contacts Switch Sensor NC with Adjustable Bracket](https://www.amazon.com/Magnetic-Contacts-Shutter-Adjustable-Bracket/dp/B07ZBT28L8)

## ESPHome config

```yaml
substitutions:
  device_name: garage-door
  friendly_name: Garage Door

esphome:
  name: ${device_name}
  comment: Open and close a garage door
  project:
    name: "aceat64.garage_door"
    version: "1.0.0"

esp32:
  board: featheresp32

wifi:
  # Use a static IP, it improves connection time
  # Recommended by ESPHome: https://esphome.io/components/wifi.html
  manual_ip:
    static_ip: 192.168.xxx.xxx
    gateway: 192.168.xxx.xxx
    subnet: 255.255.255.0
    dns1: 192.168.xxx.xxx
  # SSID and password stored as secrets, so that all devices share the config
  ssid: !secret wifi_ssid
  password: !secret wifi_password

  # Enable fallback hotspot (captive portal) in case wifi connection fails
  ap:
    ssid: ${device_name}
    password: !secret fallback_password

captive_portal:

# Enable logging
logger:
  # Make sure logging is not using the serial port
  baud_rate: 0

# Enable Home Assistant API
api:

ota:
  password: !secret ota_password

binary_sensor:
  - platform: gpio
    pin:
      number: A0
      mode: INPUT_PULLUP
    name: "Garage Door Contact Sensor"
    id: contact_sensor
    internal: true

switch:
  - platform: gpio
    pin: A1
    name: "Garage Door Relay"
    id: relay
    internal: true

cover:
  - platform: template
    device_class: garage
    name: ${friendly_name}
    lambda: |-
      if (id(contact_sensor).state) {
        return COVER_OPEN;
      } else {
        return COVER_CLOSED;
      }
    open_action:
      - switch.turn_on: relay
      - delay: 0.5s
      - switch.turn_off: relay
    close_action:
      - switch.turn_on: relay
      - delay: 0.5s
      - switch.turn_off: relay
```
