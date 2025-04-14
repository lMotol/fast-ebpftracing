#!/bin/bash

commit_hashs=("a14fabc095db4fbddd5dc0833fa35b99c439f367"
    "9c6aee0c781ca8dea76d2d17b641d045b26bd5a7"
    "f9977fa3781c75aff67f188e67a283bdd1ee271a"
    "701453a047c0f97eca566408e36ae8ec57e0bddd"
    "0520e3f9431204ff4aea8ab27b30a42d134f3212"
    "94f9e1318b3a9b3d9a62abbdac7b30f4c4f9c401"
    "72ea79339213446099288a85071cc965d7a143e8"
    "c53f70493b6e0c33dd3d9e5add0862976fae664e"
    "95ffc24966ded7d5bdd74ea2b8b3ddc2c39fe167"
    "d9b62bb75fab0aaee9ff28ef469cfd6982a9058d")
case_names=("len_16"
    "len_32"
    "len_64"
    "len_128"
    "len_256"
    "len_512"
    "len_1024"
    "len_2048"
    "len_4096"
    "len_8192")

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
