// MakeEff includes
#include "MakeEff.h"
#include "xAODEventInfo/EventInfo.h"

#include "GaudiKernel/ITHistSvc.h"

//for trigMET
#include "xAODRootAccess/TEvent.h"

#include "TrigDecisionTool/TrigDecisionTool.h"
#include "xAODTrigMissingET/TrigMissingETContainer.h"
#include "TEfficiency.h"


using namespace xAOD;
namespace {
  float GeV(0.001);
  //float mT(const xAOD::IParticle* particle, const xAOD::MissingET* met) {
  //  return sqrt(2*particle->pt()*met->met()*(1-cos(met->phi()-particle->phi()) ) )*GeV;
  //}
}


MakeEff::MakeEff( const std::string& name, ISvcLocator* pSvcLocator ) : AthAlgorithm( name, pSvcLocator )
{

  declareProperty("Decorator", m_decorator);
  declareProperty("GlobalConfigTool", m_configTool);
  declareProperty("ToolBox", m_toolBox);
  declareProperty("TrigDecisionTool", m_trigDecTool);

}


MakeEff::~MakeEff() {}


StatusCode MakeEff::initialize() {
  ATH_MSG_INFO ("Initializing " << name() << "...");
  ServiceHandle<ITHistSvc> histSvc("THistSvc",name());
  ATH_CHECK( histSvc.retrieve() );


  ATH_CHECK( m_configTool.retrieve() );
  ATH_CHECK( m_toolBox.retrieve() );

  h_HLT_xe100_L1XE50 = new TH1D("h_HLT_xe100_L1XE50", "HLT_xe100_L1XE50 ;Offline E_{T}^{miss}  [GeV]", 400,0,400);
  ATH_CHECK( histSvc->regHist("/METHIST/h_HLT_xe100_L1XE50", h_HLT_xe100_L1XE50) );

  h_MET = new TH1D("h_MET", "MET ;Offline E_{T}^{miss}  [GeV]", 400,0,400);
  ATH_CHECK( histSvc->regHist("/METHIST/h_MET", h_MET) );

  h2_offlineVsCellMET = new TH2D("OffLineVSCellMet", "Offline vs HLT Cell  MET;OffLine E_{T}^{miss}, #mu invisible  [GeV]; HLT cell E_{T}^{miss}  [GeV]", 400,0,400,400,0,400);
  ATH_CHECK( histSvc->regHist("/METHIST/h2_offlineVsCellMET", h2_offlineVsCellMET) );





  // first try just 1 hist for (TH1* cutflow : {h_Wenu, h_Zee, h_Wmunu, h_Zmumu} ) cutflow->Fill("Number of events", 0.);
  //for (TH1* cutflow : {h_Wenu, h_Zee, h_Wmunu, h_Zmumu} ) cutflow->Fill("Bad Jet Veto", 0.);

  //m_trigDecTool->setProperty("TrigDecisionKey","xTrigDecision");

  return StatusCode::SUCCESS;
}

StatusCode MakeEff::finalize() {
  ATH_MSG_INFO ("Finalizing " << name() << "...");

  return StatusCode::SUCCESS;
}

StatusCode MakeEff::execute() {  
  ATH_MSG_DEBUG ("Executing " << name() << "...");
  //auto chainGroup = trigDecTool.getChainGroup(".*");
  //for(auto &trig : chainGroup->getListOfTriggers()) {
  //  auto cg = trigDecTool.getChainGroup(trig);
  //}


  //retrieve tirggerMET
  //auto cg = m_trigDecTool->getChainGroup("HLT_xe100_L1XE50");
  //auto fc = cg->features();
  //auto eventFeatureMET = fc.elementFeature<TrigMissingETContainer>(); 
  //auto onLineMETcont = *eventFeatureMET.cptr();
  //ATH_MSG_DEBUG(onLineMETcont->met());
  //auto cg = m_trigDecTool->getChainGroup("HLT_e25_etcut");
  //auto fc = cg->features();
  //auto eventFeatureMET = fc.containerFeature<"TrigElectronContainer">(); 
  //auto onLineMETcont = *eventFeatureMET.cptr();
  //ATH_MSG_DEBUG(onLineMETcont->met());

  const xAOD::TrigMissingETContainer* hlt_cell_Cont(0);
  CHECK( evtStore()->retrieve(hlt_cell_Cont, "HLT_xAOD__TrigMissingETContainer_TrigEFMissingET") );
  float hlt_cell_ex = hlt_cell_Cont->front()->ex();
  float hlt_cell_ey = hlt_cell_Cont->front()->ey();
  float hlt_cell_Met = sqrt(hlt_cell_ex*hlt_cell_ex + hlt_cell_ey*hlt_cell_ey);


  const xAOD::MissingETContainer* metCont(0);
  ATH_CHECK( evtStore()->retrieve(metCont, m_configTool->metName() ) );
  auto metItr = metCont->find("FinalTrk");
  if (metItr == metCont->end() ) {
    ATH_MSG_ERROR( "FinalTrk not present in container " << m_configTool->metName() );
    return StatusCode::FAILURE;
  }
  const auto met = *metItr;

  const xAOD::EventInfo* evtInfo(0);
  ATH_CHECK( evtStore()->retrieve(evtInfo, "EventInfo") );
  
  static SG::AuxElement::ConstAccessor<char> cacc_decorator("Pass_"+m_decorator);

  if (cacc_decorator(*evtInfo)){
    ATH_MSG_DEBUG (m_decorator << " event pre-selected");

    h_MET->Fill(met->met()*GeV);
    if (m_toolBox->isPassed("HLT_xe100_L1XE50")) h_HLT_xe100_L1XE50->Fill(met->met()*GeV);
  }

  h2_offlineVsCellMET->Fill(hlt_cell_Met*GeV,met->met()*GeV); 

  return StatusCode::SUCCESS;
}

StatusCode MakeEff::beginInputFile() { 
  //
  //This method is called at the start of each input file, even if
  //the input file contains no events. Accumulate metadata information here
  //

  //example of retrieval of CutBookkeepers: (remember you will need to include the necessary header files and use statements in requirements file)
  // const xAOD::CutBookkeeperContainer* bks = 0;
  // CHECK( inputMetaStore()->retrieve(bks, "CutBookkeepers") );

  //example of IOVMetaData retrieval (see https://twiki.cern.ch/twiki/bin/viewauth/AtlasProtected/AthAnalysisBase#How_to_access_file_metadata_in_C)
  //float beamEnergy(0); CHECK( retrieveMetadata("/TagInfo","beam_energy",beamEnergy) );
  //std::vector<float> bunchPattern; CHECK( retrieveMetadata("/Digitiation/Parameters","BeamIntensityPattern",bunchPattern) );



  return StatusCode::SUCCESS;
}
