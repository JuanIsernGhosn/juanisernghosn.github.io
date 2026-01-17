#!/usr/bin/env ruby
# Script para exportar archivos YAML de _data a archivos Markdown en export/

require 'yaml'
require 'fileutils'

DATA_DIR = File.join(__dir__, '..', '_data')
EXPORT_DIR = File.join(__dir__, '..', 'export')

# Crear directorio de exportación
FileUtils.mkdir_p(EXPORT_DIR)

# Función para convertir un item a Markdown según su tipo
def item_to_markdown(item, type)
  case type
  when 'work_experience'
    md = "### #{item['company']}\n"
    md += "**Periodo:** #{item['begin']} - #{item['end']}\n\n"
    md += "#{item['comment']}\n"
    md
  when 'education'
    md = "### #{item['centre']}\n"
    md += "**#{item['study']}**\n\n"
    md += "**Periodo:** #{item['begin']} - #{item['end']}\n\n"
    if item['comments']
      item['comments'].each do |comment|
        md += "- **#{comment['name']}:** #{comment['text']}\n"
      end
    end
    md
  when 'courses'
    md = "### #{item['name']}\n"
    md += "- **Institución:** #{item['institution']}\n"
    md += "- **Fecha:** #{item['date']}\n"
    md += "- **Certificado:** [Ver certificado](#{item['url']})\n" if item['url']
    md
  when 'certifications'
    md = "### #{item['name']}\n"
    md += "- **Institución:** #{item['institution']}\n" if item['institution']
    md += "- **Fecha:** #{item['date']}\n" if item['date']
    md += "- **URL:** [Ver](#{item['url']})\n" if item['url']
    md
  when 'research_work'
    md = "### #{item['title'] || item['name']}\n"
    md += "- **Tipo:** #{item['type']}\n" if item['type']
    md += "- **Fecha:** #{item['date']}\n" if item['date']
    md += "- **Descripción:** #{item['description']}\n" if item['description']
    md += "- **URL:** [Ver](#{item['url']})\n" if item['url']
    md
  when 'expertise'
    md = "### #{item['name']}\n"
    if item['skills']
      item['skills'].each do |skill|
        md += "- #{skill['name']}"
        md += " (#{skill['level']})" if skill['level']
        md += "\n"
      end
    end
    md
  when 'introduction'
    md = ""
    item.each do |key, value|
      md += "**#{key.capitalize}:** #{value}\n\n"
    end
    md
  when 'settings'
    md = ""
    item.each do |key, value|
      md += "- **#{key}:** #{value}\n"
    end
    md
  else
    # Formato genérico para tipos desconocidos
    md = ""
    if item.is_a?(Hash)
      item.each do |key, value|
        if value.is_a?(Array)
          md += "**#{key}:**\n"
          value.each { |v| md += "  - #{v}\n" }
        elsif value.is_a?(Hash)
          md += "**#{key}:**\n"
          value.each { |k, v| md += "  - #{k}: #{v}\n" }
        else
          md += "**#{key}:** #{value}\n"
        end
      end
    else
      md += "#{item}\n"
    end
    md
  end
end

# Títulos legibles para cada tipo de archivo
TITLES = {
  'work_experience' => 'Experiencia Laboral',
  'education' => 'Educación',
  'courses' => 'Cursos',
  'certifications' => 'Certificaciones',
  'research_work' => 'Trabajos de Investigación',
  'expertise' => 'Áreas de Expertise',
  'introduction' => 'Introducción',
  'settings' => 'Configuración'
}

# Procesar cada archivo YAML
Dir.glob(File.join(DATA_DIR, '*.{yml,yaml}')).each do |yaml_file|
  filename = File.basename(yaml_file, '.*')
  data = YAML.load_file(yaml_file)

  next if data.nil?

  title = TITLES[filename] || filename.gsub('_', ' ').capitalize

  md_content = "# #{title}\n\n"
  md_content += "---\n\n"

  if data.is_a?(Array)
    data.each_with_index do |item, index|
      md_content += item_to_markdown(item, filename)
      md_content += "\n---\n\n" unless index == data.length - 1
    end
  elsif data.is_a?(Hash)
    md_content += item_to_markdown(data, filename)
  end

  # Escribir archivo Markdown
  output_file = File.join(EXPORT_DIR, "#{filename}.md")
  File.write(output_file, md_content)
  puts "Exportado: #{output_file}"
end

puts "\n✓ Exportación completada en: #{EXPORT_DIR}"
