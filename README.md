# GFS_GCS_fMRI
This software is for the paper [1], whose abstract is as follows. 

Since functional Magnetic Resonance Imaging (fMRI) signals are a group of sparse signals, and its autocorrelation matrix contains limited information, it is difficult to accurately locate the brain activation area directly using traditional blind separation algorithms. For the issue, this paper proposes a method with inverse-sparse transform and second order blind identification (SOBI) for the separation of the activations. The contribution of this paper is to achieve the separation of sparse brain map signals and have lower computational complexity than higher-order statistical BSS. In experiments, we use both simulated and measured fMRI data to evaluate our method. The experimental results show that the proposed method’s running time is only 1/30 of a higher-order statistical independent component analysis (ICA) algorithm, while its separation errors is close to ICA and less than half of a traditional SOBI algorithm.

Dependencies:
1. SimTB, address:http://trendscenter.org/trends/software/simtb/index.html
2. GIFT, address:https://trendscenter.org/trends/software/gift/index.html

Simulaed experiment steps
1. Produce simulated data via Simtb software
  (1) Move files, 'run_NoMotion.m' and 'experiment_params_aod_NoMotion.m' into the folder '\simtb_v18\examples'. 
  Note that the different between 'experiment_params_aod_NoMotion.m' and the original file, 'experiment_params_aod.m' is as follows:
    i) 'out_path' in lin.22
    ii) 'M=3' in lin. 40
    iii) 'SM_source_ID = [  2  4  6  8  10  15  18  19  29 ]' in line. 51
    iv) 'D_motion_FLAG = 0' in lin.244
    v) 'saveNII_FLAG = 1' in lin. 26
  (2) Run simtb.m , and then run 'run_NoMotion.m'.
  (3) Find the output folder and move '*.nii' into created subfolders 'sub0*'
  (4) Change 'experiment_params_aod_NoMotion.m' parameters
    i) 'out_path = 'D:\simtb_data_hcnr'' to 'out_path = 'D:\simtb_data_lcnr'' in lin.22
    ii) 'minCNR = 5;  maxCNR = 5.5;' to 'minCNR = 0.65;  maxCNR = 2;' in lin. 238
  (5) run 'run_NoMotion.m'.
  (6) Find the output folder and move '*.nii' into created subfolders 'sub0*'
2. Algorithm complexity analysis
