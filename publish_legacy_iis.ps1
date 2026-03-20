# Script para publicar api-credit-legacy a IIS local (C:\inetpub\wwwroot\api-credit-legacy)
# IMPORTANTE: Ejecute PowerShell como Administrador

$SourceDir = "d:\Proyectos\Credit_Core_Work_Space\api-credit-legacy\ctPaga"
$PublishedDir = "d:\Proyectos\Credit_Core_Work_Space\api-credit-legacy-published"
$DestDir = "C:\inetpub\wwwroot\api-credit-legacy"

Write-Host "Iniciando publicación de api-credit-legacy..." -ForegroundColor Cyan

# Comprobrar si el origen existe
if (-not (Test-Path $SourceDir)) {
    Write-Error "No se encontró el directorio de origen: $SourceDir"
    exit
}

# Comprobar/Crear el directorio de destino
if (-not (Test-Path $DestDir)) {
    Write-Host "Creando el directorio de destino: $DestDir"
    New-Item -ItemType Directory -Path $DestDir -Force | Out-Null
} else {
    Write-Host "Limpiando el directorio de destino existente..."
    # Limpiamos con precaución: mantenemos la carpeta raíz para no romper el binding en IIS
    Get-ChildItem -Path $DestDir | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
}

# Sincronizar archivos esenciales
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

foreach ($item in $ItemsToCopy) {
    $srcPath = Join-Path $SourceDir $item
    if (Test-Path $srcPath) {
        Write-Host "Copiando $item..." -ForegroundColor Yellow
        Copy-Item -Path $srcPath -Destination $DestDir -Recurse -Force
    } else {
        Write-Host "Aviso: No se encontró el elemento $item, se omitirá." -ForegroundColor DarkYellow
    }
}

Write-Host "Publicación completada exitosamente en: $DestDir" -ForegroundColor Green
Write-Host "Recuerde verificar que el Application Pool en IIS use .NET CLR v4.0." -ForegroundColor Cyan
