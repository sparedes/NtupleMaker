// NtupleMaker includes
#include "MakeTree.h"

#include "GaudiKernel/ITHistSvc.h"

#include "TRandom.h"

#include "xAODEventInfo/EventInfo.h"
  
//for trigMET
//#include "xAODRootAccess/TEvent.h"
  
#include "TrigDecisionTool/TrigDecisionTool.h"
#include "xAODTrigMissingET/TrigMissingETContainer.h"
//#include "TEfficiency.h"


using namespace xAOD;
namespace {
  float GeV(0.001);
  //float mT(const xAOD::IParticle* particle, const xAOD::MissingET* met) {
  //  return sqrt(2*particle->pt()*met->met()*(1-cos(met->phi()-particle->phi()) ) )*GeV;
  //}
} 



MakeTree::MakeTree( const std::string& name, ISvcLocator* pSvcLocator ) : AthAlgorithm( name, pSvcLocator ){

  declareProperty("Decorator", m_decorator);
  declareProperty("GlobalConfigTool", m_configTool);
  declareProperty("ToolBox", m_toolBox);
  //declareProperty("TrigDecisionTool", m_trigDecTool);
  

}


MakeTree::~MakeTree() {}


StatusCode MakeTree::initialize() {
  ATH_MSG_INFO ("Initializing " << name() << "...");

  ServiceHandle<ITHistSvc> histSvc("THistSvc",name());
  ATH_CHECK( histSvc.retrieve() );

  ATH_CHECK( m_configTool.retrieve() );
  ATH_CHECK( m_toolBox.retrieve() );

  //ATH_CHECK( book(TTree("metTree", "metTree") ) );
  t_metTree = new TTree("metTree","metTree");
  //OfflineMET branches
  t_metTree->Branch("offLineMET",&offLineMET);
  t_metTree->Branch("offLineMET_x",&offLineMET_x);
  t_metTree->Branch("offLineMET_y",&offLineMET_y);
  t_metTree->Branch("offLineMET_sumet",&offLineMET_sumet);
  t_metTree->Branch("offLineMET_phi",&offLineMET_phi);
  //HLT met branches
  t_metTree->Branch("hlt_cell_met",&hlt_cell_met);
  t_metTree->Branch("hlt_cell_ex",&hlt_cell_ex);
  t_metTree->Branch("hlt_cell_ey",&hlt_cell_ey);
  t_metTree->Branch("hlt_cell_sumet",&hlt_cell_sumet);
  t_metTree->Branch("hlt_cell_sume",&hlt_cell_sume);
  //EvenInfo branches
  t_metTree->Branch("eventNumber",&eventNumber);
  t_metTree->Branch("runNumber",&runNumber);
  t_metTree->Branch("lumiBlock",&lumiBlock);

  ATH_CHECK( histSvc->regTree("/METTREE/metTree", t_metTree) );



  //h_HLT_xe100_L1XE50 = new TH1D("h_HLT_xe100_L1XE50", "HLT_xe100_L1XE50 ;Offline E_{T}^{miss}  [GeV]", 400,0,400);
  //ATH_CHECK( histSvc->regHist("/METHIST/h_HLT_xe100_L1XE50", h_HLT_xe100_L1XE50) );

  //h_MET = new TH1D("h_MET", "MET ;Offline E_{T}^{miss}  [GeV]", 400,0,400);
  //ATH_CHECK( histSvc->regHist("/METHIST/h_MET", h_MET) );

  //h2_offlineVsCellMET = new TH2D("OffLineVSCellMet", "Offline vs HLT Cell  MET;OffLine E_{T}^{miss}, #mu invisible  [GeV]; HLT cell E_{T}^{miss}  [GeV]", 400,0,400,400,0,400);
  //ATH_CHECK( histSvc->regHist("/METHIST/h2_offlineVsCellMET", h2_offlineVsCellMET) );

  return StatusCode::SUCCESS;
}

StatusCode MakeTree::finalize() {
  ATH_MSG_INFO ("Finalizing " << name() << "...");

  return StatusCode::SUCCESS;
}

StatusCode MakeTree::execute() {  
  ATH_MSG_DEBUG ("Executing " << name() << "...");

  t_metTree->SetBranchAddress("offLineMET",&offLineMET);
  t_metTree->SetBranchAddress("offLineMET_x",&offLineMET_x);
  t_metTree->SetBranchAddress("offLineMET_y",&offLineMET_y);
  t_metTree->SetBranchAddress("offLineMET_sumet",&offLineMET_sumet);
  t_metTree->SetBranchAddress("offLineMET_phi",&offLineMET_phi);

  t_metTree->SetBranchAddress("hlt_cell_met",&hlt_cell_met);
  t_metTree->SetBranchAddress("hlt_cell_ex",&hlt_cell_ex);
  t_metTree->SetBranchAddress("hlt_cell_ey",&hlt_cell_ey);
  t_metTree->SetBranchAddress("hlt_cell_sumet",&hlt_cell_sumet);
  t_metTree->SetBranchAddress("hlt_cell_sume",&hlt_cell_sume);


  t_metTree->SetBranchAddress("eventNumber",&eventNumber);
  t_metTree->SetBranchAddress("runNumber",&runNumber);
  t_metTree->SetBranchAddress("lumiBlock",&lumiBlock);
  //HLT trigger emulation
  const xAOD::TrigMissingETContainer* hlt_cell_Cont(0);
  CHECK( evtStore()->retrieve(hlt_cell_Cont, "HLT_xAOD__TrigMissingETContainer_TrigEFMissingET") );
  //finding hlt trigger met quantities to fill branches
  hlt_cell_ex = hlt_cell_Cont->front()->ex()*GeV;
  hlt_cell_ey = hlt_cell_Cont->front()->ey()*GeV;
  hlt_cell_met = sqrt(hlt_cell_ex*hlt_cell_ex + hlt_cell_ey*hlt_cell_ey);
  hlt_cell_sumet = hlt_cell_Cont->front()->sumEt()*GeV;
  hlt_cell_sume = hlt_cell_Cont->front()->sumE()*GeV;

  //Retrieving offline MET
  const xAOD::MissingETContainer* metCont(0);
  ATH_CHECK( evtStore()->retrieve(metCont, m_configTool->metName() ) );
  auto metItr = metCont->find("FinalTrk");
  if (metItr == metCont->end() ) {
    ATH_MSG_ERROR( "FinalTrk not present in container " << m_configTool->metName() );
    return StatusCode::FAILURE;
  }
  const auto met = *metItr;

  //EventInfo quantities
  const xAOD::EventInfo* evtInfo(0);
  ATH_CHECK( evtStore()->retrieve(evtInfo, "EventInfo") );
  eventNumber = evtInfo->eventNumber();
  runNumber = evtInfo->runNumber();
  lumiBlock = evtInfo->lumiBlock();

  //Checking if event passes signal selection
  static SG::AuxElement::ConstAccessor<char> cacc_decorator("Pass_"+m_decorator);
  if (cacc_decorator(*evtInfo)){
    ATH_MSG_DEBUG (m_decorator << " event pre-selected");
    //finding offlineMet quantities to fill branches
    offLineMET = met->met()*GeV;
    offLineMET_x = met->mpx()*GeV;
    offLineMET_y = met->mpy()*GeV;
    offLineMET_sumet = met->sumet()*GeV;
    offLineMET_phi = met->phi();
    
    //Fill TTree if event passed signal selection
    t_metTree->Fill();
    //if (m_toolBox->isPassed("HLT_xe100_L1XE50")) met->met()*GeV;
  }
  //debug int i = 0;
  //debug offLineMET = gRandom->Rndm();
  //debug if (i%100 == 0) ATH_MSG_DEBUG ("value was " << offLineMET << "...");
  //debug i++;

  
  return StatusCode::SUCCESS;
}


