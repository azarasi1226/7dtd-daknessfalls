# 7 Days to Die Dedicated Server (Docker) + Darkness Falls

ソロ〜2-3人向けの、Dockerで動かす7DTDサーバーです。
Darkness Falls などの大型Modも簡単に導入できます。

## 📁 ディレクトリ構成

```
7dtd-docker/
├── Dockerfile               # サーバー用イメージの定義
├── docker-compose.yml       # 起動設定
├── entrypoint.sh            # コンテナ起動時の処理
├── config/
│   └── serverconfig.xml     # サーバー設定（編集してください）
├── mods/                    # Modを入れる場所（Darkness Falls等）
│   └── README.md
├── serverdata/              # SteamCMDがDLしたサーバー本体（自動生成）
├── savedata/                # セーブデータ・生成ワールド（自動生成）
├── unity-config/            # Unity設定（PlayerPrefs等、自動生成）
└── steamcmd/                # SteamCMD状態（自動生成）
```

すべてのデータは **このフォルダ内に完結** します。フォルダごと別PCにコピーすればサーバー状態をそのまま移設できます。

## 🚀 使い方

### 1. 事前準備
- Docker Desktop（Windows/Mac）または Docker Engine + Compose（Linux）をインストール
- 空きディスク容量 **20GB以上**（7DTD本体5GB + DF 6GB + セーブ等）
- RAM **8GB以上**推奨（ソロなら6GBでも動く）

### 2. Modの配置
Darkness Falls のZIPを解凍し、中の `Mods` フォルダの **中身** を
プロジェクトの `mods/` フォルダに配置してください。
詳細は `mods/README.md` を参照。

### 3. 設定の編集
`config/serverconfig.xml` を開いて以下を変更：

- `ServerName` … サーバー名
- `ServerPassword` … 参加パスワード（必ず変えてください）
- `TelnetPassword` … 管理用パスワード
- `GameWorld` … 使用マップ（DFalls-Medium1 など）

### 4. 起動

```bash
# イメージをビルドして起動（初回は10-20分かかります）
docker compose up -d --build

# ログを見る（初回はSteamCMDのDLとワールド生成で時間がかかる）
docker compose logs -f

# 起動完了の目印（このログが出たら接続可能）:
# INF [Steamworks.NET] GameServer.LogOn successful
```

### 5. 停止・再起動

```bash
# 停止（セーブデータは残る）
docker compose down

# 再起動
docker compose restart

# 2回目以降の起動を高速化したい場合:
# docker-compose.yml の SKIP_UPDATE を "1" に変える
```

## 🎮 クライアント（プレイヤー）側の準備

**重要：** Darkness Falls を使う場合、**プレイヤー全員** がクライアントにも DF を入れる必要があります。

1. 7D2D Mod Launcher を使うのが一番ラク
   - https://7d2dmodlauncher.org/
2. Darkness Falls を選んで Install → Play
3. サーバーのIP・ポート・パスワードを入れて接続

## 🔧 便利なコマンド

```bash
# サーバーコンソールに入る（telnet経由）
docker exec -it 7dtd-server telnet localhost 8081

# コンテナの中に入って直接確認
docker exec -it 7dtd-server bash

# サーバー本体を手動で更新したい時
docker compose down
docker compose up -d   # SKIP_UPDATE=0 の状態で起動すればOK

# セーブデータのバックアップ
cp -r savedata savedata.backup.$(date +%Y%m%d)
```

## ⚠️ 注意事項

- **EAC（Easy Anti-Cheat）は必ず無効化** します（DFが動かないため）
- Modを変更した場合、**既存のセーブと互換性がない**ことがあります
- 初回起動時はワールド生成に **10-20分** かかることがあります
- ポート `26900` をルーターで **ポート開放**（TCP/UDP両方）する必要があります
- Telnet/Web管理ポート（8081/8080）は `127.0.0.1` にバインドしているので、
  外部からは見えません。必要なら `docker-compose.yml` で調整してください。

## 💾 RAM見積り（参考）

| プレイヤー数 | マップサイズ | 推奨RAM |
|---|---|---|
| ソロ | 8K (Medium) | 6-8 GB |
| 2-3人 | 8K (Medium) | 8-10 GB |
| 4-8人 | 10K+ | 12-16 GB |

## 📚 参考リンク

- 公式サーバーWiki: https://community.7daystodie.com/
- Darkness Falls: https://7daystodiemods.com/darkness-falls-mod/
- 7D2D Mod Launcher: https://7d2dmodlauncher.org/
