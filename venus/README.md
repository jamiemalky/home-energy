# Victron GX (Venus OS)

Scripts that run on the Victron GX device. See the appendix in
[the project proposal](../docs/project_proposal.md) for how the
grid meter setup works.

## Firmware record

| Date | Firmware | Notes |
| --- | --- | --- |
| 2026-11-15 | v3.75 (standard), build 20260624163305 | Before firmware upgrade to VenusOS large. Grid meter services working. |

**Rollback:** Remote Console → Settings → Firmware → Online updates →
Image type: Normal, then reinstall v3.75. Or use Settings → Firmware →
Stored backup firmware to boot the previous version.

## Files

| Repo path | Location on GX | Purpose |
| --- | --- | --- |
| `em112/socat/run` | `/data/em112/socat/run` | Virtual serial port linked to the Wi-Fi bridge |
| `em112/cgwacs/run` | `/data/em112/cgwacs/run` | Victron meter driver reading the EM112 |
| `rc.local` | `/data/rc.local` | Starts both services at boot |

Also required on the GX: a copy of socat at `/data/bin/socat`, so it
survives firmware updates.

## Restore after a firmware reset

Copy the files above back to their locations on the GX, make them
executable with `chmod +x`, copy socat to `/data/bin/`, then run
`/data/rc.local`.
