# zunda-summary 🔊

[日本語](#日本語) ・ [English](#english)

---

## English

A Claude Code plugin that reads out the key points of Claude's answers in the voice of **Zundamon ([VOICEVOX](https://voicevox.hiroshiba.jp/))**.

Hear the conclusion by ear before reading the full answer. While coding or away from the screen, you can grasp in a few seconds what Claude did or what the answer was — and read the details in text later.

### Commands

| Command | What it does |
|---|---|
| `/vsum <question or instruction>` | Answers normally, then automatically reads out a 2–3 sentence summary of the key points |
| `/vsum-now` | Reads out a summary of the previous answer on demand (for when you forgot to use `/vsum`) |

Summaries are **conclusion-first**: for an instruction, the first sentence states what was implemented or changed; for a question, it states the core answer. The same text is also shown at the end of the chat as "🔊 音声要約:".

### Requirements

- **macOS** — the playback script uses `say` / `afplay` / `open`.
  - ⚠️ **Windows and Linux are not supported yet.** The plugin will install, but audio playback will not work. Contributions are welcome.
- **jq** — `brew install jq`
- **[VOICEVOX](https://voicevox.hiroshiba.jp/)** (recommended, free) — needed for the Zundamon voice. If VOICEVOX is not installed or cannot start, the plugin automatically falls back to the built-in macOS `say` voice (Kyoko), so it still works without VOICEVOX.

### Installing VOICEVOX

VOICEVOX is a free Japanese text-to-speech application. The installation steps differ between macOS and Windows:

**macOS** (what this plugin uses):

1. Download the **macOS (Apple Silicon / Intel) dmg** from the [official site](https://voicevox.hiroshiba.jp/) or [GitHub Releases](https://github.com/VOICEVOX/voicevox/releases) (pick `arm64` for Apple Silicon, `x64` for Intel).
2. Open the dmg and drag `VOICEVOX.app` into `Applications`.
3. On first launch, right-click the app and choose **Open** to pass the Gatekeeper warning (the app is not notarized).
4. That's it. The speech engine runs on `127.0.0.1:50021` while the app is running. You don't need to keep it open — the plugin launches VOICEVOX in the background automatically when needed (the first read-out may take a few seconds).

**Windows** (for reference):

- VOICEVOX for Windows is distributed as an **installer (.exe)** — download it from the official site, run it, and choose the CPU or GPU (DirectML) edition. There is no drag-and-drop step like on macOS.
- Note again: installing VOICEVOX on Windows does not make this plugin work there yet, because the playback script itself is macOS-only.

### Install the plugin

Inside Claude Code:

```
/plugin marketplace add one-code-club/zunda-summary
/plugin install zunda-summary@zunda-summary
```

### Usage

```
/vsum Investigate and fix the bug on the login screen
```

→ Claude investigates and fixes as usual, and when finished reads out something like "I fixed the login bug. The cause was ...".

```
/vsum-now
```

→ Reads out the conclusion of the previous answer.

### Customization

Change the voice and speed via environment variables:

```bash
# Change the speaker (default: 3 = Zundamon, normal style)
export VSUM_SPEAKER=8   # e.g. Kasukabe Tsumugi

# Change the speaking speed (default: 1.1)
export VSUM_SPEED=1.3
```

List available speaker IDs while VOICEVOX is running:

```bash
curl -s http://127.0.0.1:50021/speakers | jq -r '.[] | .name as $n | .styles[] | "\(.id)\t\($n)(\(.name))"' | sort -n
```

### How it works

```
/vsum <question>
   │ answers normally
   ▼
summarizes the conclusion in 2–3 sentences
   │ scripts/vsum-say.sh
   ▼
synthesizes speech via the VOICEVOX engine (127.0.0.1:50021) → plays with afplay
   └ auto-launches the engine if not running / falls back to say (Kyoko) if unavailable
```

### VOICEVOX terms of use

This plugin does not bundle VOICEVOX. Use of VOICEVOX and its voice libraries (Zundamon, etc.) is subject to the [VOICEVOX terms](https://voicevox.hiroshiba.jp/term/) and each character's license. Listening locally by yourself is fine, but if you publish generated audio (e.g. in videos), a credit such as "VOICEVOX:ずんだもん" is required.

### License

[MIT](LICENSE)

---

## 日本語

Claude Code の回答の要点を、**ずんだもん([VOICEVOX](https://voicevox.hiroshiba.jp/))の声で読み上げる**プラグインです。

長い回答を読む前に「結論だけ耳で聞く」ことができます。作業しながら・席を離れながらでも、Claude が何をしたのか・答えは何だったのかを数秒で把握でき、細部はあとからテキストで読めます。

### できること

| コマンド | 動作 |
|---|---|
| `/vsum <質問・指示>` | 普段どおり回答したあと、要点2〜3文を自動で読み上げます |
| `/vsum-now` | 直前の回答の要点をその場で読み上げます(`/vsum` を付け忘れたとき用) |

要約は「結論ファースト」です。指示なら「何をどう実装・変更できたか」、質問なら「答えのコア」を最初の1文で言い切ります。読み上げた文はチャット末尾にも「🔊 音声要約:」として表示されます。

### 動作環境

- **macOS** — 読み上げスクリプトが `say` / `afplay` / `open` を使用しています。
  - ⚠️ **Windows・Linux は現状未対応です。** プラグインのインストール自体はできますが、音声再生が動きません。対応のコントリビュートは歓迎です。
- **jq** — `brew install jq`
- **[VOICEVOX](https://voicevox.hiroshiba.jp/)**(推奨・無料)— ずんだもんの声での読み上げに必要です。VOICEVOX が未インストール・起動不可の場合は macOS 標準の `say`(Kyoko)に自動フォールバックするため、VOICEVOX なしでも動作はします。

### VOICEVOX のインストール方法

VOICEVOX は無料の日本語音声合成アプリです。インストール手順は macOS と Windows で異なります:

**macOS**(本プラグインが使う環境):

1. [公式サイト](https://voicevox.hiroshiba.jp/)または [GitHub Releases](https://github.com/VOICEVOX/voicevox/releases) から **macOS 用 dmg** をダウンロードします(Apple Silicon は `arm64`、Intel は `x64`)。
2. dmg を開き、`VOICEVOX.app` を `アプリケーション` フォルダにドラッグします。
3. 初回起動時は Gatekeeper の警告が出るため、アプリを**右クリック →「開く」**で起動してください。
4. 以上で完了です。アプリ起動中は音声合成エンジンが `127.0.0.1:50021` で動きます。常時起動しておく必要はなく、読み上げ時に本プラグインがバックグラウンドで自動起動します(初回のみ数秒待ちます)。

**Windows**(参考):

- Windows 版は **インストーラー(.exe)** 形式です。公式サイトからダウンロードして実行し、CPU 版か GPU(DirectML)版を選びます。macOS のようなドラッグ&ドロップは不要です。
- ただし前述のとおり、読み上げスクリプトが macOS 専用のため、Windows に VOICEVOX を入れても本プラグインはまだ動きません。

### プラグインのインストール

Claude Code 内で:

```
/plugin marketplace add one-code-club/zunda-summary
/plugin install zunda-summary@zunda-summary
```

### 使い方

```
/vsum ログイン画面で発生しているバグの原因を調べて修正して
```

→ 通常どおり調査・修正が行われ、完了と同時に「ログイン画面のバグを修正しました。原因は〜」と読み上げられます。

```
/vsum-now
```

→ 直前の回答の結論を読み上げます。

### カスタマイズ

環境変数で声と話速を変えられます:

```bash
# 話者を変える(デフォルト: 3 = ずんだもん ノーマル)
export VSUM_SPEAKER=8   # 例: 春日部つむぎ

# 話速を変える(デフォルト: 1.1)
export VSUM_SPEED=1.3
```

話者IDの一覧は、VOICEVOX 起動中に次のコマンドで確認できます:

```bash
curl -s http://127.0.0.1:50021/speakers | jq -r '.[] | .name as $n | .styles[] | "\(.id)\t\($n)(\(.name))"' | sort -n
```

### 仕組み

```
/vsum <質問>
   │ 通常どおり回答
   ▼
回答の要点を結論ファーストで2〜3文に要約
   │ scripts/vsum-say.sh
   ▼
VOICEVOX エンジン (127.0.0.1:50021) で音声合成 → afplay で再生
   └ エンジン未起動なら自動起動 / 利用不可なら say (Kyoko) にフォールバック
```

### VOICEVOX の利用規約について

本プラグインは VOICEVOX を同梱していません。VOICEVOX および各音声ライブラリ(ずんだもん等)の利用は[VOICEVOX の利用規約](https://voicevox.hiroshiba.jp/term/)と各キャラクターの利用規約に従ってください。本人がローカルで聞く用途は問題ありませんが、生成した音声を動画等で公開する場合は「VOICEVOX:ずんだもん」等のクレジット表記が必要です。

### License

[MIT](LICENSE)
