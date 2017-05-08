#ifndef NTUPLEMAKER_MAKETREE_H
#define NTUPLEMAKER_MAKETREE_H 1

#include "AthenaBaseComps/AthAlgorithm.h"
#include "GaudiKernel/ToolHandle.h" //included under assumption you'll want to use some tools! Remove if you don't!

#include "METTriggerToolBox/Interfaces/IGlobalConfigTool.h"
#include "METTriggerToolBox/AnalysisToolBox.h"

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
  std::string m_decorator;
  TH1* h_HLT_xe100_L1XE50;
  TH1F* h_Offline_MET;
  TH2* h2_offlineVsCellMET;

  // Tree and tree branches
  TTree* t_metTree;
  float offLineMET;
  float offLineMET_x;
  float offLineMET_y;
  float offLineMET_sumet;
  float offLineMET_phi;

  float hlt_cell_met;
  float hlt_cell_ex;
  float hlt_cell_ey;
  float hlt_cell_sumet;
  float hlt_cell_sume;

  float eventNumber;
  float runNumber;
  float lumiBlock;



}; 

#endif //> !NTUPLEMAKER_MAKETREE_H
