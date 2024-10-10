#!/bin/bash
#SBATCH --mem=32G
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --gpus-per-task=2
#SBATCH --cpus-per-task=12
#SBATCH --time=00:10:00
#SBATCH --output=accelerate_run_parallel.out

export OMP_NUM_THREADS=$(( $SLURM_CPUS_PER_TASK / $SLURM_GPUS_ON_NODE ))

apptainer exec --nv accelerate_cuda.sif \
  torchrun \
    --nproc_per_node $SLURM_GPUS_ON_NODE \
    ./nlp_example.py \
    --mixed_precision fp16
