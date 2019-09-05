#!/bin/bash
#SBATCH --job-name=petsc_test                                                                                                                                                 
#SBATCH -N 4 
#SBATCH -C quad,cache                                                                                                                                                         
#SBATCH -p apsxrmd
#SBATCH -n 64                                                                                                                                                                 
#SBATCH --time=08:00:00                                                                                                                                                       
                                                                                                                                                                              
module load intel/18.0.3-d6gtsxs                                                                                                                                              
module load intel-parallel-studio/cluster.2018.3-xvnfrfz                                                                                                                      
source /blues/gpfs/home/software/spack-0.10.1/opt/spack/linux-centos7-x86_64/gcc-4.8.5/intel-parallel-studio-cluster.2018.3-xvnfrfzyraglaflq3eh2fdunffixalau/vtune_amplifier_2
018.3.0.558279/amplxe-vars.sh                                                                                                                                                 
source /blues/gpfs/home/software/spack-0.10.1/opt/spack/linux-centos7-x86_64/gcc-4.8.5/intel-parallel-studio-cluster.2018.3-xvnfrfzyraglaflq3eh2fdunffixalau/vtune_amplifier_2
018.3.0.558279/apsvars.sh                                                                                                                                                     
                                                                                                                                                                              
export I_MPI_FABRICS=shm:ofi                                                                                                                                                  
export I_MPI_MIC=enable                                                                                                                                                       
export I_MPI_SHM=knl_mcdram                                                                                                                                                   
export I_MPI_PIN=1                                                                                                                                                            
export I_MPI_PIN_DOMAIN=core                                                                                                                                                  
export PMI_NO_FORK=1                                                                                                                                                          
                                                                                                                                                                              
source /home/sajid/miniconda3/etc/profile.d/conda.sh                                                                                                                          
conda activate intelpy3                                                                                                                                                       
which python                                                                                                                                                                  
rm eff_petsc                                                                                                                                                                  
rm times_petsc                                                                                                                                                                
rm out*                                                                                                                                                                       
spack load /bu2b                                                                                                                                                              
rm ex_modify                                                                                                                                                                  
make ex_modify                                                                                                                                                                
for i in {1..100};                                                                                                                                                            
do                                                                                                                                                                            
        SECONDS=0                                                                                                                                                             
                srun ./ex_modify -ts_type cn -prop_steps $i -pc_type gamg -ts_monitor -log_view &> out$i                                                                      
        ELAPSED="Elapsed: $(($SECONDS / 3600))hrs $((($SECONDS / 60) % 60))min $(($SECONDS % 60))sec"                                                                         
        echo "$ELAPSED" >> "times_petsc"                                                                                                                                      
        python petsc_eff_print.py >> eff_petsc                                                                                                                                
done                                                                                                                                                                          
