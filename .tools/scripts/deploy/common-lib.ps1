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

    # Resolver la ruta absoluta real
    $LocalPath = (Get-Item $LocalPath).FullName
    if (!(Test-Path $LocalPath)) { throw "La ruta local no existe: $LocalPath" }

    Write-Host "📦 Preparando archivos en $LocalPath..." -ForegroundColor Gray
    
    if (!$LocalPath.EndsWith("\")) { $LocalPath += "\" }
    if (!$RemoteUrl.EndsWith("/")) { $RemoteUrl += "/" }

    $files = Get-ChildItem -Path $LocalPath -Recurse | Where-Object { !$_.PSIsContainer }
    $total = $files.Count
    $count = 0

    # Cache de directorios creados para evitar intentos repetitivos
    $createdDirs = New-Object System.Collections.Generic.HashSet[string]

    foreach ($file in $files) {
        $count++
        $relativeName = $file.FullName.Substring($LocalPath.Length).Replace("\", "/")
        $targetUri = "$RemoteUrl$relativeName"
        
        # Manejo de subdirectorios
        $parts = $relativeName.Split('/')
        if ($parts.Count -gt 1) {
            $currentRemoteDir = $RemoteUrl
            for ($i = 0; $i -lt $parts.Count - 1; $i++) {
                $currentRemoteDir += $parts[$i] + "/"
                if (!$createdDirs.Contains($currentRemoteDir)) {
                    try {
                        $mkdirRequest = [System.Net.FtpWebRequest]::Create($currentRemoteDir)
                        $mkdirRequest.Credentials = New-Object System.Net.NetworkCredential($Username, $Password)
                        $mkdirRequest.Method = [System.Net.WebRequestMethods+Ftp]::MakeDirectory
                        $response = $mkdirRequest.GetResponse()
                        $response.Close()
                    } catch {
                        # Error 550 suele significar que ya existe, lo ignoramos
                    }
                    $createdDirs.Add($currentRemoteDir) | Out-Null
                }
            }
        }

        Write-Host "[$count/$total] 📤 Subiendo: $relativeName" -ForegroundColor Cyan
        try {
            $ftprequest = [System.Net.FtpWebRequest]::Create($targetUri)
            $ftprequest.Credentials = New-Object System.Net.NetworkCredential($Username, $Password)
            $ftprequest.Method = [System.Net.WebRequestMethods+Ftp]::UploadFile
            
            $fileContent = [System.IO.File]::ReadAllBytes($file.FullName)
            $ftprequest.ContentLength = $fileContent.Length
            
            $requestStream = $ftprequest.GetRequestStream()
            $requestStream.Write($fileContent, 0, $fileContent.Length)
            $requestStream.Close()
            
            $response = $ftprequest.GetResponse()
            $response.Close()
        } catch {
            Write-Host "❌ Error subiendo $($file.Name): $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}
