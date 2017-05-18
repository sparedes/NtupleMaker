//Script to print TEfficiency objects from a .root file containing only TEfficiency objects. 
//run root, .L thisfile.C, plotHist()  
#include "../AtlasStyle/AtlasStyle.C"
#include "../AtlasStyle/AtlasUtils.C"
#include "../AtlasStyle/AtlasUtils.h"
#include "../AtlasStyle/AtlasLabels.C"
#include "../AtlasStyle/AtlasLabels.h"
#include "TFile.h"
#include "TAxis.h"
#include "TPaveText.h"
#include "TGaxis.h"
#include "TKey.h"
#include "TDirectory.h"
#include "TROOT.h"


namespace {
    float GeV(0.001);
    int offCol(kBlue);
    int cellCol(kYellow+1);
    int mhtCol(kRed);
    int pufitCol(kCyan+1);
    int mhtPcellCol(kOrange-3);
    int tcCol(kGreen);
    int puetaCol(kPink);
    //TODO make this configurable
    const char* sampleType("Data 2016, #sqrt{s}= 13 TeV");
    const char* labelTag("Internal");//could be "Preliminary","Trigger Operations", "Trigger Preliminary" etc.
}

template<typename T> T* readKey(TObject* key) {
    TKey* asKey = dynamic_cast<TKey*>(key);
    return dynamic_cast<T*>(asKey->ReadObj());
}

void setTrigMETStyle(TH1* hist){
  //setting default colors for each met ALG
  TString histName = hist->GetName();
  //finding type of algorithm from the TEfficiency name
  if (histName.Index("mht")  != -1 && histName.Index("AND")  == -1 ) {
    hist->SetMarkerColor(mhtCol);
    hist->SetLineColor(mhtCol);
  }
  else if (histName.Index("pufit")  != -1) {
    hist->SetMarkerColor(pufitCol);
    hist->SetLineColor(pufitCol);
  }
  else if (histName.Index("mht")  != -1 && histName.Index("AND")  != -1 ) {
    hist->SetMarkerColor(mhtPcellCol);
    hist->SetLineColor(mhtPcellCol);
  }
  else if (histName.Index("tc") != -1) {
    hist->SetMarkerColor(tcCol);
    hist->SetLineColor(tcCol);
  }
  else if (histName.Index("pueta") != -1) {
    hist->SetMarkerColor(puetaCol);
    hist->SetLineColor(puetaCol);
  }
  else {
    hist->SetMarkerColor(cellCol);
    hist->SetLineColor(cellCol);
  }
}
void setTrigMETStyle(TGraphAsymmErrors* eff){
  //setting default colors for each met ALG
  TString effName = eff->GetName();
  if (effName.Index("mht")  != -1 && effName.Index("AND")  == -1 ) {
    eff->SetMarkerColor(mhtCol);
    eff->SetLineColor(mhtCol);
  }
  else if (effName.Index("pufit")  != -1) {
    eff->SetMarkerColor(pufitCol);
    eff->SetLineColor(pufitCol);
  }
  else if (effName.Index("mht")  != -1 && effName.Index("AND")  != -1 ) {
    eff->SetMarkerColor(mhtPcellCol);
    eff->SetLineColor(mhtPcellCol);
  }
  else if (effName.Index("tc") != -1) {
    eff->SetMarkerColor(tcCol);
    eff->SetLineColor(tcCol);
  }
  else if (effName.Index("pueta") != -1) {
    eff->SetMarkerColor(puetaCol);
    eff->SetLineColor(puetaCol);
  }
  else {
    eff->SetMarkerColor(cellCol);
    eff->SetLineColor(cellCol);
  }
}

// type of file output by funcion can be specified, default is .eps
void plotHist(string fileType = "eps"){
  SetAtlasStyle(); 
  TFile *myHistoFile = TFile::Open("metHistograms.root");
  TCanvas *C = new TCanvas("atlas_rectangular","Canvas title",0.,0.,800,600);

  //gStyle->SetOptTitle(kTRUE);
  
  //loop over all histograms in the file
  for(auto histoKey : *(myHistoFile->GetListOfKeys())) {
    auto metHisto = readKey<TH1>(histoKey);
    if(metHisto == nullptr) break;
    
    //setting default colors
    setTrigMETStyle(metHisto);

    TString histoName = metHisto->GetName();
    TGaxis::SetMaxDigits(3);
    metHisto->Draw("COLZ");
    //path to save file
    TString nametext = "plots/firstTests/";
    nametext += metHisto->GetName();    
    nametext += ".";    
    nametext += fileType;    
    //creating labels
    ATLASLabel(0.6,0.5,labelTag);
    TPaveText* pave = new TPaveText(0.62,0.42,0.85,0.5,"NDC");
    pave->SetBorderSize(0);
    pave->SetFillColor(0);
    pave->SetTextSize(0.); 
    pave->AddText(sampleType); 
    pave->Draw(); 
    C->Print(nametext);
    C->Clear();
    }
  C->Close();
}
void plotEff(string fileType = "eps"){
  SetAtlasStyle(); 
  TFile *myEffFile = TFile::Open("metEfficiencies.root");
  TCanvas *C = new TCanvas("atlas_rectangular","Canvas title",0.,0.,800,600);

  //gStyle->SetOptTitle(kTRUE);
  
  for(auto effKey : *(myEffFile->GetListOfKeys())) {
    auto metEff = readKey<TGraphAsymmErrors>(effKey);
    string st(typeid(metEff).name());
    if(metEff == nullptr) break;
    TString effName = metEff->GetName();
    TGaxis::SetMaxDigits(3);
    auto legend = new TLegend(0.45,0.2,0.9,0.4);
    
    //setting default colors
    setTrigMETStyle(metEff);

    metEff->SetTitle(";offline E_{Tmiss} [GeV]; Efficiency");
    metEff->Draw("AP");
    TString nametext = "plots/firstTests/";
    nametext += metEff->GetName();    
    nametext += ".";    
    nametext += fileType;    
    cout<<nametext<<endl;
    ATLASLabel(0.6,0.5,labelTag);
    TPaveText* pave = new TPaveText(0.62,0.42,0.89,0.5,"NDC");
    pave->SetBorderSize(0);
    pave->SetFillStyle(0);
    pave->SetTextSize(0.); 
    pave->AddText(sampleType); 
    pave->Draw(); 
    TString legendText(effName(effName.Index("HLT"),effName.Length()));
    legend->AddEntry(metEff->GetName(),legendText,"ep");
    C->Print(nametext);
    C->Clear();
  } 
  //C->Close();
}
void plotAllEff(string fileType = "eps"){
  SetAtlasStyle(); 
  TFile *myEffFile = TFile::Open("metEfficiencies.root");
  TCanvas *C = new TCanvas("atlas_rectangular","Canvas title",0.,0.,800,600);

  string selection = "Zmumu";
  //gStyle->SetOptTitle(kTRUE);

  auto legend = new TLegend(0.45,0.2,0.89,0.4);
  
  int nEf = 0;
  for(auto effKey : *(myEffFile->GetListOfKeys())) {
    auto metEff = readKey<TGraphAsymmErrors>(effKey);
    //string st(typeid(metEff).name());
    if(metEff == nullptr) break;
    TGaxis::SetMaxDigits(3);

    //setting default colors
    setTrigMETStyle(metEff);

    metEff->SetTitle(";offline E_{Tmiss} [GeV]; Efficiency");
    if (nEf == 0) metEff->Draw("AP");
    else metEff->Draw("SAMEP");
    TString effName = metEff->GetName();
    TString legendText(effName(effName.Index("HLT"),effName.Length()));
    legend->AddEntry(metEff->GetName(),legendText,"ep");
    nEf++;
  } 
  cout<<nEf<<endl;
  TString nametext = "plots/firstTests/allEffs_";
  nametext += selection;    
  nametext += ".";    
  nametext += fileType;    
  cout<<nametext<<endl;
  ATLASLabel(0.6,0.5,labelTag);
  TPaveText* pave = new TPaveText(0.62,0.42,0.85,0.5,"NDC");
  pave->SetBorderSize(0);
  pave->SetFillStyle(0);
  pave->SetTextSize(0.); 
  pave->AddText(sampleType); 

  legend->SetBorderSize(0);
  legend->SetFillStyle(0);
  legend->SetTextSize(0.); 
  legend->Draw();

  pave->Draw(); 
  C->Print(nametext);
  //setting default colors for each met ALG
  //C->Clear();
  //C->Close();
}
