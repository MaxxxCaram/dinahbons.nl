# 🚀 Auto-Deploy Scripts for Dinah Bons Website

Este conjunto de scripts te permite desplegar automáticamente tu sitio web cada vez que hagas cambios.

## 📁 Archivos Creados

- **`deploy.ps1`** - Script principal de despliegue (usa configuración)
- **`deploy-config.json`** - Archivo de configuración
- **`watch-and-deploy.ps1`** - Monitoreo automático de cambios
- **`deploy-simple.ps1`** - Script simple con opciones múltiples

## 🚀 Uso Rápido

### 1. Configurar el despliegue

Edita `deploy-config.json` con tus datos:

```json
{
  "deployment": {
    "method": "ftp",
    "ftp": {
      "server": "tu-servidor.com",
      "username": "tu-usuario",
      "password": "tu-contraseña",
      "remotePath": "/public_html/"
    }
  }
}
```

### 2. Ejecutar el despliegue

```powershell
# Desplegar una vez
.\deploy.ps1

# O usar el script simple
.\deploy-simple.ps1
```

### 3. Monitoreo automático

```powershell
# Para monitoreo automático (sube archivos cuando cambien)
.\watch-and-deploy.ps1
```

## 🔧 Métodos de Despliegue

### FTP
- **Para:** Hosting compartido, cPanel
- **Configuración:** Edita `deploy-config.json` con datos FTP
- **Uso:** Cambia `"method": "ftp"`

### SCP (SSH)
- **Para:** VPS, servidores dedicados
- **Configuración:** Necesitas acceso SSH
- **Uso:** Cambia `"method": "scp"`

### Git
- **Para:** GitHub Pages, Netlify, Vercel
- **Configuración:** Repositorio Git configurado
- **Uso:** Cambia `"method": "git"`

## 📋 Pasos para Configurar

1. **Edita `deploy-config.json`** con tus datos de servidor
2. **Ejecuta `.\deploy.ps1`** para probar la conexión
3. **Usa `.\watch-and-deploy.ps1`** para monitoreo automático

## 🎯 Características

- ✅ **Detección automática** de cambios en archivos
- ✅ **Subida automática** cuando detecta cambios
- ✅ **Múltiples métodos** de despliegue (FTP, SCP, Git)
- ✅ **Configuración fácil** en archivo JSON
- ✅ **Monitoreo en tiempo real** de archivos
- ✅ **Logs coloridos** para seguimiento fácil

## 🚨 Notas Importantes

- **Guarda tu contraseña** de forma segura
- **Prueba primero** con un archivo pequeño
- **Verifica permisos** en tu servidor
- **Haz backup** antes de desplegar

## 🔍 Solución de Problemas

### Error de conexión FTP
- Verifica usuario/contraseña
- Comprueba que el servidor permita FTP
- Verifica la ruta remota

### Error de permisos
- Verifica permisos de escritura en el servidor
- Comprueba que la ruta remota existe

### Archivos no se suben
- Verifica que los archivos no estén en `.gitignore`
- Comprueba la configuración de archivos incluidos/excluidos

## 📞 Soporte

Si tienes problemas:
1. Revisa los logs del script
2. Verifica tu configuración
3. Prueba con un método diferente de despliegue

---

**¡Tu sitio web se actualizará automáticamente cada vez que hagas cambios!** 🎉
