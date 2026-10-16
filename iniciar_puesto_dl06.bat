@echo off
setlocal
cd /d "%~dp0"
where node >nul 2>nul
if errorlevel 1 (echo Instale Node.js 22.13 o superior. & pause & exit /b 1)
node -e "const v=process.versions.node.split('.').map(Number);process.exit(v[0]>22||(v[0]===22&&v[1]>=13)?0:1)"
if errorlevel 1 (echo Se requiere Node.js 22.13 o superior. & pause & exit /b 1)
if not exist dist\index.js (echo Falta compilacion. Ejecute npm install y npm run build. & pause & exit /b 1)
node -e "for(const name of ['express','socket.io','mssql'])require.resolve(name)" >nul 2>nul
if errorlevel 1 (
 call npm install --omit=dev
 if errorlevel 1 (pause & exit /b 1)
)
if exist configurar_sql_server.bat call configurar_sql_server.bat
node -e "fetch('http://localhost:3002/api/health').then(r=>process.exit(r.ok?0:1)).catch(()=>process.exit(1))" >nul 2>nul
if not errorlevel 1 (
 echo Ya hay un servidor en el puerto 3002. Cierre la ventana DL06 servidor anterior.
 echo Vuelva a ejecutar este archivo para usar la version actualizada.
 pause
 exit /b 1
)
start "DL06 servidor" cmd /k "node dist/index.js"
for /l %%i in (1,1,30) do (
 node -e "fetch('http://localhost:3002/api/health').then(r=>process.exit(r.ok?0:1)).catch(()=>process.exit(1))" >nul 2>nul
 if not errorlevel 1 goto ready
 timeout /t 1 /nobreak >nul
)
echo El servidor no respondio. Revise la ventana del servidor.
pause
exit /b 1
:ready
start "" http://localhost:3002
