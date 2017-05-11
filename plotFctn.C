//Script to print TEfficiency objects from a .root file containing only TEfficiency objects. 
//run root, .L thisfile.C, plotHist()  
#include "TFile.h"
#include "TKey.h"
#include "TDirectory.h"

template<typename T> T* readKey(TObject* key) {
    TKey* asKey = dynamic_cast<TKey*>(key);
    return dynamic_cast<T*>(asKey->ReadObj());
}

void plotHist(){
  cout<<"I'm ALIIIIVE (before oppening file)"<<endl;
  TFile *myHistoFile = TFile::Open("metHistograms.root");
  TCanvas *C = new TCanvas();
  gStyle->SetOptTitle(kTRUE);
  
  for(auto histoKey : *(myHistoFile->GetListOfKeys())) {
    auto metHisto = readKey<TH1>(histoKey);
    if(metHisto == nullptr) break;
    // Retrieving Trigger name from histogram name 
    TString histoName = metHisto->GetName();
    TString newName;
    metHisto->Draw("COLZ");
    TString nametext = "plots/firstTests/";
    nametext += metHisto->GetName();    
    nametext += ".png";    
    cout<<nametext<<endl;
    C->Print(nametext);
    C->Clear();
    }
  C->Close();
}
