#Skeleton joboption for a simple analysis job

#---- Minimal joboptions -------

theApp.EvtMax=1000                                         #says how many events to run over. Set to -1 for all events
#theApp.EvtMax=10000                                         #says how many events to run over. Set to -1 for all events
#theApp.EvtMax=100000                                         #says how many events to run over. Set to -1 for all events
#theApp.EvtMax=200000                                         #says how many events to run over. Set to -1 for all events
#theApp.EvtMax=500000                                         #says how many events to run over. Set to -1 for all events
#theApp.EvtMax=-1                                         #says how many events to run over. Set to -1 for all events
from glob import glob

#jps.AthenaCommonFlags.FilesInput = glob("/data/atlas/atlasdata3/burr/xAOD/testFiles/mc15_13TeV.363436.Sherpa_NNPDF30NNLO_Wmunu_Pt0_70_CVetoBVeto.merge.AOD.e4715_s2726_r9226_r8423/AOD.10988161._000001.pool.root.1")   #insert your list of input files here (do this before next lines)

#SP's test files
jps.AthenaCommonFlags.FilesInput = glob("/data/atlas/atlasdata3/paredes/JETM11/data16_13TeV.00307732.physics_Main.merge.DAOD_JETM11.f741_m1673_p2950_tid10313937_00/DAOD_JETM11.*.root*")#insert your list of input files here (do this before next lines)

msgLevel = DEBUG

import AthenaPoolCnvSvc.ReadAthenaPool                   #sets up reading of POOL files (e.g. xAODs)
#import AthenaRootComps.ReadAthenaxAODHybrid             #alternative for FAST xAOD reading!

## for BunchCrossingTool setup
from PyUtils import AthFile
from AthenaCommon.GlobalFlags import globalflags
from TrigBunchCrossingTool.BunchCrossingTool import BunchCrossingTool
af = AthFile.fopen(svcMgr.EventSelector.InputCollections[0]) 
isMC = 'IS_SIMULATION' in af.fileinfos['evt_type']
globalflags.DataSource = 'geant4' if isMC else 'data' 
globalflags.DatabaseInstance = 'CONDBR2' 



ToolSvc += CfgMgr.GoodRunsListSelectionTool("GoodRunsListSelectionTool",GoodRunsListVec=["GoodRunsLists/data16_13TeV/20170215/data16_13TeV.periodAllYear_DetStatus-v88-pro20-21_DQDefects-00-02-04_PHYS_StandardGRL_All_Good_25ns.xml"]) 

ToolSvc += CfgMgr.METTrig__GlobalConfigTool("GlobalConfigTool",
                                            ConfigFiles = ["METTriggerToolBox/share/WZCommon.json"] ,
                                            OutputLevel = msgLevel)
ToolSvc += CfgMgr.METTrig__AnalysisToolBox("AnalysisToolBox",
                                           GlobalConfigTool = ToolSvc.GlobalConfigTool,
                                           OutputLevel = msgLevel)
ToolSvc += CfgMgr.METTrig__WZCommonEventSelector("WZCommonEventSelector",
                                           Decorator = "WZCommon",
                                           GlobalConfigTool = ToolSvc.GlobalConfigTool,
                                           OutputLevel = msgLevel)

ToolSvc += CfgMgr.TrigConf__xAODConfigTool("xAODConfigTool")
ToolSvc += CfgMgr.Trig__TrigDecisionTool("TrigDecisionTool",
                                         ConfigTool = ToolSvc.xAODConfigTool,
                                         TrigDecisionKey = "xTrigDecision")
## setting up BunchCrossingTool
if isMC: ToolSvc += BunchCrossingTool( "MC" )
else: ToolSvc += BunchCrossingTool( "LHC" )

algseq = CfgMgr.AthSequencer("AthAlgSeq")                #gets the main AthSequencer
algseq += CfgMgr.AthEventCounter(Frequency = 1000)                                 #adds an instance of your alg to it

#Run PreliminaryAlg first to apply GRL, find if event has primary vertex, etc. 
algseq += CfgMgr.METTrig__PreliminaryAlg("PreliminaryAlg",
                                         GRLTool = ToolSvc.GoodRunsListSelectionTool)
algseq += CfgMgr.METTrig__GetObjects("GetObjects",
                                     ToolBox = ToolSvc.AnalysisToolBox,
                                     GlobalConfigTool = ToolSvc.GlobalConfigTool,
                                     RootStreamName = "CUTFLOW",
                                     RootDirName = "Objects",
                                     OutputLevel = msgLevel)
algseq += CfgMgr.METTrig__EventSelectionAlg("WZCommonSelections",
                                            SelectionTool = ToolSvc.WZCommonEventSelector,
                                            SetFilter = False,
                                            RootStreamName = "CUTFLOW",
                                            RootDirName = "Events",
                                            OutputLevel = msgLevel)
algseq += CfgMgr.MakeTree("MakeTree",
                          ToolBox = ToolSvc.AnalysisToolBox,
                          GlobalConfigTool = ToolSvc.GlobalConfigTool,
                          #OLD EventSelection = "Zmumu",
                          OutputLevel = msgLevel)

#-------------------------------


#note that if you edit the input files after this point you need to pass the new files to the EventSelector:
#like this: svcMgr.EventSelector.InputCollections = ["new","list"] 


print algseq
print ToolSvc


##--------------------------------------------------------------------
## This section shows up to set up a HistSvc output stream for outputing histograms and trees
## See https://twiki.cern.ch/twiki/bin/viewauth/AtlasProtected/AthAnalysisBase#How_to_output_trees_and_histogra for more details and examples

if not hasattr(svcMgr, 'THistSvc'): svcMgr += CfgMgr.THistSvc() #only add the histogram service if not already present (will be the case in this jobo)
svcMgr.THistSvc.Output += ["CUTFLOW DATAFILE='cutflow.root' OPT='RECREATE'"] #add an output root file stream
svcMgr.THistSvc.Output += ["METTREE DATAFILE='metTree.root' OPT='RECREATE'"] #add an output root file stream

##--------------------------------------------------------------------


##--------------------------------------------------------------------
## The lines below are an example of how to create an output xAOD
## See https://twiki.cern.ch/twiki/bin/viewauth/AtlasProtected/AthAnalysisBase#How_to_create_an_output_xAOD for more details and examples

#from OutputStreamAthenaPool.MultipleStreamManager import MSMgr
#xaodStream = MSMgr.NewPoolRootStream( "StreamXAOD", "xAOD.out.root" )

##EXAMPLE OF BASIC ADDITION OF EVENT AND METADATA ITEMS
##AddItem and AddMetaDataItem methods accept either string or list of strings
#xaodStream.AddItem( ["xAOD::JetContainer#*","xAOD::JetAuxContainer#*"] ) #Keeps all JetContainers (and their aux stores)
#xaodStream.AddMetaDataItem( ["xAOD::TriggerMenuContainer#*","xAOD::TriggerMenuAuxContainer#*"] )
#ToolSvc += CfgMgr.xAODMaker__TriggerMenuMetaDataTool("TriggerMenuMetaDataTool") #MetaDataItems needs their corresponding MetaDataTool
#svcMgr.MetaDataSvc.MetaDataTools += [ ToolSvc.TriggerMenuMetaDataTool ] #Add the tool to the MetaDataSvc to ensure it is loaded

##EXAMPLE OF SLIMMING (keeping parts of the aux store)
#xaodStream.AddItem( ["xAOD::ElectronContainer#Electrons","xAOD::ElectronAuxContainer#ElectronsAux.pt.eta.phi"] ) #example of slimming: only keep pt,eta,phi auxdata of electrons

##EXAMPLE OF SKIMMING (keeping specific events)
#xaodStream.AddAcceptAlgs( "AthEventCounter" ) #will only keep events where 'setFilterPassed(false)' has NOT been called in the given algorithm

##--------------------------------------------------------------------


include("AthAnalysisBaseComps/SuppressLogging.py")              #Optional include to suppress as much athena output as possible. Keep at bottom of joboptions so that it doesn't suppress the logging of the things you have configured above
MessageSvc.Format = "% F%60W%S%7W%R%T %0W%M"

