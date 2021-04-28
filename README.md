# GFS_GCS_fMRI
This software is for the paper [1], whose abstract is as follows. 

Since functional Magnetic Resonance Imaging (fMRI) signals are a group of sparse signals, and its autocorrelation matrix contains limited information, it is difficult to accurately locate the brain activation area directly using traditional blind separation algorithms. For the issue, this paper proposes a method with inverse-sparse transform and second order blind identification (SOBI) for the separation of the activations. The contribution of this paper is to achieve the separation of sparse brain map signals and have lower computational complexity than higher-order statistical BSS. In experiments, we use both simulated and measured fMRI data to evaluate our method. The experimental results show that the proposed method’s running time is only 1/30 of a higher-order statistical independent component analysis (ICA) algorithm, while its separation errors is close to ICA and less than half of a traditional SOBI algorithm.

Dependencies:
1. SimTB, address:http://trendscenter.org/trends/software/simtb/index.html
2. GIFT, address:https://trendscenter.org/trends/software/gift/index.html

Simulaed data experiment steps
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
2. Complexity analysis of four algorithms
  Add a folder '\algorithm' to 'set path'.
  (1) Time complexity analysis
  Find a file ‘icatb_icaAlgorithm.m’ in a folder ‘gift\GroupICATv4.0b\icatb\ icatb_analysis_functions’, and add the following codes to lin. 112 
    mento = 500;
    TimeComplexity(data,ICA_Options,mento);
  (2) Multiplicative times analysis
    Find a file ‘icatb_icaAlgorithm.m’ in a folder ‘gift\GroupICATv4.0b\icatb\ icatb_analysis_functions’, and add the following codes to lin. 112
    MULtimes(data,ICA_Options);
  3. Separation error
    i) FastICA
      Find a file ‘icatb_calculateICA.m’ in a folder ‘gift\GroupICATv4.0b\icatb\ icatb_analysis_functions’, and add the following codes to lin. 252
      locerror(icasig);
    ii) GFS
      Find a file ‘icatb_calculateICA.m’ in a folder ‘gift\GroupICATv4.0b\icatb\ icatb_analysis_functions’, and add the following codes to lin. 252
      locerror(icasig);
      Find a file ‘icatb_icaAlgorithm.m’ in a folder ‘gift\GroupICATv4.0b\icatb\ icatb_analysis_functions’, and add the following codes to lin. 112(Comment codes in lin. 113-116)
      [A, W, icasig_tmp] = fsobi(data, size(data,1));   
      icasig_tmp = real(icasig_tmp);            
      W = real(W);            
      A = real(A);
    iii) GCS
      Find a file ‘icatb_calculateICA.m’ in a folder ‘gift\GroupICATv4.0b\icatb\ icatb_analysis_functions’, and add the following codes to lin. 252
      locerror(icasig);
      Find a file ‘icatb_icaAlgorithm.m’ in a folder ‘gift\GroupICATv4.0b\icatb\ icatb_analysis_functions’, and add the following codes to lin. 112(Comment codes in lin. 113-116)
      [A, W, icasig_tmp] = csobi(data, size(data,1));   
      icasig_tmp = real(icasig_tmp);            
      W = real(W);            
      A = real(A);
    iv) SOBI
      Find a file ‘icatb_calculateICA.m’ in a folder ‘gift\GroupICATv4.0b\icatb\ icatb_analysis_functions’, and add the following codes to lin. 252
      locerror(icasig);
      Find a file ‘icatb_icaAlgorithm.m’ in a folder ‘gift\GroupICATv4.0b\icatb\ icatb_analysis_functions’, and add the following codes to lin. 112(Comment codes in lin. 113-116)
      [A, W, icasig_tmp] = sobi(data, size(data,1));   
      icasig_tmp = real(icasig_tmp);            
      W = real(W);            
      A = real(A);
      
  Run a file, ‘icatb_runAnalysis.m’ in a folder ‘gift\GroupICATv4.0b\icatb\icatb_analysis_functions’
  
  
Measured data experiment steps
1. The download address of measured data is https://trendscenter.org/trends/software/gift/data/example_subjects.zip
2. Time complexity analysis
  Find a file ‘icatb_icaAlgorithm.m’ in a folder ‘gift\GroupICATv4.0b\icatb\ icatb_analysis_functions’, and add the following codes to lin. 112 
    mento = 500;
    TimeComplexity(data,ICA_Options,mento);
3. The separation results of the four algorithms
  i) FastICA
  ii) GFS
    Find a file ‘icatb_icaAlgorithm.m’ in a folder ‘gift\GroupICATv4.0b\icatb\ icatb_analysis_functions’, and add the following codes to lin. 112(Comment codes in lin. 113-116)
    [A, W, icasig_tmp] = fsobi(data, size(data,1));   
    icasig_tmp = real(icasig_tmp);            
    W = real(W);            
    A = real(A);
  iii) GCS
    Find a file ‘icatb_icaAlgorithm.m’ in a folder ‘gift\GroupICATv4.0b\icatb\ icatb_analysis_functions’, and add the following codes to lin. 112(Comment codes in lin. 113-116)
    [A, W, icasig_tmp] = csobi(data, size(data,1));   
    icasig_tmp = real(icasig_tmp);            
    W = real(W);            
    A = real(A);
  iv) SOBI
    Find a file ‘icatb_icaAlgorithm.m’ in a folder ‘gift\GroupICATv4.0b\icatb\ icatb_analysis_functions’, and add the following codes to lin. 112(Comment codes in lin. 113-116)
    [A, W, icasig_tmp] = sobi(data, size(data,1));   
    icasig_tmp = real(icasig_tmp);            
    W = real(W);            
    A = real(A);
    
    Run a file, ‘icatb_runAnalysis.m’ in a folder ‘gift\GroupICATv4.0b\icatb\icatb_analysis_functions’
