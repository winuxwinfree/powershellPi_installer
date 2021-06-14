#!/bin/bash
#Powershell installer V1 for Debian PI
#Script made by androrama fenixlinux.com
#License GPLV3. 
###################################
#Uninstall the program
PSDIR=$HOME/powershell
if [ -d "$PSDIR" ]; then
 if zenity --question --title="Uninstall powershell" --text="Powershell is installed, do you want to uninstall it?"
    then
	   rm -rf ~/powershell
       echo "Process completed."
    exit 1
 fi
  exit 1
fi
###################################
#About: 
 tfile=`mktemp`
   echo "
-Powershell installer V1 for Debian PI fenixlinux.com
-About:\n PowerShell is a task automation and configuration management framework, consisting of a command-line shell and the associated scripting language.\n -You can uninstall it by running this script again."> "$tfile"
if zenity --text-info --title="About this program" --filename="$tfile" 
	then
rm -f "$tfile"
###################################
echo "Installing prerequisites"
echo "Update package lists"
sudo apt-get update
echo "Install libunwind8 and libssl1.0"
echo "Regex is used to ensure that we do not install libssl1.0-dev, as it is a variant that is not required"
sudo apt-get install '^libssl1.0.[0-9]$' libunwind8 -y
###################################
echo "Download and extract PowerShell"
VER=7.1.3
echo "Grab the latest tar.gz"
    if zenity --question --title="choose a version" --text="You are going to download the version ${VER}, do you want to download another one?" --no-wrap
       then
       Answer=$(zenity --entry --text "Download version: "); echo New verson code = $Answer
       VER=$Answer
       echo "Download version=${VER}, ok."    
    fi
rm -rf powershell-*-linux-arm32.tar.gz
wget https://github.com/PowerShell/PowerShell/releases/download/v${VER}/powershell-${VER}-linux-arm32.tar.gz 
PSFILE=./powershell-${VER}-linux-arm32.tar.gz 
if [ -f "$PSFILE" ]; then
echo "Make folder to put powershell"
mkdir ~/powershell
echo "Unpack the tar.gz file"
tar -xvf ./powershell-${VER}-linux-arm32.tar.gz -C ~/powershell
###################################
if zenity --question --width=400 --title="Run the program." --text="Do you want to run this program? Type exit to close."
   then
echo "Start PowerShell"
~/powershell/pwsh
fi
###################################
#Symbolic link
echo "Start PowerShell from bash with sudo to create a symbolic link"
if zenity --question --title="create a symbolic link" --text="Do you want to create a symbolic link?"
    then
        sudo ~/powershell/pwsh -c New-Item -ItemType SymbolicLink -Path "/usr/bin/pwsh" -Target "$PSHOME/pwsh" -Force
fi
	echo "Alternatively you can run following to create a symbolic link:"
	echo "sudo ln -s ~/powershell/pwsh /usr/bin/pwsh2"
	echo "Now to start PowerShell you can just run pwsh"
#Paths
   tfile=`mktemp`
   echo "
-PSHOME is /opt/microsoft/powershell/7/
-User profiles are read from ~/.config/powershell/profile.ps1
-Default profiles are read from $PSHOME/profile.ps1
-User modules are read from ~/.local/share/powershell/Modules
-Shared modules are read from /usr/local/share/powershell/Modules
-Default modules are read from $PSHOME/Modules
-PSReadLine history is recorded to ~/.local/share/powershell/PSReadLine/ConsoleHost_history.txt
-The profiles respect PowerShell's per-host configuration, so the default host-specific profiles exists at Microsoft.PowerShell_profile.ps1 in the same locations."> "$tfile"
zenity --text-info --title="About Paths" --filename="$tfile"
rm -f "$tfile"
else 
echo "ERROR, FILE NOT FOUND!"
fi
#Support
   if zenity --info  --width=400 \
   --text="That's all, don't forget to support the developers of these amazing applications if you like them."
      then
   xdg-open 'https://github.com/powershell/powershell' &>/dev/null
   xdg-open 'https://fenixlinux.com/pdownload' &>/dev/null
   fi
fi
exit 1
