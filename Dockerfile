FROM n8nio/n8n:latest

# Variables de entorno opcionales aquí
ENV N8N_HOST=0.0.0.0
ENV N8N_PORT=3000

EXPOSE 3000

# n8n se ejecuta automáticamente
