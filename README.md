# Peter's AutoHotkey Scripts

Repo for little helper macros on Windows using [AutoHotkey](https://www.autohotkey.com/).

Helpful links

- [AHK Symbol Cheatsheet](https://www.autohotkey.com/docs/v2/Hotkeys.htm#Symbols)
- [How to Send Keystrokes](https://www.autohotkey.com/docs/v2/howto/SendKeys.htm)
- [Hotstrings](https://www.autohotkey.com/docs/v2/Hotstrings.htm)

### Windows Run on Startup

Something I've found useful is configuring a few scripts to be run on startup, so their functionality is simply available by default on the machine I'm using.

To do this for Windows, find your **Startup directory**, it is likely something like 

```
C:\Users\<USERNAME>\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
```

Then create a batch file e.g. `ahk_scripts.bat` in this folder, with content something like this:

```batch
@echo off
echo Running autohotkey scripts on startup

powerShell "C:\<PATH_TO_AHK_SCRIPTS>\ahk-scripts\extra_glyphs.ahk"
powerShell "C:\<PATH_TO_AHK_SCRIPTS>\ahk-scripts\new_txt_file_laptop.ahk"

echo Done!
timeout /T 4
exit
```
