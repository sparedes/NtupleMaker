#include "GaudiKernel/DeclareFactoryEntries.h"

#include "../MakeTree.h"
DECLARE_ALGORITHM_FACTORY( MakeTree )

DECLARE_FACTORY_ENTRIES( NtupleMaker ) 
{
  DECLARE_ALGORITHM( MakeTree );
  DECLARE_ALGORITHM( MakeEff );
}
