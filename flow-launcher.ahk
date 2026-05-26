#Requires AutoHotkey v2.0
#SingleInstance Force

; Map Alt+Space to LWin (e.g. to trigger Flow Launcher)
; Not entirely sure why the space is needed - but it doesn't seem to work without it 🤔  
!Space::Send " {LWin}"
 