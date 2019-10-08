import numpy as np
import matplotlib.pyplot as plt
import h5py
import os,pickle
from os.path import dirname as up
from multislice import prop,prop_utils

pwd = os.getcwd()
os.chdir(pwd+"/rings")

parameters = pickle.load(open('parameters.pickle','rb'))
grid_size  = parameters['grid_size']
energy     = parameters['energy(in eV)']
wavel      = parameters['wavelength in m']
foc_length = parameters['focal_length']
step_xy    = parameters['step_xy']
L          = step_xy*grid_size

os.chdir(pwd)

f = h5py.File("solution.h5")
wave_exit = f["sol_vec"][:,:,:]
f.close()

wave_exit = wave_exit[:,:,0] + 1j*wave_exit[:,:,1]

step_z = foc_length
p = prop_utils.decide(step_z,step_xy,L,wavel)
print('Propagation to focal plane')
print('Fresnel Number :',((L**2)/(wavel*step_z)))
wave_focus,L2 = p(wave_exit - np.ones(np.shape(wave_exit)),step_xy,L,wavel,step_z)
wave_focus = wave_focus +  np.ones(np.shape(wave_exit))

focal_spot_size = 100
focal_spot,x_,y_,max_val = prop_utils.get_focal_spot(np.abs(wave_focus),grid_size,focal_spot_size)
np.save('foc_spot.npy',focal_spot)
