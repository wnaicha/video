@echo off
:: 强行切换本地黑框框为 UTF-8 编码，完美兼容云端拉取下来的中文
chcp 65001 >nul
title YouTube 顶级画质全自动流水线 (云端托管版)
color 0B

echo ==========================================
echo 正在初始化运行环境，请稍候...
echo ==========================================
echo.

:: 1. 自动检测并配置 yt-dlp
if not exist "yt-dlp.exe" (
    echo [状态] 未找到 yt-dlp.exe，正在自动拉取最新版...
    curl -L -o yt-dlp.exe https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe
    echo yt-dlp 下载完成！
) else (
    echo [状态] yt-dlp 已存在，正在静默检测官方最新版本...
    yt-dlp -U
)
echo.

:: 2. 自动检测 ffmpeg (从你的专属云端拉取)
if not exist "ffmpeg.exe" (
    echo [状态] 未找到 ffmpeg.exe，正在从专属云端自动拉取...
    curl -L -o ffmpeg.exe "https://github.com/wnaicha/video/releases/download/video/ffmpeg.exe"
    echo ffmpeg 下载完成！
)
echo.
echo 所有核心环境就绪！

:MENU
color 0B
cls
echo ==========================================
echo YouTube 顶级画质下载流水线
echo ==========================================
echo.
echo  [1] 单个链接下载 (连续右键粘贴模式)
echo  [2] 批量文件下载 (自动读取 links.txt)
echo  [3] 退出程序
echo.
set /p choice="请选择操作模式 (输入 1, 2 或 3 并按回车): "

if "%choice%"=="1" goto SINGLE
if "%choice%"=="2" goto BATCH
:: 核心修复：这里必须使用 exit /b，代表温和退出当前模块，把控制权还给本地启动器去执行删除命令
if "%choice%"=="3" exit /b
goto MENU

:SINGLE
cls
echo ==========================================
echo 单链接下载模式 (支持连续右键粘贴)
echo ==========================================
echo.

:SINGLE_LOOP
set /p url="请右键粘贴视频链接 (输入 b 返回主菜单): "
if /i "%url%"=="b" goto MENU
if "%url%"=="" goto SINGLE_LOOP

echo.
echo 正在全速抓取最高画质原盘，请耐心稍候...
yt-dlp -f "bestvideo+bestaudio/best" --merge-output-format mkv "%url%"
echo.
echo [OK] 当前视频下载合并完毕！
echo ------------------------------------------
echo.
goto SINGLE_LOOP

:BATCH
cls
echo ==========================================
echo 批量下载模式
echo ==========================================
echo.
if not exist "links.txt" (
    type nul > links.txt
    echo [提示] 尚未发现 links.txt 文件，已为你自动创建。
    echo 请打开当前文件夹下的 links.txt，把需要下载的链接一行一个粘贴进去。
    echo 保存并关闭文档后，按任意键继续执行批量下载！
    echo.
    pause
)

echo 正在读取 links.txt 中的链接并开始排队下载...
yt-dlp -f "bestvideo+bestaudio/best" --merge-output-format mkv -a links.txt
echo.
echo 批量下载任务全部完成！
pause
goto MENU