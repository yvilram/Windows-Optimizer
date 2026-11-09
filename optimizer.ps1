# =======================================================
# WINDOWS OPTIMIZER & UNINSTALLER TOOL (Win32 + UWP)
# =======================================================

function Show-Menu {
    Clear-Host
    Write-Host "================================================" -ForegroundColor Cyan
    Write-Host "       OPTIMIZADOR Y DESINSTALADOR DE WINDOWS   " -ForegroundColor Yellow
    Write-Host "================================================" -ForegroundColor Cyan
    Write-Host "1. Limpiar Archivos Basura (Temp, Prefetch, Papelera)" -ForegroundColor White
    Write-Host "2. Limpiar Cache de Windows Update (WinSxS / Downloads)" -ForegroundColor White
    Write-Host "3. Desactivar Telemetria basica de rastreo" -ForegroundColor White
    Write-Host "4. Eliminar Bloatware estandar preinstalado" -ForegroundColor White
    Write-Host "5. [INTERACTIVO] Listar y seleccionar programas/apps a eliminar" -ForegroundColor Green
    Write-Host "6. Ejecutar optimizacion COMPLETA (Opcion 1 a 4)" -ForegroundColor Magenta
    Write-Host "7. Salir" -ForegroundColor Red
    Write-Host "================================================" -ForegroundColor Cyan
}

function Clean-TempFiles {
    Write-Host "`n[+] Limpiando archivos temporales y basura..." -ForegroundColor Yellow
    Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "C:\Users\$env:USERNAME\AppData\Local\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "C:\Windows\Prefetch\*" -Recurse -Force -ErrorAction SilentlyContinue
    Clear-RecycleBin -Force -ErrorAction SilentlyContinue
    Write-Host "[OK] Archivos temporales y papelera limpiados con exito." -ForegroundColor Green
    Pause
}

function Clean-UpdateCache {
    Write-Host "`n[+] Deteniendo servicios de Windows Update para limpiar cache..." -ForegroundColor Yellow
    Stop-Service -Name wuauserv -ErrorAction SilentlyContinue
    Stop-Service -Name bits -ErrorAction SilentlyContinue
    Remove-Item -Path "C:\Windows\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue
    Start-Service -Name wuauserv -ErrorAction SilentlyContinue
    Start-Service -Name bits -ErrorAction SilentlyContinue
    Write-Host "[OK] Cache de Windows Update liberada." -ForegroundColor Green
    Pause
}

function Disable-Telemetry {
    Write-Host "`n[+] Desactivando servicios de telemetria y rastreo..." -ForegroundColor Yellow
    Set-Service -Name DiagTrack -StartupType Disabled -ErrorAction SilentlyContinue
    Stop-Service -Name DiagTrack -ErrorAction SilentlyContinue
    Set-Service -Name dmwappushservice -StartupType Disabled -ErrorAction SilentlyContinue
    Stop-Service -Name dmwappushservice -ErrorAction SilentlyContinue
    Write-Host "[OK] Telemetria desactivada." -ForegroundColor Green
    Pause
}

function Remove-StandardBloatware {
    Write-Host "`n[+] Eliminando aplicaciones preinstaladas comunes..." -ForegroundColor Yellow
    $Bloatware = @(
        "Microsoft.3DBuilder", "Microsoft.BingNews", "Microsoft.BingWeather", 
        "Microsoft.GetHelp", "Microsoft.Getstarted", "Microsoft.MicrosoftOfficeHub",
        "Microsoft.MicrosoftSolitaireCollection", "Microsoft.People", "Microsoft.SkypeApp",
        "Microsoft.Todos", "Microsoft.WindowsAlarms", "Microsoft.WindowsFeedbackHub",
        "Microsoft.WindowsMaps", "Microsoft.YourPhone", "Microsoft.ZuneMusic", "Microsoft.ZuneVideo"
    )

    foreach ($App in $Bloatware) {
        Get-AppxPackage -Name $App -AllUsers | Remove-AppxPackage -ErrorAction SilentlyContinue
        Get-AppxProvisionedPackage -Online | Where-Object DisplayName -eq $App | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
    }
    Write-Host "[OK] Bloatware estandar eliminado." -ForegroundColor Green
    Pause
}

function Interactive-Uninstaller {
    Clear-Host
    Write-Host "================================================" -ForegroundColor Cyan
    Write-Host "     DESINSTALADOR INTERACTIVO DE APLICACIONES  " -ForegroundColor Yellow
    Write-Host "================================================" -ForegroundColor Cyan
    Write-Host "Buscando programas (Win32) y aplicaciones (UWP)..." -ForegroundColor Gray

    $AllSoftware = @()

    # 1. Buscar Programas Tradicionales (Registro 64-bit y 32-bit)
    $RegPaths = @(
        "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*"
    )

    $Win32Apps = Get-ItemProperty $RegPaths | 
        Where-Object { $_.DisplayName -and $_.UninstallString } | 
        Select-Object @{N="Name";E={$_.DisplayName}}, @{N="Type";E={"Win32"}}, @{N="Uninstall";E={$_.UninstallString}}

    # 2. Buscar Aplicaciones Modernas (Store/UWP)
    $UwpApps = Get-AppxPackage -AllUsers | 
        Where-Object { $_.NonRemovable -ne $true -and $_.SignatureKind -ne "System" } | 
        Select-Object @{N="Name";E={$_.Name}}, @{N="Type";E={"UWP"}}, @{N="Uninstall";E={$_.PackageFullName}}

    # Combinar y ordenar
    $AllSoftware = ($Win32Apps + $UwpApps) | Sort-Object Name -Unique

    if ($AllSoftware.Count -eq 0) {
        Write-Host "No se encontraron programas ni aplicaciones desinstalables." -ForegroundColor Red
        Pause
        return
    }

    $i = 1
    Write-Host "`nProgramas y Aplicaciones encontradas:`n" -ForegroundColor Yellow
    foreach ($Item in $AllSoftware) {
        $Tag = if ($Item.Type -eq "Win32") { "[PROGRAMA]" } else { "[APP STORE]" }
        Write-Host " [$i] $Tag $($Item.Name)" -ForegroundColor White
        $i++
    }

    Write-Host "`n[?] Introduce los NUMEROS de los programas a eliminar separados por comas (ej: 3, 12, 25)" -ForegroundColor Cyan
    Write-Host "[?] Escribe 'CANCELAR' para volver al menu principal." -ForegroundColor Gray
    $Selection = Read-Host "`nSeleccion"

    if ($Selection -eq "CANCELAR" -or [string]::IsNullOrWhiteSpace($Selection)) {
        return
    }

    $Indices = $Selection.Split(',') | ForEach-Object { $_.Trim() }

    foreach ($Idx in $Indices) {
        if ($Idx -match "^\d+$" -and [int]$Idx -le $AllSoftware.Count -and [int]$Idx -gt 0) {
            $Target = $AllSoftware[[int]$Idx - 1]
            Write-Host "`n[+] Procesando desinstalacion de: $($Target.Name)..." -ForegroundColor Yellow
            
            if ($Target.Type -eq "UWP") {
                Remove-AppxPackage -Package $Target.Uninstall -ErrorAction SilentlyContinue
                Get-AppxProvisionedPackage -Online | Where-Object PackageName -eq $Target.Uninstall | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
                Write-Host "[OK] App de la tienda $($Target.Name) desinstalada." -ForegroundColor Green
            } else {
                # Ejecutar el desinstalador nativo del programa Win32
                Write-Host "[i] Abriendo el desinstalador de $($Target.Name)... Sigue los pasos en pantalla." -ForegroundColor Cyan
                try {
                    if ($Target.Uninstall -match "msiexec") {
                        $MsiGuid = ($Target.Uninstall -replace "msiexec.exe /I", "") -replace "msiexec.exe /X", ""
                        Start-Process "msiexec.exe" -ArgumentList "/x $MsiGuid /qb" -Wait
                    } else {
                        # Extraer ruta y argumentos si aplica
                        $Cmd = $Target.Uninstall
                        Start-Process cmd.exe -ArgumentList "/c $Cmd" -Wait
                    }
                    Write-Host "[OK] Proceso de desinstalacion finalizado para $($Target.Name)." -ForegroundColor Green
                } catch {
                    Write-Host "[!] No se pudo iniciar el desinstalador automatico." -ForegroundColor Red
                }
            }
        } else {
            Write-Host "[!] Opcion invalida omitida: $Idx" -ForegroundColor Red
        }
    }
    Pause
}

do {
    Show-Menu
    $Choice = Read-Host "`nIngresa una opcion (1-7)"
    switch ($Choice) {
        '1' { Clean-TempFiles }
        '2' { Clean-UpdateCache }
        '3' { Disable-Telemetry }
        '4' { Remove-StandardBloatware }
        '5' { Interactive-Uninstaller }
        '6' { 
            Clean-TempFiles
            Clean-UpdateCache
            Disable-Telemetry
            Remove-StandardBloatware
        }
        '7' { Write-Host "`nHasta luego!" -ForegroundColor Green; break }
        default { Write-Host "Opcion invalida, intenta de nuevo." -ForegroundColor Red; Start-Sleep -Seconds 1 }
    }
} while ($Choice -ne '7')