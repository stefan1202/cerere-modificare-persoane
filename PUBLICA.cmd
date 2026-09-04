@echo off
REM Publica site-ul pe GitHub (stefan1202/cerere-modificare-persoane) folosind cheia SSH din acest calculator.
cd /d "%~dp0"
if exist .git rmdir /s /q .git
git init
git add -A
git commit -m "Formular online cerere modificare numar persoane (GitHub Pages)"
git branch -M main
git remote add origin git@github.com:stefan1202/cerere-modificare-persoane.git
git push -u origin main
if errorlevel 1 (echo. & echo Push-ul a esuat. Verificati ca repo-ul github.com/stefan1202/cerere-modificare-persoane exista si ca aveti cheia SSH configurata. & pause & exit /b 1)
where gh >nul 2>nul && gh api -X POST repos/stefan1202/cerere-modificare-persoane/pages -f "source[branch]=main" -f "source[path]=/" >nul 2>nul && echo GitHub Pages activat.
echo.
echo Gata. Site-ul va fi disponibil in 1-2 minute la https://stefan1202.github.io/cerere-modificare-persoane/
pause
