# ベースイメージにRocky Linux 9を使用
FROM rockylinux:9

# 必要な基本ツールとSQLiteのインストール
RUN dnf update -y
RUN dnf install git -y
RUN dnf install sqlite -y
RUN dnf install sqlite-devel -y
RUN dnf install wget -y
RUN dnf install gcc -y
RUN dnf install make -y
RUN dnf install tar -y
RUN dnf install golang -y
RUN go install github.com/asdf-vm/asdf/cmd/asdf@v0.19.0
RUN dnf install -y \
    autoconf \
    ncurses-devel
# 4. asdfに必要なデータディレクトリと、goバイナリがある場所を「絶対パス」で確実にPATHへ追加
ENV ASDF_DATA_DIR="/root/.asdf"
ENV PATH="/go/bin:/root/go/bin:${ASDF_DATA_DIR}/shims:${PATH}"

# 5. バージョン確認 (これで exit 127 が解消されます)
RUN asdf version

RUN asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git
RUN asdf plugin add rebar https://github.com/Stratus3D/asdf-rebar.git
RUN asdf plugin add gleam https://github.com/vic/asdf-gleam.git

RUN asdf set -u erlang latest
RUN asdf set -u rebar latest
RUN asdf set -u gleam latest

RUN asdf install

RUN gleam --version

# 作業ディレクトリの設定
WORKDIR /app
# コンテナが勝手に終了しないようにシェルを維持する設定
CMD ["/bin/bash"]
