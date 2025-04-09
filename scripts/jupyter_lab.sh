#!/bin/bash
# このスクリプトは、サーバ上で Poetry 環境内の Jupyter サーバを起動します。
# ローカル PC のブラウザからの接続には、あらかじめ ssh のポートフォワーディングを設定してください。
#
# ※ローカル側でのポートフォワーディング例:
#    ssh -N -L [LOCAL_PORT]:localhost:[REMOTE_PORT] user@your_server_address

# 指定されたポート（なければ 8888）を使います
PORT=${1:-8888}

echo "Starting Jupyter server on port ${PORT}..."

# Poetry 環境内で Jupyter Lab を起動（Notebook を利用する場合は "jupyter notebook" に変更）
cd ~/fast-ebpftracing/ipftrace_parse/
poetry run jupyter lab --no-browser --ip=0.0.0.0 --port=${PORT}
