# SkyFold

**Foldable drone platform — OpenSCAD sources, STL prints, and configuration files.**

Maintained by [UAVOPSYS](https://github.com/uavopsys).

## Compatibility

This build integrates the following hardware:

| Component | Product | Link |
|---|---|---|
| Gimbal | Allxianfei C20T (3-axis FPV) | https://www.allxianfei.com/en/c20t-3axis-fpv-gimbal.html |
| VTX / Air Unit | DJI O4 Pro | — |
| Lidar / Optical Flow | MicoAir MTF-01P | https://micoair.com/optical_range_sensor_mtf-01p/ |
| Antennas | Dual SMA stock | — |
| GPS | GEPRC GEP-M1025 | https://geprc.com/product/gep-m1025-series-gps-module/ |
| LTE Cellular Relay | SkyRelay Conduit | https://www.skyrelay.us/products.html |
| Remote ID | Bluemark DB152 | https://gearfocus.com/products/bluemark-db152-fpv-dronebeacon-faa-remote-id-pcb-the-origina-viB7I |

## Parts

All 3D-printable parts live under `parts/`. Each folder contains:
- The `.scad` source (parametric — edit to fit your variant)
- An `stl/` subfolder with the ready-to-print rendering

| Folder | Part | Fits |
|---|---|---|
| `gimbal-mount-c20t/` | Top module (gimbal + VTX housing + antennas + lidar) | Allxianfei C20T |
| `vtx-cover/` *(planned split)* | Swappable back cover by VTX | DJI O4 Pro (v1); more to come |
| `geprc-m1025-gps-mount/` | GPS module mount | GEPRC GEP-M1025 |
| `skyrelay-conduit-mount/` | Drone-side bracket for the SkyRelay Conduit | SkyRelay Conduit |
| `bluemark-db152-mount/` | Remote ID beacon bracket | Bluemark DB152 |
| `motor-wire-guard/` | Motor lead cover | Generic 8-fold frame |
| `motor-adapter-19-25/` | Mount-pattern adapter | 19×19 → 25×25 |
| `side-panel/` | Side frame panel (prints as a mirrored pair from one SCAD) | — |
| `xt60-holder/` | XT60 battery connector mount | — |

## How to render or modify

1. Install [OpenSCAD](https://openscad.org/) (2021.01+ recommended)
2. Clone this repo
3. Open any `.scad` under `parts/` — the libraries in `libs/` are included via relative paths, so it just works
4. Export → STL

## Print settings

Recommended (full guide in `docs/print-settings.md`):
- **Material:** PETG (for drone parts; PLA is too brittle for vibration)
- **Layer height:** 0.2mm
- **Infill:** 30–40% gyroid
- **Walls:** 3 perimeters minimum
- **Orientation:** print with stress-direction along the filament layers

## Lua scripts / GCS configs

- `lua/` — ArduPilot scripts for the platform
- `gcs/` — QGroundControl / MissionPlanner parameter files

## License

[CC-BY-SA 4.0](LICENSE) — you are free to remix and commercialize, provided you credit UAVOPSYS and share derivatives under the same license.

Bundled third-party libraries under `libs/` retain their original licenses — see [`libs/ATTRIBUTION.md`](libs/ATTRIBUTION.md).

## Changelog

See [`CHANGELOG.md`](CHANGELOG.md).
