# Changelog

All notable changes to the SkyFold repo will go here. Format loosely follows [Keep a Changelog](https://keepachangelog.com/).

## [Unreleased]

### Planned
- Split `parts/gimbal-mount-c20t/top_module.scad` into two separately printable parts:
  - `top_module.scad` (gimbal mount body — core structure)
  - `vtx-cover/dji_o4_pro_cover.scad` (interchangeable rear shell per VTX)
  - `parts/_common/interface.scad` (shared mount-seam contract)
- Re-render all STLs from SCAD and commit under each `parts/<folder>/stl/`
- Add `docs/build-guide.md` with photos
- Add `docs/bom.md` and `docs/print-settings.md`

## [0.1.0] – 2026-04-19

### Added
- Initial repo scaffold
- Restructured internal file layout into customer-facing names under `parts/`
- Bundled `libs/` (BOSL2, jl_scad, eazl) with attribution notices
- CC-BY-SA 4.0 license
- `refs/` for third-party imported STLs (DJI O4 Pro antenna holder)

### Renamed from internal names
| From | To |
|---|---|
| `ct20d_top_gimbal_dji_O4Pro_dual_sma_antenna.scad` | `parts/gimbal-mount-c20t/top_module.scad` |
| `gps_midbody_bridge.scad` | `parts/geprc-m1025-gps-mount/geprc_m1025_gps_mount.scad` |
| `skyfold_conduit_holder.scad` | `parts/skyrelay-conduit-mount/skyrelay_conduit_mount.scad` |
| `motor-wire-shield.scad` | `parts/motor-wire-guard/motor_wire_guard.scad` |
| `remoteid.scad` | `parts/bluemark-db152-mount/bluemark_db152_mount.scad` |
| `motor_adapter_2812.scad` | `parts/motor-adapter-19-25/motor_adapter_19_25.scad` |
| `side_panel.scad` | `parts/side-panel/side_panel.scad` |
| `xt60-holder.scad` | `parts/xt60-holder/xt60_holder.scad` |

### Removed
- Prototype STLs (`gps_midbody_pedestal`, `test_gps_peedestal`, `side-panel-port-left`)
- Old rendered STLs (will be re-rendered from current SCAD)
- `gps_rear_mount.*` archived — rear-mounted GPS had EMI issues

### Excluded from repo (gitignored, kept locally)
- `PLAN.md`
- `backup/`, `notused/`, `archive/`
- `skyfold-13-parts.3mf`
