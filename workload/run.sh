#!/bin/bash

# パスなど
WORKLOAD_PATH="${HOME}/fast-ebpftracing/workload/workload_template.sh"
current_date=$(date "+%Y-%m-%d_%H-%M")
experiment_name="value-size"
RESULT_PATH="${HOME}/fast-ebpftracing/result/${current_date}_${experiment_name}/"

# 結果保存ディレクトリの作成
if [ ! -d "$RESULT_PATH" ]; then
    mkdir "$RESULT_PATH"
    echo "$RESULT_PATH フォルダを作成しました。"
else
    echo "$RESULT_PATH フォルダは既に存在します。"
fi

# 実行
"$WORKLOAD_PATH" -r "$RESULT_PATH" |& tee "${RESULT_PATH}/log.txt"
cp "$WORKLOAD_PATH" "$RESULT_PATH"
