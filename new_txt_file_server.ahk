; https://superuser.com/a/1880043/1268619
#Requires AutoHotkey v2.0
#SingleInstance Force

; Item in list polyfill, what is this language
IsItemInList(item, list, del:=",") {
    haystack:=del
    if !IsObject(list)
        haystack.= list del
    else
        for k,v in list
            haystack.= v del    
    Return !!InStr(del haystack del, del item del)
}

; Ctrl + Alt + N
; $ → Prevents hotkey from triggering itself
$^!n:: {

    ; Get active window
    activeWin := WinActive("A")
    activeClass := WinGetClass(activeWin)
    
    ; If active window isn't File Explorer - exit
    explorerClasses := ["CabinetWClass", "ExploreWClass"]
    if !IsItemInList(activeClass, explorerClasses) {
        Send "^!n"
        return
    }

    Sleep 100
    
    ; Move the mouse to the left side of the window
    WinGetPos(&winX, &winY, &winWidth, &winHeight)    
    MouseMove (winWidth - 35), (winHeight // 2)

    ; Left click to clear any selection
    Send "{LButton}"

    ; Shift + right click - Old Context Menu
    Send "+{RButton}"
    Sleep 10
    
    ; Twice press W - "New"
    Send "w"
    Sleep 10
    Send "w"
    Sleep 10
    
    Send "{Enter}"
    Sleep 10
    
    ; Press T - "Text Document"
    Send "t"
}
