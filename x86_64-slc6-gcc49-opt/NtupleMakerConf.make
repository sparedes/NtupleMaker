#-- start of make_header -----------------

#====================================
#  Document NtupleMakerConf
#
#   Generated Wed May  3 17:31:05 2017  by paredes
#
#====================================

include ${CMTROOT}/src/Makefile.core

ifdef tag
CMTEXTRATAGS = $(tag)
else
tag       = $(CMTCONFIG)
endif

cmt_NtupleMakerConf_has_no_target_tag = 1

#--------------------------------------------------------

ifdef cmt_NtupleMakerConf_has_target_tag

tags      = $(tag),$(CMTEXTRATAGS),target_NtupleMakerConf

NtupleMaker_tag = $(tag)

#cmt_local_tagfile_NtupleMakerConf = $(NtupleMaker_tag)_NtupleMakerConf.make
cmt_local_tagfile_NtupleMakerConf = $(bin)$(NtupleMaker_tag)_NtupleMakerConf.make

else

tags      = $(tag),$(CMTEXTRATAGS)

NtupleMaker_tag = $(tag)

#cmt_local_tagfile_NtupleMakerConf = $(NtupleMaker_tag).make
cmt_local_tagfile_NtupleMakerConf = $(bin)$(NtupleMaker_tag).make

endif

include $(cmt_local_tagfile_NtupleMakerConf)
#-include $(cmt_local_tagfile_NtupleMakerConf)

ifdef cmt_NtupleMakerConf_has_target_tag

cmt_final_setup_NtupleMakerConf = $(bin)setup_NtupleMakerConf.make
cmt_dependencies_in_NtupleMakerConf = $(bin)dependencies_NtupleMakerConf.in
#cmt_final_setup_NtupleMakerConf = $(bin)NtupleMaker_NtupleMakerConfsetup.make
cmt_local_NtupleMakerConf_makefile = $(bin)NtupleMakerConf.make

else

cmt_final_setup_NtupleMakerConf = $(bin)setup.make
cmt_dependencies_in_NtupleMakerConf = $(bin)dependencies.in
#cmt_final_setup_NtupleMakerConf = $(bin)NtupleMakersetup.make
cmt_local_NtupleMakerConf_makefile = $(bin)NtupleMakerConf.make

endif

#cmt_final_setup = $(bin)setup.make
#cmt_final_setup = $(bin)NtupleMakersetup.make

#NtupleMakerConf :: ;

dirs ::
	@if test ! -r requirements ; then echo "No requirements file" ; fi; \
	  if test ! -d $(bin) ; then $(mkdir) -p $(bin) ; fi

javadirs ::
	@if test ! -d $(javabin) ; then $(mkdir) -p $(javabin) ; fi

srcdirs ::
	@if test ! -d $(src) ; then $(mkdir) -p $(src) ; fi

help ::
	$(echo) 'NtupleMakerConf'

binobj = 
ifdef STRUCTURED_OUTPUT
binobj = NtupleMakerConf/
#NtupleMakerConf::
#	@if test ! -d $(bin)$(binobj) ; then $(mkdir) -p $(bin)$(binobj) ; fi
#	$(echo) "STRUCTURED_OUTPUT="$(bin)$(binobj)
endif

${CMTROOT}/src/Makefile.core : ;
ifdef use_requirements
$(use_requirements) : ;
endif

#-- end of make_header ------------------
# File: cmt/fragments/genconfig_header
# Author: Wim Lavrijsen (WLavrijsen@lbl.gov)

# Use genconf.exe to create configurables python modules, then have the
# normal python install procedure take over.

.PHONY: NtupleMakerConf NtupleMakerConfclean

confpy  := NtupleMakerConf.py
conflib := $(bin)$(library_prefix)NtupleMaker.$(shlibsuffix)
confdb  := NtupleMaker.confdb
instdir := $(CMTINSTALLAREA)$(shared_install_subdir)/python/$(package)
product := $(instdir)/$(confpy)
initpy  := $(instdir)/__init__.py

ifdef GENCONF_ECHO
genconf_silent =
else
genconf_silent = $(silent)
endif

NtupleMakerConf :: NtupleMakerConfinstall

install :: NtupleMakerConfinstall

NtupleMakerConfinstall : /home/paredes/ETMissFW/NtupleMaker/genConf/NtupleMaker/$(confpy)
	@echo "Installing /home/paredes/ETMissFW/NtupleMaker/genConf/NtupleMaker in /home/paredes/ETMissFW/InstallArea/python" ; \
	 $(install_command) --exclude="*.py?" --exclude="__init__.py" --exclude="*.confdb" /home/paredes/ETMissFW/NtupleMaker/genConf/NtupleMaker /home/paredes/ETMissFW/InstallArea/python ; \

/home/paredes/ETMissFW/NtupleMaker/genConf/NtupleMaker/$(confpy) : $(conflib) /home/paredes/ETMissFW/NtupleMaker/genConf/NtupleMaker
	$(genconf_silent) $(genconfig_cmd)   -o /home/paredes/ETMissFW/NtupleMaker/genConf/NtupleMaker -p $(package) \
	  --configurable-module=GaudiKernel.Proxy \
	  --configurable-default-name=Configurable.DefaultName \
	  --configurable-algorithm=ConfigurableAlgorithm \
	  --configurable-algtool=ConfigurableAlgTool \
	  --configurable-auditor=ConfigurableAuditor \
          --configurable-service=ConfigurableService \
	  -i ../$(tag)/$(library_prefix)NtupleMaker.$(shlibsuffix)

/home/paredes/ETMissFW/NtupleMaker/genConf/NtupleMaker:
	@ if [ ! -d /home/paredes/ETMissFW/NtupleMaker/genConf/NtupleMaker ] ; then mkdir -p /home/paredes/ETMissFW/NtupleMaker/genConf/NtupleMaker ; fi ;

NtupleMakerConfclean :: NtupleMakerConfuninstall
	$(cleanup_silent) $(remove_command) /home/paredes/ETMissFW/NtupleMaker/genConf/NtupleMaker/$(confpy) /home/paredes/ETMissFW/NtupleMaker/genConf/NtupleMaker/$(confdb)

uninstall :: NtupleMakerConfuninstall

NtupleMakerConfuninstall ::
	@$(uninstall_command) /home/paredes/ETMissFW/InstallArea/python
libNtupleMaker_so_dependencies = ../x86_64-slc6-gcc49-opt/libNtupleMaker.so
#-- start of cleanup_header --------------

clean :: NtupleMakerConfclean ;
#	@cd .

ifndef PEDANTIC
.DEFAULT::
	$(echo) "(NtupleMakerConf.make) $@: No rule for such target" >&2
else
.DEFAULT::
	$(error PEDANTIC: $@: No rule for such target)
endif

NtupleMakerConfclean ::
#-- end of cleanup_header ---------------
