---
status: deprecated
icon: material/light-switch
---

# Light/Fan Switches

!!! quote deprecated "Deprecated"

    These switches are still in use at our old house, but going forward I am now using Leviton's Decora Smart Wi-Fi Dimmer (2nd Gen). With an upgrade to a newer firmware these switches support [Matter](https://www.home-assistant.io/integrations/matter) connectivity.

    That's pretty neat.

In our house, all of the light and fan switches are "Martin Jerry Smart Switches", as they use the common Tuya module, which is really just an esp8266 board. Perfect for reflashing and running ESPHome on!

## Switch

```yaml
substitutions:
  device_name: hall-bath-light
  friendly_name: Hall Bath Light

esphome:
  name: ${device_name}
  comment: On/off light switch
  project:
    name: "aceat64.light_switch"
    version: "1.0.0"

esp8266:
  # Switch uses a Tuya module
  board: esp01_1m
  # Keeps the light's state saved in case of power loss
  restore_from_flash: true

# Enable logging
logger:
  # Make sure logging is not using the serial port
  baud_rate: 0

# Enable Home Assistant API
api:
  encryption:
    key: "xxxxxx"

ota:
  platform: esphome
  password: !secret ota_password

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

output:
  - platform: gpio
    pin: GPIO12
    id: power
  - platform: gpio
    pin: GPIO5
    inverted: true
    id: led1

light:
  - platform: binary
    name: ${friendly_name}
    output: power
    id: powerswitch
    restore_mode: RESTORE_DEFAULT_OFF
    on_turn_on:
      - output.turn_on: led1
    on_turn_off:
      - output.turn_off: led1

status_led:
  pin:
    number: GPIO4
    inverted: true

binary_sensor:
  - platform: gpio
    pin:
      number: GPIO13
      mode: INPUT_PULLUP
    internal: true
    id: main_button
    on_press:
      - light.toggle: powerswitch
```

## Dimmer

```yaml
# Based on: https://github.com/mjoshd/esphome_martin-jerry-mj-sd01-dimmer/blob/master/martin_jerry_mj_sd01_dimmer.yaml
substitutions:
  device_name: hall-light
  friendly_name: Hall Light
  pwm_min_power: 15%      # keep dimming functional at lowest levels
  no_delay: 0s            # transition when changing dimmer_lvl & relay delay
  transition_length: .5s  # transition when turning on/off
  long_press_min: .4s     # minimum time to activate long-press action
  long_press_max: 2s      # maximum time to activate long-press action
  long_press_up: 100%     # long press brightness
  long_press_down: 33%    # long press brightness
  long_press_main: 50%    # long press brightness

esphome:
  name: ${device_name}
  comment: Dimmer switch
  project:
    name: "aceat64.dimmer_switch"
    version: "1.0.0"

esp8266:
  # Switch uses a Tuya module
  board: esp01_1m
  # Keeps the light's state saved in case of power loss
  restore_from_flash: true

# Enable logging
logger:
  # Make sure logging is not using the serial port
  baud_rate: 0

# Enable Home Assistant API
api:
  encryption:
    key: "xxxxxx"

ota:
  platform: esphome
  password: !secret ota_password

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

output:
  - platform: gpio
    pin: GPIO3
    inverted: true
    id: led5
  - platform: gpio
    pin: GPIO5
    inverted: true
    id: led4
  - platform: gpio
    pin: GPIO12
    inverted: true
    id: led3
  - platform: gpio
    pin: GPIO14
    inverted: true
    id: led2
  - platform: esp8266_pwm
    pin: GPIO13
    id: pwm
    power_supply: relay
    min_power: ${pwm_min_power}

light:
  - platform: monochromatic
    name: ${friendly_name}
    output: pwm
    default_transition_length: ${no_delay}
    id: dimmer
    restore_mode: RESTORE_DEFAULT_OFF

status_led:
  pin:
    number: GPIO4
    inverted: true

power_supply:
  - id: relay
    pin:
      number: GPIO16
      inverted: True
    enable_time: ${no_delay}
    keep_on_time: ${no_delay}

binary_sensor:
  - platform: gpio
    pin:
      number: GPIO0
      inverted: True
      mode: INPUT_PULLUP
    name: ${friendly_name} Up Button
    id: up_button
    internal: True
    on_press:
      then:
        - lambda: |-
            if (id(dimmer_lvl) > .91) {
              id(dimmer_lvl) = 1.0;
            }
            else if (id(dimmer_lvl) <= .91) {
              id(dimmer_lvl) += .083;
            };
            id(apply_dimming).execute();
    on_click:
      min_length: ${long_press_min}
      max_length: ${long_press_max}
      then:
        - light.turn_on:
            id: dimmer
            brightness: ${long_press_up}
  - platform: gpio
    pin:
      number: GPIO1
      inverted: True
      mode: INPUT_PULLUP
    name: ${friendly_name} Down Button
    internal: True
    on_press:
      then:
        - lambda: !lambda |-
            if (id(dimmer_lvl) < .10) {
              id(dimmer_lvl) = .01;
            }
            else if (id(dimmer_lvl) >= .10) {
              id(dimmer_lvl) -= .083;
            };
            id(apply_dimming).execute();
    on_click:
      min_length: ${long_press_min}
      max_length: ${long_press_max}
      then:
        - light.turn_on:
            id: dimmer
            brightness: ${long_press_down}
  - platform: gpio
    pin:
      number: GPIO15
      mode: INPUT_PULLUP
    name: ${friendly_name} Main Button
    internal: True
    on_press:
      - light.toggle: dimmer
    on_click:
      min_length: ${long_press_min}
      max_length: ${long_press_max}
      then:
        - light.turn_on:
            id: dimmer
            brightness: ${long_press_main}

globals:
  - id: dimmer_lvl
    type: float
    restore_value: no
    initial_value: '1.0'

script:
  - id: apply_dimming
    then:
      - lambda: |-
          auto call = id(dimmer).turn_on();
          call.set_brightness(id(dimmer_lvl));
          call.perform();
      - logger.log:
          format: "dimmer_lvl = %.2f"
          args: ['id(dimmer_lvl)']

interval:
  - interval: 250ms
    then:
      - lambda: |-
          auto dimmer_vals = id(dimmer).current_values;
          if (dimmer_vals.is_on()) {
            id(dimmer_lvl) = dimmer_vals.get_brightness();
          }
          if (id(dimmer_lvl) > .19) { id(led2).turn_on(); }
          if (id(dimmer_lvl) < .20) { id(led2).turn_off(); }
          if (id(dimmer_lvl) > .39) { id(led3).turn_on(); }
          if (id(dimmer_lvl) < .40) { id(led3).turn_off(); }
          if (id(dimmer_lvl) > .59) { id(led4).turn_on(); }
          if (id(dimmer_lvl) < .60) { id(led4).turn_off(); }
          if (id(dimmer_lvl) > .79) { id(led5).turn_on(); }
          if (id(dimmer_lvl) < .80) { id(led5).turn_off(); }
          if (!dimmer_vals.is_on()) {
            id(led2).turn_off();
            id(led3).turn_off();
            id(led4).turn_off();
            id(led5).turn_off();
          }
```
