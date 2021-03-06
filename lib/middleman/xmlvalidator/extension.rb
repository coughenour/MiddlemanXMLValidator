module Middleman
  module Xmlvalidator
    class << self
			def registered(app)
				require 'nokogiri'
				app.after_build do |builder|
					puts "", "Validating with NokoGiri", ""

					Dir.glob("build/**/*BingSiteAuth.xml").each do |full_path|
						puts "  validating".blue + "  #{full_path}....." + (Xmlvalidator.valid(full_path, 'BingSiteAuth.xsd') == true ? "COMPLETE".green : "ERRORS FOUND".red)
						Xmlvalidator.validate(full_path, 'BingSiteAuth.xsd').each do |error|
							puts "     " + error.message
						end
					end

					Dir.glob("build/**/*crossdomain.xml").each do |full_path|
						puts "  validating".blue + "  #{full_path}....." + (Xmlvalidator.valid(full_path, 'crossdomain.xsd') == true ? "COMPLETE".green : "ERRORS FOUND".red)
						Xmlvalidator.validate(full_path, 'crossdomain.xsd').each do |error|
							puts "     " + error.message
						end
					end

					Dir.glob("build/**/*Sitemap.xml").each do |full_path|
						puts "  validating".blue + "  #{full_path}....." + (Xmlvalidator.valid(full_path, 'Sitemap3.xsd') == true ? "COMPLETE".green : "ERRORS FOUND".red)
						Xmlvalidator.validate(full_path, 'Sitemap3.xsd').each do |error|
							puts "     " + error.message
						end
					end

					Dir.glob("build/**/*.rss").each do |full_path|
						puts "  validating".blue + "  #{full_path}....." + (Xmlvalidator.valid(full_path, 'RSSSchema.xsd') == true ? "COMPLETE".green : "ERRORS FOUND".red)
						Xmlvalidator.validate(full_path, 'RSSSchema.xsd').each do |error|
							puts "     " + error.message
						end
					end

					Dir.glob("build/**/*.xml").each do |full_path|
						if not (full_path.match(/^.*BingSiteAuth.xml$/) || full_path.match(/^.*crossdomain.xml$/) || full_path.match(/^.*Sitemap.xml$/))
							puts "  validating".blue + "  #{full_path}....." + (Xmlvalidator.valid(full_path, 'XMLSchema.xsd') == true ? "COMPLETE".green : "ERRORS FOUND".red)
							Xmlvalidator.validate(full_path, 'XMLSchema.xsd').each do |error|
								puts "     " + error.message
							end
						end
					end

					puts "", "Validation with NokoGiri " + "Complete".green, ""
				end
			end
			alias :included :registered
		end

		def self.validate(document_path, schema_path)
			schema = Nokogiri::XML::Schema(File.read(File.join(File.dirname(File.expand_path(__FILE__)), "./schema/" + schema_path)))
			document = Nokogiri::XML(File.read(document_path))
			schema.validate(document)
		end

		def self.valid(document_path, schema_path)
			schema = Nokogiri::XML::Schema(File.read(File.join(File.dirname(File.expand_path(__FILE__)), "./schema/" + schema_path)))
			document = Nokogiri::XML(File.read(document_path))
			schema.valid?(document)
		end
	end
end