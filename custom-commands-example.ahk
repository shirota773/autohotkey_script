; Custom Commands Example
; このファイルをコピーして、独自のコマンドを追加できます

; ============================================================================
; カスタムコマンドの例
; ============================================================================

; 例1: 特定のアプリケーションを起動
LaunchVSCode() {
    ; Visual Studio Codeを起動
    Run("code")
}

LaunchSlack() {
    ; Slackを起動
    Run("slack")
}

; 例2: 特定のウィンドウを決まった位置に移動
MoveNotepadToTopLeft() {
    ; メモ帳を画面左上に移動
    if WinExist("ahk_class Notepad") {
        hwnd := WinExist()
        WinMove(0, 0, 800, 600, hwnd)
    } else {
        MsgBox("Notepad is not running")
    }
}

MoveBrowserToRight() {
    ; ブラウザを画面右半分に配置
    ; Chromeの例
    if WinExist("ahk_exe chrome.exe") {
        hwnd := WinExist()
        MonitorGetWorkArea(, &left, &top, &right, &bottom)
        width := (right - left) // 2
        height := bottom - top
        WinMove(left + width, top, width, height, hwnd)
    }
}

; 例3: 複数のアプリを一度に起動
LaunchDevEnvironment() {
    ; 開発環境を一括起動
    Run("code")        ; VSCode
    Sleep(500)
    Run("wt.exe")      ; Windows Terminal
    Sleep(500)
    Run("chrome.exe")  ; Chrome
}

; 例4: ウィンドウを特定のレイアウトに配置
ArrangeIDELayout() {
    ; IDE用のウィンドウレイアウト
    ; VSCodeを左半分、ターミナルを右上、ブラウザを右下

    MonitorGetWorkArea(, &left, &top, &right, &bottom)
    width := (right - left) // 2
    height := bottom - top
    halfHeight := height // 2

    ; VSCodeを左半分
    if WinExist("ahk_exe Code.exe") {
        WinMove(left, top, width, height, WinExist())
    }

    ; ターミナルを右上
    if WinExist("ahk_exe WindowsTerminal.exe") {
        WinMove(left + width, top, width, halfHeight, WinExist())
    }

    ; ブラウザを右下
    if WinExist("ahk_exe chrome.exe") {
        WinMove(left + width, top + halfHeight, width, halfHeight, WinExist())
    }
}

; 例5: スクリーンショットを撮る
TakeScreenshot() {
    ; Snipping Toolを起動
    Run("SnippingTool.exe")
}

; 例6: 音量調整
VolumeUp() {
    SoundSetVolume("+10")
    volume := Round(SoundGetVolume())
    TrayTip("Volume", "Volume: " volume "%")
}

VolumeDown() {
    SoundSetVolume("-10")
    volume := Round(SoundGetVolume())
    TrayTip("Volume", "Volume: " volume "%")
}

VolumeMute() {
    SoundSetMute(!SoundGetMute())
    if SoundGetMute() {
        TrayTip("Volume", "Muted")
    } else {
        TrayTip("Volume", "Unmuted")
    }
}

; 例7: クリップボード操作
ClearClipboard() {
    A_Clipboard := ""
    TrayTip("Clipboard", "Clipboard cleared")
}

ShowClipboard() {
    MsgBox("Current clipboard:`n`n" A_Clipboard, "Clipboard Contents")
}

; 例8: ディスプレイ設定
SwitchMonitorMode() {
    ; Windowsのディスプレイ設定を開く
    Run("ms-settings:display")
}

; 例9: システム操作
LockComputer() {
    DllCall("LockWorkStation")
}

OpenTaskManager() {
    Run("taskmgr.exe")
}

EmptyRecycleBin() {
    result := MsgBox("ごみ箱を空にしますか？", "Confirm", "YesNo")
    if (result = "Yes") {
        FileRecycleEmpty()
        TrayTip("Recycle Bin", "Recycle bin emptied")
    }
}

; 例10: カスタムフォルダを開く
OpenDownloads() {
    Run("explorer.exe " A_MyDocuments "\..\Downloads")
}

OpenDesktop() {
    Run("explorer.exe " A_Desktop)
}

OpenDocuments() {
    Run("explorer.exe " A_MyDocuments)
}

; ============================================================================
; これらのカスタムコマンドを使用するには：
;
; 1. command-palette.ahk の GetCommandList() にコマンド名を追加
; 2. ExecuteCommand() に case を追加
; 3. このファイルを #Include で読み込む
;
; 例：
; command-palette.ahk の最後に以下を追加:
; #Include custom-commands-example.ahk
; ============================================================================
