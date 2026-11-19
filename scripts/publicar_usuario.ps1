# Publicación voluntaria del nombre de usuario real de Windows en GitHub.
# Requiere confirmación interactiva y acceso de escritura al repositorio.
$ErrorActionPreference = 'Stop'
$raiz = Split-Path -Parent $PSScriptRoot
Push-Location $raiz
try {
    if (-not (Test-Path '.git')) { throw 'Ejecuta este script desde un clon Git del proyecto.' }

    $remoto = (git remote get-url origin).Trim()
    if ($LASTEXITCODE -ne 0 -or
        $remoto -notmatch '^(https://github\.com/|git@github\.com:)SebastianRKN/repoprueba(\.git)?$') {
        throw 'El remoto origin no coincide con SebastianRKN/repoprueba.'
    }
    $rama = (git branch --show-current).Trim()
    if ($rama -ne 'main') { throw 'Cambia a la rama main antes de continuar.' }

    git diff --cached --quiet
    if ($LASTEXITCODE -ne 0) { throw 'Hay otros cambios preparados. Dejalos fuera del indice antes de continuar.' }
    if (Test-Path -LiteralPath 'nombre_de_usuario.md') {
        throw 'nombre_de_usuario.md ya existe; no se sobrescribira.'
    }

    $usuario = [Environment]::UserName
    Write-Host 'Se publicara en GitHub un archivo con el nombre REAL de usuario de Windows:'
    Write-Host "  Usuario: $usuario"
    Write-Host '  Repositorio: SebastianRKN/repoprueba'
    Write-Host '  Archivo: nombre_de_usuario.md'
    Write-Host '  Este dato podra quedar visible en el historial del repositorio.'
    $confirmacion = Read-Host 'Para autorizar el commit y push escribe PUBLICAR'
    if ($confirmacion -cne 'PUBLICAR') {
        Write-Output 'Cancelado. No se creo ni publico ningun archivo.'
        return
    }

    @"
# Nombre de usuario de Windows

Usuario: $usuario

Publicado voluntariamente en el laboratorio universitario.
"@ | Set-Content -LiteralPath 'nombre_de_usuario.md' -Encoding UTF8

    git add -- nombre_de_usuario.md
    if ($LASTEXITCODE -ne 0) { throw 'Fallo git add.' }
    git commit -m 'Lab: publish authorized Windows username'
    if ($LASTEXITCODE -ne 0) { throw 'Fallo git commit.' }
    git push origin HEAD:main
    if ($LASTEXITCODE -ne 0) { throw 'Fallo git push. El commit puede existir localmente.' }
    Write-Output 'Publicado: https://github.com/SebastianRKN/repoprueba/blob/main/nombre_de_usuario.md'
}
finally {
    Pop-Location
}
