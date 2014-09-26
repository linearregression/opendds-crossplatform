echo checkout/update OpenDDS source code
cd C:\trunk
svn update
call "C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\vcvarsall.bat"
set PATH=C:\Perl64\bin;%PATH%
perl configure
call setenv.cmd
echo msbuild
type nul > build_dds.log
msbuild DDS_TAOv2_all.sln /p:Configuration=Debug  > build_dds.log
copy build_dds.log c:\vagrant\build_dds.log

echo "set env vars..."
call c:\trunk\setenv
echo "change directory..."
cd %DDS_ROOT%\DevGuideExamples\DCPS\Messenger.minimal
echo "set gateway..."
REM set gateway
netsh int ip set address "Local Area Connection 3" static address=196.128.0.2 mask=255.255.255.0 gateway=196.128.0.1 gwmetric=2
REM wait a moment to let windows set gateway
timeout /t 10 > nul

del c:\vagrant\scripts\repo.log
del c:\vagrant\scripts\repo.ior
echo "run repo..."
%DDS_ROOT%\bin\DCPSInfoRepo -ORBDebugLevel 10 -DCPSDebugLevel 10  -ORBListenEndpoints iiop://"196.128.0.2:15000"
