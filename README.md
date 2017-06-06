# NtupleMaker
This package produces a flat ntuple from an xAOD file, and plots histograms from these. It uses the tools setup in METTriggerToolBox for object setup and calibration. 

The xAOD -> NTUPLE  step is run in athena by the algorithm _MakeTree_. 

The package also contains two simple macros, one (_makeHist.C_) to write a histograms from the ntuple to a root file, and the other one (_plotFctn.C_) to exports the plots to image files. 

## Setup
First download the necessary packages:
```
setupATLAS
mkdir ETMissPlotting ; cd ETMissPlotting
git clone https://:@gitlab.cern.ch:8443/jburr/METTriggerToolBox.git
git clone https://github.com/sparedes/NtupleMaker.git # or download as zip and extract
```
Now setup athena and compile

```
asetup AthAnalysisBase,2.4.29,here 
cmt find_packages
cmt compile
```

## MakeTree Usage
The package's main algorithm is MakeTree (_NtupleMaker/src/MakeTree.\*_), which reads an xAOD file specified in the job options and writes a flat ntuple.


Check the job options file in `NtupleMaker/share/makeNtupleTest.py` for an example of how to use NtupleMaker.
To run, and save log, simply do (the second line only cleans up the area after the code runs): 


```
athena NtupleMaker/share/makeNtupleTest.py  2>&1 | tee log.txt
rm -f athfile* PoolFileCatalog* eventLoopHeartBeat.txt
``` 

from a directory with an athena setup (tested using 2.4.29). 

If needed, more branches could be added to the TTree by adding them in the same way other branches are crated in MakeTree.cxx and .h


### makeHist Usage 
This script reads the TTree generated by MakeTree, and outputs a root file with a few histograms. To use it, load it from a root session (make sure the path to metTree.root is correct in makeHist.C) :

```
root [0] .L NtupleMaker/src/makeHist.C 
root [1] treeToHist()
```
### plotFcn Usage
*plitFcn.C* is a plotting script I put together to produce files from histograms. 
It loops over a flat ntuple and produces a file of each of the histograms in it. Before running, create a directory for the plots.

Note: you can specify the type of file for the output when calling the function, as seen below. The default is eps.

```
mkdir plots
```

Then, in a root session:

```
root [0] .L NtupleMaker/plotFctn.C 
```
From here you can either:
 
 + Plot all the histograms(TH1 and TH2) in the file by doing:
```
root [1] plotHist("pdf")
```
 + Plot all the efficiency plots in the file in the file by doing:
```
root [2] plotEff("pdf")
```
or

 + Plot all the efficiencies in one plot by doing:
```
root [3] plotAllEff("pdf")
```


### Running on the Grid 
To run on the grid do (from the athena area):

```
lsetup panda
pathena path/to/jobOptions --inDS data.set.name  --outDS user.USERNAME.output
```
for example:
```
pathena NtupleMaker/share/makeNtupleTest.py --inDS data16_13TeV.00308084.physics_Main.merge.DAOD_JETM11.f741_m1673_p2950  --outDS user.saparede.METTrigger.PlotingFW.gridTest
```

To run on multiple datasets, one can do so with:
```
pathena NtupleMaker/share/makeNtupleTest.py --inDsTxt dsList.txt --useContElementBoundary --addNthFieldOfInDSToLFN 1,2  --outDS user.saparede.METTrigger.PlotingFW.gridTest
```
where dsList.txt is a text file with the dataset names on each line.

