# Home energy

Logging, analysing and optimising a home energy system: solar, battery,
heat pump, EV and room temperatures.

See the [project proposal](docs/project_proposal.md) for aims, hardware,
stages and how progress is measured.

## Status

- [x] **Stage 1: Grid meter and Venus OS Large.** EM112 grid meter over Wi-Fi, GX on Venus OS Large with Node-RED. See [venus](venus/).
- [ ] **Stage 2: Feasibility backtest and tariff comparison.** In progress: Python environment set up; development data window 22 Oct to 7 Nov 2026; winter data accumulating.
- [x] **Stage 3: Home server foundations.** Proxmox on an HP EliteDesk mini PC, with a data container running Mosquitto, PostgreSQL and Node-RED. See [infra](infra/).
- [ ] **Stage 4: Victron data pipeline.** Logging since 22 Nov 2026: grid, consumption, solar and battery power plus battery state of charge, every 30 seconds. Next: more readings and a week of gap-free data.
- [ ] **Stage 5: Heat pump data.** In progress: ebusd 26.1 reading the controller, indoor unit and outdoor unit (power, flow rate, temperatures, daily yields). Next: log selected values to the database every 30 seconds.
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
