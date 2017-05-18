// NtupleMaker includes
#include "MakeTree.h"

#include "GaudiKernel/ITHistSvc.h"

#include "TRandom.h"

#include "xAODEventInfo/EventInfo.h"
  
//for trigMET
//#include "xAODRootAccess/TEvent.h"
  
#include "TrigDecisionTool/TrigDecisionTool.h"
#include "TrigBunchCrossingTool/BunchCrossingToolBase.h"
#include "xAODTrigMissingET/TrigMissingETContainer.h"
#include "TrigAnalysisInterfaces/IBunchCrossingTool.h"

#include "xAODTracking/VertexContainer.h"
//#include "TEfficiency.h"


using namespace xAOD;
namespace {
  float GeV(0.001);
} 



MakeTree::MakeTree( const std::string& name, ISvcLocator* pSvcLocator ) : AthAlgorithm( name, pSvcLocator ){

  declareProperty("GlobalConfigTool", m_configTool);
  declareProperty("BunchCrossingTool", m_bunchCrossTool);
  declareProperty("ToolBox", m_toolBox);
  

}


MakeTree::~MakeTree() {}


StatusCode MakeTree::initialize() {
  ATH_MSG_INFO ("Initializing " << name() << "...");

  ServiceHandle<ITHistSvc> histSvc("THistSvc",name());
  ATH_CHECK( histSvc.retrieve() );

  ATH_CHECK( m_configTool.retrieve() );
  ATH_CHECK( m_toolBox.retrieve() );

  t_metTree = new TTree("metTree","metTree");
  //offlineMET branches
  t_metTree->Branch("offlineMET",&offlineMET);
  t_metTree->Branch("offlineMET_x",&offlineMET_x);
  t_metTree->Branch("offlineMET_y",&offlineMET_y);
  t_metTree->Branch("offlineMET_sumet",&offlineMET_sumet);
  t_metTree->Branch("offlineMET_phi",&offlineMET_phi);
  //HLT met branches
  //Cell  
  t_metTree->Branch("hlt_cell_met",&hlt_cell_met);
  t_metTree->Branch("hlt_cell_ex",&hlt_cell_ex);
  t_metTree->Branch("hlt_cell_ey",&hlt_cell_ey);
  t_metTree->Branch("hlt_cell_sumet",&hlt_cell_sumet);
  t_metTree->Branch("hlt_cell_sume",&hlt_cell_sume);
  //mht (tc_mht)  
  t_metTree->Branch("hlt_mht_met",&hlt_mht_met);
  t_metTree->Branch("hlt_mht_ex",&hlt_mht_ex);
  t_metTree->Branch("hlt_mht_ey",&hlt_mht_ey);
  t_metTree->Branch("hlt_mht_sumet",&hlt_mht_sumet);
  t_metTree->Branch("hlt_mht_sume",&hlt_mht_sume);
  //Topocluster (tc_lcw)  
  t_metTree->Branch("hlt_topoCluster_met",&hlt_topoCluster_met);
  t_metTree->Branch("hlt_topoCluster_ex",&hlt_topoCluster_ex);
  t_metTree->Branch("hlt_topoCluster_ey",&hlt_topoCluster_ey);
  t_metTree->Branch("hlt_topoCluster_sumet",&hlt_topoCluster_sumet);
  t_metTree->Branch("hlt_topoCluster_sume",&hlt_topoCluster_sume);
  //Topocluster pileup fit (tc_lcw_pufit) 
  t_metTree->Branch("hlt_pufit_met",&hlt_pufit_met);
  t_metTree->Branch("hlt_pufit_ex",&hlt_pufit_ex);
  t_metTree->Branch("hlt_pufit_ey",&hlt_pufit_ey);
  t_metTree->Branch("hlt_pufit_sumet",&hlt_pufit_sumet);
  t_metTree->Branch("hlt_pufit_sume",&hlt_pufit_sume);
  //Topocluster pileup subtraction (tc_lcw_pueta) 
  t_metTree->Branch("hlt_pueta_met",&hlt_pueta_met);
  t_metTree->Branch("hlt_pueta_ex",&hlt_pueta_ex);
  t_metTree->Branch("hlt_pueta_ey",&hlt_pueta_ey);
  t_metTree->Branch("hlt_pueta_sumet",&hlt_pueta_sumet);
  t_metTree->Branch("hlt_pueta_sume",&hlt_pueta_sume);
  //EvenInfo branches
  t_metTree->Branch("eventNumber",&eventNumber);
  t_metTree->Branch("runNumber",&runNumber);
  t_metTree->Branch("lumiBlock",&lumiBlock);
  t_metTree->Branch("actualMu",&actualMu);
  t_metTree->Branch("averageMu",&averageMu);
  t_metTree->Branch("bunchCrossingID",&bunchCrossingID);
  t_metTree->Branch("nPrimaryVtx",&nPrimaryVtx);
  //BunchCrossing branches
  t_metTree->Branch("distanceFromFront",&distanceFromFront);//distance of the spacific bunch from the FRONT of the train
  t_metTree->Branch("distanceFromTail",&distanceFromTail);//distance of the spacific bunch from the TAIL of the train

  //Signal selection booleans
  t_metTree->Branch("passWenu",&passWenu);
  t_metTree->Branch("passWmunu",&passWmunu);
  t_metTree->Branch("passZee",&passZee);
  t_metTree->Branch("passZmumu",&passZmumu);

  //Lowest unprescaled trigger booleans
  t_metTree->Branch("pass_HLT_xe100_L1XE50",&pass_HLT_xe100_L1XE50);
  t_metTree->Branch("pass_HLT_xe110_mht_L1XE50",&pass_HLT_xe110_mht_L1XE50);
  t_metTree->Branch("pass_HLT_xe160_tc_lcw_L1XE50",&pass_HLT_xe160_tc_lcw_L1XE50);
  t_metTree->Branch("pass_HLT_xe140_pufit_L1XE50",&pass_HLT_xe140_pufit_L1XE50);
  t_metTree->Branch("pass_HLT_xe140_pueta_L1XE50",&pass_HLT_xe140_pueta_L1XE50);
  t_metTree->Branch("pass_HLT_xe110_mht_L1XE50_AND_xe70_L1XE50",&pass_HLT_xe110_mht_L1XE50_AND_xe70_L1XE50);

  ATH_CHECK( histSvc->regTree("/METTREE/metTree", t_metTree) );

  //Setup bunch crossing tool 
  m_bunchCrossTool.setTypeAndName("Trig::LHCBunchCrossingTool/BunchCrossingTool");

  return StatusCode::SUCCESS;
}

StatusCode MakeTree::finalize() {
  ATH_MSG_INFO ("Finalizing " << name() << "...");

  return StatusCode::SUCCESS;
}

StatusCode MakeTree::execute() {  
  ATH_MSG_DEBUG ("Executing " << name() << "...");

  //HLT level met
  const xAOD::TrigMissingETContainer* hlt_cell_Cont(0);
  CHECK( evtStore()->retrieve(hlt_cell_Cont, "HLT_xAOD__TrigMissingETContainer_TrigEFMissingET") );
  //finding hlt trigger met quantities to fill branches
  hlt_cell_ex = hlt_cell_Cont->front()->ex()*GeV;
  hlt_cell_ey = hlt_cell_Cont->front()->ey()*GeV;
  hlt_cell_met = sqrt(hlt_cell_ex*hlt_cell_ex + hlt_cell_ey*hlt_cell_ey);
  hlt_cell_sumet = hlt_cell_Cont->front()->sumEt()*GeV;
  hlt_cell_sume = hlt_cell_Cont->front()->sumE()*GeV;
  const xAOD::TrigMissingETContainer* hlt_mht_Cont(0);
  CHECK( evtStore()->retrieve(hlt_mht_Cont, "HLT_xAOD__TrigMissingETContainer_TrigEFMissingET_mht") );
  hlt_mht_ex = hlt_mht_Cont->front()->ex()*GeV;
  hlt_mht_ey = hlt_mht_Cont->front()->ey()*GeV;
  hlt_mht_met = sqrt(hlt_mht_ex*hlt_mht_ex + hlt_mht_ey*hlt_mht_ey);
  hlt_mht_sumet = hlt_mht_Cont->front()->sumEt()*GeV;
  hlt_mht_sume = hlt_mht_Cont->front()->sumE()*GeV;
  const xAOD::TrigMissingETContainer* hlt_topoCluster_Cont(0);
  CHECK( evtStore()->retrieve(hlt_topoCluster_Cont, "HLT_xAOD__TrigMissingETContainer_TrigEFMissingET_topocl") );
  hlt_topoCluster_ex = hlt_topoCluster_Cont->front()->ex()*GeV;
  hlt_topoCluster_ey = hlt_topoCluster_Cont->front()->ey()*GeV;
  hlt_topoCluster_met = sqrt(hlt_topoCluster_ex*hlt_topoCluster_ex + hlt_topoCluster_ey*hlt_topoCluster_ey);
  hlt_topoCluster_sumet = hlt_topoCluster_Cont->front()->sumEt()*GeV;
  hlt_topoCluster_sume = hlt_topoCluster_Cont->front()->sumE()*GeV;
  const xAOD::TrigMissingETContainer* hlt_pufit_Cont(0);
  CHECK( evtStore()->retrieve(hlt_pufit_Cont, "HLT_xAOD__TrigMissingETContainer_TrigEFMissingET_topocl_PUC") );
  hlt_pufit_ex = hlt_pufit_Cont->front()->ex()*GeV;
  hlt_pufit_ey = hlt_pufit_Cont->front()->ey()*GeV;
  hlt_pufit_met = sqrt(hlt_pufit_ex*hlt_pufit_ex + hlt_pufit_ey*hlt_pufit_ey);
  hlt_pufit_sumet = hlt_pufit_Cont->front()->sumEt()*GeV;
  hlt_pufit_sume = hlt_pufit_Cont->front()->sumE()*GeV;
  const xAOD::TrigMissingETContainer* hlt_pueta_Cont(0);
  CHECK( evtStore()->retrieve(hlt_pueta_Cont, "HLT_xAOD__TrigMissingETContainer_TrigEFMissingET_topocl_PS") );
  hlt_pueta_ex = hlt_pueta_Cont->front()->ex()*GeV;
  hlt_pueta_ey = hlt_pueta_Cont->front()->ey()*GeV;
  hlt_pueta_met = sqrt(hlt_pueta_ex*hlt_pueta_ex + hlt_pueta_ey*hlt_pueta_ey);
  hlt_pueta_sumet = hlt_pueta_Cont->front()->sumEt()*GeV;
  hlt_pueta_sume = hlt_pueta_Cont->front()->sumE()*GeV;

  //Retrieving offline MET
  const xAOD::MissingETContainer* metCont(0);
  ATH_CHECK( evtStore()->retrieve(metCont, m_configTool->metName() ) );
  auto metItr = metCont->find("FinalTrk");
  if (metItr == metCont->end() ) {
    ATH_MSG_ERROR( "FinalTrk not present in container " << m_configTool->metName() );
    return StatusCode::FAILURE;
  }
  const auto met = *metItr;
  //finding offlineMet quantities to fill branches
  offlineMET = met->met()*GeV;
  offlineMET_x = met->mpx()*GeV;
  offlineMET_y = met->mpy()*GeV;
  offlineMET_sumet = met->sumet()*GeV;
  offlineMET_phi = met->phi();

  //EventInfo quantities
  const xAOD::EventInfo* evtInfo(0);
  ATH_CHECK( evtStore()->retrieve(evtInfo, "EventInfo") );
  eventNumber = evtInfo->eventNumber();
  runNumber = evtInfo->runNumber();
  lumiBlock = evtInfo->lumiBlock();
  actualMu = evtInfo->actualInteractionsPerCrossing();
  averageMu = evtInfo->averageInteractionsPerCrossing();
  bunchCrossingID = evtInfo->bcid();
  //Bunch Info
  distanceFromFront = m_bunchCrossTool->distanceFromFront(bunchCrossingID);//in nanoseconds
  distanceFromTail = m_bunchCrossTool->distanceFromTail(bunchCrossingID);
  
  //Finding number of primary vertices
  const xAOD::VertexContainer* vertices(0);
  ATH_CHECK( evtStore()->retrieve(vertices, "PrimaryVertices") );
  nPrimaryVtx = vertices->size();

  //Checking if event passes signal selection
  //booleans eventSelections
  static SG::AuxElement::ConstAccessor<char> cacc_eventWenu("Pass_Wenu");
  static SG::AuxElement::ConstAccessor<char> cacc_eventWmunu("Pass_Wmunu");
  static SG::AuxElement::ConstAccessor<char> cacc_eventZee("Pass_Zee");
  static SG::AuxElement::ConstAccessor<char> cacc_eventZmumu("Pass_Zmumu");
  passWenu =  (cacc_eventWenu(*evtInfo));    
  passWmunu = (cacc_eventWmunu(*evtInfo));   
  passZee = (cacc_eventZee(*evtInfo));     
  passZmumu = (cacc_eventZmumu(*evtInfo));   
  
  bool isSignalEvent = passWenu || passWmunu || passZmumu || passZee;

  //bools triggers
  //TODO: PRIORITY. Get Triggers from list
  pass_HLT_xe100_L1XE50 = m_toolBox->isPassed("HLT_xe100_L1XE50");
  pass_HLT_xe110_mht_L1XE50 = m_toolBox->isPassed("HLT_xe110_mht_L1XE50");
  pass_HLT_xe160_tc_lcw_L1XE50 = m_toolBox->isPassed("HLT_xe160_tc_lcw_L1XE50");
  pass_HLT_xe140_pufit_L1XE50 = m_toolBox->isPassed("HLT_xe140_pufit_L1XE50");
  pass_HLT_xe140_pueta_L1XE50 = m_toolBox->isPassed("HLT_xe140_pueta_L1XE50");
  pass_HLT_xe110_mht_L1XE50_AND_xe70_L1XE50 = m_toolBox->isPassed("HLT_xe110_mht_L1XE50_AND_xe70_L1XE50");


  if (isSignalEvent) t_metTree->Fill();
  return StatusCode::SUCCESS;
}


