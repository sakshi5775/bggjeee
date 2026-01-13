@echo off
cd /d "E:\astro_user_app-astro-user-new\astro_user_app-astro-user-new"

:: Create timestamp
for /f "tokens=1-4 delims=/ " %%a in ("%date%") do (
    set dd=%%a
    set mm=%%b
    set yy=%%c
)
for /f "tokens=1-2 delims=: " %%a in ("%time%") do (
    set hh=%%a
    set min=%%b
)

set timestamp=%yy%%mm%%dd%_%hh%%min%
set branchName=auto-backup-new

:: Create and checkout new branch
git checkout -b %branchName%

:: Add, commit and push changes
git add .
git commit -m "Auto backup at %timestamp%"
git push -u origin %branchName%
