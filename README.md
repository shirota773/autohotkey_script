# AutoHotkey v2 Command Palette

Emacsの`M-x`スタイルのコマンドパレットをAutoHotkey v2で実装しました。fzfを使って関数を絞り込んで実行できます。

## 必要なもの

1. **AutoHotkey v2** - [ダウンロード](https://www.autohotkey.com/)
2. **fzf** - [ダウンロード](https://github.com/junegunn/fzf/releases)

## セットアップ

### 1. fzfのインストール

#### Windowsの場合:
```powershell
# Chocolateyを使用
choco install fzf

# または、Scoopを使用
scoop install fzf

# または、手動でダウンロード
# https://github.com/junegunn/fzf/releases から fzf.exe をダウンロードし、
# PATHの通った場所に配置
```

### 2. AutoHotkey v2のインストール

[AutoHotkey v2公式サイト](https://www.autohotkey.com/)からダウンロードしてインストール

### 3. スクリプトの実行

```
command-palette.ahk をダブルクリックして実行
```

または、スタートアップに登録して自動起動させることもできます。

## 使い方

### コマンドパレットを開く

**Alt + x** を押すと、fzfのコマンド選択画面が表示されます

### コマンド一覧

#### AutoHotkey制御
- `reload-autohotkey` - スクリプトをリロード
- `suspend-autohotkey` - ホットキーを一時停止
- `resume-autohotkey` - ホットキーを再開
- `exit-autohotkey` - AutoHotkeyを終了

#### アプリケーション起動
- `launch-notepad` - メモ帳を起動
- `launch-calculator` - 電卓を起動
- `launch-browser` - ブラウザを起動
- `launch-terminal` - ターミナルを起動（Windows Terminal or cmd）

#### ウィンドウ移動
- `move-window-left` - アクティブウィンドウを画面左半分に移動
- `move-window-right` - アクティブウィンドウを画面右半分に移動
- `move-window-center` - アクティブウィンドウを画面中央に移動

#### ウィンドウリサイズ
- `resize-window-half` - アクティブウィンドウを画面の半分にリサイズ
- `resize-window-full` - アクティブウィンドウを画面全体にリサイズ

#### ウィンドウ管理
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
    commands := "
    (
    reload-autohotkey
    ...
    your-new-command
    )"
    return commands
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

### fzfのカスタマイズ

`ShowCommandPalette()` 関数内のfzfオプションを変更できます：

```ahk
fzfCmd := Format('powershell -Command "Get-Content ''{}'' | fzf --prompt=''M-x: '' --height=40% --reverse --border --preview-window=right:50% | Out-File -Encoding UTF8 ''{}''"',
                 TempCommandFile, TempResultFile)
```

fzfのオプション：
- `--height` - 高さ
- `--reverse` - リストを上から表示
- `--border` - 境界線を表示
- `--preview` - プレビューウィンドウを表示
- `--prompt` - プロンプト文字列

## トラブルシューティング

### fzfが見つからない場合

スクリプトの冒頭で`FzfPath`を修正してください：

```ahk
global FzfPath := "C:\\path\\to\\fzf.exe"
```

### PowerShellが使えない場合

`ShowCommandPalette()` 関数を修正して、cmdを使用するように変更できます。

## ライセンス

MIT License

## 参考

- [AutoHotkey v2 Documentation](https://www.autohotkey.com/docs/v2/)
- [fzf](https://github.com/junegunn/fzf)
