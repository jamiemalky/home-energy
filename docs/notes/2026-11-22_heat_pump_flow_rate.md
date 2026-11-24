# Heat pump flow rate and zone valves

22 November 2026

## Question

The heat pump's building-circuit flow rate read 1,066 l/h with the circulation
pump at 100%. A few days earlier it had read about 1,200 l/h. The minimum flow
for this aroTHERM plus is 1,075 l/h. Was the circuit, or the heat pump's
internal heat exchanger, becoming blocked? The system had been running without
a filter since a drain-down.

## Readings (heating mode, outside about 3 °C)

| Condition | Flow rate (l/h) |
| --- | --- |
| Underfloor zones closed, radiators only | 1,066 to 1,072 |
| Extra radiator TRVs opened | 1,100 |
| One underfloor zone opened, actuator part-open | 1,134 |
| Same zone, actuator fully open (a few minutes later) | 1,195 |
| Earlier reading, cold house, all zones calling | about 1,200 |

Pump modulation was 100% throughout, so the pump was not limiting flow.

## Heat exchanger check

The refrigerant condensing temperature was 40.1 °C against a water flow
temperature of about 38 °C: a gap of about 2 K. Fouling insulates the plates
and widens this gap, so a gap this small indicates a clean exchanger.

## Live COP from first principles

The unit's own `CurrentYieldPower` read 0.0 (the borrowed ebusd definition
file does not decode it correctly), so heat output was calculated instead:

- flow 1,072 l/h = 0.298 l/s
- flow minus return temperature = 37.9 − 34.4 = 3.5 K
- heat = 0.298 × 4.18 × 3.5 ≈ 4.4 kW
- electrical input (`RunDataElectricPowerConsumption`) = 1.18 kW
- COP ≈ 3.7 at about 3 °C outside

With only 3.5 K across the unit, a 0.5 K sensor error changes the heat figure
by about 15%, so single readings are noisy; hourly and daily averages are more
reliable, and can be checked against the unit's own daily yield.

## Conclusion

Flow depends on how many zones are open. It is not a blockage. With the
underfloor zones closed, flow sits at or just below the 1,075 l/h minimum,
which may have contributed to the failed defrosts (F.283) earlier in November.

## Actions

- Keep one underfloor zone permanently open until the pipework is upgraded.
- Fit a full-bore magnetic filter (planned) and ask about a system clean.
- Log flow rate, flow and return temperatures, electrical power and the
  condensing temperature gap, to track flow margin and exchanger fouling
  over time, and to measure the effect of the filter and pipework changes.
