# ============================================================
# Script AUTOMATIZADO - Publicacion del nombre de usuario
# SIN confirmacion interactiva
# USO BAJO TU PROPIA RESPONSABILIDAD
# ============================================================

$ErrorActionPreference = 'Stop'
$raiz = Split-Path -Parent $PSScriptRoot
Push-Location $raiz

try {
    # Verificar que es un repositorio Git
    if (-not (Test-Path '.git')) {
        Write-Host "ERROR: No es un repositorio Git." -ForegroundColor Red
        Write-Host "Ejecuta este script desde la carpeta del proyecto clonado." -ForegroundColor Yellow
        exit 1
    }

    # Verificar remoto
    $remoto = (git remote get-url origin 2>$null)
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERROR: No se pudo obtener el remoto origin." -ForegroundColor Red
        exit 1
    }

    # Verificar rama
    $rama = (git branch --show-current).Trim()
    if ($rama -ne 'main') {
        Write-Host "ERROR: Debes estar en la rama main. Estás en: $rama" -ForegroundColor Red
        exit 1
    }

    # Obtener nombre de usuario
    $usuario = [Environment]::UserName
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "  PUBLICACION AUTOMATIZADA" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Usuario detectado: $usuario" -ForegroundColor Green
    Write-Host "Repositorio destino: SebastianRKN/repoprueba" -ForegroundColor Green
    Write-Host "Archivo: nombre_de_usuario.md" -ForegroundColor Green
    Write-Host ""

    # Verificar si ya existe el archivo
    if (Test-Path -LiteralPath 'nombre_de_usuario.md') {
        Write-Host "ADVERTENCIA: nombre_de_usuario.md ya existe." -ForegroundColor Yellow
        Write-Host "Se procedera a actualizar el contenido." -ForegroundColor Yellow
        Remove-Item -LiteralPath 'nombre_de_usuario.md' -Force
    }

    # Crear el archivo
    $contenido = @"
# Nombre de usuario de Windows

Usuario: $usuario

Publicado automaticamente desde el laboratorio universitario.
Fecha: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
"@

    $contenido | Set-Content -LiteralPath 'nombre_de_usuario.md' -Encoding UTF8
    Write-Host "[OK] Archivo nombre_de_usuario.md creado." -ForegroundColor Green

    # Git add
    git add -- nombre_de_usuario.md
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERROR: Fallo git add." -ForegroundColor Red
        exit 1
    }
    Write-Host "[OK] git add completado." -ForegroundColor Green

    # Git commit
    git commit -m "Lab: publish authorized Windows username (automated)"
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERROR: Fallo git commit." -ForegroundColor Red
        exit 1
    }
    Write-Host "[OK] git commit completado." -ForegroundColor Green

    # Git push
    Write-Host ""
    Write-Host "Publicando en GitHub..." -ForegroundColor Yellow
    git push origin HEAD:main
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERROR: Fallo git push." -ForegroundColor Red
        Write-Host "El commit puede existir localmente. Intenta hacer push manual." -ForegroundColor Yellow
        exit 1
    }
    Write-Host "[OK] git push completado." -ForegroundColor Green

    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "  PUBLICACION EXITOSA" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "URL: https://github.com/SebastianRKN/repoprueba/blob/main/nombre_de_usuario.md" -ForegroundColor Cyan
    Write-Host ""
}
catch {
    Write-Host ""
    Write-Host "ERROR GENERAL: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
finally {
    Pop-Location
}
