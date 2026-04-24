# Script para publicar api-credit-legacy a IIS local (C:\inetpub\wwwroot\api-credit-legacy)
# IMPORTANTE: Ejecute PowerShell como Administrador

# 1. Verificar elevación
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Elevando privilegios para realizar cambios en IIS..." -ForegroundColor Yellow
    $arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    Start-Process powershell -ArgumentList $arguments -Verb RunAs
    exit
}

$SourceDir = "d:\Proyectos\Credit_Core_Work_Space\api-credit-legacy\ctPaga"
$DestDir = "C:\inetpub\wwwroot\api-credit-legacy"
$AppOfflineFile = Join-Path $DestDir "app_offline.htm"

Write-Host "Iniciando publicación de api-credit-legacy..." -ForegroundColor Cyan

# 2. Asegurar que el destino existe
if (-not (Test-Path $DestDir)) {
    Write-Host "Creando el directorio de destino: $DestDir"
    New-Item -ItemType Directory -Path $DestDir -Force | Out-Null
}

# 3. Poner la aplicación fuera de línea para liberar locks en DLLs
Write-Host "Poniendo la aplicación fuera de línea (app_offline.htm)..." -ForegroundColor Yellow
$offlineHtml = "<html><head><meta charset='UTF-8'></head><body><div style='font-family:sans-serif;text-align:center;margin-top:50px;'><h1>Sistema en Mantenimiento</h1><p>Estamos publicando una nueva versión. Por favor, espere unos segundos.</p></div></body></html>"
$offlineHtml | Out-File -FilePath $AppOfflineFile -Encoding UTF8 -Force

# Darle un momento a IIS para que procese el app_offline y libere los archivos
Write-Host "Esperando liberación de archivos..."
Start-Sleep -Seconds 3

# 4. Limpieza del directorio (excepto archivos estáticos grandes si se desea, pero aquí limpiamos bin y config)
Write-Host "Limpiando archivos antiguos..."
# Intentamos borrar recursivamente. Si falla algún archivo bloqueado, informamos.
Get-ChildItem -Path $DestDir -Exclude "app_offline.htm" | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

# 5. Sincronizar archivos esenciales
$ItemsToCopy = @(
    "bin",
    "Views",
    "Areas",
    "Content",
    "fonts",
    "Scripts",
    "Global.asax",
    "Web.config",
    "appSettings.secrets.config",
    "connectionStrings.secrets.config"
)

$allCopied = $true
foreach ($item in $ItemsToCopy) {
    $srcPath = Join-Path $SourceDir $item
    if (Test-Path $srcPath) {
        Write-Host "Copiando $item..." -ForegroundColor Yellow
        try {
            Copy-Item -Path $srcPath -Destination $DestDir -Recurse -Force -ErrorAction Stop
        } catch {
            Write-Host "Error al copiar ${item}: $($_.Exception.Message)" -ForegroundColor Red
            $allCopied = $false
        }
    } else {
        Write-Host "Aviso: No se encontró el origen para $item, se omitirá." -ForegroundColor DarkYellow
    }
}

# 6. Poner la aplicación en línea nuevamente
Write-Host "Poniendo la aplicación en línea..." -ForegroundColor Yellow
if (Test-Path $AppOfflineFile) {
    Remove-Item -Path $AppOfflineFile -Force
}

if ($allCopied) {
    Write-Host "`nPublicación completada exitosamente en: $DestDir" -ForegroundColor Green
    Write-Host "Recuerde verificar que el Application Pool en IIS use .NET CLR v4.0 e Integrated Pipeline." -ForegroundColor Cyan
} else {
    Write-Host "`nLa publicación finalizó con algunos errores. Revise los mensajes anteriores." -ForegroundColor Red
}
