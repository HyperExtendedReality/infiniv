@echo off
midl /winrt /metadata_dir "%WindowsSdkDir%References\10.0.26100.0\windows.foundation.foundationcontract\4.0.0.0" /h "nul" /nomidl /reference "%WindowsSdkDir%References\10.0.26100.0\Windows.Foundation.FoundationContract\4.0.0.0\Windows.Foundation.FoundationContract.winmd" /reference "%WindowsSdkDir%References\10.0.26100.0\Windows.Foundation.UniversalApiContract\19.0.0.0\Windows.Foundation.UniversalApiContract.winmd" BackdropBrush.idl

"C:\infiniv\code\build\five\packages\Microsoft.Windows.CppWinRT.2.0.250303.1\bin\cppwinrt.exe" -in BackdropBrush.winmd -c -r sdk -o .

del module.g.cpp
