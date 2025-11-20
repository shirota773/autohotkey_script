; AutoHotkey v2 Command Palette with fzf
; Press Alt+x (M-x style) to open command palette

#Requires AutoHotkey v2.0

; ============================================================================
; Global Variables
; ============================================================================
global FzfPath := "fzf.exe"  ; Adjust path if needed
global TempCommandFile := A_Temp "\ahk_commands.txt"
global TempResultFile := A_Temp "\ahk_result.txt"

; ============================================================================
; Main Hotkey: Alt+x (M-x)
; ============================================================================
!x:: {
    ShowCommandPalette()
}

; ============================================================================
; Command Palette System
; ============================================================================
ShowCommandPalette() {
    ; Create command list
    commands := GetCommandList()

    ; Write commands to temp file
    try {
        FileDelete(TempCommandFile)
    }
    FileAppend(commands, TempCommandFile)

    ; Delete old result file
    try {
        FileDelete(TempResultFile)
    }

    ; Build fzf command
    fzfCmd := Format('powershell -Command "Get-Content ''{}'' | fzf --prompt=''M-x: '' --height=40% --reverse --border | Out-File -Encoding UTF8 ''{}''"',
                     TempCommandFile, TempResultFile)

    ; Run fzf and wait for result
    RunWait(fzfCmd, , "Hide")

    ; Read selected command
    if FileExist(TempResultFile) {
        selectedCmd := FileRead(TempResultFile)
        selectedCmd := Trim(selectedCmd, " `t`r`n")

        if (selectedCmd != "") {
            ExecuteCommand(selectedCmd)
        }
    }

    ; Cleanup
    try {
        FileDelete(TempCommandFile)
        FileDelete(TempResultFile)
    }
}

; ============================================================================
; Command List Definition
; ============================================================================
GetCommandList() {
    commands := "
    (
    reload-autohotkey
    suspend-autohotkey
    resume-autohotkey
    exit-autohotkey
    launch-notepad
    launch-calculator
    launch-browser
    launch-terminal
    move-window-left
    move-window-right
    move-window-center
    resize-window-half
    resize-window-full
    tile-windows-left-right
    maximize-window
    minimize-window
    close-window
    pin-window-topmost
    unpin-window-topmost
    )"
    return commands
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
