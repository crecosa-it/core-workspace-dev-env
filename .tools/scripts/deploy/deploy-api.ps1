param(
    [Parameter(Mandatory=$true)][string]$TargetName,
    [string]$Env = "test"
)

# Cargar librería común
. "$PSScriptRoot/common-lib.ps1"

try {
    Write-Host "`n🚀 Iniciando despliegue de: $TargetName en entorno: $Env" -ForegroundColor Yellow -BackgroundColor Black
    
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
    # Usamos una carpeta centralizada fuera de los proyectos
    $buildsBase = Join-Path $rootWorkspace ".tools/builds"
    $publishPath = Join-Path $buildsBase $TargetName
    
    # Limpiar carpeta de build anterior para este proyecto si existe
    if (Test-Path $publishPath) {
        Write-Host "🧹 Limpiando carpeta de build anterior: $publishPath" -ForegroundColor Gray
        Remove-Item -Path $publishPath -Recurse -Force
    }
    New-Item -ItemType Directory -Force -Path $publishPath | Out-Null
    
    # 3. Build & Publish
    Write-Host "`n🔨 Compilando proyecto .NET ($($target.type))..." -ForegroundColor Cyan
    Set-Location (Split-Path $fullProjectPath)

    if ($target.type -eq "dotnet-framework") {
        Write-Host "🔍 Buscando MSBuild para proyecto legado..." -ForegroundColor Gray
        $msbuildPaths = @(
            "C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\MSBuild\Current\Bin\MSBuild.exe",
            "C:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBuild.exe",
            "C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\MSBuild\Current\Bin\MSBuild.exe",
            "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\MSBuild\15.0\Bin\MSBuild.exe"
        )
        $msbuild = $msbuildPaths | Where-Object { Test-Path $_ } | Select-Object -First 1
        
        if (!$msbuild) {
            # Búsqueda dinámica si no están en rutas estándar
            $msbuild = Get-ChildItem -Path "C:\Program Files (x86)\Microsoft Visual Studio", "C:\Program Files\Microsoft Visual Studio" -Filter "MSBuild.exe" -Recurse -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName -First 1
        }

        if (!$msbuild) { throw "No se pudo encontrar MSBuild para compilar el proyecto legado. Por favor, instala Build Tools o VS." }
        
        Write-Host "🚧 Usando: $msbuild" -ForegroundColor Gray
        & $msbuild (Split-Path $fullProjectPath -Leaf) /p:Configuration=Release /p:DeployOnBuild=true /p:PublishUrl=$publishPath /p:WebPublishMethod=FileSystem /p:DeleteExistingFiles=True
    } else {
        dotnet publish (Split-Path $fullProjectPath -Leaf) -c Release -o $publishPath
    }
    
    if ($LASTEXITCODE -ne 0) { throw "Error en la compilación de .NET ($($target.type))" }

    # 4. Construir URL FTP dinámica usando el puerto del proyecto
    $port = $envConfig.ports.$TargetName
    if (!$port) { $port = 21 } # Default a 21 si no se especifica

    $ftpBaseUrl = $envConfig.server.TrimEnd('/')
    $remoteUrl = "${ftpBaseUrl}:${port}/"
    
    Write-Host "`n🚀 Subiendo a: $remoteUrl (Usuario: $($envConfig.username))" -ForegroundColor Green
    Invoke-FTPUpload -LocalPath $publishPath -RemoteUrl $remoteUrl -Username $envConfig.username -Password $envConfig.password

    Write-Host "`n✅ ¡Despliegue de $TargetName completado con éxito! `n" -ForegroundColor White -BackgroundColor Green

} catch {
    Write-Host "`n❌ ERROR: $($_.Exception.Message)" -ForegroundColor White -BackgroundColor Red
} finally {
    Set-Location $PSScriptRoot
}
