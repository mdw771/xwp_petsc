#!/bin/bash


export MODULEPATH=$MODULEPATH:/home/sajid/packages/spack/share/spack/modules/linux-centos7-x86_64/
module load intel19
spack load --dependencies /vzlfvup

make -b ex_dmda

j=$(python3 -c "import pickle,os;os.chdir(os.getcwd()+'/rings');p = pickle.load(open('parameters.pickle','rb'));print(p['grid_size']*p['step_xy'])")

mpirun -np 28 ./ex_dmda -prop_steps 200 -L_x $j -L_y $j -ts_type cn -ksp_type fgmres -ksp_rtol 1e-5 -pc_type gamg -pc_gamg_type agg -pc_gamg_threshold -0.04  -pc_gamg_coarse_eq_limit 5000  -pc_gamg_use_parallel_coarse_grid_solver -pc_gamg_square_graph 10 -mg_levels_ksp_type gmres -mg_levels_pc_type jacobi -pc_gamg_reuse_interpolation true  -ts_monitor -log_view &> log
