# Data periods

A record of events that change how the house's energy data should be read.
Analyses use this log to decide which days to include, exclude or flag.
Newest first. Dates marked *to confirm* need checking against the source.

| Date | Event | Effect on analysis |
| --- | --- | --- |
| 2026-11-24 | Victron logging extended from 5 to about 55 readings (from about 10:45) | Grid meter counters, BMS and system state available from here |
| 2026-11-24 | Heat pump readings logged to PostgreSQL every 30 s (from about 10:16) | Start of high-resolution heat pump data |
| 2026-11-23 | Hot water target lowered from 50 °C to 45 °C | Hot water energy, cycle frequency and COP change from here |
| 2026-11-24 | System filter fitted on the heat pump primary circuit (planned) | Compare flow rate before and after |
| 2026-11-24 | Victron Dynamic ESS turned off; ESS scheduled charging to 100% in the Cosy cheap windows (04:00–07:00, 13:00–16:00, 22:00–00:00) | Start of the scheduled-charging period. DESS period ends |
| 2026-11-23 | Hot water target lowered from 50 °C to 45 °C | Hot water energy, cycle frequency and COP change from here |
| 2026-11-23 | DESS fortnightly battery balancing day (battery held high, grid used instead) | Exclude from analysis of DESS's everyday decisions |
| 2026-11-22 | Node-RED logging Victron readings to PostgreSQL every 30 s (from about 21:50) | Start of high-resolution database data |
| 2026-11-22 | Flow rate found to depend on open zones; one underfloor zone kept permanently open from this evening | Heat pump flow and possibly COP change from here |
| 2026-11-16 | Vaillant visit for repeated F.283 defrost faults (16/11/2026) | Days with defrost faults (about 10–16 Nov) are not normal heat pump behaviour | Strainer filter removed temporarily to bring flow rate up, heat pump now operating normally |
| 2026-11-11 | Import tariff switched to Octopus Cosy (11/11/2026) | Tariff change: costs before and after are not directly comparable |
| 2026-11-12 | Heating changed from time-controlled with 15 °C night set-back to continuous | Night-time demand profile changes |
| 2026-11-03 | Hot water sensor moved to the cylinder outlet pipe; hot water no longer overheating | Hot water energy before this date is unrepresentative (about 10 kWh/day) |
| 2026-10-22 to 2026-11-07 | DESS working with Octopus prices; heat pump not yet operating normally | Development data window for stage 2 |
| Before 2026-10-22 | DESS not yet receiving Octopus prices | Exclude from any DESS comparison |
