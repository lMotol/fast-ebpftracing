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


