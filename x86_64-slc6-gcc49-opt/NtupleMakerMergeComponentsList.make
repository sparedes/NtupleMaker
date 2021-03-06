#-- start of make_header -----------------

#====================================
#  Document NtupleMakerMergeComponentsList
#
#   Generated Tue May 30 12:40:56 2017  by paredes
#
#====================================

include ${CMTROOT}/src/Makefile.core

ifdef tag
CMTEXTRATAGS = $(tag)
else
tag       = $(CMTCONFIG)
endif

cmt_NtupleMakerMergeComponentsList_has_no_target_tag = 1

#--------------------------------------------------------

ifdef cmt_NtupleMakerMergeComponentsList_has_target_tag

tags      = $(tag),$(CMTEXTRATAGS),target_NtupleMakerMergeComponentsList

NtupleMaker_tag = $(tag)

#cmt_local_tagfile_NtupleMakerMergeComponentsList = $(NtupleMaker_tag)_NtupleMakerMergeComponentsList.make
cmt_local_tagfile_NtupleMakerMergeComponentsList = $(bin)$(NtupleMaker_tag)_NtupleMakerMergeComponentsList.make

else

tags      = $(tag),$(CMTEXTRATAGS)

NtupleMaker_tag = $(tag)

#cmt_local_tagfile_NtupleMakerMergeComponentsList = $(NtupleMaker_tag).make
cmt_local_tagfile_NtupleMakerMergeComponentsList = $(bin)$(NtupleMaker_tag).make

endif

include $(cmt_local_tagfile_NtupleMakerMergeComponentsList)
#-include $(cmt_local_tagfile_NtupleMakerMergeComponentsList)

ifdef cmt_NtupleMakerMergeComponentsList_has_target_tag

cmt_final_setup_NtupleMakerMergeComponentsList = $(bin)setup_NtupleMakerMergeComponentsList.make
cmt_dependencies_in_NtupleMakerMergeComponentsList = $(bin)dependencies_NtupleMakerMergeComponentsList.in
#cmt_final_setup_NtupleMakerMergeComponentsList = $(bin)NtupleMaker_NtupleMakerMergeComponentsListsetup.make
cmt_local_NtupleMakerMergeComponentsList_makefile = $(bin)NtupleMakerMergeComponentsList.make

else

cmt_final_setup_NtupleMakerMergeComponentsList = $(bin)setup.make
cmt_dependencies_in_NtupleMakerMergeComponentsList = $(bin)dependencies.in
#cmt_final_setup_NtupleMakerMergeComponentsList = $(bin)NtupleMakersetup.make
cmt_local_NtupleMakerMergeComponentsList_makefile = $(bin)NtupleMakerMergeComponentsList.make

endif

#cmt_final_setup = $(bin)setup.make
#cmt_final_setup = $(bin)NtupleMakersetup.make

#NtupleMakerMergeComponentsList :: ;

dirs ::
	@if test ! -r requirements ; then echo "No requirements file" ; fi; \
	  if test ! -d $(bin) ; then $(mkdir) -p $(bin) ; fi

javadirs ::
	@if test ! -d $(javabin) ; then $(mkdir) -p $(javabin) ; fi

srcdirs ::
	@if test ! -d $(src) ; then $(mkdir) -p $(src) ; fi

help ::
	$(echo) 'NtupleMakerMergeComponentsList'

binobj = 
ifdef STRUCTURED_OUTPUT
binobj = NtupleMakerMergeComponentsList/
#NtupleMakerMergeComponentsList::
#	@if test ! -d $(bin)$(binobj) ; then $(mkdir) -p $(bin)$(binobj) ; fi
#	$(echo) "STRUCTURED_OUTPUT="$(bin)$(binobj)
endif

${CMTROOT}/src/Makefile.core : ;
ifdef use_requirements
$(use_requirements) : ;
endif

#-- end of make_header ------------------
# File: cmt/fragments/merge_componentslist_header
# Author: Sebastien Binet (binet@cern.ch)

# Makefile fragment to merge a <library>.components file into a single
# <project>.components file in the (lib) install area
# If no InstallArea is present the fragment is dummy


.PHONY: NtupleMakerMergeComponentsList NtupleMakerMergeComponentsListclean

# default is already '#'
#genmap_comment_char := "'#'"

componentsListRef    := ../$(tag)/NtupleMaker.components

ifdef CMTINSTALLAREA
componentsListDir    := ${CMTINSTALLAREA}/$(tag)/lib
mergedComponentsList := $(componentsListDir)/$(project).components
stampComponentsList  := $(componentsListRef).stamp
else
componentsListDir    := ../$(tag)
mergedComponentsList :=
stampComponentsList  :=
endif

NtupleMakerMergeComponentsList :: $(stampComponentsList) $(mergedComponentsList)
	@:

.NOTPARALLEL : $(stampComponentsList) $(mergedComponentsList)

$(stampComponentsList) $(mergedComponentsList) :: $(componentsListRef)
	@echo "Running merge_componentslist  NtupleMakerMergeComponentsList"
	$(merge_componentslist_cmd) --do-merge \
         --input-file $(componentsListRef) --merged-file $(mergedComponentsList)

NtupleMakerMergeComponentsListclean ::
	$(cleanup_silent) $(merge_componentslist_cmd) --un-merge \
         --input-file $(componentsListRef) --merged-file $(mergedComponentsList) ;
	$(cleanup_silent) $(remove_command) $(stampComponentsList)
libNtupleMaker_so_dependencies = ../x86_64-slc6-gcc49-opt/libNtupleMaker.so
#-- start of cleanup_header --------------

clean :: NtupleMakerMergeComponentsListclean ;
#	@cd .

ifndef PEDANTIC
.DEFAULT::
	$(echo) "(NtupleMakerMergeComponentsList.make) $@: No rule for such target" >&2
else
.DEFAULT::
	$(error PEDANTIC: $@: No rule for such target)
endif

NtupleMakerMergeComponentsListclean ::
#-- end of cleanup_header ---------------
