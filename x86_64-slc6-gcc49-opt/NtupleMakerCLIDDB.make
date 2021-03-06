#-- start of make_header -----------------

#====================================
#  Document NtupleMakerCLIDDB
#
#   Generated Tue May 30 12:40:54 2017  by paredes
#
#====================================

include ${CMTROOT}/src/Makefile.core

ifdef tag
CMTEXTRATAGS = $(tag)
else
tag       = $(CMTCONFIG)
endif

cmt_NtupleMakerCLIDDB_has_no_target_tag = 1

#--------------------------------------------------------

ifdef cmt_NtupleMakerCLIDDB_has_target_tag

tags      = $(tag),$(CMTEXTRATAGS),target_NtupleMakerCLIDDB

NtupleMaker_tag = $(tag)

#cmt_local_tagfile_NtupleMakerCLIDDB = $(NtupleMaker_tag)_NtupleMakerCLIDDB.make
cmt_local_tagfile_NtupleMakerCLIDDB = $(bin)$(NtupleMaker_tag)_NtupleMakerCLIDDB.make

else

tags      = $(tag),$(CMTEXTRATAGS)

NtupleMaker_tag = $(tag)

#cmt_local_tagfile_NtupleMakerCLIDDB = $(NtupleMaker_tag).make
cmt_local_tagfile_NtupleMakerCLIDDB = $(bin)$(NtupleMaker_tag).make

endif

include $(cmt_local_tagfile_NtupleMakerCLIDDB)
#-include $(cmt_local_tagfile_NtupleMakerCLIDDB)

ifdef cmt_NtupleMakerCLIDDB_has_target_tag

cmt_final_setup_NtupleMakerCLIDDB = $(bin)setup_NtupleMakerCLIDDB.make
cmt_dependencies_in_NtupleMakerCLIDDB = $(bin)dependencies_NtupleMakerCLIDDB.in
#cmt_final_setup_NtupleMakerCLIDDB = $(bin)NtupleMaker_NtupleMakerCLIDDBsetup.make
cmt_local_NtupleMakerCLIDDB_makefile = $(bin)NtupleMakerCLIDDB.make

else

cmt_final_setup_NtupleMakerCLIDDB = $(bin)setup.make
cmt_dependencies_in_NtupleMakerCLIDDB = $(bin)dependencies.in
#cmt_final_setup_NtupleMakerCLIDDB = $(bin)NtupleMakersetup.make
cmt_local_NtupleMakerCLIDDB_makefile = $(bin)NtupleMakerCLIDDB.make

endif

#cmt_final_setup = $(bin)setup.make
#cmt_final_setup = $(bin)NtupleMakersetup.make

#NtupleMakerCLIDDB :: ;

dirs ::
	@if test ! -r requirements ; then echo "No requirements file" ; fi; \
	  if test ! -d $(bin) ; then $(mkdir) -p $(bin) ; fi

javadirs ::
	@if test ! -d $(javabin) ; then $(mkdir) -p $(javabin) ; fi

srcdirs ::
	@if test ! -d $(src) ; then $(mkdir) -p $(src) ; fi

help ::
	$(echo) 'NtupleMakerCLIDDB'

binobj = 
ifdef STRUCTURED_OUTPUT
binobj = NtupleMakerCLIDDB/
#NtupleMakerCLIDDB::
#	@if test ! -d $(bin)$(binobj) ; then $(mkdir) -p $(bin)$(binobj) ; fi
#	$(echo) "STRUCTURED_OUTPUT="$(bin)$(binobj)
endif

${CMTROOT}/src/Makefile.core : ;
ifdef use_requirements
$(use_requirements) : ;
endif

#-- end of make_header ------------------
# File: cmt/fragments/genCLIDDB_header
# Author: Paolo Calafiura
# derived from genconf_header

# Use genCLIDDB_cmd to create package clid.db files

.PHONY: NtupleMakerCLIDDB NtupleMakerCLIDDBclean

outname := clid.db
cliddb  := NtupleMaker_$(outname)
instdir := $(CMTINSTALLAREA)/share
result  := $(instdir)/$(cliddb)
product := $(instdir)/$(outname)
conflib := $(bin)$(library_prefix)NtupleMaker.$(shlibsuffix)

NtupleMakerCLIDDB :: $(result)

$(instdir) :
	$(mkdir) -p $(instdir)

$(result) : $(conflib) $(product)
	@$(genCLIDDB_cmd) -p NtupleMaker -i$(product) -o $(result)

$(product) : $(instdir)
	touch $(product)

NtupleMakerCLIDDBclean ::
	$(cleanup_silent) $(uninstall_command) $(product) $(result)
	$(cleanup_silent) $(cmt_uninstallarea_command) $(product) $(result)

#-- start of cleanup_header --------------

clean :: NtupleMakerCLIDDBclean ;
#	@cd .

ifndef PEDANTIC
.DEFAULT::
	$(echo) "(NtupleMakerCLIDDB.make) $@: No rule for such target" >&2
else
.DEFAULT::
	$(error PEDANTIC: $@: No rule for such target)
endif

NtupleMakerCLIDDBclean ::
#-- end of cleanup_header ---------------
