; AutoHotkey v2 Command Palette with Native GUI
; Press Alt+x (M-x style) to open command palette

#Requires AutoHotkey v2.0

; ============================================================================
; Global Variables
; ============================================================================
global CommandPaletteGui := ""
global SearchBox := ""
global CommandList := ""
global AllCommands := []
global FilteredCommands := []

; ============================================================================
; Main Hotkey: Alt+x (M-x)
; ============================================================================
!x:: {
    ShowCommandPalette()
}

; ============================================================================
; Command Palette GUI System
; ============================================================================
ShowCommandPalette() {
    global CommandPaletteGui, SearchBox, CommandList, AllCommands, FilteredCommands

    ; Get all available commands
    AllCommands := GetCommandList()
    FilteredCommands := AllCommands.Clone()

    ; Create GUI if it doesn't exist
    if (!IsObject(CommandPaletteGui)) {
        CommandPaletteGui := Gui("+AlwaysOnTop -Caption +Border", "M-x")
        CommandPaletteGui.BackColor := "0x282828"
        CommandPaletteGui.SetFont("s10", "Consolas")

        ; Add prompt text
        promptText := CommandPaletteGui.Add("Text", "x10 y10 w580 cWhite", "M-x:")

        ; Add search box
        SearchBox := CommandPaletteGui.Add("Edit", "x10 y35 w580 h25 Background0x3C3836 cWhite")
        SearchBox.OnEvent("Change", FilterCommands)

        ; Add command list
        CommandList := CommandPaletteGui.Add("ListBox", "x10 y70 w580 h400 Background0x3C3836 cWhite Choose1")
        CommandList.OnEvent("DoubleClick", ExecuteSelectedCommand)

        ; Set up key handlers
        SearchBox.OnEvent("KeyDown", HandleKeyDown)

        ; Set up GUI close handler
        CommandPaletteGui.OnEvent("Escape", CloseCommandPalette)
        CommandPaletteGui.OnEvent("Close", CloseCommandPalette)
    }

    ; Reset and populate the list
    SearchBox.Value := ""
    UpdateCommandList()

    ; Show GUI centered on screen
    CommandPaletteGui.Show("w600 h480 Center")
    SearchBox.Focus()
}

; ============================================================================
; Filter Commands based on search input
; ============================================================================
FilterCommands(*) {
    global SearchBox, AllCommands, FilteredCommands

    searchText := SearchBox.Value
    FilteredCommands := []

    if (searchText = "") {
        FilteredCommands := AllCommands.Clone()
    } else {
        ; Fuzzy matching: check if all characters in search text appear in order
        for cmd in AllCommands {
            if (FuzzyMatch(cmd, searchText)) {
                FilteredCommands.Push(cmd)
            }
        }
    }

    UpdateCommandList()
}

; ============================================================================
; Fuzzy Match Algorithm
; ============================================================================
FuzzyMatch(str, pattern) {
    str := StrLower(str)
    pattern := StrLower(pattern)

    patternIdx := 1
    patternLen := StrLen(pattern)

    Loop Parse, str {
        if (patternIdx > patternLen) {
            return true
        }
        if (A_LoopField = SubStr(pattern, patternIdx, 1)) {
            patternIdx++
        }
    }

    return patternIdx > patternLen
}

; ============================================================================
; Update Command List Display
; ============================================================================
UpdateCommandList() {
    global CommandList, FilteredCommands

    ; Clear the list
    CommandList.Delete()

    ; Add filtered commands
    if (FilteredCommands.Length > 0) {
        for cmd in FilteredCommands {
            CommandList.Add([cmd])
        }
        CommandList.Choose(1)
    } else {
        CommandList.Add(["No matches found"])
    }
}

; ============================================================================
; Handle Keyboard Navigation
; ============================================================================
HandleKeyDown(ctrl, key, *) {
    global CommandList, FilteredCommands

    ; Enter key - execute command
    if (key = 13) { ; Enter
        ExecuteSelectedCommand()
        return
    }

    ; Escape key - close palette
    if (key = 27) { ; Escape
        CloseCommandPalette()
        return
    }

    ; Arrow Down - move selection down
    if (key = 40) { ; Down arrow
        currentChoice := CommandList.Value
        if (currentChoice < FilteredCommands.Length) {
            CommandList.Choose(currentChoice + 1)
        }
        return
    }

    ; Arrow Up - move selection up
    if (key = 38) { ; Up arrow
        currentChoice := CommandList.Value
        if (currentChoice > 1) {
            CommandList.Choose(currentChoice - 1)
        }
        return
    }

    ; Ctrl+N - next item (Emacs-style)
    if (key = 78 && GetKeyState("Ctrl")) { ; Ctrl+N
        currentChoice := CommandList.Value
        if (currentChoice < FilteredCommands.Length) {
            CommandList.Choose(currentChoice + 1)
        }
        return
    }

    ; Ctrl+P - previous item (Emacs-style)
    if (key = 80 && GetKeyState("Ctrl")) { ; Ctrl+P
        currentChoice := CommandList.Value
        if (currentChoice > 1) {
            CommandList.Choose(currentChoice - 1)
        }
        return
    }
}

; ============================================================================
; Execute Selected Command
; ============================================================================
ExecuteSelectedCommand(*) {
    global CommandList, FilteredCommands, CommandPaletteGui

    if (FilteredCommands.Length = 0) {
        return
    }

    selectedIdx := CommandList.Value
    if (selectedIdx > 0 && selectedIdx <= FilteredCommands.Length) {
        selectedCmd := FilteredCommands[selectedIdx]
        CommandPaletteGui.Hide()
        ExecuteCommand(selectedCmd)
    }
}

; ============================================================================
; Close Command Palette
; ============================================================================
CloseCommandPalette(*) {
    global CommandPaletteGui
    CommandPaletteGui.Hide()
}

; ============================================================================
; Command List Definition
; ============================================================================
GetCommandList() {
    return [
        "reload-autohotkey",
        "suspend-autohotkey",
        "resume-autohotkey",
        "exit-autohotkey",
        "launch-notepad",
        "launch-calculator",
        "launch-browser",
        "launch-terminal",
        "move-window-left",
        "move-window-right",
        "move-window-center",
        "resize-window-half",
        "resize-window-full",
        "tile-windows-left-right",
        "maximize-window",
        "minimize-window",
        "close-window",
        "pin-window-topmost",
        "unpin-window-topmost"
    ]
}

; ============================================================================
; Command Execution Router
; ============================================================================
ExecuteCommand(cmdName) {
    switch cmdName {
        ; AutoHotkey Control
        case "reload-autohotkey":
            ReloadAutoHotkey()
        case "suspend-autohotkey":
            SuspendAutoHotkey()
        case "resume-autohotkey":
            ResumeAutoHotkey()
        case "exit-autohotkey":
            ExitAutoHotkey()

        ; Application Launchers
        case "launch-notepad":
            LaunchNotepad()
        case "launch-calculator":
            LaunchCalculator()
        case "launch-browser":
            LaunchBrowser()
        case "launch-terminal":
            LaunchTerminal()

        ; Window Movement
        case "move-window-left":
            MoveWindowLeft()
        case "move-window-right":
            MoveWindowRight()
        case "move-window-center":
            MoveWindowCenter()

        ; Window Resizing
        case "resize-window-half":
            ResizeWindowHalf()
        case "resize-window-full":
            ResizeWindowFull()

        ; Window Management
        case "tile-windows-left-right":
            TileWindowsLeftRight()
        case "maximize-window":
            MaximizeWindow()
        case "minimize-window":
            MinimizeWindow()
        case "close-window":
            CloseWindow()
        case "pin-window-topmost":
            PinWindowTopmost()
        case "unpin-window-topmost":
            UnpinWindowTopmost()

        default:
            MsgBox("Unknown command: " cmdName)
    }
}

; ============================================================================
; AutoHotkey Control Functions
; ============================================================================
ReloadAutoHotkey() {
    Reload()
}

SuspendAutoHotkey() {
    Suspend(1)
    TrayTip("AutoHotkey Suspended", "Hotkeys are now suspended")
}

ResumeAutoHotkey() {
    Suspend(0)
    TrayTip("AutoHotkey Resumed", "Hotkeys are now active")
}

ExitAutoHotkey() {
    result := MsgBox("Are you sure you want to exit AutoHotkey?", "Confirm Exit", "YesNo")
    if (result = "Yes") {
        ExitApp()
    }
}

; ============================================================================
; Application Launcher Functions
; ============================================================================
LaunchNotepad() {
    Run("notepad.exe")
}

LaunchCalculator() {
    Run("calc.exe")
}

LaunchBrowser() {
    Run("https://www.google.com")
}

LaunchTerminal() {
    ; Try to launch Windows Terminal, fallback to cmd
    try {
        Run("wt.exe")
    } catch {
        Run("cmd.exe")
    }
}

; ============================================================================
; Window Movement Functions
; ============================================================================
MoveWindowLeft() {
    if hwnd := WinExist("A") {
        MonitorGetWorkArea(, &left, &top, &right, &bottom)
        width := (right - left) // 2
        height := bottom - top
        WinMove(left, top, width, height, hwnd)
    }
}

MoveWindowRight() {
    if hwnd := WinExist("A") {
        MonitorGetWorkArea(, &left, &top, &right, &bottom)
        width := (right - left) // 2
        height := bottom - top
        WinMove(left + width, top, width, height, hwnd)
    }
}

MoveWindowCenter() {
    if hwnd := WinExist("A") {
        WinGetPos(&x, &y, &w, &h, hwnd)
        MonitorGetWorkArea(, &left, &top, &right, &bottom)
        centerX := left + ((right - left - w) // 2)
        centerY := top + ((bottom - top - h) // 2)
        WinMove(centerX, centerY, , , hwnd)
    }
}

; ============================================================================
; Window Resizing Functions
; ============================================================================
ResizeWindowHalf() {
    if hwnd := WinExist("A") {
        MonitorGetWorkArea(, &left, &top, &right, &bottom)
        width := (right - left) // 2
        height := bottom - top
        WinMove(, , width, height, hwnd)
    }
}

ResizeWindowFull() {
    if hwnd := WinExist("A") {
        MonitorGetWorkArea(, &left, &top, &right, &bottom)
        width := right - left
        height := bottom - top
        WinMove(left, top, width, height, hwnd)
    }
}

; ============================================================================
; Window Management Functions
; ============================================================================
TileWindowsLeftRight() {
    ; Get all visible windows (excluding system windows)
    windows := []
    for hwnd in WinGetList() {
        if (WinGetTitle(hwnd) != "" && IsWindowVisible(hwnd)) {
            windows.Push(hwnd)
        }
    }

    if (windows.Length < 2) {
        MsgBox("Need at least 2 windows to tile")
        return
    }

    ; Take first 2 windows and tile them
    MonitorGetWorkArea(, &left, &top, &right, &bottom)
    width := (right - left) // 2
    height := bottom - top

    WinMove(left, top, width, height, windows[1])
    WinMove(left + width, top, width, height, windows[2])
}

MaximizeWindow() {
    if hwnd := WinExist("A") {
        WinMaximize(hwnd)
    }
}

MinimizeWindow() {
    if hwnd := WinExist("A") {
        WinMinimize(hwnd)
    }
}

CloseWindow() {
    if hwnd := WinExist("A") {
        WinClose(hwnd)
    }
}

PinWindowTopmost() {
    if hwnd := WinExist("A") {
        WinSetAlwaysOnTop(1, hwnd)
        TrayTip("Window Pinned", "Window is now always on top")
    }
}

UnpinWindowTopmost() {
    if hwnd := WinExist("A") {
        WinSetAlwaysOnTop(0, hwnd)
        TrayTip("Window Unpinned", "Window is no longer always on top")
    }
}

; ============================================================================
; Helper Functions
; ============================================================================
IsWindowVisible(hwnd) {
    return DllCall("IsWindowVisible", "Ptr", hwnd)
}
