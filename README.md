# Home energy

Logging, analysing and optimising a home energy system: solar, battery,
heat pump, EV and room temperatures.

See the [project proposal](docs/project_proposal.md) for aims, hardware,
stages and how progress is measured.

## Status

- [x] **Stage 1: Grid meter and Venus OS Large.** EM112 grid meter over Wi-Fi, GX on Venus OS Large with Node-RED. See [venus](venus/).
- [ ] **Stage 2: Feasibility backtest and tariff comparison.** In progress: Python environment set up; development data window 22 Oct to 7 Nov 2026; winter data accumulating.
- [x] **Stage 3: Home server foundations.** Proxmox on an HP EliteDesk mini PC, with a data container running Mosquitto, PostgreSQL and Node-RED. See [infra](infra/).
- [ ] **Stage 4: Victron data pipeline.** Logging about 55 readings every 30 seconds (5 since 22 Nov 2026, the rest since 24 Nov): power flows, grid meter energy counters, battery BMS (cell voltages and temperatures, current limits, alarms), inverter and solar charger states. See [signals](docs/signals.md). Next: log settings when they change, and a week of gap-free data.
- [ ] **Stage 5: Heat pump data.** Logging since 24 Nov 2026: 24 readings from the outdoor unit and controller (power, flow rate, temperatures, compressor, defrosts, daily yields) every 30 seconds. Next: work out the operating state (heating, hot water, defrost, idle) and live and daily COP.
- [ ] Stage 6: Room data
- [ ] Stage 7: Prices, weather and forecasts
- [ ] Stage 8: Analysis and dashboards
- [ ] Stage 9: Household interface and alerts
- [ ] Stage 10: Axle VPP participation
- [ ] Stage 11: Forecasting and optimiser

## Repository layout

| Folder | Contents |
| --- | --- |
| `docs/` | Project proposal and stage write-ups |
| `venus/` | Scripts that run on the Victron GX |
| `infra/` | Home server and container setup |
| `flows/` | Node-RED flow exports |
| `db/` | Database schema |
