## Despliegue de n8n con Docker y Railway

Este repositorio contiene una configuración mínima para ejecutar y desplegar una instancia de n8n (plataforma de automatización de flujos de trabajo) usando Docker. Incluye además la configuración de despliegue para Railway.

### Estructura
- `Dockerfile`: Construye una imagen basada en `n8nio/n8n:latest`, expone el puerto 3000 y define variables básicas (`N8N_HOST`, `N8N_PORT`).
- `railway.json`: Configuración para desplegar en Railway usando el builder "DOCKERFILE" y el comando de arranque `n8n start`.

### Requisitos
- Docker 20+ instalado
- (Opcional) Cuenta en Railway para despliegue gestionado

### Ejecutar localmente con Docker
Construye la imagen:
```bash
docker build -t my-n8n .
```

Ejecuta el contenedor exponiendo el puerto 3000 y con volumen persistente para datos de n8n:
```bash
docker run \
  -p 3000:3000 \
  -e N8N_HOST=0.0.0.0 \
  -e N8N_PORT=3000 \
  -v n8n_data:/home/node/.n8n \
  --name my-n8n \
  my-n8n
```

Accede en el navegador a: `http://localhost:3000`

### Variables de entorno útiles
- `N8N_HOST`: Host donde escucha n8n (por defecto `0.0.0.0`).
- `N8N_PORT`: Puerto de la aplicación (por defecto `3000`).
- `WEBHOOK_URL`: URL pública completa si n8n está detrás de un proxy o dominio (recomendado en producción).
- `N8N_BASIC_AUTH_ACTIVE`: Activa autenticación básica (`true`/`false`).
- `N8N_BASIC_AUTH_USER` / `N8N_BASIC_AUTH_PASSWORD`: Credenciales si activas autenticación básica.
- `GENERIC_TIMEZONE`: Zona horaria, por ejemplo `Europe/Madrid`.

Consulta más variables soportadas en la documentación oficial de n8n.

### Despliegue en Railway
1. Conecta este repositorio a un proyecto en Railway.
2. Railway detectará `railway.json` y construirá usando el `Dockerfile`.
3. Configura variables de entorno en Railway (al menos `WEBHOOK_URL` si usas dominio propio y variables de seguridad según necesites).
4. Despliega. El servicio arrancará con `n8n start` y política de reinicio `ON_FAILURE`.

Nota: Para persistencia en Railway, añade un volumen/persistent storage si tu plan lo permite, y móntalo en `/home/node/.n8n`.

### Persistencia de datos
En local se recomienda usar un volumen Docker (como en el ejemplo `-v n8n_data:/home/node/.n8n`). En producción, monta almacenamiento persistente en esa misma ruta para conservar credenciales, flujos y configuraciones.

### Seguridad (recomendado)
- Habilita autenticación básica (`N8N_BASIC_AUTH_ACTIVE=true`).
- Coloca n8n detrás de un proxy con TLS (HTTPS) y define `WEBHOOK_URL` con HTTPS.
- Restringe el acceso por IP o mediante SSO si es posible.

### Actualización de la imagen
Para actualizar a la última versión de n8n:
```bash
docker pull n8nio/n8n:latest
docker build -t my-n8n .
docker stop my-n8n && docker rm my-n8n
docker run ... # (repite el comando de ejecución de arriba)
```

### Recursos
- Documentación n8n: `https://docs.n8n.io`
- Repositorio de la imagen oficial: `https://hub.docker.com/r/n8nio/n8n`

