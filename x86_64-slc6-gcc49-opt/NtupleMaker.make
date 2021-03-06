#-- start of make_header -----------------

#====================================
#  Library NtupleMaker
#
#   Generated Tue May 30 12:37:19 2017  by paredes
#
#====================================

include ${CMTROOT}/src/Makefile.core

ifdef tag
CMTEXTRATAGS = $(tag)
else
tag       = $(CMTCONFIG)
endif

cmt_NtupleMaker_has_no_target_tag = 1

#--------------------------------------------------------

ifdef cmt_NtupleMaker_has_target_tag

tags      = $(tag),$(CMTEXTRATAGS),target_NtupleMaker

NtupleMaker_tag = $(tag)

#cmt_local_tagfile_NtupleMaker = $(NtupleMaker_tag)_NtupleMaker.make
cmt_local_tagfile_NtupleMaker = $(bin)$(NtupleMaker_tag)_NtupleMaker.make

else

tags      = $(tag),$(CMTEXTRATAGS)

NtupleMaker_tag = $(tag)

#cmt_local_tagfile_NtupleMaker = $(NtupleMaker_tag).make
cmt_local_tagfile_NtupleMaker = $(bin)$(NtupleMaker_tag).make

endif

include $(cmt_local_tagfile_NtupleMaker)
#-include $(cmt_local_tagfile_NtupleMaker)

ifdef cmt_NtupleMaker_has_target_tag

cmt_final_setup_NtupleMaker = $(bin)setup_NtupleMaker.make
cmt_dependencies_in_NtupleMaker = $(bin)dependencies_NtupleMaker.in
#cmt_final_setup_NtupleMaker = $(bin)NtupleMaker_NtupleMakersetup.make
cmt_local_NtupleMaker_makefile = $(bin)NtupleMaker.make

else

cmt_final_setup_NtupleMaker = $(bin)setup.make
cmt_dependencies_in_NtupleMaker = $(bin)dependencies.in
#cmt_final_setup_NtupleMaker = $(bin)NtupleMakersetup.make
cmt_local_NtupleMaker_makefile = $(bin)NtupleMaker.make

endif

#cmt_final_setup = $(bin)setup.make
#cmt_final_setup = $(bin)NtupleMakersetup.make

#NtupleMaker :: ;

dirs ::
	@if test ! -r requirements ; then echo "No requirements file" ; fi; \
	  if test ! -d $(bin) ; then $(mkdir) -p $(bin) ; fi

javadirs ::
	@if test ! -d $(javabin) ; then $(mkdir) -p $(javabin) ; fi

srcdirs ::
	@if test ! -d $(src) ; then $(mkdir) -p $(src) ; fi

help ::
	$(echo) 'NtupleMaker'

binobj = 
ifdef STRUCTURED_OUTPUT
binobj = NtupleMaker/
#NtupleMaker::
#	@if test ! -d $(bin)$(binobj) ; then $(mkdir) -p $(bin)$(binobj) ; fi
#	$(echo) "STRUCTURED_OUTPUT="$(bin)$(binobj)
endif

${CMTROOT}/src/Makefile.core : ;
ifdef use_requirements
$(use_requirements) : ;
endif

#-- end of make_header ------------------
#-- start of libary_header ---------------

NtupleMakerlibname   = $(bin)$(library_prefix)NtupleMaker$(library_suffix)
NtupleMakerlib       = $(NtupleMakerlibname).a
NtupleMakerstamp     = $(bin)NtupleMaker.stamp
NtupleMakershstamp   = $(bin)NtupleMaker.shstamp

NtupleMaker :: dirs  NtupleMakerLIB
	$(echo) "NtupleMaker ok"

#-- end of libary_header ----------------
#-- start of library_no_static ------

#NtupleMakerLIB :: $(NtupleMakerlib) $(NtupleMakershstamp)
NtupleMakerLIB :: $(NtupleMakershstamp)
	$(echo) "NtupleMaker : library ok"

$(NtupleMakerlib) :: $(bin)MakeTree.o $(bin)NtupleMaker_load.o $(bin)NtupleMaker_entries.o
	$(lib_echo) "static library $@"
	$(lib_silent) cd $(bin); \
	  $(ar) $(NtupleMakerlib) $?
	$(lib_silent) $(ranlib) $(NtupleMakerlib)
	$(lib_silent) cat /dev/null >$(NtupleMakerstamp)

#------------------------------------------------------------------
#  Future improvement? to empty the object files after
#  storing in the library
#
##	  for f in $?; do \
##	    rm $${f}; touch $${f}; \
##	  done
#------------------------------------------------------------------

#
# We add one level of dependency upon the true shared library 
# (rather than simply upon the stamp file)
# this is for cases where the shared library has not been built
# while the stamp was created (error??) 
#

$(NtupleMakerlibname).$(shlibsuffix) :: $(bin)MakeTree.o $(bin)NtupleMaker_load.o $(bin)NtupleMaker_entries.o $(use_requirements) $(NtupleMakerstamps)
	$(lib_echo) "shared library $@"
	$(lib_silent) $(shlibbuilder) $(shlibflags) -o $@ $(bin)MakeTree.o $(bin)NtupleMaker_load.o $(bin)NtupleMaker_entries.o $(NtupleMaker_shlibflags)
	$(lib_silent) cat /dev/null >$(NtupleMakerstamp) && \
	  cat /dev/null >$(NtupleMakershstamp)

$(NtupleMakershstamp) :: $(NtupleMakerlibname).$(shlibsuffix)
	$(lib_silent) if test -f $(NtupleMakerlibname).$(shlibsuffix) ; then \
	  cat /dev/null >$(NtupleMakerstamp) && \
	  cat /dev/null >$(NtupleMakershstamp) ; fi

NtupleMakerclean ::
	$(cleanup_echo) objects NtupleMaker
	$(cleanup_silent) /bin/rm -f $(bin)MakeTree.o $(bin)NtupleMaker_load.o $(bin)NtupleMaker_entries.o
	$(cleanup_silent) /bin/rm -f $(patsubst %.o,%.d,$(bin)MakeTree.o $(bin)NtupleMaker_load.o $(bin)NtupleMaker_entries.o) $(patsubst %.o,%.dep,$(bin)MakeTree.o $(bin)NtupleMaker_load.o $(bin)NtupleMaker_entries.o) $(patsubst %.o,%.d.stamp,$(bin)MakeTree.o $(bin)NtupleMaker_load.o $(bin)NtupleMaker_entries.o)
	$(cleanup_silent) cd $(bin); /bin/rm -rf NtupleMaker_deps NtupleMaker_dependencies.make

#-----------------------------------------------------------------
#
#  New section for automatic installation
#
#-----------------------------------------------------------------

install_dir = ${CMTINSTALLAREA}/$(tag)/lib
NtupleMakerinstallname = $(library_prefix)NtupleMaker$(library_suffix).$(shlibsuffix)

NtupleMaker :: NtupleMakerinstall ;

install :: NtupleMakerinstall ;

NtupleMakerinstall :: $(install_dir)/$(NtupleMakerinstallname)
ifdef CMTINSTALLAREA
	$(echo) "installation done"
endif

$(install_dir)/$(NtupleMakerinstallname) :: $(bin)$(NtupleMakerinstallname)
ifdef CMTINSTALLAREA
	$(install_silent) $(cmt_install_action) \
	    -source "`(cd $(bin); pwd)`" \
	    -name "$(NtupleMakerinstallname)" \
	    -out "$(install_dir)" \
	    -cmd "$(cmt_installarea_command)" \
	    -cmtpath "$($(package)_cmtpath)"
endif

##NtupleMakerclean :: NtupleMakeruninstall

uninstall :: NtupleMakeruninstall ;

NtupleMakeruninstall ::
ifdef CMTINSTALLAREA
	$(cleanup_silent) $(cmt_uninstall_action) \
	    -source "`(cd $(bin); pwd)`" \
	    -name "$(NtupleMakerinstallname)" \
	    -out "$(install_dir)" \
	    -cmtpath "$($(package)_cmtpath)"
endif

#-- end of library_no_static ------
#-- start of cpp_library -----------------

ifneq (-MMD -MP -MF $*.d -MQ $@,)

ifneq ($(MAKECMDGOALS),NtupleMakerclean)
ifneq ($(MAKECMDGOALS),uninstall)
-include $(bin)$(binobj)MakeTree.d

$(bin)$(binobj)MakeTree.d :

$(bin)$(binobj)MakeTree.o : $(cmt_final_setup_NtupleMaker)

$(bin)$(binobj)MakeTree.o : $(src)MakeTree.cxx
	$(cpp_echo) $(src)MakeTree.cxx
	$(cpp_silent) $(cppcomp) -MMD -MP -MF $*.d -MQ $@ -o $@ $(use_pp_cppflags) $(NtupleMaker_pp_cppflags) $(lib_NtupleMaker_pp_cppflags) $(MakeTree_pp_cppflags) $(use_cppflags) $(NtupleMaker_cppflags) $(lib_NtupleMaker_cppflags) $(MakeTree_cppflags) $(MakeTree_cxx_cppflags)  $(src)MakeTree.cxx
endif
endif

else
$(bin)NtupleMaker_dependencies.make : $(MakeTree_cxx_dependencies)

$(bin)NtupleMaker_dependencies.make : $(src)MakeTree.cxx

$(bin)$(binobj)MakeTree.o : $(MakeTree_cxx_dependencies)
	$(cpp_echo) $(src)MakeTree.cxx
	$(cpp_silent) $(cppcomp) -o $@ $(use_pp_cppflags) $(NtupleMaker_pp_cppflags) $(lib_NtupleMaker_pp_cppflags) $(MakeTree_pp_cppflags) $(use_cppflags) $(NtupleMaker_cppflags) $(lib_NtupleMaker_cppflags) $(MakeTree_cppflags) $(MakeTree_cxx_cppflags)  $(src)MakeTree.cxx

endif

#-- end of cpp_library ------------------
#-- start of cpp_library -----------------

ifneq (-MMD -MP -MF $*.d -MQ $@,)

ifneq ($(MAKECMDGOALS),NtupleMakerclean)
ifneq ($(MAKECMDGOALS),uninstall)
-include $(bin)$(binobj)NtupleMaker_load.d

$(bin)$(binobj)NtupleMaker_load.d :

$(bin)$(binobj)NtupleMaker_load.o : $(cmt_final_setup_NtupleMaker)

$(bin)$(binobj)NtupleMaker_load.o : $(src)components/NtupleMaker_load.cxx
	$(cpp_echo) $(src)components/NtupleMaker_load.cxx
	$(cpp_silent) $(cppcomp) -MMD -MP -MF $*.d -MQ $@ -o $@ $(use_pp_cppflags) $(NtupleMaker_pp_cppflags) $(lib_NtupleMaker_pp_cppflags) $(NtupleMaker_load_pp_cppflags) $(use_cppflags) $(NtupleMaker_cppflags) $(lib_NtupleMaker_cppflags) $(NtupleMaker_load_cppflags) $(NtupleMaker_load_cxx_cppflags) -I../src/components $(src)components/NtupleMaker_load.cxx
endif
endif

else
$(bin)NtupleMaker_dependencies.make : $(NtupleMaker_load_cxx_dependencies)

$(bin)NtupleMaker_dependencies.make : $(src)components/NtupleMaker_load.cxx

$(bin)$(binobj)NtupleMaker_load.o : $(NtupleMaker_load_cxx_dependencies)
	$(cpp_echo) $(src)components/NtupleMaker_load.cxx
	$(cpp_silent) $(cppcomp) -o $@ $(use_pp_cppflags) $(NtupleMaker_pp_cppflags) $(lib_NtupleMaker_pp_cppflags) $(NtupleMaker_load_pp_cppflags) $(use_cppflags) $(NtupleMaker_cppflags) $(lib_NtupleMaker_cppflags) $(NtupleMaker_load_cppflags) $(NtupleMaker_load_cxx_cppflags) -I../src/components $(src)components/NtupleMaker_load.cxx

endif

#-- end of cpp_library ------------------
#-- start of cpp_library -----------------

ifneq (-MMD -MP -MF $*.d -MQ $@,)

ifneq ($(MAKECMDGOALS),NtupleMakerclean)
ifneq ($(MAKECMDGOALS),uninstall)
-include $(bin)$(binobj)NtupleMaker_entries.d

$(bin)$(binobj)NtupleMaker_entries.d :

$(bin)$(binobj)NtupleMaker_entries.o : $(cmt_final_setup_NtupleMaker)

$(bin)$(binobj)NtupleMaker_entries.o : $(src)components/NtupleMaker_entries.cxx
	$(cpp_echo) $(src)components/NtupleMaker_entries.cxx
	$(cpp_silent) $(cppcomp) -MMD -MP -MF $*.d -MQ $@ -o $@ $(use_pp_cppflags) $(NtupleMaker_pp_cppflags) $(lib_NtupleMaker_pp_cppflags) $(NtupleMaker_entries_pp_cppflags) $(use_cppflags) $(NtupleMaker_cppflags) $(lib_NtupleMaker_cppflags) $(NtupleMaker_entries_cppflags) $(NtupleMaker_entries_cxx_cppflags) -I../src/components $(src)components/NtupleMaker_entries.cxx
endif
endif

else
$(bin)NtupleMaker_dependencies.make : $(NtupleMaker_entries_cxx_dependencies)

$(bin)NtupleMaker_dependencies.make : $(src)components/NtupleMaker_entries.cxx

$(bin)$(binobj)NtupleMaker_entries.o : $(NtupleMaker_entries_cxx_dependencies)
	$(cpp_echo) $(src)components/NtupleMaker_entries.cxx
	$(cpp_silent) $(cppcomp) -o $@ $(use_pp_cppflags) $(NtupleMaker_pp_cppflags) $(lib_NtupleMaker_pp_cppflags) $(NtupleMaker_entries_pp_cppflags) $(use_cppflags) $(NtupleMaker_cppflags) $(lib_NtupleMaker_cppflags) $(NtupleMaker_entries_cppflags) $(NtupleMaker_entries_cxx_cppflags) -I../src/components $(src)components/NtupleMaker_entries.cxx

endif

#-- end of cpp_library ------------------
#-- start of cleanup_header --------------

clean :: NtupleMakerclean ;
#	@cd .

ifndef PEDANTIC
.DEFAULT::
	$(echo) "(NtupleMaker.make) $@: No rule for such target" >&2
else
.DEFAULT::
	$(error PEDANTIC: $@: No rule for such target)
endif

NtupleMakerclean ::
#-- end of cleanup_header ---------------
#-- start of cleanup_library -------------
	$(cleanup_echo) library NtupleMaker
	-$(cleanup_silent) cd $(bin) && \rm -f $(library_prefix)NtupleMaker$(library_suffix).a $(library_prefix)NtupleMaker$(library_suffix).$(shlibsuffix) NtupleMaker.stamp NtupleMaker.shstamp
#-- end of cleanup_library ---------------
