# Laboratorio: solo escribe un registro local; no realiza solicitudes de red.
$ErrorActionPreference = 'Stop'
$usuario = [System.Environment]::UserName
$destinatario = 'amb3rosekun@gmail.com'
$salida = Join-Path (Split-Path -Parent $PSScriptRoot) 'resultado_prueba.txt'

@"
SIMULACION DE EXFILTRACION (SIN ENVIO)
Destinatario simulado: $destinatario
Usuario detectado: $usuario
Estado: Solo archivo local. Ningun mensaje fue enviado.
"@ | Set-Content -LiteralPath $salida -Encoding UTF8

Write-Output "Simulacion registrada en: $salida"
