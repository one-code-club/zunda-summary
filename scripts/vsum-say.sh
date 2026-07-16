#!/bin/bash
# vsum-say.sh — テキストをVOICEVOXで読み上げる。
# エンジン未起動なら VOICEVOX.app をバックグラウンド起動して待機し、
# 使えない場合は macOS の say (Kyoko) にフォールバックする。
#
# 使い方:   vsum-say.sh "読み上げるテキスト"
# 話者変更: VSUM_SPEAKER=8 vsum-say.sh "..."  (IDは http://127.0.0.1:50021/speakers 参照)
# 話速変更: VSUM_SPEED=1.2 vsum-say.sh "..."
set -u

TEXT="${1:?usage: vsum-say.sh \"text\"}"
SPEAKER="${VSUM_SPEAKER:-3}"   # 3 = ずんだもん(ノーマル)
SPEED="${VSUM_SPEED:-1.1}"
BASE="http://127.0.0.1:50021"

engine_up() { curl -sf -m 2 "$BASE/version" >/dev/null 2>&1; }

if ! engine_up; then
  # -g: 前面に出さない / -j: 隠して起動
  open -gja VOICEVOX 2>/dev/null
  for _ in $(seq 1 30); do
    engine_up && break
    sleep 1
  done
fi

fallback() {
  say -v Kyoko "$TEXT"
  exit 0
}

engine_up || fallback

ENC=$(jq -rn --arg t "$TEXT" '$t|@uri') || fallback
QUERY=$(curl -sf -m 15 -X POST "$BASE/audio_query?speaker=$SPEAKER&text=$ENC") || fallback
QUERY=$(printf '%s' "$QUERY" | jq --argjson s "$SPEED" '.speedScale=$s') || fallback

WAV=$(mktemp -t vsum).wav
# 初回はモデル読み込みで数秒かかることがあるため長めのタイムアウト
curl -sf -m 60 -X POST "$BASE/synthesis?speaker=$SPEAKER" \
  -H 'Content-Type: application/json' -d "$QUERY" -o "$WAV" || { rm -f "$WAV"; fallback; }

afplay "$WAV"
rm -f "$WAV"
