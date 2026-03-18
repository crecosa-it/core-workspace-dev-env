function Get-Config {
    param($Type)
    $path = "$PSScriptRoot/../config/$Type.json"
    if (Test-Path $path) {
        return Get-Content $path | ConvertFrom-Json
    }
    throw "Config file $Type not found at $path"
}

function Invoke-FTPUpload {
    param(
        [Parameter(Mandatory=$true)]$LocalPath,
        [Parameter(Mandatory=$true)]$RemoteUrl,
        [Parameter(Mandatory=$true)]$Username,
        [Parameter(Mandatory=$true)]$Password
    )

    $webclient = New-Object System.Net.WebClient
    $webclient.Credentials = New-Object System.Net.NetworkCredential($Username, $Password)

    # Resolver la ruta absoluta real para evitar problemas con ".." en la longitud de la cadena
    $LocalPath = (Get-Item $LocalPath).FullName
    
    if (!(Test-Path $LocalPath)) {
        throw "La ruta local no existe: $LocalPath"
    }

    Write-Host "📦 Preparando archivos en $LocalPath..." -ForegroundColor Gray
    
    # Asegurarse de que el path local termine en slash
    if (!$LocalPath.EndsWith("\")) { $LocalPath += "\" }

    $files = Get-ChildItem -Path $LocalPath -Recurse | Where-Object { !$_.PSIsContainer }
    $total = $files.Count
    $count = 0

    foreach ($file in $files) {
        $count++
        $relativeName = $file.FullName.Substring($LocalPath.Length).Replace("\", "/")
        $targetUri = "$RemoteUrl$relativeName"
        
        # Intentar crear directorios remotos (esto es simplificado, FtpWebRequest es mejor para esto)
        # Nota: La carga vía WebClient requiere que el directorio destino EXISTA.
        
        Write-Host "[$count/$total] 📤 Subiendo: $relativeName" -ForegroundColor Cyan
        try {
            $webclient.UploadFile($targetUri, "STOR", $file.FullName)
        } catch {
            Write-Host "❌ Error subiendo $($file.Name): $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}
