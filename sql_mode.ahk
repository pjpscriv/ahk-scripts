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
    "primary", "key", "foreign", "references", "constraint", "unique", "default",

    ; More BigQuery-specific keywords
    "with", "bigquery", "bq", "partition", "clustering", "dataset", "project", "schema", "routine",
    "procedure", "function", "materialized", "snapshot", "external", "dataflow", "ml",
    "analytics", "geography", "json", "xml", "array", "struct", "timestamp", "datetime",
    "time", "date", "float64", "int64", "numeric", "bignumeric", "bool", "bytes", "safe_cast",
    "cast", "extract", "format", "parse", "current_date", "current_time", "current_timestamp",
    "session_user", "system_user", "user"
]

; Function to create the purple GUI
CreateSQLModeGUI() {
    global sqlGui, hoverTimer
    
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
    
    ; Start hover timer
    hoverTimer := SetTimer(CheckMouseHover, 100)  ; Check every 100ms
}

; Check if mouse hovering the GUI
CheckMouseHover() {
    global sqlGui
    static wasHovering := false
    if (!IsObject(sqlGui) || !sqlGui.Hwnd)
        return
    MouseGetPos(&mouseX, &mouseY, &winUnderMouse)    
    isHovering := (winUnderMouse = sqlGui.Hwnd)
    if (isHovering != wasHovering) {
        OnHover(isHovering)
        wasHovering := isHovering
    }
}

; Perform GUI hover effect
OnHover(isHovering) {
    global sqlGui
    if (isHovering) {
        sqlGui.BackColor := "0x9932CC"  ; DarkOrchid
    } else {
        sqlGui.BackColor := "Purple"
    }
}

; Actually perform string uppercasing
CreateHotstrings() {
    global sqlKeywords
    for keyword in sqlKeywords {
        Hotstring("::" . keyword, StrUpper(keyword), 1)
    }
}

SQLModeEnd(*) {
    global sqlGui
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


Esc::SQLModeEnd()   ; ESC key to end
^!s::SQLModeStart() ; Ctrl + Alt + S to start
SQLModeStart()      ; Start on script launch too
