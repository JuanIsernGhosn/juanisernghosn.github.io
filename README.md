# Juan Isern - Portfolio Personal

Sitio web personal desarrollado con Jekyll, desplegado en GitHub Pages.

🌐 **URL:** [https://jisern.rocks](https://jisern.rocks)

## Requisitos Previos

Antes de comenzar, asegúrate de tener instalado:

- **Ruby** (versión 2.7 o superior)
- **Bundler** (gestor de gemas de Ruby)
- **Make** (para usar el Makefile)

### Instalación de Ruby y Bundler

**macOS:**
```bash
# Ruby viene preinstalado, pero se recomienda usar rbenv o rvm
brew install rbenv ruby-build
rbenv install 3.1.0
rbenv global 3.1.0

# Instalar Bundler
gem install bundler
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt update
sudo apt install ruby-full build-essential zlib1g-dev
gem install bundler
```

**Windows:**
- Descarga e instala [RubyInstaller](https://rubyinstaller.org/)
- Durante la instalación, asegúrate de agregar Ruby al PATH

## Inicio Rápido

### 1. Instalar Dependencias

```bash
make install
```

Este comando instalará todas las gemas necesarias en `vendor/bundle`.

### 2. Lanzar Servidor de Desarrollo

```bash
make serve
```

El sitio estará disponible en [http://localhost:4000](http://localhost:4000) con recarga automática (livereload).

### Atajo de Desarrollo

Para instalar y servir en un solo comando:

```bash
make dev
```

## Comandos Disponibles

Ejecuta `make help` o `make` para ver todos los comandos disponibles:

### Desarrollo

- `make install` - Instala las dependencias de Ruby
- `make update` - Actualiza las dependencias
- `make serve` - Lanza el servidor de desarrollo con livereload
- `make serve-drafts` - Incluye borradores en el servidor
- `make serve-future` - Incluye posts con fecha futura
- `make serve-all` - Incluye borradores y posts futuros
- `make dev` - Instala dependencias y lanza servidor (atajo)

### Construcción

- `make build` - Construye el sitio en `_site/`
- `make build-prod` - Construye para producción con optimizaciones

### Mantenimiento

- `make clean` - Limpia archivos generados (`_site/`, `.jekyll-cache/`)
- `make clean-all` - Limpia todo incluyendo dependencias
- `make check` - Verifica la configuración de Jekyll
- `make status` - Muestra el estado del repositorio git

### Crear Contenido

- `make new-post TITLE="Título del Post"` - Crea un nuevo post en `content/projects/_posts/`

**Ejemplo:**
```bash
make new-post TITLE="Mi Nuevo Proyecto"
```

## Estructura del Proyecto

```
.
├── _config.yml              # Configuración de Jekyll
├── _data/                   # Datos estructurados (YAML)
│   ├── certifications.yml
│   ├── courses.yaml
│   ├── education.yml
│   ├── expertise.yml
│   └── settings.yml
├── _includes/               # Componentes HTML reutilizables
├── _layouts/                # Plantillas de página
├── _site/                   # Sitio generado (no versionado)
├── assets/                  # Recursos estáticos
│   ├── documents/
│   └── img/
├── content/                 # Contenido del sitio
│   └── projects/
│       └── _posts/         # Posts de proyectos
├── pages/                   # Páginas principales
│   ├── index.html
│   ├── projects.html
│   └── talks.html
├── res/                     # Recursos (CSS, JS)
│   ├── css/
│   └── js/
├── vendor/                  # Dependencias (no versionado)
├── Gemfile                  # Dependencias de Ruby
├── Gemfile.lock            # Versiones exactas de gemas
├── Makefile                # Comandos de automatización
└── README.md               # Este archivo
```

## Configuración

### Personalización

Edita [_config.yml](_config.yml) para personalizar:

- Título del sitio
- Descripción
- URLs de redes sociales
- Email
- Plugins

**Nota:** Después de modificar `_config.yml`, debes reiniciar el servidor.

### Datos Personales

Los datos estructurados se encuentran en el directorio [_data/](_data/):

- `certifications.yml` - Certificaciones
- `courses.yaml` - Cursos
- `education.yml` - Educación
- `expertise.yml` - Áreas de especialización
- `settings.yml` - Configuraciones adicionales

## Desarrollo

### Agregar un Nuevo Post

1. **Usando el comando:**
   ```bash
   make new-post TITLE="Título de mi Proyecto"
   ```

2. **Manualmente:**
   - Crea un archivo en `content/projects/_posts/` con el formato: `YYYY-MM-DD-titulo.md`
   - Agrega el front matter:
     ```yaml
     ---
     layout: post
     title: "Título del Post"
     date: YYYY-MM-DD
     categories: projects
     ---
     ```

### Agregar Imágenes

Coloca las imágenes en `assets/img/` y referéncialas en Markdown:

```markdown
![Descripción](/assets/img/mi-imagen.jpg)
```

### Estilos y Scripts

- CSS: `res/css/`
- JavaScript: `res/js/`

## Despliegue

Este sitio está configurado para desplegarse automáticamente en GitHub Pages.

### Despliegue Automático

Los cambios en la rama `master` se despliegan automáticamente.

### Construcción Local para Producción

```bash
make build-prod
```

El sitio se generará en el directorio `_site/` optimizado para producción.

## Solución de Problemas

### Error: "bundle: command not found"

Instala Bundler:
```bash
gem install bundler
```

### Error: "Could not find gem"

Reinstala las dependencias:
```bash
make clean-all
make install
```

### El servidor no recarga automáticamente

Reinicia el servidor:
```bash
# Detén el servidor (Ctrl+C)
make serve
```

### Error: "Permission denied"

En algunos sistemas, puede ser necesario usar `sudo`:
```bash
sudo gem install bundler
```

O configurar Ruby para instalar gemas sin sudo (recomendado).

## Tecnologías Utilizadas

- [Jekyll 4.0](https://jekyllrb.com/) - Generador de sitios estáticos
- [Minima](https://github.com/jekyll/minima) - Tema base
- [AOS.js](https://michalsnik.github.io/aos/) - Animaciones on scroll
- [GitHub Pages](https://pages.github.com/) - Hosting

## Plugins de Jekyll

- `jekyll-feed` - Genera feed RSS
- `jekyll-seo-tag` - Optimización SEO

## Licencia

© Juan Isern - Todos los derechos reservados

## Contacto

- **Email:** [juan.isern95@gmail.com](mailto:juan.isern95@gmail.com)
- **LinkedIn:** [juan-isern](https://linkedin.com/in/juan-isern)
- **GitHub:** [JuanIsernGhosn](https://github.com/JuanIsernGhosn)
- **Twitter:** [@juan_isern](https://twitter.com/juan_isern)

## Recursos Adicionales

- [Documentación de Jekyll](https://jekyllrb.com/docs/)
- [GitHub Pages Documentation](https://docs.github.com/en/pages)
- [Markdown Cheatsheet](https://www.markdownguide.org/cheat-sheet/)
