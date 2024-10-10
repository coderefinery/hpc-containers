#!/bin/bash
#SBATCH --time=00:10:00
#SBATCH --mem=2G
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --output=lammps_indent.out

# Copy example from image
apptainer exec lammps-openmpi.sif cp -r /opt/lammps/examples/indent .

cd indent

# Load OpenMPI module
module load openmpi

export PMIX_MCA_gds=hash

# Run simulation
srun apptainer run ../lammps-openmpi.sif -in in.indent
