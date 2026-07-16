# zunda-summary 🔊

Claude Code の回答の要点を、**ずんだもん(VOICEVOX)の声で読み上げる**プラグインです。

長い回答を読む前に「結論だけ耳で聞く」ことができます。作業しながら・席を離れながらでも、Claude が何をしたのか・答えは何だったのかを数秒で把握できます。

## できること

| コマンド | 動作 |
|---|---|
| `/vsum <質問・指示>` | 普段どおり回答したあと、要点2〜3文を自動で読み上げます |
| `/vsum-now` | 直前の回答の要点をその場で読み上げます(`/vsum` を付け忘れたとき用) |

要約は「結論ファースト」です。指示なら「何をどう実装・変更できたか」、質問なら「答えのコア」を最初の1文で言い切り、細部はチャットのテキストで読む前提になっています。読み上げた文はチャット末尾にも「🔊 音声要約:」として表示されます。

## 動作環境

- **macOS**(`say` / `afplay` / `open` を使用しているため。Linux/Windows は現状未対応)
- **jq**(`brew install jq`)
- **[VOICEVOX](https://voicevox.hiroshiba.jp/)**(推奨・無料)— ずんだもんの声での読み上げに必要です。
  - VOICEVOX が未インストール・起動不可の場合は、macOS 標準の `say`(Kyoko)に自動フォールバックするので、プラグイン自体は VOICEVOX なしでも動きます。
  - VOICEVOX アプリが終了していても、読み上げ時にバックグラウンドで自動起動します(初回は数秒待ちます)。

## インストール

Claude Code 内で:

```
/plugin marketplace add one-code-club/zunda-summary
/plugin install zunda-summary@zunda-summary
```

## 使い方

```
/vsum ログイン画面で発生しているバグの原因を調べて修正して
```

→ 通常どおり調査・修正が行われ、完了と同時に「ログイン画面のバグを修正しました。原因は〜」と読み上げられます。

```
/vsum-now
```

→ 直前の回答の結論を読み上げます。

## カスタマイズ

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

## 仕組み

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

## VOICEVOX の利用規約について

本プラグインは VOICEVOX を同梱していません。VOICEVOX および各音声ライブラリ(ずんだもん等)の利用は[VOICEVOX の利用規約](https://voicevox.hiroshiba.jp/term/)と各キャラクターの利用規約に従ってください。本人がローカルで聞く用途は問題ありませんが、生成した音声を動画等で公開する場合は「VOICEVOX:ずんだもん」等のクレジット表記が必要です。

## License

[MIT](LICENSE)
