@echo off
REM Publica / actualizeaza site-ul pe GitHub (stefan1202/cerere-modificare-persoane) folosind cheia SSH din acest calculator.
cd /d "%~dp0"
git rev-parse --is-inside-work-tree >nul 2>nul
if errorlevel 1 (
  if exist .git rmdir /s /q .git
  git init
  git branch -M main
  git remote add origin git@github.com:stefan1202/cerere-modificare-persoane.git
)
git add -A
git diff --cached --quiet && (echo Nicio modificare de publicat.) || git commit -m "Actualizare site cerere modificare numar persoane"
git push -u origin main
if errorlevel 1 (echo. & echo Push-ul a esuat. Verificati ca repo-ul github.com/stefan1202/cerere-modificare-persoane exista si ca aveti cheia SSH configurata. & pause & exit /b 1)
where gh >nul 2>nul && gh api -X POST repos/stefan1202/cerere-modificare-persoane/pages -f "source[branch]=main" -f "source[path]=/" >nul 2>nul && echo GitHub Pages activat.
echo.
echo Gata. Site-ul: https://stefan1202.github.io/cerere-modificare-persoane/
pause
