# fast-ebpftracing
ebpf map の性能調査
- YCSB
    - ベンチマークツール YCSB が入っている
- workload
- ipftrace2
    - eBPF を使用したトレースツール
- ipftrace_parse
    - ipftrace2 で出力された結果をパースする
    - jupyter notebook を日付ごとに作成して使用する
- scripts
    - 便利なスクリプトを置いておく


## branch
- main
    - デフォルト設定のものをまとめておく
    - 全体に適応したい変更はこっちでやる
- 作業ブランチ
    - 実験対象ごとにブランチをきる
    - ipftrace2 の大きな変更などは全て作業ブランチ上で実装
    - パラメータの設定はコミットで管理する


# setup
## YCSB, memcached
```
#!/bin/bash

sudo apt-get install -y memcached

# install Java and Maven
sudo apt-get install -y java
sudo apt-get install -y maven
mvn -version

# Set up YCSB
git clone http://github.com/brianfrankcooper/YCSB.git
cd YCSB
mvn -pl site.ycsb:memcached-binding -am clean package
```

## memcached の設定
memcached サーバが動作するコアを指定するには，`/etc/systemd/system/memcached.service` を書き換える必要がある
以下のように CPU Affinity を設定する
```
[Unit]
Description=memcached daemon
After=network.target

[Service]
CPUAffinity=0 1
ExecStart=/usr/bin/memcached -u memcache
ExecStop=/bin/kill -s TERM $MAINPID
PIDFile=/var/run/memcached/memcached.pid
User=memcache
Group=memcache

[Install]
WantedBy=multi-user.target
```

設定ファイルの読み込みと再起動
```
sudo systemctl daemon-reload

# memcached を設定ファイルから起動できるようにする
sudo systemctl enable memcached

sudo systemctl restart memcached
sudo systemctl status memcached
```



