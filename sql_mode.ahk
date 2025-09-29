#Requires AutoHotkey v2.0
#SingleInstance Force
; AutoHotkey v2 SQL Mode Script
; Converts SQL keywords to uppercase and shows a purple GUI indicator

; Initialize variables
sqlKeywords := [
    "select", "from", "where", "insert", "update", "delete", "create", "drop", "alter", 
    "table", "database", "index", "view", "join", "inner", "left", "right", "outer",
    "union", "group", "order", "by", "having", "distinct", "as", "and", "or", "not",
    "null", "is", "like", "between", "in", "exists", "case", "when", "then", "else",
    "end", "count", "sum", "avg", "max", "min", "varchar", "int", "char", "text",
    "primary", "key", "foreign", "references", "constraint", "unique", "default"
]

; Function to create the purple GUI
CreateSQLModeGUI() {
    global sqlGui
    
    ; Create GUI with purple background
    sqlGui := Gui("+AlwaysOnTop +ToolWindow -Caption", "SQL Mode Active")
    sqlGui.BackColor := "Purple"
    sqlGui.MarginX := 0
    sqlGui.MarginY := 4
    screenWidth := A_ScreenWidth
    guiWidth := 135
    guiHeight := 22
    xPos := (screenWidth - guiWidth) // 2

    ; Add status text
    statusText := sqlGui.Add("Text", "w" . guiWidth . " h20 Center c0xFFFFFF", "SQL Mode: ACTIVE")
    statusText.SetFont("s10 Bold")
    statusText.OnEvent("Click", SQLModeEnd)
    sqlGui.OnEvent("Close", SQLModeEnd)
    


    ; Show the GUI
    sqlGui.Show("x" . xPos . " y0 w" . guiWidth . " h" . guiHeight)
    
    ; Start timer to check for mouse hover
    global hoverTimer
    hoverTimer := SetTimer(CheckMouseHover, 100)  ; Check every 100ms
}

; Function to check mouse position for hover effect
CheckMouseHover() {
    global sqlGui
    static wasHovering := false
    if (!IsObject(sqlGui) || !sqlGui.Hwnd)
        return
        
    ; Check if mouse is over our GUI
    MouseGetPos(&mouseX, &mouseY, &winUnderMouse)    
    isHovering := (winUnderMouse = sqlGui.Hwnd)
    
    ; Only update if hover state changed
    if (isHovering != wasHovering) {
        OnHover(isHovering)
        wasHovering := isHovering
    }
}

; Function to handle hover effects
OnHover(isHovering) {
    global sqlGui
    if (isHovering) {
        sqlGui.BackColor := "0x9932CC"  ; DarkOrchid
    } else {
        sqlGui.BackColor := "Purple"
    }
}


; Create hotstrings for each SQL keyword
CreateHotstrings() {
    global sqlKeywords
    for keyword in sqlKeywords {
        Hotstring("::" . keyword, StrUpper(keyword), 1)
    }
}


; Function to close GUI and disable SQL mode
SQLModeEnd(*) {
    global sqlGui
    
    ; Stop the hover timer
    SetTimer(CheckMouseHover, 0)
        
    sqlGui.Destroy()
    for keyword in sqlKeywords {
        Hotstring("::" . keyword, keyword, 0)
    }
}


SQLModeStart() {
    CreateSQLModeGUI()
    CreateHotstrings()
}

; Optional: ESC key to quickly close (can be removed if not wanted)
Esc::SQLModeEnd()

; Hotkey to start SQL mode (Ctrl+Alt+S)
^!s::SQLModeStart()

; Testing - Start SQL mode on script launch
SQLModeStart()