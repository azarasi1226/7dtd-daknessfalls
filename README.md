# 7 Days to Die Dedicated Server (Docker) + Darkness Falls

[vinanrra/7dtd-server](https://github.com/vinanrra/Docker-7DaysToDie)（LinuxGSMベース）を使って、
Docker で7DTDサーバー + Darkness Falls を動かす構成です。

## 📁 ディレクトリ構成

```
7dtd-docker/
├── docker-compose.yml       # 起動設定（ここを編集）
├── README.md
├── config/
│   └── serverconfig.xml     # サーバー設定のリファレンス（後述）
├── serverfiles/             # 7DTD本体 + MOD（自動配置）
├── savedata/                # セーブデータ・生成ワールド
├── lgsm-config/             # LinuxGSM設定
├── backups/                 # 自動バックアップ保存先
└── logs/                    # ログ
```

**すべてのデータは 7dtd-docker フォルダ内に完結** します。
フォルダごと別PCにコピーすればサーバー状態をそのまま移設可能です。

## 🚀 使い方

### 1. 事前準備
- Docker Desktop（Windows/Mac）または Docker Engine + Compose（Linux）
- 空きディスク容量 **20GB以上**
- RAM **8GB以上**推奨

### 2. 初回起動

```bash
docker compose up -d

# ログを見る（初回はSteamCMDのDLとDFインストールで10-20分かかる）
docker compose logs -f

# 起動完了の目印:
# INF [Steamworks.NET] GameServer.LogOn successful
```

`DARKNESS_FALLS: "YES"` により、自動で Darkness Falls がインストールされます。
`ALLOC_FIXES: "YES"` により、Web管理用の Alloc Fixes も自動で入ります。

### 3. サーバー設定の編集

初回起動後、`serverfiles/sdtdserver.xml` が生成されます。
これを編集してから再起動してください：

```bash
# 停止
docker compose down

# serverfiles/sdtdserver.xml を編集（下記項目を参照）

# 再起動
docker compose up -d
```

**最低限変更すべき項目**（`config/serverconfig.xml` も参考用に置いてあります）：

- `ServerName` … サーバー名
- `ServerPassword` … 参加パスワード（必ず変更）
- `TelnetPassword` … 管理用パスワード
- `ControlPanelPassword` … Web管理パスワード
- `GameWorld` … `DFalls-Medium1` など（DF付属マップ）
- `EACEnabled` … **必ず `false`**（DF利用時）

### 4. 停止・再起動

```bash
docker compose down       # 停止（セーブデータは残る）
docker compose restart    # 再起動
docker compose logs -f    # ログ監視
```

## 🎮 クライアント（プレイヤー）側

**重要：** Darkness Falls を使う場合、**プレイヤー全員** がクライアントにも DF を入れる必要があります。

1. [7D2D Mod Launcher](https://7d2dmodlauncher.org/) を使うのが一番ラク
2. Darkness Falls を選んで Install → Play
3. サーバーのIP・ポート・パスワードを入れて接続

## 🔧 便利なコマンド

```bash
# コンテナに入る
docker exec -it 7dtd-server bash

# LinuxGSMコマンドを使う（コンテナ内で）
./sdtdserver details     # サーバー情報
./sdtdserver backup      # 手動バックアップ
./sdtdserver update      # 7DTD本体の更新
./sdtdserver mods-update # MODの更新
./sdtdserver console     # サーバーコンソール

# telnet経由でサーバーコンソールに入る（ローカルから）
telnet 127.0.0.1 8081

# Web管理パネル（Alloc Fixes）
# ブラウザで http://127.0.0.1:8080 を開く
```

## 📦 追加MODを入れたい場合

MODファイルを `serverfiles/Mods/` に直接配置するか、
`docker-compose.yml` の環境変数で URL 指定できます：

```yaml
environment:
  MODS_URLS: "https://example.com/mod1.zip,https://example.com/mod2.zip"
```

## ⚠️ 注意事項

- **EAC（Easy Anti-Cheat）は必ず無効化** します（DFが動かないため）
- Modを変更した場合、**既存のセーブと互換性がない**ことがあります
- ポート `26900` をルーターで **ポート開放**（TCP/UDP両方）する必要があります
- 管理ポート（8080/8081/8082）は `127.0.0.1` にバインドしているので、
  外部からは見えません

## 💾 RAM見積り（参考）

| プレイヤー数 | マップサイズ | 推奨RAM |
|---|---|---|
| ソロ | 8K (Medium) | 6-8 GB |
| 2-3人 | 8K (Medium) | 8-10 GB |
| 4-8人 | 10K+ | 12-16 GB |

## 📚 参考リンク

- [vinanrra/Docker-7DaysToDie](https://github.com/vinanrra/Docker-7DaysToDie) - 使用イメージ
- [LinuxGSM 7DTD](https://docs.linuxgsm.com/game-servers/7-days-to-die) - 管理コマンド
- [Darkness Falls 公式](https://community.7daystodie.com/topic/4941-darkness-falls-they-mostly-come-out-at-night/)
- [7D2D Mod Launcher](https://7d2dmodlauncher.org/) - クライアント側
