#!/bin/bash

commit_hashs=("dc88f500a2514d34aeec5c244f018c7e995aca07"
    "1a3759f6abebe0bef9ffa25bf9932eaba0c3aa6c"
    "01dc78e3fd4f39b1ee38352783faa56cc75a0675"
    "f0c73e9d7d7208b3ec2c6927563eaba4ac108b86"
    "b686b93a8dd0dea2335dd19adab205cb8254ce1b"
    "705be60c4bece41e36ecf8a9882742ce63f141e8"
    "bda937ac80d72b22039e5a967efc38a3b5fd53a6"
)
case_names=("len_4"
    "len_16"
    "len_64"
    "len_256"
    "len_1024"
    "len_4096"
    "len_16384")

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
