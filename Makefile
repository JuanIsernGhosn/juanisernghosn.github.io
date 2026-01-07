.PHONY: help install serve build clean deploy status

# Variables
JEKYLL = bundle exec jekyll
BUNDLE = bundle

# Default target
.DEFAULT_GOAL := help

help: ## Muestra este mensaje de ayuda
	@echo "Comandos disponibles para el sitio Jekyll:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'
	@echo ""

install: ## Instala las dependencias de Ruby (gems)
	@echo "📦 Instalando dependencias..."
	$(BUNDLE) install --path vendor/bundle

update: ## Actualiza las dependencias
	@echo "🔄 Actualizando dependencias..."
	$(BUNDLE) update

serve: ## Lanza el servidor de desarrollo en http://localhost:4000
	@echo "🚀 Lanzando servidor de desarrollo..."
	@echo "🌐 Abre http://localhost:4000 en tu navegador"
	$(JEKYLL) serve --livereload

serve-drafts: ## Lanza el servidor incluyendo borradores
	@echo "🚀 Lanzando servidor con borradores..."
	$(JEKYLL) serve --livereload --drafts

serve-future: ## Lanza el servidor incluyendo posts con fecha futura
	@echo "🚀 Lanzando servidor con posts futuros..."
	$(JEKYLL) serve --livereload --future

serve-all: ## Lanza el servidor con borradores y posts futuros
	@echo "🚀 Lanzando servidor con todo el contenido..."
	$(JEKYLL) serve --livereload --drafts --future

build: ## Construye el sitio estático en _site/
	@echo "🔨 Construyendo sitio..."
	$(JEKYLL) build

build-prod: ## Construye el sitio para producción
	@echo "🔨 Construyendo sitio para producción..."
	JEKYLL_ENV=production $(JEKYLL) build

clean: ## Limpia archivos generados (_site, .jekyll-cache)
	@echo "🧹 Limpiando archivos generados..."
	$(JEKYLL) clean
	@rm -rf .sass-cache

clean-all: clean ## Limpia todo incluyendo dependencias
	@echo "🧹 Limpiando dependencias..."
	@rm -rf vendor/bundle .bundle

status: ## Muestra el estado del repositorio git
	@echo "📊 Estado del repositorio:"
	@git status

dev: install serve ## Instala dependencias y lanza servidor (atajo para desarrollo)

check: ## Verifica la configuración de Jekyll
	@echo "🔍 Verificando configuración..."
	$(JEKYLL) doctor

new-post: ## Crea un nuevo post (uso: make new-post TITLE="Mi Post")
	@if [ -z "$(TITLE)" ]; then \
		echo "❌ Error: Debes especificar TITLE"; \
		echo "Uso: make new-post TITLE=\"Título del Post\""; \
		exit 1; \
	fi
	@DATE=$$(date +%Y-%m-%d); \
	SLUG=$$(echo "$(TITLE)" | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g' | sed 's/[^a-z0-9-]//g'); \
	FILE="content/projects/_posts/$$DATE-$$SLUG.md"; \
	echo "📝 Creando nuevo post: $$FILE"; \
	mkdir -p content/projects/_posts; \
	echo "---" > $$FILE; \
	echo "layout: post" >> $$FILE; \
	echo "title: \"$(TITLE)\"" >> $$FILE; \
	echo "date: $$DATE" >> $$FILE; \
	echo "categories: projects" >> $$FILE; \
	echo "---" >> $$FILE; \
	echo "" >> $$FILE; \
	echo "Escribe tu contenido aquí..." >> $$FILE; \
	echo "✅ Post creado: $$FILE"
