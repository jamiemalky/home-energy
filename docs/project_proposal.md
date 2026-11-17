# Home Energy Data Project — Proposal

Last updated Nov 15, 2026

## Summary

This project logs a home's solar, battery, heat pump and room-temperature data into a PostgreSQL database every 10–60 seconds, on a small home server. The data is used to measure heat pump performance, model the house's heat loss, catch faults early, and finally schedule the battery, EV, heating and hot water against half-hourly electricity prices with a custom optimiser. The same control layer lets the battery take part in Axle Energy's virtual power plant (VPP), earning payments for supporting the grid. The flows, schema, analysis and dashboards all live in this repository, so the whole system can be rebuilt from scratch.

## Goals

**What the house gets**

- Lower running costs, by moving battery, EV, heating and hot water use into cheap and solar-rich periods.
- The right Octopus tariff for each season, chosen from modelled costs on the house's own half-hourly data rather than estimates.
- Extra income from grid-support events through the Axle VPP, without compromising the house's own needs.
- Better heat pump efficiency, by tuning the heating curve and hot water settings from measured COP rather than guesswork.
- Earlier fault detection: failed defrosts, communication faults, falling system pressure or a cylinder not reaching temperature, spotted before they mean a cold house or a cold shower.
- A measured picture of the house: its heat-loss coefficient, room-by-room heating demand, and where each kWh came from.
- Simple controls and alerts for the household through an existing smart display.

**Engineering practice**

- Version control throughout: a branch per stage, meaningful commits, and a README that rebuilds the system.
- A proper relational schema and SQL views over time-series data.
- Tested, quality-assured Python analysis, following reproducible analytical pipeline (RAP) principles.
- Dashboards and short write-ups that explain each result to a non-technical reader.

## System context

The project builds on equipment already installed: a Victron EasySolar inverter-charger with a GX device, 20 kWh of LiFePO4 batteries and 9 kW of solar; an EM112 grid meter; a Vaillant aroTHERM air-source heat pump with a sensoCOMFORT controller; underfloor heating and radiators with Heatmiser neo room thermostats; and Octopus time-of-use import and export tariffs, chosen by season (Cosy import for winter 2026–27).

&#91;embedded content: system architecture · 4 sources, the home server, 4 outputs\]

The Victron and smart-display links run both ways, because later stages send control commands back out; everything else is read-only.

## Hardware

The only new purchases are a used mini PC and an eBUS adapter; everything else is already installed.

| Item | Status | Purpose and notes |
| --- | --- | --- |
| HP EliteDesk 800 G3 Mini (i5-6500T, 8 GB RAM, 256 GB NVMe) | Chosen, about £70 used | Home server running Proxmox. Idles around 10 W, takes up to 32 GB RAM and a second drive |
| Ethernet link to the router | Required | Wired connection for reliable logging |
| External USB drive | Owned | Local target for nightly backups |
| eBUS Adapter Stick C6 | Ordered | Wi-Fi, galvanically isolated, polarity-free. Wired in parallel to the eBUS pair at the heat pump controller, with the system isolated first |
| 5V USB-C supply for the eBUS adapter | To buy | Phone charger or a USB-C wall plate; under 120 mA draw |
| Victron EasySolar with GX, LiFePO4 batteries, EM112 grid meter | Installed | Solar, battery and grid data over MQTT |
| Vaillant aroTHERM with sensoCOMFORT VRC 720 | Installed | Heat pump data over eBUS |
| Heatmiser neoHub and neoStats | Installed | Room temperatures and setpoints over the neoHub local API |
| Google Nest Hub | Owned | Display, voice and control surface for the household |

A Raspberry Pi 4 was the original plan. A used business mini PC costs about the same, and adds internal NVMe storage, x86 compatibility and room to run Home Assistant alongside the logging stack. No circuits in the house are battery-backed, so the server must recover cleanly by itself after a power cut.

## Software

Everything is free and open source. Proxmox keeps each service separate, so any part can be snapshotted, rebuilt or upgraded without touching the rest.

| Component | Runs on | Role |
| --- | --- | --- |
| Venus OS Large | Victron GX | Victron firmware with Node-RED built in; runs the grid-meter services and the battery-side control flows, including Axle VPP events |
| Proxmox VE | Mini PC | Hypervisor: runs the data stack and optional services as separate virtual machines or containers, with snapshots |
| Debian | Proxmox VM or container | Host for the data stack |
| Mosquitto | Data stack | MQTT broker that every data source publishes into |
| Node-RED | Data stack | Collects, cleans and batches data into the database; runs control logic, alerts and the smart-display switches |
| PostgreSQL (TimescaleDB optional) | Data stack | Time-series database for readings, prices and forecasts |
| ebusd | Data stack | Reads the heat pump through the eBUS adapter and publishes to MQTT; read-only at first |
| Venus OS MQTT | Victron GX | Publishes inverter, battery, solar and grid data; needs a keepalive about once a minute |
| neoHub local API (neohubapi library) | Data stack | Polls room temperatures and setpoints every 1–5 minutes |
| Octopus Agile API | Internet | Half-hourly Agile prices, published around 4pm for the next day, and historical rates for every tariff |
| Axle Energy API | Internet | Grid-support event notifications and results for the VPP |
| Open-Meteo, Forecast.Solar or Solcast | Internet | Weather and solar forecasts |
| Python: pandas, psycopg, pvlib, PuLP or scipy, pytest | Data stack or laptop | Analysis, forecasting, the optimiser and its tests |
| Grafana | Data stack | Dashboards built from SQL queries |
| node-red-contrib-google-smarthome, with a Cloudflare or Tailscale tunnel | Data stack | Exposes virtual switches such as Charge EV now to the smart display, without opening router ports |
| Home Assistant OS (optional) | Proxmox VM | Future integrations, sharing the same MQTT broker |
| Git and GitHub | Everywhere | This repository: flows, schema, analysis code and dashboard definitions |
| pg\_dump and restic | Data stack | Nightly backups to the external drive and an off-site cloud bucket |

## Measurables

Success is judged on data quality first, then on what the data reveals, and last on money saved or earned against Victron Dynamic ESS.

| Area | Measure | Target |
| --- | --- | --- |
| Data quality | Share of expected samples recorded per week, excluding power cuts | 99% or better |
| Reliability | Time to resume logging after a pulled-plug power cut, with no manual steps | Under 5 minutes |
| Reproducibility | Rebuild the server from this repository and its README alone | Done once, end to end |
| Fault detection | Time from a heat pump fault or failed defrost to an alert | Under 10 minutes |
| Heat pump | Daily COP and a seasonal SCOP estimate, against outdoor and flow temperature | First month's figures published |
| Hot water | Daily hot water energy | 3–4 kWh a day once settings are tuned |
| Energy sourcing | Share of heat pump electricity from solar, battery and grid | Calculated monthly |
| Tariff choice | Modelled annual cost of each allowed Octopus import and export pairing, on the house's own data | Recommendation reviewed each season |
| House model | Heat-loss coefficient in W/K, with an uncertainty range | Compared with the design heat-loss calculation |
| Forecasting | Solar and load forecast error, as mean absolute error in kWh per day | Each forecast source compared on the same days |
| VPP | Events joined, energy delivered and income earned; every event ends with the system back in its normal state | All events handled safely; income reported monthly |
| Optimiser | Cost per day against Victron Dynamic ESS, in shadow mode | At least 4 weeks at parity or better before it takes control |

## Stages

Eleven stages, each ending in something that works and is committed to Git. Stage 1 is partly done already. Stages 5 and 6 depend on hardware, so they can swap order or run alongside stage 7.

### 1. Grid meter and Venus OS Large

- **Goal:** an accurate grid meter feeding the Victron ESS, and the GX running Venus OS Large without losing it.
- **Already done:** a Carlo Gavazzi EM112 meter read over Wi-Fi through a Waveshare RS485 bridge, presented to Venus OS as a local serial port and driven by Victron's own meter driver. It runs as persistent services that survive reboots. The appendix documents how.
- **Requires for the upgrade:** copy `/data/em112/` and `/data/rc.local` off the GX and note the current firmware version for rollback. Check where `socat` lives; if it is under `/usr/bin`, copy it to `/data/bin/` and point the run script there, because firmware updates replace `/usr`. Then install Venus OS Large.
- **Done when:** after the upgrade and a reboot, both meter services are up, the EM112 shows as the grid meter, ESS and Victron Dynamic ESS behave as before, Node-RED is reachable on the GX, and MQTT can be switched on for stage 4.

### 2. Feasibility backtest and tariff comparison on existing data (solar and battery only)

- **Goal:** early, evidence-based answers to two questions, using data that already exists and before any new hardware arrives: could a custom battery schedule beat Victron Dynamic ESS, and which Octopus import and export tariffs suit the house best, season by season?
- **Requires:** historical solar, consumption, grid and battery data exported from VRM (CSV download or the VRM API), and historical unit rates and standing charges for the candidate tariffs from Octopus's public API for the local region: Agile, Cosy, Go, Flux and Tracker on import, and Agile Outgoing and fixed export on the export side. A Python model of the battery (usable capacity, charge and discharge power limits, round-trip efficiency, the 15% state-of-charge floor and the export limit), solved as the same half-hourly linear programme planned for stage 11, using PuLP, and re-run under each tariff, because the best battery schedule changes with the tariff. Heat pump, EV and hot water use are treated as fixed demand, because they can't be shifted in hindsight. Only import and export pairings that Octopus actually allows are compared.
- **Done when:** a notebook and a short write-up in `docs/` report, over at least a month of data: actual cost; optimised cost on the current tariff and the gap between them; and the annualised cost of each allowed tariff pairing, standing charges included. The write-up states plainly that optimised figures assume perfect foresight and are therefore an upper bound, recommends a tariff for winter and for summer, and concludes whether the stage 11 optimiser is worth building. The comparison is re-run as each new season of data arrives.

### 3. Home server foundations

- **Goal:** a home server that is secure, updated and backed up from day one.
- **Requires:** Proxmox on the mini PC, a Debian VM or container for the data stack, SSH keys, then Mosquitto, Node-RED and PostgreSQL. Secrets kept outside Git. Nightly backups to the external drive and the cloud.
- **Done when:** the server survives a pulled-plug reboot and comes back with every service running, and a test restore from backup works.

### 4. Victron data pipeline

- **Goal:** the first real data flowing into the database.
- **Requires:** MQTT switched on in the GX, a Node-RED keepalive, the first schema (a readings table with timestamp, source, metric and value), and batched inserts every 10–60 seconds.
- **Done when:** a week of solar, battery, load and grid data sits in PostgreSQL with no gaps beyond power cuts.

### 5. Heat pump data

- **Goal:** heat pump temperatures, power, energy counters, status codes and defrost events logged alongside the Victron data.
- **Requires:** the eBUS adapter wired in parallel at the controller with the system isolated, joined to Wi-Fi, ebusd in read-only mode with the right Vaillant message definitions.
- **Done when:** flow, return and outdoor temperature, flow rate, compressor state, status codes and energy figures appear every minute.

### 6. Room data

- **Goal:** temperature and setpoint for every room.
- **Requires:** API access switched on in the Neo app to get a token, and a poller every 1–5 minutes.
- **Done when:** all rooms log continuously and match the thermostats' own displays.

### 7. Prices, weather and forecasts

- **Goal:** the context for every reading: what electricity cost, and what was forecast.
- **Requires:** the Agile import and export price fetch, Open-Meteo weather, and at least one solar forecast source, each stored with the time it was issued so forecasts can be scored later.
- **Done when:** prices and forecasts are stored daily and forecast-against-actual can be queried.

### 8. Analysis and dashboards

- **Goal:** the first findings, written up.
- **Requires:** SQL views for daily energy; Python analysis of COP, energy sourcing, heat loss and defrost behaviour; Grafana dashboards exported to this repository.
- **Done when:** a short write-up reports COP against outdoor temperature, the heat-loss coefficient, where the heat pump's electricity comes from, and how often it defrosts.

### 9. Household interface and alerts

- **Goal:** useful controls and warnings without opening an app.
- **Requires:** Heatmiser linked to Google Home; virtual switches such as Charge EV now and Boost hot water; spoken announcements and phone alerts from Node-RED for faults, low system pressure and cheap-price periods. Load shedding on the grid-meter reading is built here, before any automatic control.
- **Done when:** a switch on the smart display sets an override that expires on its own and respects every safety limit, and a simulated fault raises an alert.

### 10. Axle VPP participation

- **Goal:** the battery taking part in Axle Energy grid-support events automatically and safely.
- **Requires:** a Node-RED flow on the GX that receives events from the Axle API, pauses Victron Dynamic ESS for the event window, sets the ESS grid setpoint to export at the agreed power, and restores normal operation afterwards. Safety features come first: a state-of-charge floor, an absolute end-time timer independent of the event logic, and a restore-to-safe-state on Node-RED startup. Every event is logged to the database.
- **Done when:** a test event and then several real events run end to end, the system returns to its normal state every time, and delivered energy and income are reported.

### 11. Forecasting and optimiser

- **Goal:** a scheduler for the battery, EV, heating and hot water that beats Victron Dynamic ESS.
- **Requires:** a load model trained on the logged data, solar and weather forecasts, and a linear programme over 48 half-hour slots, solved with PuLP or scipy and re-run every half hour. It runs in shadow mode first and is backtested against Victron Dynamic ESS. VPP event windows are treated as fixed commitments.
- **Done when:** four weeks in shadow mode show parity or better. Only then does it take control, with Victron Dynamic ESS kept as the fallback.

## Risks and safeguards

The main risks come from the control stages, so safety logic is built before any control logic.

| Risk | Safeguard |
| --- | --- |
| Overloading the incoming supply: heat pump, EV and immersion are all on the grid side of the inverter | Load shedding on the grid-meter reading with a ceiling of about 65–70 A; every override still passes through it |
| An override, schedule or VPP event left running | Every override expires on its own; an absolute end-time timer sits outside the event logic |
| Battery run too low, including during a VPP event | A state-of-charge floor of 15%, matching the minimum set in Victron Dynamic ESS, that no schedule or event can breach |
| Node-RED restarts mid-action | Restore a safe state on startup, with Victron Dynamic ESS as the fallback |
| Victron Dynamic ESS and a VPP event fighting each other | Dynamic ESS is paused for the event window and re-enabled automatically when it ends |
| Writing to the eBUS upsets the heat pump | ebusd stays read-only until logging is proven |
| Losing the grid meter after a firmware update | Back up the meter services first, keep dependencies in `/data`, and note the firmware version for rollback |
| Server hardware failure | Proxmox snapshots, tested off-box backups, and a rebuild path documented in this repository |
| Publishing private details | API tokens, account numbers and location data kept in an environment file excluded from Git |
| Exposing the server to the internet for Google Home | A tunnel with authentication; no open router ports |
| The grid-meter link breaking silently | Alert when grid-meter data goes stale |
| Scope creep | Each stage is finished and committed before the next starts |

## Repository layout

- `venus/`: GX service scripts for the grid meter (stage 1) and GX Node-RED flows, including the VPP flow
- `infra/`: Proxmox and VM setup notes, service configuration
- `flows/`: Node-RED flow exports from the home server (JSON)
- `db/`: schema and migrations
- `analysis/`: Python package, notebooks and tests
- `dashboards/`: Grafana dashboard JSON
- `docs/`: this proposal and a short write-up for each finished stage

## Appendix: grid meter over Wi-Fi

**The problem.** The EM112 is a Modbus RTU meter on RS485. Running a cable to the GX wasn't practical, so the meter connects to a Waveshare RS485-to-Wi-Fi bridge instead. Venus OS couldn't see it that way: its Carlo Gavazzi driver, `dbus-cgwacs`, only reads local serial ports, and its Modbus TCP scanner only recognises the Ethernet version of a different meter (the EM24).

**The solution.** `socat` on the GX creates a virtual serial port, `/dev/ttyEM112`, connected to the bridge's TCP socket. `dbus-cgwacs` runs against that port exactly as if the meter were wired in locally, and publishes it on D-Bus as a grid meter.

**Services.** Each runs under Venus OS's service supervisor from a script in `/data`, which survives firmware updates.

`/data/em112/socat/run`:

```sh
#!/bin/sh
exec 2>&1
exec socat pty,link=/dev/ttyEM112,raw,echo=0 \
    tcp:<bridge-ip>:502,nodelay,keepalive,keepidle=10,keepintvl=3,keepcnt=3
```

`/data/em112/cgwacs/run`:

```sh
#!/bin/sh
exec 2>&1
sleep 3
exec /opt/victronenergy/dbus-cgwacs/dbus-cgwacs --timeout 1000 /dev/ttyEM112
```

`/data/rc.local`, which links both into the supervisor at boot:

```sh
#!/bin/sh
ln -sf /data/em112/socat  /service/socat-em112
ln -sf /data/em112/cgwacs /service/cgwacs-em112
```

Check with `svstat /service/socat-em112 /service/cgwacs-em112`: both should show `up`, with the seconds count climbing on repeat checks.

**Lessons learned**

- The bridge must be in **transparent mode**, not Modbus TCP-to-RTU conversion. A factory reset puts it back to conversion, and the meter then disappears with no obvious error.
- `echo=0` on the virtual port is essential; without it, echoed bytes corrupt the Modbus frames.
- Install services in `/data` and symlink them into `/service`. A service directory created directly under `/opt` kept overriding the working one after every reboot until it was found and removed.
- `--timeout 1000` allows for Wi-Fi latency, and the short `sleep` stops the driver starting before the virtual port exists.
- Firmware updates replace `/usr`, so any extra binary the services depend on belongs in `/data`.
