
#include "GaudiKernel/DeclareFactoryEntries.h"

#include "../MakeEff.h"

DECLARE_ALGORITHM_FACTORY( MakeEff )


#include "../MakeTree.h"
DECLARE_ALGORITHM_FACTORY( MakeTree )

DECLARE_FACTORY_ENTRIES( NtupleMaker ) 
{
  DECLARE_ALGORITHM( MakeTree );
  DECLARE_ALGORITHM( MakeEff );
}
