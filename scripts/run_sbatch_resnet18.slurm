#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH -p sequana_gpu_shared
#SBATCH -J cerranet-resnet18
#SBATCH --no-requeue
#SBATCH --time=03:00:00
#SBATCH --mail-type=BEGIN,END
#SBATCH --mail-user=e.lucas@unifesp.br

echo '========================================'
echo '- Job ID:' $SLURM_JOB_ID
echo '- # of nodes in the job:' $SLURM_JOB_NUM_NODES
echo '- # of tasks per node:' $SLURM_NTASKS_PER_NODE
echo '- # of tasks:' $SLURM_NTASKS
echo '- # of cpus per task:' $SLURM_CPUS_PER_TASK
echo '- Dir from which sbatch was invoked:' ${SLURM_SUBMIT_DIR##*/}
echo -n '- Nodes allocated to the job: '
nodeset -e $SLURM_JOB_NODELIST

#Change dir to the dir where the job was invoked
cd $SLURM_SUBMIT_DIR

# Run your code
echo -n '<1. starting python script > ' && date
echo '-- output -----------------------------'

#executa o script

echo 'train and eval on last model!'
singularity run --nv -B /scratch/ideeps/lucas.silva6/cerranet/cerraData /scratch/ideeps/lucas.silva6/singularity-containers/pytorch112.sif sh -c 'cd $SLURM_SUBMIT_DIR && python trainer.py --arch resnet18 --runs 5 --ts 0.002 --pretrained'

echo 'eval on best model!'
singularity run --nv -B /scratch/ideeps/lucas.silva6/cerranet/cerraData /scratch/ideeps/lucas.silva6/singularity-containers/pytorch112.sif sh -c 'cd $SLURM_SUBMIT_DIR && python trainer.py --arch resnet18 --runs 5 --ts 0.002 --pretrained --resume --evaluate --get-features'

echo '-- end --------------------------------'
echo -n '<2. quit>                    ' && date
