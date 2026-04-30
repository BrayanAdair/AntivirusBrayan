@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul 2>&1
title Antivirus BrayanAdair083
color 0A

:: ============================================================
::  VARIABLES GLOBALES
:: ============================================================
set "VERSION=2.1"
set "AUTOR=BrayanAdair083"
set "LOGFILE=%~dp0AV_log_%date:~-4,4%%date:~-7,2%%date:~0,2%.txt"
set "CUARENTENA=%~dp0Cuarentena"
set "AMENAZAS=0"
set "ELIMINADOS=0"
set "CUARENTENADOS=0"
set "RESTAURADOS=0"

:: Crear carpeta de cuarentena si no existe
if not exist "%CUARENTENA%" mkdir "%CUARENTENA%"

:: Iniciar log
echo ============================================================ >> "%LOGFILE%"
echo  Antivirus %AUTOR% v%VERSION% >> "%LOGFILE%"
echo  Fecha: %date%   Hora: %time% >> "%LOGFILE%"
echo ============================================================ >> "%LOGFILE%"

goto :MENU_PRINCIPAL

:: ============================================================
::  FUNCIONES DE PANTALLA
:: ============================================================
:LIMPIAR
cls
goto :EOF

:CABECERA
echo.
echo  +==============================================================+
echo  ^|   _____         _   _      _                    _           ^|
echo  ^|  ^|  _  ^|___ _ _^|_^|___^| ^|_ ^|_^|___ ^|___ ___   ___^| ^|         ^|
echo  ^|  ^|     ^|  _^| ^| ^| ^|  ^| '^| ^| ^|   ^|   ^|_ -^|  ^| ^|  . ^| . ^|       ^|
echo  ^|  ^|_^|_^|_^|_^| ^|_^|_^|_^|_^|_^|_^|_^|_^|_^|_^|___^|_^|_^|  ^|_^|_^|_^|         ^|
echo  ^|                                                            ^|
echo  ^|          ANTIVIRUS  %AUTOR%  v%VERSION%              ^|
echo  +==============================================================+
echo  ^|  Protegiendo tu equipo desde %date%              ^|
echo  +==============================================================+
goto :EOF

:BARRA_PROGRESO
:: Uso: call :BARRA_PROGRESO "Texto" porcentaje
set "TEXTO=%~1"
set /a "PORCENTAJE=%~2"
set /a "BLOQUES=!PORCENTAJE!/5"
set "BARRA="
for /l %%i in (1,1,20) do (
    if %%i LEQ !BLOQUES! (
        set "BARRA=!BARRA!█"
    ) else (
        set "BARRA=!BARRA!░"
    )
)
echo  ^| %-22s [!BARRA!] %~2%%
goto :EOF

:LOG
:: Uso: call :LOG "nivel" "mensaje"
set "NIVEL=%~1"
set "MSGG=%~2"
echo  [%time:~0,8%] [%NIVEL%] %MSGG% >> "%LOGFILE%"
if /i "%NIVEL%"=="AMENAZA"  echo  [!] AMENAZA  : %MSGG%
if /i "%NIVEL%"=="OK"       echo  [+] OK       : %MSGG%
if /i "%NIVEL%"=="INFO"     echo  [i] INFO     : %MSGG%
if /i "%NIVEL%"=="ACCION"   echo  [>] ACCION   : %MSGG%
if /i "%NIVEL%"=="WARN"     echo  [^!] AVISO    : %MSGG%
goto :EOF

:: ============================================================
::  MENU PRINCIPAL
:: ============================================================
:MENU_PRINCIPAL
call :LIMPIAR
call :CABECERA
echo.
echo  +==============================================================+
echo  ^|   MENU PRINCIPAL                                            ^|
echo  +==============================================================+
echo  ^|                                                              ^|
echo  ^|   [1]  Escaneo Rapido  (USB / unidad actual)                ^|
echo  ^|   [2]  Escaneo Completo (todas las unidades)                ^|
echo  ^|   [3]  Limpiar Procesos Maliciosos                          ^|
echo  ^|   [4]  Restaurar Archivos Ocultos                           ^|
echo  ^|   [5]  Ver Cuarentena                                       ^|
echo  ^|   [6]  Ver Log de sesion                                    ^|
echo  ^|   [7]  Actualizar Definiciones (online)                     ^|
echo  ^|   [0]  Salir                                                ^|
echo  ^|                                                              ^|
echo  +==============================================================+
echo.
set /p "OPCION=  Selecciona una opcion: "

if "%OPCION%"=="1" goto :ESCANEO_RAPIDO
if "%OPCION%"=="2" goto :ESCANEO_COMPLETO
if "%OPCION%"=="3" goto :MATAR_PROCESOS
if "%OPCION%"=="4" goto :RESTAURAR_OCULTOS
if "%OPCION%"=="5" goto :VER_CUARENTENA
if "%OPCION%"=="6" goto :VER_LOG
if "%OPCION%"=="7" goto :ACTUALIZAR
if "%OPCION%"=="0" goto :SALIR
goto :MENU_PRINCIPAL

:: ============================================================
::  MATAR PROCESOS MALICIOSOS
:: ============================================================
:MATAR_PROCESOS
call :LIMPIAR
call :CABECERA
echo.
echo  +==============================================================+
echo  ^|   TERMINANDO PROCESOS MALICIOSOS                           ^|
echo  +==============================================================+
echo.
call :LOG "INFO" "Iniciando eliminacion de procesos"

:: Lista de procesos maliciosos conocidos
set PROCS=fotos.exe 1024x900.exe Win2x.exe kavsrv.exe amvo.exe autorun.exe ^
          svchost32.exe svchosts.exe Svchosl.exe Javamachine.exe ^
          readme.exe wscript.exe cscript.exe smss32.exe lsass32.exe ^
          spoolsv32.exe csrss32.exe winlogon32.exe services32.exe ^
          AdobeR.exe bsplayer.exe RavMon.exe RavMonD.exe ^
          USBVirus.exe recycler.exe desktop_.exe folderopen.exe

for %%P in (%PROCS%) do (
    tasklist /FI "IMAGENAME eq %%P" 2>nul | find /i "%%P" >nul
    if not errorlevel 1 (
        taskkill /IM %%P /F >nul 2>&1
        set /a "AMENAZAS+=1"
        call :LOG "AMENAZA" "Proceso eliminado: %%P"
    )
)

echo.
echo  +--------------------------------------------------------------+
echo  ^|  Procesos analizados. Amenazas encontradas: !AMENAZAS!        ^|
echo  +--------------------------------------------------------------+
echo.
pause
goto :MENU_PRINCIPAL

:: ============================================================
::  RESTAURAR ARCHIVOS OCULTOS
:: ============================================================
:RESTAURAR_OCULTOS
call :LIMPIAR
call :CABECERA
echo.
echo  +==============================================================+
echo  ^|   RESTAURAR ARCHIVOS OCULTOS / CONFINADOS                  ^|
echo  +==============================================================+
echo.
set /p "UNIDAD=  Ingresa la letra de la unidad a restaurar (ej. D): "
set "RUTA=!UNIDAD!:\"

if not exist "!RUTA!" (
    echo  [!] La unidad !UNIDAD!: no existe.
    pause
    goto :MENU_PRINCIPAL
)

call :LOG "INFO" "Restaurando atributos en !RUTA!"
echo.
echo  [>] Quitando atributos Sistema, Oculto y Solo-Lectura...
attrib -s -h -r "!RUTA!*" /s /d >nul 2>&1
call :LOG "OK" "Atributos restaurados en !RUTA!"

:: Proteger archivos legitimos del sistema
attrib +h +s "!RUTA!System Volume Information" >nul 2>&1
attrib +h "!RUTA!$RECYCLE.BIN" >nul 2>&1

echo  [+] Atributos restaurados correctamente en !UNIDAD!:
echo  [i] System Volume Information y Recycle Bin re-protegidos.
echo.
pause
goto :MENU_PRINCIPAL

:: ============================================================
::  ESCANEO RAPIDO
:: ============================================================
:ESCANEO_RAPIDO
call :LIMPIAR
call :CABECERA
echo.
echo  +==============================================================+
echo  ^|   ESCANEO RAPIDO - Unidad actual y USB                     ^|
echo  +==============================================================+
echo.
set "AMENAZAS=0"
set "ELIMINADOS=0"
set "CUARENTENADOS=0"
call :LOG "INFO" "Iniciando escaneo rapido"

:: Primero matar procesos
call :MATAR_PROCESOS_SILENCIOSO

:: Escanear unidad actual
set "RUTA_SCAN=%~d0\"
call :ESCANEAR_RUTA "!RUTA_SCAN!"

echo.
echo  +--------------------------------------------------------------+
echo  ^|  RESUMEN DEL ESCANEO                                        ^|
echo  +--------------------------------------------------------------+
echo  ^|  Amenazas detectadas : !AMENAZAS!                              ^|
echo  ^|  Archivos eliminados : !ELIMINADOS!                            ^|
echo  ^|  En cuarentena       : !CUARENTENADOS!                         ^|
echo  +--------------------------------------------------------------+
call :LOG "INFO" "Escaneo finalizado. Amenazas: !AMENAZAS! Eliminados: !ELIMINADOS! Cuarentena: !CUARENTENADOS!"
echo.
pause
goto :MENU_PRINCIPAL

:: ============================================================
::  ESCANEO COMPLETO
:: ============================================================
:ESCANEO_COMPLETO
call :LIMPIAR
call :CABECERA
echo.
echo  +==============================================================+
echo  ^|   ESCANEO COMPLETO - Todas las unidades                    ^|
echo  +==============================================================+
echo.
set "AMENAZAS=0"
set "ELIMINADOS=0"
set "CUARENTENADOS=0"
call :LOG "INFO" "Iniciando escaneo completo"

call :MATAR_PROCESOS_SILENCIOSO

:: Escanear todas las unidades de C a Z
for %%D in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist %%D:\ (
        echo  [i] Escaneando unidad %%D:\...
        call :LOG "INFO" "Escaneando unidad %%D:\"
        call :ESCANEAR_RUTA "%%D:\"
        call :LIMPIAR_AUTORUN "%%D:\"
    )
)

:: Escanear carpetas criticas del sistema
echo  [i] Escaneando System32...
call :ESCANEAR_SISTEMA

echo.
echo  +--------------------------------------------------------------+
echo  ^|  RESUMEN ESCANEO COMPLETO                                   ^|
echo  +--------------------------------------------------------------+
echo  ^|  Amenazas detectadas : !AMENAZAS!                              ^|
echo  ^|  Archivos eliminados : !ELIMINADOS!                            ^|
echo  ^|  En cuarentena       : !CUARENTENADOS!                         ^|
echo  +--------------------------------------------------------------+
call :LOG "INFO" "Escaneo completo finalizado. Amenazas: !AMENAZAS! Eliminados: !ELIMINADOS!"
echo.
pause
goto :MENU_PRINCIPAL

:: ============================================================
::  SUBRUTINA: ESCANEAR UNA RUTA
:: ============================================================
:ESCANEAR_RUTA
set "RUTA_ACT=%~1"

:: --- Archivos maliciosos por nombre exacto ---
set MALWARE_LIST=fotos.exe 1024x900.exe Win2x.exe kavsrv.exe amvo.exe ^
    autorun.exe boot.vbs Knight.exe ndetect.exe ylr.exe rdsfk.com ^
    lilith.com winglogon.exe kk3.com kk3.bat kk3.cmd 9.cmd ^
    9yqusig.com 9yqusig.bat 9yqusig.cmd nfdmg.com nfdmg.cmd nfdmg.bat ^
    f0.com f0.bat f0.cmd yew.cmd yew.bat yew.com otyh.com otyh.bat otyh.cmd ^
    bsu.dat 08dgu.com 08dgu.cmd 08dgu.bat d6fagcs8.cmd jfvkcsy.bat ^
    3wcxx91.cmd 2ifetri.cmd qd.cmd h.cmd comine.exe RavMon.exe RavMonD.exe ^
    AdobeR.exe smss32.exe lsass32.exe spoolsv32.exe desktop_.exe ^
    folderopen.exe USBVirus.exe svchost32.exe svchosts.exe

for %%M in (%MALWARE_LIST%) do (
    if exist "!RUTA_ACT!%%M" (
        set /a "AMENAZAS+=1"
        call :LOG "AMENAZA" "Encontrado: !RUTA_ACT!%%M"
        call :PONER_CUARENTENA "!RUTA_ACT!%%M" "%%M"
    )
)

:: --- Archivos .doc.exe, .jpg.exe, .pdf.exe (doble extension) ---
for %%E in (".doc.exe" ".jpg.exe" ".jpeg.exe" ".pdf.exe" ".mp3.exe" ".mp4.exe" ".txt.exe" ".xls.exe" ".rar.exe") do (
    for /r "!RUTA_ACT!" %%F in (*%%~E) do (
        set /a "AMENAZAS+=1"
        call :LOG "AMENAZA" "Doble extension: %%F"
        call :PONER_CUARENTENA "%%F" "%%~nxF"
    )
)

:: --- Autorun.inf sospechoso ---
if exist "!RUTA_ACT!autorun.inf" (
    findstr /i /c:"open=" /c:"shell=" /c:"shellexecute=" "!RUTA_ACT!autorun.inf" >nul 2>&1
    if not errorlevel 1 (
        set /a "AMENAZAS+=1"
        call :LOG "AMENAZA" "AutoRun malicioso: !RUTA_ACT!autorun.inf"
        call :PONER_CUARENTENA "!RUTA_ACT!autorun.inf" "autorun.inf"
    )
)

:: --- Carpetas RECYCLER / Recycled sospechosas con ejecutables ---
for %%R in (RECYCLER Recycled $Recycle.Bin) do (
    if exist "!RUTA_ACT!%%R\" (
        for /r "!RUTA_ACT!%%R\" %%F in (*.exe *.com *.bat *.vbs *.cmd) do (
            set /a "AMENAZAS+=1"
            call :LOG "AMENAZA" "Ejecutable en Recycler: %%F"
            call :PONER_CUARENTENA "%%F" "%%~nxF"
        )
    )
)

:: --- Archivos .vbs sospechosos en raiz ---
for %%F in ("!RUTA_ACT!*.vbs") do (
    set /a "AMENAZAS+=1"
    call :LOG "WARN" "VBS en raiz de unidad: %%F"
    call :PONER_CUARENTENA "%%F" "%%~nxF"
)

goto :EOF

:: ============================================================
::  SUBRUTINA: LIMPIAR AUTORUN EN UNA UNIDAD
:: ============================================================
:LIMPIAR_AUTORUN
set "UNID=%~1"
attrib -s -h -r "!UNID!autorun.inf" >nul 2>&1
if exist "!UNID!autorun.inf" (
    del /f /q "!UNID!autorun.inf" >nul 2>&1
    call :LOG "ACCION" "AutoRun eliminado en !UNID!"
    set /a "ELIMINADOS+=1"
)
goto :EOF

:: ============================================================
::  SUBRUTINA: ESCANEAR SYSTEM32
:: ============================================================
:ESCANEAR_SISTEMA
set SYSTEM_MALWARE=Javamachine.exe Win2x.exe amvo.exe readme.exe ^
    Svchosl.exe Kavsrv.exe smss32.exe lsass32.exe spoolsv32.exe

for %%S in (%SYSTEM_MALWARE%) do (
    if exist "%systemroot%\system32\%%S" (
        set /a "AMENAZAS+=1"
        call :LOG "AMENAZA" "Malware en System32: %%S"
        attrib -s -h -r "%systemroot%\system32\%%S" >nul 2>&1
        del /f /q "%systemroot%\system32\%%S" >nul 2>&1
        if errorlevel 1 (
            call :LOG "WARN" "No se pudo eliminar (puede requerir permisos de admin): %%S"
        ) else (
            set /a "ELIMINADOS+=1"
            call :LOG "ACCION" "Eliminado de System32: %%S"
        )
    )
    if exist "%systemroot%\%%S" (
        set /a "AMENAZAS+=1"
        call :LOG "AMENAZA" "Malware en Windows root: %%S"
        del /f /q "%systemroot%\%%S" >nul 2>&1
        set /a "ELIMINADOS+=1"
    )
)
goto :EOF

:: ============================================================
::  SUBRUTINA: PONER EN CUARENTENA
:: ============================================================
:PONER_CUARENTENA
:: %1 = ruta completa del archivo, %2 = nombre del archivo
set "ARCHIVO=%~1"
set "NOMBRE=%~2"
set "DESTINO=%CUARENTENA%\%NOMBRE%_%time:~0,2%%time:~3,2%%time:~6,2%.quar"

attrib -s -h -r "!ARCHIVO!" >nul 2>&1

:: Intentar mover a cuarentena primero
move /y "!ARCHIVO!" "!DESTINO!" >nul 2>&1
if not errorlevel 1 (
    set /a "CUARENTENADOS+=1"
    call :LOG "ACCION" "En cuarentena: !NOMBRE! -> !DESTINO!"
) else (
    :: Si no se puede mover, eliminar directamente
    del /f /q "!ARCHIVO!" >nul 2>&1
    if not errorlevel 1 (
        set /a "ELIMINADOS+=1"
        call :LOG "ACCION" "Eliminado directamente: !NOMBRE!"
    ) else (
        call :LOG "WARN" "No se pudo procesar: !NOMBRE! (requiere admin)"
    )
)
goto :EOF

:: ============================================================
::  SUBRUTINA: MATAR PROCESOS (SILENCIOSO)
:: ============================================================
:MATAR_PROCESOS_SILENCIOSO
set PROCS_S=fotos.exe 1024x900.exe Win2x.exe kavsrv.exe amvo.exe ^
    autorun.exe Svchosl.exe Javamachine.exe readme.exe ^
    smss32.exe lsass32.exe spoolsv32.exe csrss32.exe ^
    AdobeR.exe RavMon.exe RavMonD.exe Knight.exe ylr.exe ndetect.exe ^
    USBVirus.exe desktop_.exe folderopen.exe comine.exe

for %%P in (%PROCS_S%) do (
    taskkill /IM %%P /F >nul 2>&1
)
goto :EOF

:: ============================================================
::  VER CUARENTENA
:: ============================================================
:VER_CUARENTENA
call :LIMPIAR
call :CABECERA
echo.
echo  +==============================================================+
echo  ^|   ARCHIVOS EN CUARENTENA                                   ^|
echo  +==============================================================+
echo.
if not exist "%CUARENTENA%\*.*" (
    echo  [i] La cuarentena esta vacia.
) else (
    echo  Archivos en cuarentena:
    echo.
    dir /b "%CUARENTENA%\" 2>nul
    echo.
    echo  Ubicacion: %CUARENTENA%
    echo.
    set /p "RESP=  Deseas eliminar todo el contenido de la cuarentena? (S/N): "
    if /i "!RESP!"=="S" (
        del /f /q "%CUARENTENA%\*.*" >nul 2>&1
        call :LOG "ACCION" "Cuarentena vaciada manualmente"
        echo  [+] Cuarentena eliminada.
    )
)
echo.
pause
goto :MENU_PRINCIPAL

:: ============================================================
::  VER LOG
:: ============================================================
:VER_LOG
call :LIMPIAR
call :CABECERA
echo.
echo  +==============================================================+
echo  ^|   LOG DE SESION: %LOGFILE%
echo  +==============================================================+
echo.
if exist "%LOGFILE%" (
    type "%LOGFILE%"
) else (
    echo  [i] Aun no hay actividad registrada en esta sesion.
)
echo.
pause
goto :MENU_PRINCIPAL

:: ============================================================
::  ACTUALIZAR DEFINICIONES (placeholder)
:: ============================================================
:ACTUALIZAR
call :LIMPIAR
call :CABECERA
echo.
echo  +==============================================================+
echo  ^|   ACTUALIZAR DEFINICIONES                                  ^|
echo  +==============================================================+
echo.
echo  [i] Verificando conexion a internet...
ping -n 1 google.com >nul 2>&1
if errorlevel 1 (
    echo  [!] Sin conexion a internet. No se puede actualizar.
    call :LOG "WARN" "Intento de actualizacion fallido - sin conexion"
) else (
    echo  [+] Conexion disponible.
    echo  [i] Funcion de actualizacion automatica en desarrollo.
    echo  [i] Descarga la ultima version en:
    echo.
    echo      https://github.com/BrayanAdair/AntivirusBrayan
    echo.
    echo  [i] Abre el link en tu navegador para ver la version mas reciente.
    set /p "ABRIR=  Abrir en el navegador ahora? (S/N): "
    if /i "!ABRIR!"=="S" start https://github.com/BrayanAdair/AntivirusBrayan
    call :LOG "INFO" "Actualizacion manual requerida - visitar github"
)
echo.
pause
goto :MENU_PRINCIPAL

:: ============================================================
::  SALIR
:: ============================================================
:SALIR
call :LIMPIAR
call :CABECERA
echo.
echo  +==============================================================+
echo  ^|   RESUMEN FINAL DE SESION                                  ^|
echo  +==============================================================+
echo  ^|  Amenazas detectadas : !AMENAZAS!                              ^|
echo  ^|  Archivos eliminados : !ELIMINADOS!                            ^|
echo  ^|  En cuarentena       : !CUARENTENADOS!                         ^|
echo  ^|  Log guardado en     : %LOGFILE%     ^|
echo  +==============================================================+
echo.
echo  Gracias por usar Antivirus %AUTOR% v%VERSION%
echo.
call :LOG "INFO" "Sesion finalizada. Total amenazas: !AMENAZAS!"
timeout /t 3 >nul
exit