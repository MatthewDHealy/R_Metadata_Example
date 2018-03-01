# R_Metadata_Example
Example of merging metadata with expression data
Here's a simple example in R of how I handle the common situation when I have two text files, one of transcriptional profiling data and one of sample metadata.  Not rocket science, but there are a few wrinkles:

1. Merging column names from the data file with values from the samples file.

2. Editing the column names to match the values.

3. Extracting groups for boxplot purposes when, as is often the case, we have a different number of samples for each treatment (so the simplest way of setting up the data for boxplot purposes won't work).

## The simulated data file is too big for Github.##
You can get it from Google Drive here:
https://drive.google.com/open?id=1EOb1dq-UkhBpyJyurjmg5skz9_qWf4lf


Contents are:
````2018_03_01_12_12_24BoxPlotExampleCD274.pdf```` output plot

````MDH_simulated_data.txt```` SIMULATED data

````MDH_simulated_data_boxplots_Example.R```` code

````MDH_simulated_data_boxplots_Example_output.txt```` text output

````MDH_simulated_samples.txt```` MADE-UP samples

### These data are not real.  I made them up out of whole cloth for this example. When I figured out how to do this, I was working with Confidential data, so I made something from scratch that I can share.
