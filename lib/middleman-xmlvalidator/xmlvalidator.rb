
module Middleman
  module XMLValidator
    module ValidateLibXml
      require 'libxml'
      class << self
        def registered(app)
          app.after_build do |builder|
            puts "" , "Validating with LibXML" , ""
            Dir.glob("build/*BingSiteAuth.xml").each do |full_path|
              puts "" , "   Validating #{full_path}....."
              ValidateLibXml.validate_file(full_path, '../schema/XMLSchema.xsd')
            end
            Dir.glob("build/*crossdomain.xml").each do |full_path|
              puts "" , "   Validating #{full_path}....."
              ValidateLibXml.validate_file(full_path, '../schema/XMLSchema.xsd')
            end
            Dir.glob("build/*Sitemap.xml").each do |full_path|
              puts "" , "   Validating #{full_path}....."
              ValidateLibXml.validate_file(full_path, '../schema/Sitemap.xsd')
            end
            Dir.glob("build/*.rss").each do |full_path|
              puts "" , "   Validating #{full_path}....."
              ValidateLibXml.validate_file(full_path, '../schema/RSSSchema.xsd')
            end
            puts "" , "Validation with LibXML Complete" , ""
          end
        end
        alias :included :registered
      end

      def self.validate_abstract(xsd, &block)
        begin
          messages = []
          document = block.call
          schema = File.exist?("#{xsd}") ? ::LibXML::XML::Schema.new(xsd) : ::XML::Schema.from_string(xsd)
          result = document.validate_schema(schema) do |message|
            messages << message
          end
        rescue Exception => e
          messages << "General Error: #{e.message}"
        end
        [result || false, messages * ' ']
      end

      def self.validate_file(xml_filename, xsd)
        validate_abstract(xsd) do
          ::LibXML::XML::Document.file(xml_filename)
        end
      end

      def self.validate_string(xml_string, xsd)
        validate_abstract(xsd) do
          ::LibXML::XML::Document.string(xml_string)
        end
      end
    end

    module ValidateNokoGiri
    gem 'nokogiri'
    require 'nokogiri'
      class << self
        def registered(app)
          app.after_build do |builder|
            puts "" , "Validating with NokoGiri" , ""
            Dir.glob("build/*BingSiteAuth.xml").each do |full_path|
              puts "" , "   Validating #{full_path}....." + (ValidateNokoGiri.valid(full_path, '../schema/XMLSchema.xsd') == true ? "COMPLETE".green : "ERRORS FOUND".red)
              ValidateNokoGiri.validate(full_path, '../schema/XMLSchema.xsd').each do |error|
                puts "     " + error.message.red
              end
            end
            Dir.glob("build/*crossdomain.xml").each do |full_path|
              puts "" , "   Validating #{full_path}....." + (ValidateNokoGiri.valid(full_path, '../schema/XMLSchema.xsd') == true ? "COMPLETE".green : "ERRORS FOUND".red)
              ValidateNokoGiri.validate(full_path, '../schema/XMLSchema.xsd').each do |error|
                puts "     " + error.message.red
              end
            end
            Dir.glob("build/*Sitemap.xml").each do |full_path|
              puts "" , "   Validating #{full_path}....." + (ValidateNokoGiri.valid(full_path, '../schema/Sitemap.xsd') == true ? "COMPLETE".green : "ERRORS FOUND".red)
              ValidateNokoGiri.validate(full_path, '../schema/Sitemap.xsd').each do |error|
                puts "     " + error.message.red
              end
            end
            Dir.glob("build/*.rss").each do |full_path|
              puts "" , "   Validating #{full_path}....." + (ValidateNokoGiri.valid(full_path, '../schema/RSSSchema.xsd') == true ? "COMPLETE".green : "ERRORS FOUND".red)
              ValidateNokoGiri.validate(full_path, '../schema/RSSSchema.xsd').each do |error|
                puts "     " + error.message.red
              end
            end
            puts "" , "Validation with NokoGiri Complete" , ""
          end
        end
        alias :included :registered
      end

      def self.validate(document_path, schema_path)
        schema = Nokogiri::XML::Schema(File.read(schema_path))
        document = Nokogiri::XML(File.read(document_path))
        schema.validate(document)
      end

      def self.valid(document_path, schema_path)
        schema = Nokogiri::XML::Schema(File.read(schema_path))
        document = Nokogiri::XML(File.read(document_path))
        schema.valid?(document)
      end
    end
  end
end

#::Middleman::Extensions.register(:validate_libxml, ValidateLibXml)
#::Middleman::Extensions.register(:validate_nokogiri, ValidateNokoGiri)