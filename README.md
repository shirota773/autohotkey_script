# AutoHotkey v2 Command Palette

Emacsの`M-x`スタイルのコマンドパレットをAutoHotkey v2のネイティブGUIで実装しました。

## 特徴

- **外部依存なし**: AutoHotkey v2のみで動作（fzf不要）
- **ネイティブGUI**: 美しいダークテーマのインターフェース
- **ファジー検索**: リアルタイムでコマンドを絞り込み
- **キーボード操作**: Enter、矢印キー、Ctrl+N/P（Emacs風）で操作可能

## 必要なもの

**AutoHotkey v2** のみ - [ダウンロード](https://www.autohotkey.com/)

## セットアップ

### AutoHotkey v2のインストール

[AutoHotkey v2公式サイト](https://www.autohotkey.com/)からダウンロードしてインストール

### スクリプトの実行

```
command-palette.ahk をダブルクリックして実行
```

または、スタートアップに登録して自動起動させることもできます。

## 使い方

### コマンドパレットを開く

**Alt + x** を押すと、コマンドパレットGUIが表示されます

### 操作方法

- **文字入力**: コマンドを絞り込み（ファジー検索）
- **↑/↓ キー**: 候補を選択
- **Ctrl+N/P**: 候補を選択（Emacs風）
- **Enter**: 選択したコマンドを実行
- **Esc**: コマンドパレットを閉じる
- **ダブルクリック**: マウスでコマンドを実行

### ファジー検索の例

- `lnp` と入力 → `launch-notepad` がマッチ
- `mwl` と入力 → `move-window-left` がマッチ
- `rwh` と入力 → `resize-window-half` がマッチ

## コマンド一覧

### AutoHotkey制御
- `reload-autohotkey` - スクリプトをリロード
- `suspend-autohotkey` - ホットキーを一時停止
- `resume-autohotkey` - ホットキーを再開
- `exit-autohotkey` - AutoHotkeyを終了

### アプリケーション起動
- `launch-notepad` - メモ帳を起動
- `launch-calculator` - 電卓を起動
- `launch-browser` - ブラウザを起動
- `launch-terminal` - ターミナルを起動（Windows Terminal or cmd）

### ウィンドウ移動
- `move-window-left` - アクティブウィンドウを画面左半分に移動
- `move-window-right` - アクティブウィンドウを画面右半分に移動
- `move-window-center` - アクティブウィンドウを画面中央に移動

### ウィンドウリサイズ
- `resize-window-half` - アクティブウィンドウを画面の半分にリサイズ
- `resize-window-full` - アクティブウィンドウを画面全体にリサイズ

### ウィンドウ管理
- `tile-windows-left-right` - 上位2つのウィンドウを左右に並べる
- `maximize-window` - アクティブウィンドウを最大化
- `minimize-window` - アクティブウィンドウを最小化
- `close-window` - アクティブウィンドウを閉じる
- `pin-window-topmost` - アクティブウィンドウを常に最前面に設定
- `unpin-window-topmost` - アクティブウィンドウの最前面設定を解除

## カスタマイズ

### 新しいコマンドの追加方法

1. `GetCommandList()` 関数にコマンド名を追加
2. `ExecuteCommand()` 関数にcaseを追加
3. 実行する関数を実装

例：
```ahk
; 1. コマンドリストに追加
GetCommandList() {
    return [
        "reload-autohotkey",
        ...
        "your-new-command"
    ]
}

; 2. ルーターに追加
ExecuteCommand(cmdName) {
    switch cmdName {
        ...
        case "your-new-command":
            YourNewFunction()
    }
}

; 3. 関数を実装
YourNewFunction() {
    MsgBox("Hello from your new command!")
}
```

### GUIのカスタマイズ

`ShowCommandPalette()` 関数内でGUIの外観を変更できます：

```ahk
; 色の変更
CommandPaletteGui.BackColor := "0x282828"  ; 背景色（ダークグレー）

; 検索ボックスとリストの色
SearchBox := CommandPaletteGui.Add("Edit", "x10 y35 w580 h25 Background0x3C3836 cWhite")
CommandList := CommandPaletteGui.Add("ListBox", "x10 y70 w580 h400 Background0x3C3836 cWhite Choose1")

; フォントの変更
CommandPaletteGui.SetFont("s10", "Consolas")

; ウィンドウサイズの変更
CommandPaletteGui.Show("w600 h480 Center")
```

### ホットキーの変更

スクリプトの冒頭で変更できます：

```ahk
; Alt+x (デフォルト)
!x:: {
    ShowCommandPalette()
}

; または Ctrl+Space に変更
^Space:: {
    ShowCommandPalette()
}
```

## 技術詳細

### アーキテクチャ

- **GUI システム**: AutoHotkey v2のネイティブGUI API
- **検索アルゴリズム**: カスタムファジーマッチング実装
- **イベント処理**: リアルタイムフィルタリングとキーボードナビゲーション

### ファジーマッチングアルゴリズム

入力された文字が順番に含まれていればマッチします：

```ahk
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
```

## トラブルシューティング

### Alt+xが反応しない

1. スクリプトが起動しているか確認（タスクトレイアイコンを確認）
2. 他のアプリケーションがAlt+xを使用していないか確認
3. スクリプトを右クリック → 「管理者として実行」を試す

### GUIが表示されない

1. スクリプトをリロード（タスクトレイアイコンを右クリック → Reload）
2. AutoHotkey v2がインストールされているか確認（v1では動作しません）

### コマンドが実行されない

1. エラーメッセージを確認
2. スクリプトをリロード

## ライセンス

MIT License

## 参考

- [AutoHotkey v2 Documentation](https://www.autohotkey.com/docs/v2/)
- [AutoHotkey GUI Documentation](https://www.autohotkey.com/docs/v2/lib/Gui.htm)
