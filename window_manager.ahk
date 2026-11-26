#Requires AutoHotkey v2.0
#SingleInstance Force

; Window helpers, inspired by Rectangle on Mac (https://rectangleapp.com/)
; Ctrl + Win + C → Center window, keeping its current size
; Ctrl + Win + = → Grow window (hold to repeat)
; Ctrl + Win + - → Shrink window (hold to repeat)

; Total pixels added to / removed from the width and height per press
resizeStep := 60

; Never shrink below this fraction of the screen
minScreenFraction := 0.25

^#c::CenterWindow(WinExist("A"))
^#=::ResizeWindow(WinExist("A"), resizeStep)
^#-::ResizeWindow(WinExist("A"), -resizeStep)

CenterWindow(hwnd) {
    ; -1 = minimized, 1 = maximized
    if !CanMove(hwnd) || WinGetMinMax(hwnd) != 0
        return

    UsePhysicalPixels()
    frame := GetVisibleFrame(hwnd)
    area := GetWorkArea(hwnd)
    MoveVisibleFrame(hwnd, {
        x: area.x + (area.w - frame.w) // 2,
        y: area.y + (area.h - frame.h) // 2,
        w: frame.w,
        h: frame.h
    })
}

; Resizes around the window's center, staying within the screen
ResizeWindow(hwnd, step) {
    if !CanMove(hwnd) || WinGetMinMax(hwnd) = -1
        return

    ; Skip windows without a resizable border (WS_SIZEBOX)
    if !(WinGetStyle(hwnd) & 0x40000)
        return

    maximized := WinGetMinMax(hwnd) = 1
    if maximized && step > 0
        return

    UsePhysicalPixels()
    area := GetWorkArea(hwnd)
    ; Shrinking a maximized window starts from the full screen size
    frame := maximized ? area : GetVisibleFrame(hwnd)
    if maximized
        WinRestore(hwnd)

    target := {
        w: NewLength(frame.w, step, area.w),
        h: NewLength(frame.h, step, area.h)
    }
    PlaceAround(target, frame, area)
    MoveVisibleFrame(hwnd, target)

    ; Apps can enforce their own min / max size - if so, re-center on the size we actually got
    actual := GetVisibleFrame(hwnd)
    if actual.w != target.w || actual.h != target.h {
        PlaceAround(actual, frame, area)
        MoveVisibleFrame(hwnd, actual)
    }
}

NewLength(length, step, areaLength) {
    if step > 0
        return Max(length, Min(length + step, areaLength))
    return Min(length, Max(length + step, Round(areaLength * minScreenFraction)))
}

; Centers rect on the old frame, then nudges it back inside the work area
PlaceAround(rect, frame, area) {
    rect.x := Max(area.x, Min(frame.x + (frame.w - rect.w) // 2, area.x + area.w - rect.w))
    rect.y := Max(area.y, Min(frame.y + (frame.h - rect.h) // 2, area.y + area.h - rect.h))
}

; Ignore the desktop and taskbar
CanMove(hwnd) {
    if !hwnd
        return false
    return !(WinGetClass(hwnd) ~= "^(Progman|WorkerW|Shell_TrayWnd|Shell_SecondaryTrayWnd)$")
}

; Keeps coordinates consistent across monitors with different scaling
UsePhysicalPixels() {
    DllCall("SetThreadDpiAwarenessContext", "Ptr", -3, "Ptr")
}

; Screen area minus the taskbar, for the monitor the window is mostly on
GetWorkArea(hwnd) {
    monitor := DllCall("MonitorFromWindow", "Ptr", hwnd, "UInt", 2, "Ptr")
    info := Buffer(40, 0)
    NumPut("UInt", 40, info)
    DllCall("GetMonitorInfo", "Ptr", monitor, "Ptr", info)
    return RectFromBuffer(info, 20)
}

; Window bounds as seen on screen. Windows 10/11 windows have invisible resize
; borders, which WinGetPos includes but this doesn't
GetVisibleFrame(hwnd) {
    rect := Buffer(16, 0)
    ; 9 = DWMWA_EXTENDED_FRAME_BOUNDS
    if DllCall("dwmapi\DwmGetWindowAttribute", "Ptr", hwnd, "UInt", 9, "Ptr", rect, "UInt", 16)
        DllCall("GetWindowRect", "Ptr", hwnd, "Ptr", rect)
    return RectFromBuffer(rect, 0)
}

RectFromBuffer(buf, offset) {
    left := NumGet(buf, offset, "Int"), top := NumGet(buf, offset + 4, "Int")
    right := NumGet(buf, offset + 8, "Int"), bottom := NumGet(buf, offset + 12, "Int")
    return { x: left, y: top, w: right - left, h: bottom - top }
}

; Moves the window so that its visible frame matches rect
MoveVisibleFrame(hwnd, rect) {
    WinGetPos(&x, &y, &w, &h, hwnd)
    frame := GetVisibleFrame(hwnd)
    ; Windows running as admin can't be moved by a non-admin script
    try WinMove(rect.x + x - frame.x, rect.y + y - frame.y, rect.w + w - frame.w, rect.h + h - frame.h, hwnd)
}
