#!/bin/bash
# Usage: ./delete_dirs.sh <start_date> <end_date>
# 日付フォーマット例: 2025-04-11_04-00
# 例: ./delete_dirs.sh 2025-04-11_04-00 2025-04-11_05-00

# 引数チェック
if [ $# -ne 2 ]; then
    echo "Usage: $0 <start_date> <end_date> (format: YYYY-MM-DD_HH-MM)"
    exit 1
fi

start_date="$1"
end_date="$2"

# 範囲チェック: 開始日時 <= 終了日時でなければエラー
if [[ "$start_date" > "$end_date" ]]; then
    echo "Error: start_date ($start_date) is greater than end_date ($end_date)"
    exit 1
fi

# 日付形式のディレクトリを取得してループ処理
# [0-9]で始まる4桁-2桁-2桁_2桁-2桁のパターンを利用
cd "$HOME/fast-ebpftracing/result/"
for dir in [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]_[0-9][0-9]-[0-9][0-9]*; do
    # 該当パターンのファイルが存在しない場合、そのままループをスキップ
    [ -e "$dir" ] || continue

    # ディレクトリかどうかチェック
    if [ -d "$dir" ]; then
        # 先頭16文字を抽出（YYYY-MM-DD_HH-MM）
        dir_date="${dir:0:16}"

        # 文字列比較（ISO形式なので単純な辞書順で正しく比較可能）
        if [[ "$dir_date" < "$start_date" ]] || [[ "$dir_date" > "$end_date" ]]; then
            continue
        fi

        echo "Directory move to trash: $dir (date prefix: $dir_date)"
        mv "$dir" "$HOME/fast-ebpftracing/trash/"
    fi
done
cd ../
