#!/bin/bash

commit_hashs=("86234d255425723ccfb07133e7baa0747042cac0"
    "889fa331914fde5d4380b25fd11da20755e51e0e"
    "d6cbd17bba2a5ce4954cb2172ae0cc62d76bb744"
    "dfea4d8c98e7be5236c9cc048297b1e0bb6f8f5a"
    "931ff45275dd2338dbc2633423713e405e43d296"
    "f751e71b74d64e0794af89fc654284ce1dc259fb")
case_names=("len_2"
    "len_4"
    "len_8"
    "len_16"
    "len_32"
    "len_64")
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
