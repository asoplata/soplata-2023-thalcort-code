# Simulation and plotting code for (Soplata et al., 2023)

This repository contains the MATLAB code used to run the simulations and make
the figures and tables of:

> Soplata, Austin E., Elie Adam, Emery N. Brown, Patrick L. Purdon, Michelle M.
> McCarthy, and Nancy Kopell. 2023. "Rapid Thalamocortical Network Switching
> Mediated by Cortical Synchronization Underlies Propofol-Induced EEG
> Signatures: A Biophysical Model." *Journal of Neurophysiology* 130 (1):
> 86–103. https://doi.org/10.1152/jn.00068.2022

Everything needed to run the simulations is included: the
[DynaSim](https://github.com/DynaSim/DynaSim) simulator and the model's
mechanism files are bundled in this repository, so there is nothing else to
install.

## Quick start

1. Install MATLAB with the **Signal Processing Toolbox** and the **Curve
   Fitting Toolbox** (only the analysis scripts need these). The paper's
   simulations were run with MATLAB R2022a.
2. Download this repository, for example with:
   ```bash
   git clone https://github.com/asoplata/soplata-2023-thalcort-code.git
   ```
3. In MATLAB, open and run any `*_sim.m` script, for example
   `fig03/fig02c_fig03_propofol_sim.m`. Each script sets up the MATLAB path
   for you.
4. Then run the matching `*_analysis.m` script, if there is one, to make the
   plots.

### Where the output goes

All simulation data and plots are saved in a folder in your home directory,
which is created automatically:

| Operating system | Output folder                                    |
| ---------------- | ------------------------------------------------ |
| Mac / Linux      | `~/soplata-thalcort-2023-output`                 |
| Windows          | `%USERPROFILE%\soplata-thalcort-2023-output` (`$HOME\soplata-thalcort-2023-output` in PowerShell) |

Inside it, each figure gets its own subfolder (e.g. `fig03/`), and each
simulation gets its own folder named after its script, e.g.
`fig03/fig02c_fig03_propofol_sim_i001/`. DynaSim saves the simulation's data
in that folder's `data/` subfolder and its automatically-generated plots,
including the rastergrams, in `plots/`. To use a different location, change
`output_root` in [`setup_thalcort.m`](setup_thalcort.m).

## Which script makes which figure

Simulation scripts end in `_sim.m`; analysis/plotting scripts end in
`_analysis.m` and need their simulation to be run first. Each folder's
`reference_output/` contains the plots that were made for the paper, for
comparison with your own results.

| Paper figure | Simulation script | Analysis script | Simulated time |
| --- | --- | --- | --- |
| Fig. 2B: wakelike | [`fig02/fig02b_wakelike_sim.m`](fig02/fig02b_wakelike_sim.m) | [`fig02/fig02b_wakelike_analysis.m`](fig02/fig02b_wakelike_analysis.m) | 10 s |
| Fig. 2C: propofol | [`fig03/fig02c_fig03_propofol_sim.m`](fig03/fig02c_fig03_propofol_sim.m) | [`fig02/fig02c_propofol_analysis.m`](fig02/fig02c_propofol_analysis.m) | 30 s |
| Fig. 2D: cortex only | [`fig02/fig02d_cortex_only_sim.m`](fig02/fig02d_cortex_only_sim.m) | [`fig02/fig02d_cortex_only_analysis.m`](fig02/fig02d_cortex_only_analysis.m) | 30 s |
| Fig. 3: I-state and C-state | [`fig03/fig02c_fig03_propofol_sim.m`](fig03/fig02c_fig03_propofol_sim.m) (same as Fig. 2C) | [`fig03/fig03_analysis.m`](fig03/fig03_analysis.m) | 30 s |
| Fig. 4A: baseline (mostly C-state) | [`fig04_fig05/fig04a_baseline_sim.m`](fig04_fig05/fig04a_baseline_sim.m) | – | 10 s |
| Fig. 4B: synchronizing input example | [`fig04_fig05/fig04b_sync_example_sim.m`](fig04_fig05/fig04b_sync_example_sim.m) | – | 10 s |
| Fig. 4C: desynchronizing input example | [`fig04_fig05/fig04c_desync_example_sim.m`](fig04_fig05/fig04c_desync_example_sim.m) | – | 10 s |
| Fig. 4D: synchronizing input, all times | [`fig04_fig05/fig04d_sync_sweep_sim.m`](fig04_fig05/fig04d_sync_sweep_sim.m) | [`fig04_fig05/fig04de_fig05de_bar_charts.m`](fig04_fig05/fig04de_fig05de_bar_charts.m) | 356 × 10 s |
| Fig. 4E: desynchronizing input, all times | [`fig04_fig05/fig04e_desync_sweep_sim.m`](fig04_fig05/fig04e_desync_sweep_sim.m) | [`fig04_fig05/fig04de_fig05de_bar_charts.m`](fig04_fig05/fig04de_fig05de_bar_charts.m) | 356 × 10 s |
| Fig. 5A–E | `fig04_fig05/fig05*_sim.m`, as for Fig. 4A–E | [`fig04_fig05/fig04de_fig05de_bar_charts.m`](fig04_fig05/fig04de_fig05de_bar_charts.m) | as for Fig. 4 |
| Fig. 6: no thalamocortical feedback | [`fig06/fig06_no_thalamocortical_feedback_sim.m`](fig06/fig06_no_thalamocortical_feedback_sim.m) | – | 30 s |
| Table 1 | [`table1/table1_sim.m`](table1/table1_sim.m) | – | 10 values × 100 × 30 s |
| Table 2 | [`table2/table2_sim.m`](table2/table2_sim.m) | – | 16 combinations × 50 × 30 s |

Notes:

- The rastergrams in Figs. 3–6 are the DynaSim rastergram plots that each
  simulation script saves in its `plots/` folder.
- The bar charts in Figs. 4D–E and 5D–E, and the numbers in Tables 1 and 2,
  come from scoring the simulations' rastergrams by visual inspection. Those
  scores are in each folder's `data/` spreadsheets (see each spreadsheet's
  "Notes" sheet for what the scoring letters mean), so
  `fig04de_fig05de_bar_charts.m` can be run without running any simulations.
  `table1/data/table1_summary.csv` is the summary used for Table 1.
- Table 1, Table 2, and the Fig. 4D–E/5D–E sweeps use random seeds or many
  simulations each, so are only practical to run on a computing cluster (see
  below).
- This repository does not include Fig. 1 (human EEG data), the Fig. 2A
  schematic, or the plotting code for Fig. 2E–F.
- `fig04_fig05/reference_output/not_in_paper/` holds plots and data from
  earlier analyses that did not end up in the published paper; the scripts
  that made them are not included.

## Hardware and running time

- Individual simulations should be reproducible on a desktop computer with 32
  GB of RAM or more. Simulations were originally run on a computing cluster
  with 16–64 GB of RAM per simulation.
- Simulations that save their data (`'save_data_flag', 1`) need roughly 15 GB
  of disk space each.
- By default every script runs its simulations one after another on your own
  computer (`'cluster_flag', 0`). For the paper, simulations were submitted to
  an SGE computing cluster by setting `'cluster_flag', 1`; see DynaSim's
  documentation for how to set this up.
- MATLAB's random number generation can differ between CPU architectures. The
  paper's simulations were run on Intel "Skylake" CPUs, so simulations run on
  other CPUs may not be bit-for-bit identical, even with the same seed. This
  doesn't change the behavior described in the paper, which doesn't depend on
  exact initial conditions.

## Repository layout

```
setup_thalcort.m   Adds dynasim/ and model/ to the MATLAB path and creates the output folder
fig02/ fig03/ fig04_fig05/ fig06/ table1/ table2/
                   Simulation and analysis scripts for each figure and table
dynasim/           Bundled copy of DynaSim
model/             Bundled model: assembleFullSpec.m, assembleCortOnlySpec.m, and mechanisms/
```

### Bundled dependencies

- `dynasim/` is the "dev" branch of DynaSim at commit
  [`b1aa46d`](https://github.com/DynaSim/DynaSim/commit/b1aa46d29bd96a4383f5831211fbae73a0ff709f),
  the version used for the paper, without its `demos/` and `docs/` folders.
  DynaSim is MIT-licensed (see `dynasim/LICENSE`).
- `model/` is
  [dynasim-extended-benita-model](https://github.com/asoplata/dynasim-extended-benita-model)
  at commit `b90fe7a`, with its mechanism files moved into `model/mechanisms/`
  and unused older code removed. It is Apache-2.0-licensed (see
  `model/LICENSE`).
- `model/assembleCortOnlySpec.m`, used for Fig. 2D, was rebuilt from
  `assembleFullSpec.m` because the original was not preserved. It produces a
  DynaSim solve file identical to the one saved from the paper's original
  Fig. 2D simulation.

## Original filenames

The scripts were renamed to match the paper's figures. If you're comparing to
the original project files, the original names are:

| New name | Original name |
| --- | --- |
| `fig02/fig02b_wakelike_sim.m` | `p25d46s028_20230121_wakelike_shorter.m` |
| `fig02/fig02b_wakelike_analysis.m` | `p25d46s028_20230121_wakelike_shorter_ans.m` |
| `fig02/fig02c_propofol_analysis.m` | `p25d40s004_20230102_mainfig_i24s_ans.m` |
| `fig02/fig02d_cortex_only_sim.m` | `p25d45s002_20230121_cortonly_swo_30s.m` |
| `fig02/fig02d_cortex_only_analysis.m` | `p25d45s002_20230121_cortonly_swo_30s_ans.m` |
| `fig02/plot_isyn_spectrum.m` | `single_unfiltered_spectrum.m` |
| `fig02/plot_isyn_spectrum_cortex_only.m` | `single_unfiltered_spectrum_cortonly.m` |
| `fig03/fig02c_fig03_propofol_sim.m` | `p25d40s004_20230102_mainfig_i24s.m` |
| `fig03/fig03_analysis.m` | `p25d40s004_20230102_mainfig_i24s_ans1_subplots.m` |
| `fig04_fig05/fig04a_baseline_sim.m` | `p25d32s038_20221106_s30_baseline.m` |
| `fig04_fig05/fig04b_sync_example_sim.m` | `p25d32s065_20230122_s30_artsync_single_repro.m` |
| `fig04_fig05/fig04c_desync_example_sim.m` | `p25d32s066_20230122_s30_DEsync_single_repro.m` |
| `fig04_fig05/fig04d_sync_sweep_sim.m` | `p25d32s058_20221230_s30_artsync_str.m` |
| `fig04_fig05/fig04e_desync_sweep_sim.m` | `p25d32s060_20221230_s30_DEsync_str.m` |
| `fig04_fig05/fig05a_baseline_sim.m` | `p25d32s039_20221106_s34_baseline.m` |
| `fig04_fig05/fig05b_sync_example_sim.m` | `p25d32s067_20230122_s34_artsync_single_repro.m` |
| `fig04_fig05/fig05c_desync_example_sim.m` | `p25d32s068_20230122_s34_DEsync_single_repro.m` |
| `fig04_fig05/fig05d_sync_sweep_sim.m` | `p25d32s059_20221230_s34_artsync_str.m` |
| `fig04_fig05/fig05e_desync_sweep_sim.m` | `p25d32s061_20221230_s34_DEsync_str.m` |
| `fig04_fig05/fig04de_fig05de_bar_charts.m` | `create_bar_charts_single_phase_bin.m` |
| `fig04_fig05/data/fig0*_scoring.xlsx` | `p25d32s058`–`s061_20221230_*_str_data.xlsx` |
| `fig06/fig06_no_thalamocortical_feedback_sim.m` | `p25d32s070_20230318_NOtcpy_figure.m` |
| `table1/table1_sim.m` | `p25d34s041`–`s050_20221127_anes_stats_g0XX_ga3.m` (merged into one script) |
| `table1/data/table1_gAMPA_*_scoring.xlsx` | `p25d34s041`–`s050_20221127_anes_stats_g0XX_ga3_data.xlsx` |
| `table1/data/table1_summary.csv`, `.xlsx` | `stats_combined.csv`, `.xlsx` |
| `table2/table2_sim.m` | `p25d19s001_20221112_simple_sweep.m` |
| `table2/data/table2_scoring.xlsx` | `p25d19s001_20221112_simple_sweep_data.xlsx` |

## Help

If you need any help with this, feel free to reach out using the email on my
GitHub profile page!
