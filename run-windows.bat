@echo off
REM run-windows.bat - Pizza siparis uygulamasini Windows'ta calistirir.
REM Kullanim: run-windows.bat   (veya cift tiklayin)
REM
REM UYARI: Program TC Kimlik No / kredi karti / sifre sorar ve bunlari duz metin
REM olarak Orders_Database.csv dosyasina yazar. GERCEK VERI GIRMEYIN.
REM Ayrinti: DURUM-RAPORU.md ve YAPILACAKLAR.md (G1)

setlocal
cd /d "%~dp0"

where python >nul 2>&1
if errorlevel 1 (
  echo HATA: python bulunamadi.
  echo   https://www.python.org/downloads/windows/ adresinden Python 3 kurun.
  echo   Kurulumda "Add python.exe to PATH" kutusunu isaretleyin.
  pause
  exit /b 1
)

python -V
echo.
echo ==^> Bagimlilik gerekmiyor ^(yalnizca standart kutuphane^).
echo.
echo !!  UYARI: Sorulan TC / kart / sifre alanlarina UYDURMA deger girin.
echo !!  Bu program bu bilgileri sifrelemeden Orders_Database.csv'ye yazar.
echo.

python bootcamp.py
echo.
pause
