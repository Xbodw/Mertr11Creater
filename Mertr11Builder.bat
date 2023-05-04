@echo off
setlocal EnableExtensions EnableDelayedExpansion
FOR /F "tokens=2 delims==" %%a IN ('wmic os get OSLanguage /Value') DO set lg=%%a
if '%1' equ '/?' (
  echo Mertr11Builder
  echo 系统精简镜像制作器 1.8
  echo 用法:
  echo Mertr11Builder [/Imgpath]
  echo   /ImgPath  Windows镜像的位置
  exit /b
)
:pre
if '%1' equ '/Imgpath' ( echo Mertr11Builder找不到指定的路径 & exit /b )
cls
attrib -s -h -r %cd%
cd /d %~dp0
if %lg% equ 2052 (title Mertr 11系统精简镜像制作器) else (title Mertr 11 System streamlining Image Marker)
if %lg% equ 2052 (echo Mertr 11 & echo 系统精简镜像制作器) else (echo Mertr 11 & echo  System streamlining Image Marker)
echo By Xbodw.
set "mountp="
set "iso=%cd%\Mertr11.iso"
:iso
cls
if %lg% equ 2052 (title Mertr 11系统精简镜像制作器) else (title Mertr 11 System streamlining Image Marker)
if %lg% equ 2052 (echo Mertr 11 & echo 系统精简镜像制作器) else (echo Mertr 11 & echo  System streamlining Image Marker)
if %lg% equ 2052 (set /p mountp=请输入ISO挂载盘符:) else (set /p mountp=Press the ISO Mount Drive:)
if not exist %mountp% (
  if %lg% equ 2052 (
    start /wait "" "mshta.exe" vbscript:CreateObject("Wscript.Shell"^).popup("无效的Windows镜像驱动器或文件夹: %mountp%",7,"Mertr 11系统精简镜像制作器",48^)(window.close^) 
    goto pre
  ) else (
    start /wait "" "mshta.exe" vbscript:CreateObject("Wscript.Shell"^).popup("Invaild a Drive of The WindowsImage or Dirctory: %mountp%",7,"Mertr 11 System streamlining Image Marker",48^)(window.close^) 
    goto pre
  )
)
if not exist %mountp%\sources\boot.wim (
  if %lg% equ 2052 (
    start /wait "" "mshta.exe" vbscript:CreateObject("Wscript.Shell"^).popup("无效的Windows镜像驱动器或文件夹: %mountp%,在%mountp%\sources中找不到boot.wim",7,"Mertr 11系统精简镜像制作器",48^)(window.close^) 
    goto pre
  ) else (
    start /wait "" "mshta.exe" vbscript:CreateObject("Wscript.Shell"^).popup("Invaild a Drive of The WindowsImage or Dirctory: %mountp%,Not Found boot.wim in %mountp%\sources",7,"Mertr 11 System streamlining Image Marker",48^)(window.close^) 
    goto pre
  )
)
if not exist %mountp%\sources\install.wim (
  if %lg% equ 2052 (
    start /wait "" "mshta.exe" vbscript:CreateObject("Wscript.Shell"^).popup("无效的Windows镜像驱动器或文件夹: %mountp%,在%mountp%\sources中找不到install.wim,请不要使用esd镜像",7,"Mertr 11系统精简镜像制作器",48^)(window.close^) 
    goto pre
  ) else (
    start /wait "" "mshta.exe" vbscript:CreateObject("Wscript.Shell"^).popup("Invaild a Drive of The WindowsImage or Dirctory: %mountp%,Not Found install.wim in %mountp%\sources,Please not use the esd Image",7,"Mertr 11 System streamlining Image Marker",48^)(window.close^) 
    goto pre
  )
)
:go
if not exist MakeDir md MakeDir
if not exist Moud md Moud
xcopy /s /i /e /y /o "%mountp%" MakeDir
cls
dism /Mount-Wim /WimFile:MakeDir\sources\boot.wim /index:2 /MountDir:Moud
copy /y autounattend.xml Moud\sources\autounattend.xml
Reg load HKLM\tSYSTEM "Moud\Windows\System32\config\System" >nul
Reg add "HKLM\tSYSTEM\Setup\LabConfig" /v "BypassCPUCheck" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\tSYSTEM\Setup\LabConfig" /v "BypassRAMCheck" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\tSYSTEM\Setup\LabConfig" /v "BypassSecureBootCheck" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\tSYSTEM\Setup\LabConfig" /v "BypassStorageCheck" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\tSYSTEM\Setup\LabConfig" /v "BypassTPMCheck" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\tSYSTEM\Setup\MoSetup" /v "AllowUpgradesWithUnsupportedTPMOrCPU" /t REG_DWORD /d "1" /f >nul 2>&1
reg unload HKLM\tSYSTEM >nul
dism /Unmount-Wim /MountDir:Moud /commit
cls
if %lg% equ 2052 (title Mertr 11系统精简镜像制作器) else (title Mertr 11 System streamlining Image Marker)
if %lg% equ 2052 (echo Mertr 11 & echo 系统精简镜像制作器) else (echo Mertr 11 & echo  System streamlining Image Marker)
echo By Xbodw.
dism /Get-WimInfo /WimFile:MakeDir\sources\install.wim
set "index=1"
if %lg% equ 2052 (set /p index=请输入镜像索引:) else (set /p index=Press The Image Index:)
cls
if %lg% equ 2052 (title Mertr 11系统精简镜像制作器) else (title Mertr 11 System streamlining Image Marker)
if %lg% equ 2052 (echo Mertr 11 & echo 系统精简镜像制作器) else (echo Mertr 11 & echo  System streamlining Image Marker)
echo By Xbodw.
dism /Mount-Wim /WimFile:MakeDir\sources\install.wim /index:%index% /MountDir:Moud
if %lg% equ 2052 (echo 正在卸载程序包与修改注册表,可能需要一些时间... ) else (echo Removeing Packages and Change Registry,We're GonNa take some time...)
if %lg% equ 2052 (echo 以下是未被删除的系统程序包: ) else (echo The following packages have not been deleted:)
for /f "tokens=2 delims=:| " %%s in ('dism /Image:Moud /Get-ProvisionedAppxPackages^|Find /i "_"') do (
  echo %%s|Find /i "Microsoft.WindowsStore" && echo off || (
   echo %%s|Find /i "Microsoft.DesktopAppInstaller" && echo off || dism /Image:Moud /Remove-ProvisionedAppxPackage /PackageName:%%s   >nul  2>nul
  )
)
cls
dism /Image:Moud /Cleanup-Image /StartComponentCleanup
dism /Image:Moud /Cleanup-Image /StartComponentCleanup /ResetBase
dism /Image:Moud /Apply-Unattend:autounattend.xml
::rd "Moud\Program Files (x86)\Microsoft\Edge\" /s /q
::rd "Moud\Program Files (x86)\Microsoft\EdgeUpdate" /s /q
Reg load HKLM\tSYSTEM "Moud\Windows\System32\config\System" >nul
Reg load HKLM\tSOFTWARE "Moud\Windows\System32\config\Software" >nul
echo "HKEY_LOCAL_MACHINE\tSOFTWARE\Policies\Microsoft\Windows Defender"[7] > regi.ini
echo "HKEY_LOCAL_MACHINE\tSYSTEM\CurrentControlSet\Services\SecurityHealthService"[7] >> regi.ini
regini regi.ini
de /f /q regi.ini
reg add "HKLM\tSYSTEM\CurrentControlSet\Services\SecurityHealthService" /v Start -t REG_DWORD /d 4 /f >nul  2>nul
reg add "HKLM\tSOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /d 1 /t REG_DWORD /f
Reg add "HKLM\tSYSTEM\Setup\LabConfig" /v "BypassCPUCheck" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\tSYSTEM\Setup\LabConfig" /v "BypassRAMCheck" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\tSYSTEM\Setup\LabConfig" /v "BypassSecureBootCheck" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\tSYSTEM\Setup\LabConfig" /v "BypassStorageCheck" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\tSYSTEM\Setup\LabConfig" /v "BypassTPMCheck" /t REG_DWORD /d "1" /f >nul 2>&1
Reg add "HKLM\tSYSTEM\Setup\MoSetup" /v "AllowUpgradesWithUnsupportedTPMOrCPU" /t REG_DWORD /d "1" /f >nul 2>&1
reg unload HKLM\tSYSTEM >nul
reg unload HKLM\tSOFTWARE >nul
cls
if %lg% equ 2052 (title Mertr 11系统精简镜像制作器) else (title Mertr 11 System streamlining Image Marker)
if %lg% equ 2052 (echo Mertr 11 & echo 系统精简镜像制作器) else (echo Mertr 11 & echo  System streamlining Image Marker)
echo By Xbodw.
dism /UnMount-Wim /MountDir:Moud /commit
dism /Export-Image /SourceImageFile:MakeDir\sources\install.wim /SourceIndex:%index% /DestinationImageFile:MakeDir\sources\install-new.wim
del /f /q MakeDir\sources\install.wim
ren MakeDir\sources\install-new.wim install.wim
rd /s /q Moud
copy /y autounattend.xml MakeDir\sources\autounattend.xml
if exist MakeDir\sources\appraiserres.dll del /f /q MakeDir\sources\appraiserres.dll
isomk.exe -m -o -u2 -udfver102 -bootdata:2#p0,e,bMakeDir\boot\etfsboot.com#pEF,e,bMakeDir\efi\microsoft\boot\efisys.bin -l"Mertr11_X64FRE_Media" MakeDir "%isof%"
rd /s /q MakeDir
cls
if %lg% equ 2052 (title Mertr 11系统精简镜像制作器) else (title Mertr 11 System streamlining Image Marker)
if %lg% equ 2052 (echo Mertr 11 & echo 系统精简镜像制作器) else (echo Mertr 11 & echo  System streamlining Image Marker)
if %lg% equ 2052 (echo 完成) else (echo Complate.)
pause>nul
