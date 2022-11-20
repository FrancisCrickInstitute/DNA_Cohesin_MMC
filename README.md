# DNA_Cohesin_MMC
 
Installation:
Copy all files to one folder and add the folder to the MATLAB path. 
 
Data Examples are available here:
https://www.dropbox.com/s/a4eiluxajz3viha/Data_Examples.zip?dl=0

Data Analysis:
Files:
load_stack.m
click_stack.m
force_txt_read_file.m
 
Instructions:
Both for photobleaching and brightness distribution analysis, the codes used were load_stack.m followed by click_stack.m.
For photobleaching step analysis, first load the data: run >> load_stack.m and select one of the bleaching.tif files above. 
Then run >> click_stack.m. Right click to select background fluorescence, left click to determine the brightness of the molecule. For each photobleaching trace, one molecule was selected after preliminary visualisation and all left clicks were acquired for that molecule. After photobleaching of the molecule, data was acquired (left click) on the background region where the fluorescent signal was.
Expected output: A photobleaching trace, showing fluorescence intensity (variable Mtotal) as a function of time (frame). The typical time required to process a stack of 1000 frames is approximately 1 min. 
 
For brightness distribution analysis, first load the data: run >> load_stack.m and select the histogram.tif file above. 
Then run >> click_stack.m. As above, right click to select background fluorescence, left click to determine the brightness of the molecule. 
Expected output: histogram with a peak ~ 0 a.u. indicating background fluorescence, with each subsequent peak representing the brightness of one, two, … fluorophores. Typical time required to process the stack of 1000 frames is approximately 1 min. 
 
For force-distance visualisation and analysis, run >> force_txt_read_file.m and select the force-distance data exported from the JPK Processing software as a txt file. 
Expected output: force-distance curve, showing both x and y contributions. The curve will be force (pN) as a function of displacement (m). For the example data, the force of rupture is ~ 25 pN at ~ 7 um. Expectation is that, pulling in the y direction, this will be the main contribution. However, for determining the total rupture force, both contributions were considered. Typical time required to open the file is approximately 30 seconds.
 
Data Simulations (requires optimization toolbox):
Files:
one_DNA.m
two_DNAs.m
findFandL.m
 
Instructions:
To simulate the distribution of cohesin-DNA rupture forces, run >> one_DNA for the specific set of parameters. Parameters k and delta can be changed on lines 14 and 7 of the code. 
Expected output: the simulated distribution and comparison of experimental distributions of the head and hinge cohesins. 
To simulate the distribution of DNA-DNA rupture forces, run >> two_DNAs. Parameters k and delta can be changed in the code similarly to one_DNA. 
Expected output: the simulated distribution.
findFandL.m is an auxiliary code for two_DNAs and should be in the same folder. It integrates the system of equations [5] described in the methods section of the manuscript. 
