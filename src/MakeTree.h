#ifndef NTUPLEMAKER_MAKETREE_H
#define NTUPLEMAKER_MAKETREE_H 1

#include "AthenaBaseComps/AthAlgorithm.h"
#include "GaudiKernel/ToolHandle.h" //included under assumption you'll want to use some tools! Remove if you don't!

#include "METTriggerToolBox/Interfaces/IGlobalConfigTool.h"
#include "METTriggerToolBox/AnalysisToolBox.h"
#include "TrigAnalysisInterfaces/IBunchCrossingTool.h"
#include "TrigBunchCrossingTool/BunchCrossingToolBase.h"

#include "TTree.h"
#include <TH2.h>

class MakeTree: public ::AthAlgorithm { 
 public: 
  MakeTree( const std::string& name, ISvcLocator* pSvcLocator );
  virtual ~MakeTree(); 

  virtual StatusCode  initialize();
  virtual StatusCode  execute();
  virtual StatusCode  finalize();

 private: 
  ToolHandle<METTrig::IGlobalConfigTool> m_configTool;
  ToolHandle<METTrig::AnalysisToolBox> m_toolBox;
  //ToolHandle<Trig::TrigDecisionTool> m_trigDecTool;
  ToolHandle<Trig::IBunchCrossingTool> m_bunchCrossTool;
  //ToolHandle<Trig::BunchCrossingToolBase> m_bunchCrossTool;
  //OLD std::string m_eventSelection;
  TH1* h_HLT_xe100_L1XE50;
  TH1F* h_offline_MET;
  TH2* h2_offlineVsCellMET;

  // Tree and tree branches
  TTree* t_metTree;
  float offlineMET;
  float offlineMET_x;
  float offlineMET_y;
  float offlineMET_sumet;
  float offlineMET_phi;

  float hlt_cell_met;
  float hlt_cell_ex;
  float hlt_cell_ey;
  float hlt_cell_sumet;
  float hlt_cell_sume;
  float hlt_mht_met;
  float hlt_mht_ex;
  float hlt_mht_ey;
  float hlt_mht_sumet;
  float hlt_mht_sume;
  float hlt_topoCluster_met;
  float hlt_topoCluster_ex;
  float hlt_topoCluster_ey;
  float hlt_topoCluster_sumet;
  float hlt_topoCluster_sume;
  float hlt_pufit_met;
  float hlt_pufit_ex;
  float hlt_pufit_ey;
  float hlt_pufit_sumet;
  float hlt_pufit_sume;
  float hlt_pueta_met;
  float hlt_pueta_ex;
  float hlt_pueta_ey;
  float hlt_pueta_sumet;
  float hlt_pueta_sume;

  unsigned long long int eventNumber;
  uint32_t runNumber;
  uint32_t lumiBlock;
  uint32_t bunchCrossingID;
  float actualMu;
  float averageMu;
  int nPrimaryVtx;

  int distanceFromFront;
  int distanceFromTail; 

  bool passWenu;
  bool passWmunu;
  bool passZee;
  bool passZmumu;

  bool pass_HLT_xe100_L1XE50;
  bool pass_HLT_xe110_mht_L1XE50;
  bool pass_HLT_xe160_tc_lcw_L1XE50;
  bool pass_HLT_xe140_pufit_L1XE50;
  bool pass_HLT_xe140_pueta_L1XE50;
  bool pass_HLT_xe110_mht_L1XE50_AND_xe70_L1XE50;

  
  bool pass_HLT_xe110_pufit_L1XE60;
  bool pass_HLT_xe120_pufit_L1XE60;
  bool pass_HLT_xe110_pufit_wEFMu_L1XE60;
  bool pass_HLT_xe120_mht_xe80_L1XE60;
}; 
#endif //> !NTUPLEMAKER_MAKETREE_H

