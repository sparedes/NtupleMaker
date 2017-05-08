#ifndef NTUPLEMAKER_MAKEEFF_H
#define NTUPLEMAKER_MAKEEFF_H 1

#include "AthenaBaseComps/AthAlgorithm.h"
#include "GaudiKernel/ToolHandle.h" //included under assumption you'll want to use some tools! Remove if you don't!
#include "METTriggerToolBox/METTriggerToolBox/Interfaces/IGlobalConfigTool.h"
#include "METTriggerToolBox/METTriggerToolBox/AnalysisToolBox.h"
#include "TrigDecisionTool/TrigDecisionTool.h" 

#include <TH2.h>


class MakeEff: public ::AthAlgorithm { 
 public: 
  MakeEff( const std::string& name, ISvcLocator* pSvcLocator );
  virtual ~MakeEff(); 

  virtual StatusCode  initialize();
  virtual StatusCode  execute();
  virtual StatusCode  finalize();

  virtual StatusCode beginInputFile();

 private: 
  ToolHandle<METTrig::IGlobalConfigTool> m_configTool;
  ToolHandle<Trig::TrigDecisionTool> m_trigDecTool;
  ToolHandle<METTrig::AnalysisToolBox> m_toolBox;
  std::string m_decorator;
  TH1* h_HLT_xe100_L1XE50;
  TH1* h_MET;
  TH2* h2_offlineVsCellMET;

}; 
#endif //> !METTRIGGERTOOLBOX_MAKEEFF_H
