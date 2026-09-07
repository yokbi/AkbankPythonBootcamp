#!/usr/bin/env bash
#
# run-mac-apple-silicon.sh — Pizza sipariş uygulamasını Apple Silicon Mac'te (arm64) çalıştırır.
# Intel Mac ve Linux'ta da aynen çalışır; ek bağımlılık yoktur.
#
# Kullanım:  ./run-mac-apple-silicon.sh
#
# UYARI: Program TC Kimlik No / kredi kartı / şifre sorar ve bunları düz metin
# olarak Orders_Database.csv dosyasına yazar. GERÇEK VERİ GİRMEYİN.
# Ayrıntı: DURUM-RAPORU.md §5, YAPILACAKLAR.md → G1

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

if ! command -v python3 >/dev/null 2>&1; then
  echo "HATA: python3 bulunamadı." >&2
  echo "  macOS: Xcode Command Line Tools kurun ->  xcode-select --install" >&2
  echo "  veya:  brew install python@3.11" >&2
  echo "  veya:  https://www.python.org/downloads/macos/ (Intel için universal2 .pkg)" >&2
  exit 1
fi

echo "==> $(python3 -V)"
echo "==> Bağımlılık gerekmiyor (yalnızca standart kütüphane)."
echo
echo "!!  UYARI: Sorulan TC / kart / şifre alanlarına UYDURMA değer girin."
echo "!!  Bu program bu bilgileri şifrelemeden Orders_Database.csv'ye yazar."
echo

exec python3 bootcamp.py
