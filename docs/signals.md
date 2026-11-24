# Signals

Every reading the project logs or plans to log, where it comes from, and why
it's worth having. Use it as the checklist when adding readings to a Node-RED
flow, and as the data dictionary when analysing the `readings` table.

The rule of thumb is to log generously. Storage is cheap: 60 readings every 30
seconds is roughly 170,000 rows, or about 25 MB, a day, or about 9 GB a year
on a 256 GB drive. A missing reading can never be recovered later.

**Status:** ✅ logging · 🟡 next · ⚪ later · ❌ not available on this system · ❔ check it exists

Victron topics are written after `N/c0619aba02e2/`. Device instances on this
system: grid 30, vebus 275, battery 512, solarcharger 273. Victron readings
logged since 22 Nov 2026 (first five) and 24 Nov 2026 (the rest).

## 1. Victron: system summary (`system/0`)

The GX's own roll-up of the whole installation. Single-phase, so L1 only.

| Status | Topic path | Metric name | Unit | Why |
| --- | --- | --- | --- | --- |
| ✅ | `Ac/Grid/L1/Power` | `grid_power_w` | W | Import (+) and export (−) |
| ✅ | `Ac/Consumption/L1/Power` | `consumption_power_w` | W | Total house load |
| ✅ | `Dc/Pv/Power` | `pv_power_w` | W | Solar into the system |
| ✅ | `Dc/Battery/Power` | `battery_power_w` | W | Charge (+) and discharge (−) |
| ✅ | `Dc/Battery/Soc` | `battery_soc_pct` | % | State of charge |
| ✅ | `Ac/ConsumptionOnInput/L1/Power` | `consumption_on_input_w` | W | Loads on the grid side of the inverter (not backed up) |
| ✅ | `Ac/ConsumptionOnOutput/L1/Power` | `consumption_on_output_w` | W | Loads on the inverter output (backed up) |
| ✅ | `Dc/Battery/Voltage` | `battery_voltage_v` | V | Battery health; charging stage |
| ✅ | `Dc/Battery/Current` | `battery_current_a` | A | Compare against the BMS current limits |
| ✅ | `Dc/Battery/Temperature` | `battery_temp_c` | °C | Cold batteries charge slowly or not at all |
| ❌ | `Dc/Battery/TimeToGo` | `battery_time_to_go_s` | s | Not published on this system |
| ⚪ | `Dc/System/Power` | `dc_system_power_w` | W | DC loads, if any |
| ✅ | `Ac/ActiveIn/Source` | `active_in_source` | code | 1 grid, 240 inverting (grid lost) |
| ✅ | `SystemState/State` | `system_state` | code | See the codes below |
| ✅ | `SystemState/LowSoc` | `flag_low_soc` | 0/1 | At the minimum SOC |
| ✅ | `SystemState/SlowCharge` | `flag_slow_charge` | 0/1 | Slow-charging from the grid |
| ✅ | `SystemState/ChargeDisabled` | `flag_charge_disabled` | 0/1 | The BMS has blocked charging |
| ✅ | `SystemState/DischargeDisabled` | `flag_discharge_disabled` | 0/1 | The BMS has blocked discharging |
| ✅ | `SystemState/BatteryLife` | `flag_batterylife` | 0/1 | BatteryLife active |
| ✅ | `Control/ScheduledCharge` | `scheduled_charge_active` | 0/1 | Shows the Cosy-window schedules ran |
| ⚪ | `Timers/TimeOnGrid`, `TimeOnInverter` | `time_on_grid_s`, `time_on_inverter_s` | s | Since reboot; shows outages |

`SystemState/State` codes: 0 off, 1 low power, 2 VE.Bus fault, 3 bulk,
4 absorption, 5 float, 6 storage, 7 equalise, 8 passthru, 9 inverting,
10 assisting, 244 battery sustain, 252 external control, 256 discharging,
257 sustain, 258 recharge, 259 scheduled recharge.

## 2. Victron: grid meter, EM112 (`grid/30`)

The meter's own counters are the most accurate source for costs, because they
don't miss anything between 30-second samples.

| Status | Topic path | Metric name | Unit | Why |
| --- | --- | --- | --- | --- |
| ✅ | `Ac/Energy/Forward` | `grid_import_kwh` | kWh | Running import total, which gives exact half-hourly costs |
| ✅ | `Ac/Energy/Reverse` | `grid_export_kwh` | kWh | Running export total, for Agile Outgoing income |
| ✅ | `Ac/L1/Voltage` | `grid_voltage_v` | V | Grid quality; high voltage can limit export |
| ✅ | `Ac/L1/Current` | `grid_current_a` | A | Compare against the supply fuse |
| ❌ | `Ac/L1/PowerFactor` | `grid_power_factor` | – | Not published by this meter |
| ✅ | `Ac/Frequency` | `grid_frequency_hz` | Hz | Context for future grid services |

## 3. Victron: inverter/charger, EasySolar (`vebus/275`)

| Status | Topic path | Metric name | Unit | Why |
| --- | --- | --- | --- | --- |
| ✅ | `State` | `vebus_state` | code | What the Multi itself is doing |
| ✅ | `Ac/ActiveIn/L1/P` | `vebus_ac_in_power_w` | W | Power through the Multi's AC input |
| ✅ | `Ac/Out/L1/P` | `vebus_ac_out_power_w` | W | Power to the backed-up loads |
| ✅ | `Dc/0/Power` | `vebus_dc_power_w` | W | Charger/inverter DC side; with the AC side gives conversion losses |
| ❌ | `Dc/0/Temperature` | `vebus_temp_c` | °C | Not published by this inverter |
| ⚪ | `Ac/ActiveIn/L1/V`, `Ac/ActiveIn/L1/F` | `vebus_ac_in_v`, `vebus_ac_in_hz` | V, Hz | Grid quality at the inverter |
| ✅ | `Alarms/L1/Overload`, `Alarms/L1/HighTemperature` | `vebus_alarm_overload`, `vebus_alarm_high_temp` | 0/1/2 | Alerts in stage 9 |
| ⚪ | `Bms/AllowToCharge`, `Bms/AllowToDischarge` | `vebus_bms_allow_*` | 0/1 | Confirms the BMS signals reach the Multi ❔ |

`State` codes: 0 off, 1 low power, 2 fault, 3 bulk, 4 absorption, 5 float,
6 storage, 7 equalise, 8 passthru, 9 inverting, 10 power assist,
11 power supply, 244 sustain, 252 external control.

## 4. Victron: battery BMS, Fogstar over CAN (`battery/512`)

BMS16S200A-ST061, two heated modules (heaters switch on below about 5 °C),
400 Ah. No heater flag is published; heater cycles show up as cell
temperature rising while the battery is idle. Diagnostics, History and Sense
are empty on this BMS. Also logged: `bms_modules_online`,
`bms_modules_blocking_charge`, `bms_modules_blocking_discharge` and alarms
`bms_alarm_cell_imbalance`, `_low_charge_temp`, `_charge_blocked`,
`_discharge_blocked`, `_internal_failure`.

| Status | Topic path | Metric name | Unit | Why |
| --- | --- | --- | --- | --- |
| ✅ | `Info/MaxChargeCurrent` | `bms_ccl_a` | A | Charge limit, which may explain slow charging |
| ✅ | `Info/MaxDischargeCurrent` | `bms_dcl_a` | A | Discharge limit |
| ✅ | `Info/MaxChargeVoltage` | `bms_cvl_v` | V | Charge voltage limit |
| ✅ | `Soc` | `bms_soc_pct` | % | The BMS's own SOC, to compare with the system value |
| ✅ | `Soh` | `bms_soh_pct` | % | State of health; track degradation over years |
| ✅ | `System/MinCellVoltage`, `System/MaxCellVoltage` | `bms_cell_v_min`, `bms_cell_v_max` | V | Cell imbalance, the early sign of battery trouble |
| ✅ | `System/MinCellTemperature`, `System/MaxCellTemperature` | `bms_cell_temp_min`, `bms_cell_temp_max` | °C | Cold-charging limits |
| ❌ | `History/ChargeCycles` | `bms_cycles` | count | Not published by this BMS |
| ❌ | `History/ChargedEnergy`, `History/DischargedEnergy` | `bms_charged_kwh`, `bms_discharged_kwh` | kWh | Always 0 on this BMS |
| ⚪ | `Alarms/*` (CellImbalance, HighTemperature, LowTemperature, HighChargeCurrent and others) | `bms_alarm_*` | 0/1/2 | Alerts in stage 9 |

## 5. Victron: solar charger, EasySolar's built-in MPPT (`solarcharger/273`)

| Status | Topic path | Metric name | Unit | Why |
| --- | --- | --- | --- | --- |
| ✅ | `Pv/V` | `pv_voltage_v` | V | Panel string voltage; shows shading and faults |
| ✅ | `Yield/Power` | `mppt_power_w` | W | Solar power as the MPPT sees it |
| ✅ | `History/Daily/0/Yield` | `pv_yield_today_kwh` | kWh | Today's solar total |
| ✅ | `Yield/System` | `pv_yield_total_kwh` | kWh | Lifetime total, which can't be reset |
| ✅ | `MppOperationMode` | `mppt_mode` | code | 1 limited (curtailed, so solar was wasted), 2 tracking normally |
| ✅ | `State` | `mppt_state` | code | Bulk, absorption, float, external control |
| ✅ | `ErrorCode` | `mppt_error` | code | Alerts in stage 9 |
| ⚪ | `Dc/0/Current` | `mppt_current_a` | A | Charge current into the battery |

`MppOperationMode` matters for the optimiser: time spent at 1 means the
battery was full or export was capped, so free solar was thrown away.

## 6. Victron: settings, logged when they change

These change rarely. Log them on change, not every 30 seconds, so the
analysis knows which settings were in force at any moment. This replaces
most of the manual entries in `data_periods.md`.

| Status | Path (service `settings/0`) | Why |
| --- | --- | --- |
| ⚪ | `Settings/CGwacs/BatteryLife/MinimumSocLimit` | Minimum SOC (15%) |
| ⚪ | `Settings/CGwacs/BatteryLife/State` | ESS mode: optimised, with or without BatteryLife, keep charged |
| ⚪ | `Settings/CGwacs/Hub4Mode` | ESS control mode |
| ⚪ | `Settings/CGwacs/MaxChargePower`, `MaxDischargePower` | User power limits |
| ⚪ | `Settings/CGwacs/AcPowerSetPoint` | Grid set point |
| ⚪ | `Settings/CGwacs/MaxFeedInPower`, `OvervoltageFeedIn`, `PreventFeedback` | Export settings (3.68 kW cap) |
| ⚪ | `Settings/CGwacs/BatteryLife/Schedule/Charge/<0–4>/Day`, `Start`, `Duration`, `Soc` | The scheduled-charge windows themselves |
| ⚪ | `Settings/DynamicEss/Mode` | Whether Victron Dynamic ESS is on or off ❔ |

## 7. Victron Dynamic ESS (now off)

DESS was switched off on 24 Nov 2026. While it's on, the GX publishes its
plan, which would let the benchmark compare its decisions with yours:

- `system/0/DynamicEss/Strategy`, `.../TargetSoc`, `.../WindowSlot`, `.../ErrorCode` ❔
- `settings/0/Settings/DynamicEss/Schedule/<0–47>/Start`, `Duration`, `Soc`, `Strategy`, `AllowGridFeedIn` ❔

Not worth logging while it's off. Revisit if DESS is ever turned back on as a
benchmark.

## 8. Victron EV charger (`evcharger/<n>`), when installed

| Status | Topic path | Metric name | Unit | Why |
| --- | --- | --- | --- | --- |
| ⚪ | `Ac/Power` | `ev_power_w` | W | Charging power |
| ⚪ | `Ac/Energy/Forward` | `ev_energy_kwh` | kWh | Energy delivered |
| ⚪ | `Status` | `ev_status` | code | Disconnected, connected, charging, charged |
| ⚪ | `Mode` | `ev_mode` | code | Manual, auto, scheduled |
| ⚪ | `SetCurrent` | `ev_set_current_a` | A | Current the optimiser asked for |

## 9. Victron: GX health (`platform/0`)

| Status | Topic path | Why |
| --- | --- | --- |
| ⚪ | `Notifications/NumberOfActiveAlarms`, `NumberOfActiveWarnings` | One number for "anything wrong?" |
| ⚪ | `Network/Wifi/SignalStrength` | The grid meter and GX rely on Wi-Fi ❔ |

## 10. Heat pump, Vaillant aroTHERM via ebusd

✅ 24 readings logging since 24 Nov 2026. See the Heat pump flow for the
list. Still to add:

| Status | Source | Reading | Why |
| --- | --- | --- | --- |
| 🟡 | Derived | Operating state: heating, hot water, defrost, idle | Split energy and COP by mode |
| 🟡 | Derived | Heat output, flow × 4.18 × ΔT | Live COP every 30 seconds |
| ⚪ | ctlv3 | Room temperature and setpoint for the controlled zone | Heat loss calculation |
| ⚪ | ctlv3 | Hot water and heating mode settings, heating curve | Settings in force (log on change) |
| ⚪ | hmux0 | Energy counters, if a working field is found | Cross-check the daily yields |

## 11. Other house loads

The two Shellys (immersion heater and car park floodlight) are on Wi-Fi only,
not connected to the GX. They can publish straight to the server's Mosquitto.

| Status | Source | Reading | Why |
| --- | --- | --- | --- |
| ⚪ | Shelly on the immersion heater (MQTT) | Power and energy | Separate immersion use from heat pump hot water |
| ⚪ | Heatmiser (stage 6) | Room temperatures, setpoints, zone demand | Heat loss per room; whether zones are open |

## 12. Outside sources (stage 7)

None of these come from the GX. Each needs a small Node-RED flow or Python
script that polls an API.

| Status | Source | Readings | Why |
| --- | --- | --- | --- |
| ⚪ | **Octopus API** | Half-hourly import and export from the smart meter; Cosy unit rates; Agile Outgoing export prices; standing charges | The billing truth, to check against the EM112; prices for the optimiser and the tariff comparison |
| ⚪ | **Open-Meteo** (free, no key) | Outside temperature, cloud cover, solar irradiance (GHI, direct, diffuse), wind, humidity; forecast and historical | Heat demand and solar forecasts for the optimiser; weather-normalised comparisons |
| ⚪ | **VRM API** | Victron's solar and consumption forecasts for the site | Compare your own forecast against Victron's |
| ⚪ | **Forecast.Solar or Solcast** (free tiers) | Solar production forecast for the panel orientation | A second solar forecast to compare |
| ⚪ | **Carbon Intensity API** (National Grid ESO, regional) | Grid carbon intensity, now and forecast | Carbon cost alongside money cost |
| ⚪ | **Axle** (stage 10) | VPP event times and requested power | Score participation and earnings |

## Design notes

- **30-second snapshots** suit readings that change constantly (power,
  temperature, SOC).
- **Counters** (kWh totals, starts, defrosts) give exact energy over any
  period by subtracting two readings, so they matter more than the power
  samples for costs.
- **Codes and flags** (states, modes, alarms) are stored as numbers. The
  tables of codes in this file explain them.
- **Settings** should be logged on change into the same table, so analysis
  can look up what was in force at any time.

## Sources

- Victron D-Bus paths: [victronenergy/venus wiki: dbus](https://github.com/victronenergy/venus/wiki/dbus)
- Dynamic ESS paths: [Victron community: overriding DESS slots from Node-RED](https://community.victronenergy.com/t/can-node-red-override-dess-slot-strategy-while-mode-1-vrm-auto-is-active/56857)
- VRM forecasts: [Victron community: VRM consumption forecast via API](https://community.victronenergy.com/t/vrm-consumption-forecast-only-two-days-via-api/57273)
