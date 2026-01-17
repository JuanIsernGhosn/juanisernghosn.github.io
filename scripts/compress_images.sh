#!/bin/bash

# Script para comprimir imágenes del sitio web
# Requiere: ImageMagick (convert), jpegoptim, optipng

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Directorio de imágenes
IMG_DIR="${1:-./assets/img}"
QUALITY="${2:-85}"

# Contadores
PROCESSED=0
SKIPPED=0
TOTAL_SAVED=0

# Función para formatear bytes (compatible con macOS)
format_bytes() {
    local bytes=$1
    if [ $bytes -ge 1048576 ]; then
        echo "$(echo "scale=1; $bytes/1048576" | bc)MB"
    elif [ $bytes -ge 1024 ]; then
        echo "$(echo "scale=1; $bytes/1024" | bc)KB"
    else
        echo "${bytes}B"
    fi
}

echo -e "${BLUE}🖼️  Comprimiendo imágenes en: $IMG_DIR${NC}"
echo -e "${BLUE}📊 Calidad objetivo: $QUALITY%${NC}"
echo ""

# Verificar dependencias
check_deps() {
    local missing=()

    if ! command -v convert &> /dev/null; then
        missing+=("imagemagick")
    fi
    if ! command -v jpegoptim &> /dev/null; then
        missing+=("jpegoptim")
    fi
    if ! command -v optipng &> /dev/null; then
        missing+=("optipng")
    fi

    if [ ${#missing[@]} -ne 0 ]; then
        echo -e "${RED}❌ Faltan dependencias: ${missing[*]}${NC}"
        echo -e "${YELLOW}Instala con: brew install ${missing[*]}${NC}"
        exit 1
    fi
}

# Comprimir JPG/JPEG
compress_jpg() {
    local file="$1"
    local size_before=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file")

    jpegoptim --strip-all --max="$QUALITY" -q "$file"

    local size_after=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file")
    local saved=$((size_before - size_after))

    if [ $saved -gt 0 ]; then
        TOTAL_SAVED=$((TOTAL_SAVED + saved))
        local percent=$((saved * 100 / size_before))
        echo -e "${GREEN}✓${NC} $(basename "$file"): -${percent}% ($(format_bytes $saved))"
        PROCESSED=$((PROCESSED + 1))
    else
        echo -e "${YELLOW}○${NC} $(basename "$file"): ya optimizada"
        SKIPPED=$((SKIPPED + 1))
    fi
}

# Comprimir PNG
compress_png() {
    local file="$1"
    local size_before=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file")

    optipng -o2 -quiet "$file"

    local size_after=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file")
    local saved=$((size_before - size_after))

    if [ $saved -gt 0 ]; then
        TOTAL_SAVED=$((TOTAL_SAVED + saved))
        local percent=$((saved * 100 / size_before))
        echo -e "${GREEN}✓${NC} $(basename "$file"): -${percent}% ($(format_bytes $saved))"
        PROCESSED=$((PROCESSED + 1))
    else
        echo -e "${YELLOW}○${NC} $(basename "$file"): ya optimizada"
        SKIPPED=$((SKIPPED + 1))
    fi
}

# Redimensionar imágenes grandes
resize_if_needed() {
    local file="$1"
    local max_width="${2:-1920}"

    # Obtener dimensiones actuales
    local width=$(identify -format "%w" "$file" 2>/dev/null)

    if [ -n "$width" ] && [ "$width" -gt "$max_width" ]; then
        echo -e "${BLUE}↓${NC} Redimensionando $(basename "$file") de ${width}px a ${max_width}px"
        convert "$file" -resize "${max_width}x>" -quality "$QUALITY" "$file"
    fi
}

# Main
check_deps

echo -e "${BLUE}Procesando JPG/JPEG...${NC}"
while IFS= read -r -d '' file; do
    resize_if_needed "$file"
    compress_jpg "$file"
done < <(find "$IMG_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" \) -not -path "*/_site/*" -print0)

echo ""
echo -e "${BLUE}Procesando PNG...${NC}"
while IFS= read -r -d '' file; do
    resize_if_needed "$file"
    compress_png "$file"
done < <(find "$IMG_DIR" -type f -iname "*.png" -not -path "*/_site/*" -print0)

echo ""
echo -e "${GREEN}════════════════════════════════════════${NC}"
echo -e "${GREEN}✅ Compresión completada${NC}"
echo -e "   Procesadas: $PROCESSED"
echo -e "   Sin cambios: $SKIPPED"
if [ $TOTAL_SAVED -gt 0 ]; then
    echo -e "   Espacio ahorrado: $(format_bytes $TOTAL_SAVED)"
fi
echo -e "${GREEN}════════════════════════════════════════${NC}"
