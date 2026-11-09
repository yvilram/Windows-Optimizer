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
git clone https://github.com/TU-USUARIO/NOMBRE-DE-TU-REPOSITORIO.git
cd NOMBRE-DE-TU-REPOSITORIO
```

### 2. Ejecutar el Script
Debido a las políticas predeterminadas de ejecución de scripts en Windows, puedes lanzar la aplicación de dos formas:

#### Opción A (Recomendada - Bypass puntual):
Abre **PowerShell como Administrador** en la carpeta del script y ejecuta:

```powershell
powershell -ExecutionPolicy Bypass -File .\optimizer.ps1
```

#### Opción B (Habilitar política en la sesión activa):
```powershell
Set-ExecutionPolicy RemoteSigned -Scope Process
.\optimizer.ps1
```

---

## 🕹️ Interfaz y Navegación

Al ejecutar la herramienta se desplegará el menú principal interactivo:

```text
================================================
       OPTIMIZADOR Y DESINSTALADOR DE WINDOWS   
================================================
1. Limpiar Archivos Basura (Temp, Prefetch, Papelera)
2. Limpiar Cache de Windows Update (WinSxS / Downloads)
3. Desactivar Telemetria basica de rastreo
4. Eliminar Bloatware estandar preinstalado
5. [INTERACTIVO] Listar y seleccionar programas/apps a eliminar
6. Ejecutar optimizacion COMPLETA (Opcion 1 a 4)
7. Salir
================================================
```

---

## ⚠️ Advertencia y Descargo de Responsabilidad (Disclaimer)

> **Importante:** Este script modifica ajustes del sistema y elimina software. Aunque ha sido diseñado utilizando métodos nativos y seguros de Windows, **el uso de esta herramienta es bajo tu propia responsabilidad**. Se recomienda crear un **Punto de Restauración del Sistema** antes de realizar tareas avanzadas de optimización o desinstalación masiva.

---

## 🤝 Contribuciones

¡Las contribuciones son bienvenidas! Si deseas agregar nuevas reglas de limpieza o añadir mejoras a la interfaz:

1. Haz un **Fork** del proyecto.
2. Crea una rama para tu función (`git checkout -b feature/NuevaCaracteristica`).
3. Envía tus cambios (`git commit -m 'Añade nueva función'`).
4. Haz Push a la rama (`git push origin feature/NuevaCaracteristica`).
5. Abre un **Pull Request**.

---

## 📄 Licencia

Este proyecto está bajo la Licencia **MIT**. Consulta el archivo `LICENSE` para obtener más información.
