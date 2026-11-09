# 🚀 Windows Optimizer & Uninstaller CLI

[![PowerShell Version](https://img.shields.io/badge/PowerShell-5.1%2B-blue.svg)](https://microsoft.com/powershell)
[![Platform](https://img.shields.io/badge/Platform-Windows%2010%20%7C%2011-0078D6.svg)](https://microsoft.com/windows)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

Una herramienta interactiva por línea de comandos (CLI) escrita en PowerShell para **optimizar Windows, liberar almacenamiento reduciendo la carga del sistema y desinstalar de forma completa** tanto programas tradicionales (Win32) como aplicaciones preinstaladas (UWP/Bloatware).

---

## 📋 Características principales

- **🧹 Limpieza profunda de archivos basura:** Elimina archivos temporales de usuario y sistema (`Temp`, `Prefetch`) y vacía automáticamente la papelera de reciclaje.
- **🔄 Limpieza de caché de Windows Update:** Detiene temporalmente los servicios de actualización para vaciar la carpeta `SoftwareDistribution\Download` y liberar espacio retenido.
- **🛡️ Desactivación de Telemetría básica:** Deshabilita los servicios de rastreo y recolección de datos en segundo plano (`DiagTrack` y `dmwappushservice`) para mejorar la privacidad y liberar memoria RAM.
- **📦 Desinstalador estándar de Bloatware:** Elimina de un solo clic las aplicaciones nativas no esenciales (Noticias, El Tiempo, Zune, Feedback Hub, etc.).
- **⚡ Desinstalador Interactivo Unificado (Win32 + UWP):**
  - Escanea el Registro de Windows (32/64 bits) y los paquetes UWP.
  - Genera una lista numerada etiquetando claramente el origen: `[PROGRAMA]` (ej. Steam, Chrome) o `[APP STORE]` (ej. Spotify App).
  - Permite la desinstalación múltiple introduciendo los números de las aplicaciones separados por comas.

---

## 📥 Requisitos previos

- **Sistema Operativo:** Windows 10 o Windows 11.
- **Permisos:** Se requiere ejecutar PowerShell como **Administrador** para modificar servicios del sistema y desinstalar software.

---

## 🚀 Uso e Instalación

### 1. Clonar o descargar el repositorio
Clona el repositorio usando Git o descarga el código fuente directamente:

```bash
git clone [https://github.com/TU-USUARIO/NOMBRE-DE-TU-REPOSITO.git](https://github.com/TU-USUARIO/NOMBRE-DE-TU-REPOSITO.git)
cd NOMBRE-DE-TU-REPOSITO
