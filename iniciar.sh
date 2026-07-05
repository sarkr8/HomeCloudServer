#!/bin/bash

# ==============================================================================
# 🏠 Home Cloud Server - Script de Inicialización y Arranque Automático
# ==============================================================================
# Este script crea toda la estructura de directorios, monta las plantillas de
# configuración y levanta el stack en Docker Compose.
# ==============================================================================

# Configuración de colores para salida en consola
VERDE='\033[0;32m'
AZUL='\033[0;34m'
AMARILLO='\033[1;33m'
ROJO='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${AZUL}"
echo "=================================================================="
echo "         🏠 INICIANDO HOME CLOUD SERVER (HCS)                    "
echo "=================================================================="
echo -e "${NC}"

# 1. Definir y crear el árbol de directorios del proyecto
echo -e "* Creando estructura de directorios y bibliotecas multimedia..."
directorios=(
  "casa"
  "casaos"
  "cloudflare-tunnel"
  "jellyfin/config"
  "jellyfin/cache"
  "jellyseerr"
  "nextcloud"
  "photoprism"
  "prowlarr/config"
  "qbittorrent/config"
  "radarr/config"
  "sonarr/config"
  "transmission"
  "users"
  "media/peliculas"
  "media/series"
  "media/descargas"
  "media/fotos"
  "media/incomplete"
  "media/watch"
)

for dir in "${directorios[@]}"; do
  if [ ! -d "$dir" ]; then
    mkdir -p "$dir"
    # Crear un archivo .gitkeep local para control de estructura si es necesario
    touch "$dir/.gitkeep"
    echo -e "  [+] Creado: ${VERDE}$dir/${NC}"
  fi
done

# 2. Verificar y copiar variables de entorno (.env) de plantilla
if [ ! -f ".env" ]; then
  echo -e "* Creando archivo de variables de entorno (.env) desde plantilla..."
  cp home-cloud-server.env .env
  echo -e "  [+] Creado: ${VERDE}.env${NC}"
else
  echo -e "  [~] El archivo ${AMARILLO}.env${NC} ya existe. Saltando copia."
fi

# 3. Copiar las plantillas de bases de datos preconfiguradas
echo -e "* Comprobando y copiando plantillas de bases de datos SQLite..."
plantillas=(
  "radarr/config/radarr.db:config-templates/radarr/radarr.db"
  "sonarr/config/sonarr.db:config-templates/sonarr/sonarr.db"
  "prowlarr/config/prowlarr.db:config-templates/prowlarr/prowlarr.db"
)

for item in "${plantillas[@]}"; do
  destino="${item%%:*}"
  origen="${item##*:}"
  
  if [ ! -f "$destino" ]; then
    if [ -f "$origen" ]; then
      cp "$origen" "$destino"
      echo -e "  [+] Copiada base de datos preconfigurada: ${VERDE}$destino${NC}"
    else
      echo -e "  [${ROJO}Error${NC}] No se encontró la plantilla de origen: $origen"
    fi
  else
    echo -e "  [~] La base de datos ${AMARILLO}$destino${NC} ya existe. Conservando datos actuales."
  fi
done

# 4. Asegurar propiedad y permisos de archivos
echo -e "* Configurando propiedad de archivos a usuario no-root (1000:1000)..."
# Usamos sudo si el usuario no es root o propietario de todo, pidiendo contraseña de ser necesario
if [ "$EUID" -ne 0 ]; then
  echo -e "  [i] Es posible que se soliciten privilegios de administrador (sudo) para cambiar permisos..."
  sudo chown -R 1000:1000 casa casaos cloudflare-tunnel jellyfin jellyseerr nextcloud photoprism prowlarr qbittorrent radarr sonarr transmission users media config-templates .env
else
  chown -R 1000:1000 casa casaos cloudflare-tunnel jellyfin jellyseerr nextcloud photoprism prowlarr qbittorrent radarr sonarr transmission users media config-templates .env
fi
echo -e "  [+] Permisos configurados correctamente."

# 5. Levantar el stack de contenedores Docker
echo -e "* Iniciando contenedores en segundo plano..."
docker compose up -d

if [ $? -eq 0 ]; then
  echo -e "\n${VERDE}=================================================================="
  echo "         🚀 ¡SERVIDOR MULTIMEDIA LEVANTADO CON ÉXITO!            "
  echo "=================================================================="
  echo -e "${NC}"
  echo "Accede a tus servicios favoritos:"
  echo -e "- CasaOS:      ${AZUL}http://localhost${NC} (Puerto 80)"
  echo -e "- Jellyfin:    ${AZUL}http://localhost:9092${NC}"
  echo -e "- Seerr:       ${AZUL}http://localhost:9093${NC}"
  echo -e "- qBittorrent: ${AZUL}http://localhost:9094${NC}"
  echo -e "- Sonarr:      ${AZUL}http://localhost:9095${NC}"
  echo -e "- Radarr:      ${AZUL}http://localhost:9096${NC}"
  echo -e "- Prowlarr:    ${AZUL}http://localhost:9097${NC}"
  echo -e "==================================================================\n"
else
  echo -e "\n${ROJO}=================================================================="
  echo "       [x] ERROR AL INICIAR LOS CONTENEDORES EN DOCKER            "
  echo "=================================================================="
  echo -e "${NC}\n"
fi
