#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/pjasicek/OpenClaw.git"
REPO_BRANCH="master"
TARGET_DIR="$HOME/openclaw"
BUILD_DIR_NAME="build"

usage() {
  cat <<USAGE
Usage: $0 [options]

Options:
  --repo <url>      OpenClaw git repository URL
  --branch <name>   Git branch/tag to checkout (default: master)
  --dir <path>      Target directory for source code (default: ~/openclaw)
  -h, --help        Show this help
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo)
      REPO_URL="$2"
      shift 2
      ;;
    --branch)
      REPO_BRANCH="$2"
      shift 2
      ;;
    --dir)
      TARGET_DIR="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1"
      usage
      exit 1
      ;;
  esac
done

if ! command -v sudo >/dev/null 2>&1; then
  echo "[ERROR] sudo is required but not found."
  exit 1
fi

if [[ ! -f /etc/debian_version ]]; then
  echo "[ERROR] This script currently supports Debian/Ubuntu only."
  exit 1
fi

echo "[INFO] Installing required packages..."
sudo apt-get update
sudo apt-get install -y \
  git cmake build-essential pkg-config \
  libsdl2-dev libsdl2-image-dev libsdl2-mixer-dev libsdl2-ttf-dev \
  libgl1-mesa-dev libglu1-mesa-dev libx11-dev zlib1g-dev

if [[ -d "$TARGET_DIR/.git" ]]; then
  echo "[INFO] Existing git repo detected in $TARGET_DIR, pulling latest changes..."
  git -C "$TARGET_DIR" fetch --all --tags
  git -C "$TARGET_DIR" checkout "$REPO_BRANCH"
  git -C "$TARGET_DIR" pull --ff-only
else
  echo "[INFO] Cloning OpenClaw source into $TARGET_DIR..."
  git clone --depth 1 --branch "$REPO_BRANCH" "$REPO_URL" "$TARGET_DIR"
fi

BUILD_DIR="$TARGET_DIR/$BUILD_DIR_NAME"
mkdir -p "$BUILD_DIR"

echo "[INFO] Configuring with CMake..."
cmake -S "$TARGET_DIR" -B "$BUILD_DIR" -DCMAKE_BUILD_TYPE=Release

echo "[INFO] Building..."
cmake --build "$BUILD_DIR" -j"$(nproc)"

echo

echo "[SUCCESS] OpenClaw build completed."
echo "[NEXT] Put your legally obtained Captain Claw game assets according to upstream README."
echo "[NEXT] Then run the game executable from: $BUILD_DIR"
