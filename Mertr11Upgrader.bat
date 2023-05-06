@echo off
>nul 2>nul "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' ( goto UACPrompt ) else ( goto gotAdmin )
:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "%~s0","","","runas",1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
exit /B
:gotAdmin
setlocal EnableExtensions EnableDelayedExpansion
:pre
cls
cd /d %~dp0
attrib -s -h -r %cd%
FOR /F "tokens=2 delims==" %%a IN ('wmic os get OSLanguage /Value') DO set lg=%%a
if %lg% equ 2052 (title Mertr 11系统升级器) else (title Mertr 11 System Upgrader)
if %lg% equ 2052 (echo Mertr 11 & echo 系统升级器) else (echo Mertr 11 & echo  System Upgrader)
echo By Xbodw.
set "mountp="
echo=
echo 是否现在开始精简当前系统? 1.精简 2.稍后考虑
set /p fu=
if '%fu%' neq '1' goto ex
echo=
dism /Online /Cleanup-Image /StartComponentCleanup
dism /Online /Cleanup-Image /StartComponentCleanup /ResetBase
echo "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender"[7] > regi.ini
echo "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SecurityHealthService"[7] >> regi.ini
regini regi.ini
de /f /q regi.ini
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SecurityHealthService" /v Start -t REG_DWORD /d 4 /f >nul  2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /d 1 /t REG_DWORD /f
Reg add "HKLM\SYSTEM\Setup\LabConfig" /v "BypassCPUCheck" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\Setup\LabConfig" /v "BypassRAMCheck" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\Setup\LabConfig" /v "BypassSecureBootCheck" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\Setup\LabConfig" /v "BypassStorageCheck" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\Setup\LabConfig" /v "BypassTPMCheck" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\SYSTEM\Setup\MoSetup" /v "AllowUpgradesWithUnsupportedTPMOrCPU" /t REG_DWORD /d "1" /f >nul 2>&1
echo 正在卸载程序包...
echo  以下显示出名字的则为未被卸载的程序包
for /f "tokens=2 delims=:| " %%s in ('dism /Online /Get-ProvisionedAppxPackages^|Find /i "_"') do (
  echo %%s|Find /i "Microsoft.WindowsStore" && echo off || (
   echo %%s|Find /i "Microsoft.DesktopAppInstaller" && echo off || dism /Online /Remove-ProvisionedAppxPackage /PackageName:%%s   >nul  2>nul
  )
copy /y WallPaper.jpg %Windir%\Web\4K\WallPaper\Windows\img0_1920x1200.jpg
copy /y WallPaper.jpg %Windir%\Web\WallPaper\Windows\img0.jpg
echo=
echo 系统修改完成.
shitdown /r -t 00
:ex
pause>nul
