# echo "setup NtupleMaker NtupleMaker-00-00-00 in /home/paredes/ETMissFW"

if ( $?CMTROOT == 0 ) then
  setenv CMTROOT /cvmfs/atlas.cern.ch/repo/sw/software/AthAnalysisBase/x86_64-slc6-gcc49-opt/2.4.29/CMT/v1r25p20160527
endif
source ${CMTROOT}/mgr/setup.csh
set cmtNtupleMakertempfile=`${CMTROOT}/${CMTBIN}/cmt.exe -quiet build temporary_name`
if $status != 0 then
  set cmtNtupleMakertempfile=/tmp/cmt.$$
endif
${CMTROOT}/${CMTBIN}/cmt.exe setup -csh -pack=NtupleMaker -version=NtupleMaker-00-00-00 -path=/home/paredes/ETMissFW  -no_cleanup $* >${cmtNtupleMakertempfile}
if ( $status != 0 ) then
  echo "${CMTROOT}/${CMTBIN}/cmt.exe setup -csh -pack=NtupleMaker -version=NtupleMaker-00-00-00 -path=/home/paredes/ETMissFW  -no_cleanup $* >${cmtNtupleMakertempfile}"
  set cmtsetupstatus=2
  /bin/rm -f ${cmtNtupleMakertempfile}
  unset cmtNtupleMakertempfile
  exit $cmtsetupstatus
endif
set cmtsetupstatus=0
source ${cmtNtupleMakertempfile}
if ( $status != 0 ) then
  set cmtsetupstatus=2
endif
/bin/rm -f ${cmtNtupleMakertempfile}
unset cmtNtupleMakertempfile
exit $cmtsetupstatus

