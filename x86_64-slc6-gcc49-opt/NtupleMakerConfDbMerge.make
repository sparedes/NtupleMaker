#-- start of make_header -----------------

#====================================
#  Document NtupleMakerConfDbMerge
#
#   Generated Tue May 30 12:40:55 2017  by paredes
#
#====================================

include ${CMTROOT}/src/Makefile.core

ifdef tag
CMTEXTRATAGS = $(tag)
else
tag       = $(CMTCONFIG)
endif

cmt_NtupleMakerConfDbMerge_has_no_target_tag = 1

#--------------------------------------------------------

ifdef cmt_NtupleMakerConfDbMerge_has_target_tag

tags      = $(tag),$(CMTEXTRATAGS),target_NtupleMakerConfDbMerge

NtupleMaker_tag = $(tag)

#cmt_local_tagfile_NtupleMakerConfDbMerge = $(NtupleMaker_tag)_NtupleMakerConfDbMerge.make
cmt_local_tagfile_NtupleMakerConfDbMerge = $(bin)$(NtupleMaker_tag)_NtupleMakerConfDbMerge.make

else

tags      = $(tag),$(CMTEXTRATAGS)

NtupleMaker_tag = $(tag)

#cmt_local_tagfile_NtupleMakerConfDbMerge = $(NtupleMaker_tag).make
cmt_local_tagfile_NtupleMakerConfDbMerge = $(bin)$(NtupleMaker_tag).make

endif

include $(cmt_local_tagfile_NtupleMakerConfDbMerge)
#-include $(cmt_local_tagfile_NtupleMakerConfDbMerge)

ifdef cmt_NtupleMakerConfDbMerge_has_target_tag

cmt_final_setup_NtupleMakerConfDbMerge = $(bin)setup_NtupleMakerConfDbMerge.make
cmt_dependencies_in_NtupleMakerConfDbMerge = $(bin)dependencies_NtupleMakerConfDbMerge.in
#cmt_final_setup_NtupleMakerConfDbMerge = $(bin)NtupleMaker_NtupleMakerConfDbMergesetup.make
cmt_local_NtupleMakerConfDbMerge_makefile = $(bin)NtupleMakerConfDbMerge.make

else

cmt_final_setup_NtupleMakerConfDbMerge = $(bin)setup.make
cmt_dependencies_in_NtupleMakerConfDbMerge = $(bin)dependencies.in
#cmt_final_setup_NtupleMakerConfDbMerge = $(bin)NtupleMakersetup.make
cmt_local_NtupleMakerConfDbMerge_makefile = $(bin)NtupleMakerConfDbMerge.make

endif

#cmt_final_setup = $(bin)setup.make
#cmt_final_setup = $(bin)NtupleMakersetup.make

#NtupleMakerConfDbMerge :: ;

dirs ::
	@if test ! -r requirements ; then echo "No requirements file" ; fi; \
	  if test ! -d $(bin) ; then $(mkdir) -p $(bin) ; fi

javadirs ::
	@if test ! -d $(javabin) ; then $(mkdir) -p $(javabin) ; fi

srcdirs ::
	@if test ! -d $(src) ; then $(mkdir) -p $(src) ; fi

help ::
	$(echo) 'NtupleMakerConfDbMerge'

binobj = 
ifdef STRUCTURED_OUTPUT
binobj = NtupleMakerConfDbMerge/
#NtupleMakerConfDbMerge::
#	@if test ! -d $(bin)$(binobj) ; then $(mkdir) -p $(bin)$(binobj) ; fi
#	$(echo) "STRUCTURED_OUTPUT="$(bin)$(binobj)
endif

${CMTROOT}/src/Makefile.core : ;
ifdef use_requirements
$(use_requirements) : ;
endif

#-- end of make_header ------------------
# File: cmt/fragments/merge_genconfDb_header
# Author: Sebastien Binet (binet@cern.ch)

# Makefile fragment to merge a <library>.confdb file into a single
# <project>.confdb file in the (lib) install area

.PHONY: NtupleMakerConfDbMerge NtupleMakerConfDbMergeclean

# default is already '#'
#genconfDb_comment_char := "'#'"

instdir      := ${CMTINSTALLAREA}/$(tag)
confDbRef    := /home/paredes/ETMissFW/NtupleMaker/genConf/NtupleMaker/NtupleMaker.confdb
stampConfDb  := $(confDbRef).stamp
mergedConfDb := $(instdir)/lib/$(project).confdb

NtupleMakerConfDbMerge :: $(stampConfDb) $(mergedConfDb)
	@:

.NOTPARALLEL : $(stampConfDb) $(mergedConfDb)

$(stampConfDb) $(mergedConfDb) :: $(confDbRef)
	@echo "Running merge_genconfDb  NtupleMakerConfDbMerge"
	$(merge_genconfDb_cmd) \
          --do-merge \
          --input-file $(confDbRef) \
          --merged-file $(mergedConfDb)

NtupleMakerConfDbMergeclean ::
	$(cleanup_silent) $(merge_genconfDb_cmd) \
          --un-merge \
          --input-file $(confDbRef) \
          --merged-file $(mergedConfDb)	;
	$(cleanup_silent) $(remove_command) $(stampConfDb)
libNtupleMaker_so_dependencies = ../x86_64-slc6-gcc49-opt/libNtupleMaker.so
#-- start of cleanup_header --------------

clean :: NtupleMakerConfDbMergeclean ;
#	@cd .

ifndef PEDANTIC
.DEFAULT::
	$(echo) "(NtupleMakerConfDbMerge.make) $@: No rule for such target" >&2
else
.DEFAULT::
	$(error PEDANTIC: $@: No rule for such target)
endif

NtupleMakerConfDbMergeclean ::
#-- end of cleanup_header ---------------
