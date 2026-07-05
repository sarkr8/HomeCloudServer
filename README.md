 Home Cloud Server
Servidor multimedia casero, autoalojado en un mini PC con Zorin OS + Docker. Este sistema proporciona almacenamiento personal, galería de fotos, servidor multimedia y acceso remoto seguro.

🚀 Servicios incluidos
CasaOS: Panel de control general (corriendo en contenedor)
PhotoPrism: Galería de fotos con reconocimiento facial
Nextcloud: Almacenamiento en la nube (v31.0.7, SQLite)
Jellyfin: Servidor multimedia para streaming de películas/series
Seerr: Gestor de solicitudes y peticiones multimedia (sucesor de Jellyseerr, puerto 9093)
qBittorrent: Cliente torrent para descargas automatizadas (sin contraseña local)
Sonarr: Automatización y descarga de series
Radarr: Automatización y descarga de películas
Prowlarr: Indexador y buscador de torrents centralizado
Cloudflare Tunnel: (Pendiente de configuración) Acceso remoto sin abrir puertos
📁 Estructura del proyecto
Cada servicio está contenido y montado de forma modular bajo su carpeta respectiva en la raíz del proyecto.

📦 Requisitos
Docker + Docker Compose
Zorin OS o cualquier distro Linux con soporte a contenedores
🛠️ Instalación y Arranque Rápido
Para levantar el servidor multimedia completo en cualquier máquina Linux con Docker instalado, sigue estos pasos:

Abre una terminal en la raíz de la carpeta HomeCloudServer.

Dale permisos de ejecución al script de arranque (solo la primera vez):

chmod +x iniciar.sh
Ejecuta el script de inicialización y arranque automático:

./iniciar.sh
(El script creará automáticamente toda la estructura física de carpetas, copiará las bases de datos de plantillas genéricas preconfiguradas, corregirá los permisos y levantará todos los contenedores en segundo plano).

Acceso a los servicios desde la red local:

CasaOS: http://localhost (Puerto 80)
PhotoPrism: http://localhost:9090
Nextcloud: http://localhost:9091
Jellyfin: http://localhost:9092
Seerr: http://localhost:9093
qBittorrent: http://localhost:9094
Sonarr: http://localhost:9095
Radarr: http://localhost:9096
Prowlarr: http://localhost:9097
🔑 Credenciales de Desarrollo (Locales)
Para acceder a las interfaces web durante el desarrollo local, utiliza las siguientes credenciales genéricas (recuerda cambiarlas antes de exponer el servidor a internet):

General (CasaOS, Nextcloud, Jellyfin, Seerr, etc.):
Usuario / Email: user
Contraseña: cloudadmin
Documentado por Hiram Martínez Tumalan
