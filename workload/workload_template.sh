#!/bin/bash

# 使用するファイルを変数にまとめる
YCSB_PATH="${HOME}/fast-ebpftracing/YCSB"
YCSB_WORKLOAD_PATH="${HOME}/fast-ebpftracing/ycsb_workload/workloada"
current_date=$(date "+%Y-%m-%d_%H:%M:%S")
RESULT_PATH="${HOME}/fast-ebpftracing/result/${current_date}/"

# TODO ここで管理しないようにする
sed -i "s/"recordcount=[0-9]*"/"recordcount=50000000"/" "${YCSB_WORKLOAD_PATH}"
sed -i "s/"operationcount=[0-9]*"/"operationcount=100000000"/" "${YCSB_WORKLOAD_PATH}"

# request rate の変更
TARGET_NUM+=(60000)
for ((i = 5000; i <= 150001; i += 5000)); do
    TARGET_NUM+=($i)
done
echo "${TARGET_NUM[@]}"

# 結果保存ディレクトリの作成
if [ ! -d "$RESULT_PATH" ]; then
    mkdir "$RESULT_PATH"
    echo "$RESULT_PATH フォルダを作成しました。"
else
    echo "$RESULT_PATH フォルダは既に存在します。"
fi

# パケットにマークを付与する
sudo iptables -t raw -D OUTPUT -d 127.0.0.1 -j MARK --set-mark 0xdeadbeef
sudo iptables -t raw -D PREROUTING -s 127.0.0.1 -j MARK --set-mark 0xdeadbeef
sudo iptables -t raw -A OUTPUT -d 127.0.0.1 -j MARK --set-mark 0xdeadbeef
sudo iptables -t raw -A PREROUTING -s 127.0.0.1 -j MARK --set-mark 0xdeadbeef

# memcached の再起動
sudo service memcached restart

#
sudo taskset -c 0,2,4,6,8,10,12,14,16,18 \
    ./bin/ycsb.sh load memcached -s \
    -target 100000 \
    -P "$YCSB_WORKLOAD_PATH" \
    -p measurementtype=raw \
    -p measurement.raw.output_file="${RESULT_PATH}/${NUM}_load_latency.txt" \
    -p "memcached.hosts=127.0.0.1:11211" \
    -threads 20 |& sudo tee "${RESULT_PATH}/load.txt"
sudo sysctl -w vm.drop_caches=3

for NUM in "${TARGET_NUM[@]}"; do
    # sudo taskset -c 0 ipft -m 0xdeadbeef --module-regex "p" >&"../result_latency/${NUM}_runtrace.txt" &
    sudo taskset -c 40-42 ipft \
        -m 0xdeadbeef >&"${RESULT_PATH}/${NUM}_runtrace_parse.txt" &
    pid=$!
    if [ -f "${RESULT_PATH}/${NUM}_run_ipf_latency.txt" ]; then
        sudo rm "${RESULT_PATH}/${NUM}_run_ipf_latency.txt"
        echo "${RESULT_PATH}/${NUM}_run_ipf_latency.txt を削除しました"
    fi
    sudo taskset -c 0,2,4,6,8,10,12,14,16,18 \
        ./bin/ycsb run memcached -s \
        -target ${NUM} \
        -P "$YCSB_WORKLOAD_PATH" \
        -p maxexecutiontime=120 \
        -p measurementtype=raw \
        -p measurement.raw.output_file="${RESULT_PATH}/${NUM}_run_ipf_latency.txt" \
        -p "memcached.hosts=127.0.0.1:11211" \
        -threads 20 |& sudo tee "${RESULT_PATH}/${NUM}_run_ipf.txt"
    kill ${pid}
    RET=0
    while [ "$RET" -eq 0 ]; do
        ps ${pid}
        RET=$(echo $?)
        sleep 5
    done
    sudo sysctl -w vm.drop_caches=3

done

sed -i "s/"recordcount=[0-9]*"/"recordcount=1000000"/" "${YCSB_WORKLOAD_PATH}"
sed -i "s/"operationcount=[0-9]*"/"operationcount=1000000"/" "${YCSB_WORKLOAD_PATH}"
