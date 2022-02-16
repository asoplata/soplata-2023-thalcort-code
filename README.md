# Simulation and plotting scripts for (Soplata et al., 2021)

These are the simulation and plotting runscripts for all simulations in the
publication TBD. See below for instructions. All parameters relevant to the work
that not in this repo are contained here:
https://github.com/asoplata/dynasim-extended-benita-model which is where the
main mechanism files exist.

### Citation

TBD

### Requirements

1. Most of the simulations were run on a computing cluster with RAM anywhere
   from 12GB - 64GB. Running individual simulations on your desktop may be
   possible depending on its RAM.
2. Each simulation that saves simulation data, as opposed to simply output
   plots, requires around 15GB of space each. After you run the corresponding
   `combine_script` (see below), the non-combined data can be deleted, reducing
   the footprint to a couple GB.
3. Simulations that perform advanced analysis may take several hours.

### Installation

1. You must have a "recent" version of MATLAB installed; the simulations were
   run using version 2017a. The code is not guaranteed to work on different
   versions of MATLAB, but I can provide help if you ask.
2. You must then install a CUSTOM version of DynaSim, the `coupling_addition`
   branch of my personal DynaSim fork, available here:
   https://github.com/asoplata/DynaSim/tree/coupling_addition . If you already
   have another version of DynaSim installed on your MATLAB path, remove it beforehand.
3. You must then install the model specification itself, which is available here
   https://github.com/asoplata/dynasim-extended-benita-model . This should be as
   easy as copying those files into
   `<YOUR_DYNASIM_INSTALL_FOLDER>/models/personal`, which you may have to create
   if it doesn't exist.
4. You must change the paths `/YOUR_OUTPUT_DIR_HERE/` to your desired simulation
   data output location. I recommend using a combination of `grep` and `sed` to
   do this, as shown here https://github.com/asoplata/bin/blob/master/grsed .
5. If the above is done correctly, you should now be able to run and plot the
   simulations in this repo (see below).

### Simulation running and plotting instructions

1. First, run the simulation-run file in the corresponding "runscripts"
   sub-directory of the simulation you want to re-simulate.
   
    - These are designed to run on a cluster, so you need to either adapt them
      to your own cluster, or, if you have a desktop with enough RAM on it,
      change `cluster_flag` to 0.
    - You also need to put in what directory you want the output data to go
      into, where it says `YOUR_DIRECTORY_HERE`.
    - The final output foldername will be the filename of the runscript.

2. Next, after the simulation has completed, you need to combine the output data
   into one master data file. This is done by running the corresponding
   `combine_script` file in each directory. Note that you will likely have to
   move the data around to fit the `combine_script`, usually by moving it into
   the current directory where you run the script. Also note these
   `combine_script` files don't have consistent names, but they all have the
   string `combine_script` in their filename.
3. Finally, run the corresponding `plot` script for that simulation type. These
   filenames always begin with `plot`.
