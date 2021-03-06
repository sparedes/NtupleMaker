#-- start of make_header -----------------

#====================================
#  Document NtupleMakerComponentsList
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

cmt_NtupleMakerComponentsList_has_no_target_tag = 1

#--------------------------------------------------------

ifdef cmt_NtupleMakerComponentsList_has_target_tag

tags      = $(tag),$(CMTEXTRATAGS),target_NtupleMakerComponentsList

NtupleMaker_tag = $(tag)

#cmt_local_tagfile_NtupleMakerComponentsList = $(NtupleMaker_tag)_NtupleMakerComponentsList.make
cmt_local_tagfile_NtupleMakerComponentsList = $(bin)$(NtupleMaker_tag)_NtupleMakerComponentsList.make

else

tags      = $(tag),$(CMTEXTRATAGS)

NtupleMaker_tag = $(tag)

#cmt_local_tagfile_NtupleMakerComponentsList = $(NtupleMaker_tag).make
cmt_local_tagfile_NtupleMakerComponentsList = $(bin)$(NtupleMaker_tag).make

endif

include $(cmt_local_tagfile_NtupleMakerComponentsList)
#-include $(cmt_local_tagfile_NtupleMakerComponentsList)

ifdef cmt_NtupleMakerComponentsList_has_target_tag

cmt_final_setup_NtupleMakerComponentsList = $(bin)setup_NtupleMakerComponentsList.make
cmt_dependencies_in_NtupleMakerComponentsList = $(bin)dependencies_NtupleMakerComponentsList.in
#cmt_final_setup_NtupleMakerComponentsList = $(bin)NtupleMaker_NtupleMakerComponentsListsetup.make
cmt_local_NtupleMakerComponentsList_makefile = $(bin)NtupleMakerComponentsList.make

else

cmt_final_setup_NtupleMakerComponentsList = $(bin)setup.make
cmt_dependencies_in_NtupleMakerComponentsList = $(bin)dependencies.in
#cmt_final_setup_NtupleMakerComponentsList = $(bin)NtupleMakersetup.make
cmt_local_NtupleMakerComponentsList_makefile = $(bin)NtupleMakerComponentsList.make

endif

#cmt_final_setup = $(bin)setup.make
#cmt_final_setup = $(bin)NtupleMakersetup.make

#NtupleMakerComponentsList :: ;

dirs ::
	@if test ! -r requirements ; then echo "No requirements file" ; fi; \
	  if test ! -d $(bin) ; then $(mkdir) -p $(bin) ; fi

javadirs ::
	@if test ! -d $(javabin) ; then $(mkdir) -p $(javabin) ; fi

srcdirs ::
	@if test ! -d $(src) ; then $(mkdir) -p $(src) ; fi

help ::
	$(echo) 'NtupleMakerComponentsList'

binobj = 
ifdef STRUCTURED_OUTPUT
binobj = NtupleMakerComponentsList/
#NtupleMakerComponentsList::
#	@if test ! -d $(bin)$(binobj) ; then $(mkdir) -p $(bin)$(binobj) ; fi
#	$(echo) "STRUCTURED_OUTPUT="$(bin)$(binobj)
endif

${CMTROOT}/src/Makefile.core : ;
ifdef use_requirements
$(use_requirements) : ;
endif

#-- end of make_header ------------------
##
componentslistfile = NtupleMaker.components
COMPONENTSLIST_DIR = ../$(tag)
fulllibname = libNtupleMaker.$(shlibsuffix)

NtupleMakerComponentsList :: ${COMPONENTSLIST_DIR}/$(componentslistfile)
	@:

${COMPONENTSLIST_DIR}/$(componentslistfile) :: $(bin)$(fulllibname)
	@echo 'Generating componentslist file for $(fulllibname)'
	cd ../$(tag);$(listcomponents_cmd) --output ${COMPONENTSLIST_DIR}/$(componentslistfile) $(fulllibname)

install :: NtupleMakerComponentsListinstall
NtupleMakerComponentsListinstall :: NtupleMakerComponentsList

uninstall :: NtupleMakerComponentsListuninstall
NtupleMakerComponentsListuninstall :: NtupleMakerComponentsListclean

NtupleMakerComponentsListclean ::
	@echo 'Deleting $(componentslistfile)'
	@rm -f ${COMPONENTSLIST_DIR}/$(componentslistfile)

#-- start of cleanup_header --------------

clean :: NtupleMakerComponentsListclean ;
#	@cd .

ifndef PEDANTIC
.DEFAULT::
	$(echo) "(NtupleMakerComponentsList.make) $@: No rule for such target" >&2
else
.DEFAULT::
	$(error PEDANTIC: $@: No rule for such target)
endif

NtupleMakerComponentsListclean ::
#-- end of cleanup_header ---------------
