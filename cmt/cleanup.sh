# echo "cleanup NtupleMaker NtupleMaker-00-00-00 in /home/paredes/ETMissFW"

if test "${CMTROOT}" = ""; then
  CMTROOT=/cvmfs/atlas.cern.ch/repo/sw/software/AthAnalysisBase/x86_64-slc6-gcc49-opt/2.4.29/CMT/v1r25p20160527; export CMTROOT
fi
. ${CMTROOT}/mgr/setup.sh
cmtNtupleMakertempfile=`${CMTROOT}/${CMTBIN}/cmt.exe -quiet build temporary_name`
if test ! $? = 0 ; then cmtNtupleMakertempfile=/tmp/cmt.$$; fi
${CMTROOT}/${CMTBIN}/cmt.exe cleanup -sh -pack=NtupleMaker -version=NtupleMaker-00-00-00 -path=/home/paredes/ETMissFW  $* >${cmtNtupleMakertempfile}
if test $? != 0 ; then
  echo >&2 "${CMTROOT}/${CMTBIN}/cmt.exe cleanup -sh -pack=NtupleMaker -version=NtupleMaker-00-00-00 -path=/home/paredes/ETMissFW  $* >${cmtNtupleMakertempfile}"
  cmtcleanupstatus=2
  /bin/rm -f ${cmtNtupleMakertempfile}
  unset cmtNtupleMakertempfile
  return $cmtcleanupstatus
fi
cmtcleanupstatus=0
. ${cmtNtupleMakertempfile}
if test $? != 0 ; then
  cmtcleanupstatus=2
fi
/bin/rm -f ${cmtNtupleMakertempfile}
unset cmtNtupleMakertempfile
return $cmtcleanupstatus

