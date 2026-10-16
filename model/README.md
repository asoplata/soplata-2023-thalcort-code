# DynaSim mechanism files for simulating thalamically-extended (Benita et al., 2012) Slow Wave model

DynaSim-compatible mechanism files for simulation of a new, hybrid model
consisting of the cortex of (Benita et al., 2012), the thalamus of (Soplata et
al., 2017), and simple AMPAergic thalamocortical and corticothalamic
connections.

This is NOT intended as a bit-perfect reproduction of any original model, but
rather just an open-source, adequate reproduction of the overall qualitative
results of the individual models.

This was last run using Matlab 2022a and this commit of DynaSim:
https://github.com/DynaSim/DynaSim/commit/b1aa46d29bd96a4383f5831211fbae73a0ff709f .

## Install and Usage

The easiest way to get started with this is:
1. Install the "dev" branch of DynaSim
   (https://github.com/DynaSim/DynaSim/wiki/Installation), including adding it
   to your MATLAB path.
2. Run `git clone https://github.com/asoplata/dynasim-extended-benita-model` or
   download this code's repo
   (https://github.com/asoplata/dynasim-extended-benita-model) manually into
   `<YOUR_DYNASIM_INSTALL_FOLDER>/models/personal`, which you may have to
   create if it doesn't exist.
3. This is meant to be used in conjunction with the runscripts in
   https://github.com/asoplata/soplata-2023-thalcort-code .

## References

1. Benita, J. M., Guillamon, A., Deco, G., & Sanchez-Vives, M. V. (2012).
   Synaptic depression and slow oscillatory activity in a biophysical
   network model of the cerebral cortex. Frontiers in Computational
   Neuroscience, 6. https://doi.org/10.3389/fncom.2012.00064
2. Soplata AE, McCarthy MM, Sherfey J, Lee S, Purdon PL, Brown EN, et al.
   (2017) Thalamocortical control of propofol phase-amplitude coupling. PLoS
   Comput Biol 13(12): e1005879. https://doi.org/10.1371/journal.pcbi.1005879
