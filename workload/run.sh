#!/bin/bash

commit_hashs=("42e5607abde9088d6cec81efe45b30fc81eb2595"
    "0d1d26795bcf2dc9683e7ffd683530a0713d5b17"
    "8c2f285731a92eba982a56ca62a450c3afa01ef7"
    "5aa68abd037229ffdfc8c5f2f58949caa0aea95a"
    "7d73e2d66f444ed3274da7ce64339ce19d71c5f5")
case_names=("len_2"
    "len_4"
    "len_8"
    "len_16"
    "len_32")
for i in "${!commit_hashs[@]}"; do
    COMMIT_HASH=${commit_hashs[$i]}
    # パスなど
    WORKLOAD_PATH="${HOME}/fast-ebpftracing/workload/workload_template.sh"
    current_date=$(date "+%Y-%m-%d_%H-%M")
    experiment_name="value-size"
    case_name=${case_names[$i]}
    RESULT_PATH="${HOME}/fast-ebpftracing/result/${current_date}_${experiment_name}_${case_name}/"

    # 結果保存ディレクトリの作成
    if [ ! -d "$RESULT_PATH" ]; then
        mkdir "$RESULT_PATH"
        echo "$RESULT_PATH フォルダを作成しました。"
    else
        echo "$RESULT_PATH フォルダは既に存在します。"
    fi

    # 実行
    "$HOME/fast-ebpftracing/workload/attach_ipftrace2.sh" "$COMMIT_HASH" || exit $?
    "$WORKLOAD_PATH" -r "$RESULT_PATH" |& tee "${RESULT_PATH}/log.txt"
    cp "$WORKLOAD_PATH" "$RESULT_PATH"
done
