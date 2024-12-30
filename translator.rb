require 'google/cloud/translate/v2'
require 'yaml'
require 'fileutils'

class LocaleTranslator
  def initialize(api_key, source_locale, target_locale, source_dir, target_dir)
    @api_key = api_key
    @source_locale = source_locale
    @target_locale = target_locale
    @source_dir = source_dir
    @target_dir = target_dir
    @translate = Google::Cloud::Translate.translation_v2_service do |config|
      config.credentials = @api_key
    end
  end

  # Translates text using Google Translate API
  def translate_text(text)
    begin
      translation = @translate.translate(text, to: @target_locale)
      translation.text
    rescue StandardError => e
      puts "Error translating '#{text}': #{e.message}"
      text # Return original text on error
    end
  end

  # Reads source YAML files, translates, and writes the translations to target YAML files
  def translate_locales
    Dir.glob("#{@source_dir}/**/*.yml") do |file|
      source_locale_file = File.basename(file)
      target_locale_file = source_locale_file.sub("/#{@source_locale}/", "/#{@target_locale}/")

      # Ensure target directory exists
      target_locale_path = File.join(@target_dir, target_locale_file)
      FileUtils.mkdir_p(File.dirname(target_locale_path))

      # Read the source YAML file
      source_data = YAML.load_file(file)

      # Translate the content recursively
      translated_data = translate_hash(source_data)

      # Write the translated content to the target YAML file
      File.open(target_locale_path, "w") { |f| f.write(translated_data.to_yaml) }

      puts "Translated #{file} to #{target_locale_path}"
    end
  end

  # Recursively translates hash keys and values
  def translate_hash(hash)
    hash.each_with_object({}) do |(key, value), translated_hash|
      translated_hash[key] = if value.is_a?(Hash)
                               translate_hash(value) # Recursively translate nested hashes
                             else
                               translate_text(value) # Translate the text value
                             end
    end
  end
end

# Example usage:
api_key = "AIzaSyDXoG-6GNjdKS8jdbri46BDPZ-gbkmV7EI"  # Replace with your API key
source_locale = "en"  # Source language
target_locale = "fa"  # Target language (e.g., Persian)
source_dir = "config/locales/ss"  # Path to the source locale files
target_dir = "config/locales/fa"  # Path to the target locale directory

translator = LocaleTranslator.new(api_key, source_locale, target_locale, source_dir, target_dir)
translator.translate_locales
