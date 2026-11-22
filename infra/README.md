# Home server (infrastructure)

The home server runs the data stack: MQTT broker, Node-RED, PostgreSQL,
Grafana and the analysis code. See stage 3 in
[the project proposal](../docs/project_proposal.md).

## Hardware

| Item | Detail |
| --- | --- |
| Machine | HP EliteDesk 800 G3 Mini, bought used |
| CPU | Intel Core i5-6500T (4 cores, 35 W) |
| RAM | 8 GB DDR4 (two slots, up to 32 GB) |
| Storage | 256 GB NVMe SSD (system and data) |
| Network | Wired ethernet to the router |
| Power | Mains only; no battery backup |

## Operating system

| Item | Detail |
| --- | --- |
| Hypervisor | Proxmox VE `<version from the top of the web interface>` |
| Installed | 2026-11-21 |
| Filesystem | ext4 (installer default) |
| Update source | No-subscription repository (enterprise repositories disabled) |

## Network

| Item | Detail |
| --- | --- |
| Hostname | `pve.home` |
| IP address | `192.168.8.10/24` (static, set in the installer) |
| Gateway and DNS | `192.168.8.1` (home router) |
| Web interface | `https://192.168.8.20:8006` (log in as root, realm Linux PAM) |

All addresses are on the private home network and can't be reached from the
internet.

## BIOS settings

Changed from the defaults (press F10 at power-on to reach the BIOS):

| Setting | Value | Why |
| --- | --- | --- |
| Virtualization Technology (VT-x) | Enabled | Needed to run virtual machines |
| VT-d | Enabled | Lets virtual machines use hardware directly if needed later |
| After Power Loss | Power On | Server restarts by itself after a power cut |
| Secure Boot | Disabled | Simplest route for the Proxmox installer |

## Checks

| Date | Test | Result |
| --- | --- | --- |
| 2026-11-21 | Pulled the power plug, restored it, no other action | Booted unaided; web interface back within a few minutes |

## Rebuild from scratch

1. Download the Proxmox VE ISO from proxmox.com/downloads and write it to a
   USB stick with Rufus (DD mode).
2. Apply the BIOS settings above.
3. Boot from USB (F9 at power-on) and install with the network settings above.
4. In the web interface: Updates → Repositories, disable the enterprise
   repositories, add No-Subscription, then Refresh and Upgrade.
5. Restore the containers and data from backup (backup setup to follow).

Passwords are kept in a password manager, never in this repository.
