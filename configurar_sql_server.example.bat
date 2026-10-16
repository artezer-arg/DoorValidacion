@echo off
rem Copiar a configurar_sql_server.bat y editar localmente. No compartir credenciales.
set MSSQL_SERVER=HILO-000
set MSSQL_DATABASE=TB-L
set MSSQL_PORT=1433
set MSSQL_USER=USUARIO_SOLO_LECTURA
set MSSQL_PASSWORD=REEMPLAZAR_LOCALMENTE
set MSSQL_ENCRYPT=true
set MSSQL_TRUST_CERTIFICATE=false
rem Ejecutar en la misma consola: call configurar_sql_server.bat
rem Luego ejecutar iniciar_puesto_dl06.bat en esa consola.
