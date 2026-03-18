param(
    [Parameter(Mandatory=$true)][string]$TargetName,
    [string]$Env = "test"
)

# Cargar librería común
. "$PSScriptRoot/common-lib.ps1"

try {
    Write-Host "`n🎨 Iniciando despliegue de UI: $TargetName en entorno: $Env" -ForegroundColor Magenta
    
    # 1. Cargar Configuración
    $environments = Get-Config "environments"
    $targets = Get-Config "targets"
    
    $target = $targets.targets.$TargetName
    $envConfig = $environments.environments.$Env
    
    if (!$target) { throw "El target '$TargetName' no está definido en targets.json" }
    if (!$envConfig) { throw "El entorno '$Env' no está definido en environments.json" }

    # 2. Rutas
    $rootWorkspace = "$PSScriptRoot/../../.."
    $fullProjectPath = Join-Path $rootWorkspace $target.projectPath
    
    # 3. Build Angular
    Write-Host "`n🛠️ Ejecutando Build de Angular..." -ForegroundColor Cyan
    Set-Location $fullProjectPath
    
    if ($target.type -eq "angular-legacy") {
        Write-Host "📜 Usando Node 14 para proyecto legacy..." -ForegroundColor Gray
        nvm use 14.17.3
    }

    npm run build -- --configuration=$Env
    
    if ($LASTEXITCODE -ne 0) { throw "Error en el build de npm" }

    # Detectar carpeta de salida real (Angular suele ser dist/[project] o dist/[project]/browser)
    $distBase = Join-Path $fullProjectPath "dist"
    $distPath = Join-Path $distBase $TargetName
    if (!(Test-Path $distPath)) {
        $subFolder = Get-ChildItem -Path $distBase -Directory | Select-Object -First 1
        if ($subFolder) { $distPath = $subFolder.FullName }
    }
    $browserPath = Join-Path $distPath "browser"
    if (Test-Path $browserPath) { $distPath = $browserPath }

    # Carpeta centralizada para el historial de build
    $buildsBase = Join-Path $rootWorkspace ".tools/builds"
    $centralPublishPath = Join-Path $buildsBase $TargetName

    # Limpiar y preparar carpeta central
    if (Test-Path $centralPublishPath) { Remove-Item $centralPublishPath -Recurse -Force }
    New-Item -ItemType Directory -Force -Path $centralPublishPath | Out-Null

    # Copiar contenido del build a la carpeta central para tener el registro
    Write-Host "📂 Guardando copia del build en: $centralPublishPath" -ForegroundColor Gray
    Copy-Item -Path "$distPath/*" -Destination $centralPublishPath -Recurse -Force

    # 4. URL FTP dinámica usando el puerto del proyecto
    $port = $envConfig.ports.$TargetName
    if (!$port) { $port = 21 }

    $ftpBaseUrl = $envConfig.server.TrimEnd('/')
    $remoteUrl = "${ftpBaseUrl}:${port}/"
    
    Write-Host "`n🚀 Subiendo archivos a: $remoteUrl (Usuario: $($envConfig.username))" -ForegroundColor Green
    Invoke-FTPUpload -LocalPath $centralPublishPath -RemoteUrl $remoteUrl -Username $envConfig.username -Password $envConfig.password

    Write-Host "`n✅ UI $TargetName desplegada con éxito!`n" -ForegroundColor White -BackgroundColor Magenta

} catch {
    Write-Host "`n❌ ERROR: $($_.Exception.Message)" -ForegroundColor White -BackgroundColor Red
} finally {
    Set-Location $PSScriptRoot
}
