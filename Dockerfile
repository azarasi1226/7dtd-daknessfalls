# ===========================================
# 7 Days to Die Dedicated Server + Darkness Falls
# Base: SteamCMD 公式イメージ（Ubuntu 22.04）
# ===========================================
FROM steamcmd/steamcmd:ubuntu-22

# 必要なパッケージ
RUN apt-get update && apt-get install -y \
      telnet \
      ca-certificates \
      tzdata \
      libxml2-utils \
      rsync \
    && rm -rf /var/lib/apt/lists/*

# タイムゾーンを東京に（ログ見やすくするため）
ENV TZ=Asia/Tokyo

# 非rootユーザーを作成（セキュリティのため）
RUN useradd -m -u 1000 -s /bin/bash steam

# ディレクトリ準備
RUN mkdir -p /home/steam/7dtd \
             /home/steam/.local/share/7DaysToDie \
             /home/steam/mods \
 && chown -R steam:steam /home/steam

# 起動スクリプトをコピー
COPY --chown=steam:steam entrypoint.sh /home/steam/entrypoint.sh
RUN chmod +x /home/steam/entrypoint.sh

USER steam
WORKDIR /home/steam

# ポート公開（ゲーム本体 + telnet管理 + Web管理）
# 26900: TCP/UDP ゲーム接続
# 26901, 26902: UDP 補助ポート
# 8081: telnet（リモート管理）
# 8080: Allocs Web管理パネル（任意）
EXPOSE 26900/tcp 26900/udp 26901/udp 26902/udp 8080/tcp 8081/tcp

ENTRYPOINT ["/home/steam/entrypoint.sh"]
