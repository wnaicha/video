@echo off
title YouTube/TikTok Auto Downloader
color 0B

echo ==========================================
echo [System] Initializing environment...
echo ==========================================
echo.

if exist "yt-dlp.exe" goto CHECK_UPDATE
echo [Status] yt-dlp.exe not found, downloading...
curl -L -o yt-dlp.exe https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe
echo [OK] yt-dlp downloaded!
goto CHECK_FFMPEG

:CHECK_UPDATE
echo [Status] Checking for yt-dlp updates...
yt-dlp -U

:CHECK_FFMPEG
if exist "ffmpeg.exe" goto READY
echo [Status] ffmpeg.exe not found, downloading from cloud...
curl -L -o ffmpeg.exe "https://github.com/wnaicha/video/releases/download/video/ffmpeg.exe"
echo [OK] ffmpeg downloaded!

:READY
echo.
echo [System] All core components are ready!

:MENU
color 0B
cls
echo ==========================================
echo    Ultimate Auto Downloader Pipeline
echo ==========================================
echo.
echo  [1] Single Link Download (Paste Mode)
echo  [2] Batch Download (Read links.txt)
echo  [3] Exit
echo.
set /p choice="Select mode (1, 2, or 3) and press Enter: "

if "%choice%"=="1" goto SINGLE
if "%choice%"=="2" goto BATCH
if "%choice%"=="3" exit /b
goto MENU

:SINGLE
cls
echo ==========================================
echo    Single Link Mode
echo ==========================================
echo.

:SINGLE_LOOP
set /p url="Paste video URL (type 'b' to return): "
if /i "%url%"=="b" goto MENU
if "%url%"=="" goto SINGLE_LOOP

echo.
echo [Status] Fetching highest quality video...
yt-dlp -f "bestvideo+bestaudio/best" --merge-output-format mkv "%url%"
echo.
echo [OK] Download task completed!
echo ------------------------------------------
echo.
goto SINGLE_LOOP

:BATCH
cls
echo ==========================================
echo    Batch Download Mode
echo ==========================================
echo.
if exist "links.txt" goto BATCH_START
type nul > links.txt
echo [Notice] links.txt not found. A new one has been created.
echo Please open links.txt, paste your URLs (one per line),
echo save the file, and then press any key to continue!
echo.
pause

:BATCH_START
echo [Status] Reading links.txt and starting queue...
yt-dlp -f "bestvideo+bestaudio/best" --merge-output-format mkv -a links.txt
echo.
echo [OK] All batch downloads completed!
pause
goto MENU
