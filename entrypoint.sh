#!/bin/bash
set -e

echo "========================================"
echo " 7 Days to Die Dedicated Server (Docker)"
echo " + Darkness Falls Support"
echo "========================================"

STEAMCMD_DIR="/home/steam"
SERVER_DIR="/home/steam/7dtd"
MODS_SRC="/home/steam/mods"          # ホストから渡されるModフォルダ（読み取り）
MODS_DST="${SERVER_DIR}/Mods"        # サーバー側Modsフォルダ
CONFIG_SRC="/home/steam/config/serverconfig.xml"
CONFIG_DST="${SERVER_DIR}/serverconfig.xml"

# ----- 1. 7DTDサーバーのインストール/更新 -----
# SKIP_UPDATE=1 にすると更新をスキップ（起動を早くできる）
if [ "${SKIP_UPDATE}" != "1" ]; then
  echo "[1/4] SteamCMDで7DTDサーバーを更新中..."
  # App ID 294420 = 7 Days to Die Dedicated Server
  steamcmd \
    +force_install_dir "${SERVER_DIR}" \
    +login anonymous \
    +app_update 294420 validate \
    +quit
else
  echo "[1/4] サーバー更新をスキップ（SKIP_UPDATE=1）"
fi

# ----- 2. Modの同期 -----
echo "[2/4] Modを同期中..."
mkdir -p "${MODS_DST}"
if [ -d "${MODS_SRC}" ] && [ "$(ls -A ${MODS_SRC} 2>/dev/null)" ]; then
  # rsyncでModsフォルダを同期（--deleteで古いModも掃除）
  rsync -a --delete "${MODS_SRC}/" "${MODS_DST}/"
  echo "   → $(ls ${MODS_DST} | wc -l) 個のModを同期しました"
else
  echo "   → Modフォルダは空です（バニラで起動）"
fi

# ----- 3. 設定ファイルの配置 -----
echo "[3/4] serverconfig.xml を配置..."
if [ -f "${CONFIG_SRC}" ]; then
  cp "${CONFIG_SRC}" "${CONFIG_DST}"
  echo "   → カスタム設定を適用しました"
else
  echo "   → カスタム設定なし、デフォルトを使用"
fi

# ----- 4. サーバー起動 -----
echo "[4/4] サーバーを起動します..."
echo "========================================"
cd "${SERVER_DIR}"

# EACを無効化してDarkness Fallsを動作させる
exec ./7DaysToDieServer.x86_64 \
  -logfile /dev/stdout \
  -quit \
  -batchmode \
  -nographics \
  -dedicated \
  -configfile=serverconfig.xml
