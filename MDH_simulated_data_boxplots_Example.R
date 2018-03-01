
# MD Healy 1 March 2018

# Example of using sample annotations to group data and
# make boxplots in R.  The analyst often gets transcriptional
# profiling data as two tab-delimted files:
#
#            1. The Data, one row per GENE with samples in
#               columns
#
#            2. The Sample annotations, one row per SAMPLE.
#
# So to analyze such data, we need to group it by one or more
# of the experimental factors.
#
# For this simple example, I have generated two files of FAKE
# DATA using psuedorandom numbers.  I did this because the actual
# data for which I recently had to do something similar to this
# are marked CONFIDENTIAL by those who sent them to me.  So here
# I do it from scratch with synthetic data to illustrate the
# basic approach.  And a few wrinkles one might encounter with
# actual data...


setwd("C:/Users/matth/ExamplesWithR")

# Load libraries 
library(ggplot2)
library(stringr)


# Load my made-up sample information
Samples <- read.table("MDH_simulated_samples.txt",
                     header=TRUE,
		     sep="\t",
		     na.strings="NA",
		     stringsAsFactors = FALSE,
		     dec=".",
		     strip.white=TRUE
		     )

# Load the simulated data
Data <- read.table("MDH_simulated_data.txt",
                     header=TRUE,
		     sep="\t",
		     na.strings="NA",
		     stringsAsFactors = FALSE,
		     dec=".",
		     strip.white=TRUE
		         )

# To illustrate a common wrinkle, in the Data file I stuck on a
# "Subject_" prefix to the subject field, thus creating a need
# to strip off this prefix before doing the merge.

# First, get a vector of column names from Data, and fixup so they
# can be merged with Samples.  The I() function wrapped around
# the str_replace call is to prevent it being turned into a factor.

SubjectsFromData <- data.frame(
                        Subject = I(str_replace(
                           colnames(Data), "Subject_" , ""
                                             )),
                        ColNum = c(1:ncol(Data))
			      )

# So now we can merge this into Samples, giving us a way to index
# columns from Data based in treatments,

Samples2 <- merge(SubjectsFromData,
		  Samples,
		  by.x="Subject",
		  by.y="Subject",
		  all.x=TRUE,
		  all.y=TRUE)

# So, now Samples2 contains the information we need to break out
# Data by treatments

VehicleSamples <- Samples2[Samples2$Treatment == "Vehicle" ,     ]
Drug_ASamples <- Samples2[Samples2$Treatment == "Drug_A" ,       ]
Drug_BSamples <- Samples2[Samples2$Treatment == "Drug_B" ,       ]


VehCols <- as.numeric(na.omit(as.numeric(VehicleSamples$ColNum)))

Drug_ACols <- as.numeric(na.omit(as.numeric(Drug_ASamples$ColNum)))

Drug_BCols <- as.numeric(na.omit(as.numeric(Drug_BSamples$ColNum)))

# Now, let's pull out the Data row for the gene known as
# CD274 (also known as PDL1) expression

PDL1_flag <- Data$HGNC.Gene.Symbol == "CD274"

# Let's make a boxplot by treatment of this gene


# Open a PDF file to hold our plot
# Giving the file a unique name based on current time
PdfName <- str_replace_all(
               str_replace_all(
                   str_replace_all(
                       Sys.time(),
		       ":" , "_")
		   ," ","_"), "-" 
	       , "_")

PdfName <- paste(PdfName, "BoxPlotExampleCD274.pdf", sep="")
pdf(file=PdfName , paper = "letter")



Veh <- data.frame(group="vehicle",value=as.numeric(
                              na.omit(Data[PDL1_flag,VehCols]))
                 )

DrugA <- data.frame(group="drug A",value=as.numeric(
                              na.omit(Data[PDL1_flag,Drug_ACols]))
                 )

DrugB <- data.frame(group="drug B",value=as.numeric(
                              na.omit(Data[PDL1_flag,Drug_BCols]))
                 )

ForBoxPlot <- rbind(Veh, DrugA, DrugB)

ggplot(ForBoxPlot, aes(x=group, y=value, fill=group)) + geom_boxplot()

# Finally, make tables of the quartiles behind the boxplot

summary(ForBoxPlot)
summary(ForBoxPlot[ForBoxPlot$group=="vehicle",])
summary(ForBoxPlot[ForBoxPlot$group=="drug A",])
summary(ForBoxPlot[ForBoxPlot$group=="drug B",])

# Close the PDF file of plots
dev.off()


