require "page"
require "file_link"

module Vdoc2Org
  class OrgMode
    attr_reader :filename, :doc

    def initialize(options)
      @filename = options[:filename]
      @doc = options[:doc]
    end
    
    def pages
      doc.pages
    end
    
    def links
      doc.file_links
    end

    def vdoclinks_to_orglinks!
      #title_words = doc.vdoc_links
      pages.sort!
      pages.map do |page|
        page.change_words_to_links(doc) #title_words)
      end
    end

    def write_out
      File.open(filename, 'w:utf-8') do |fd|
        pages.each do |page|
          fd.write "* "
          fd.write page.to_s
          fd.write "\n"
        end
        fd.write "* Links\n"
        links.each do |link|
          fd.write "- "
          fd.write link
          fd.write "\n"
        end
      end
    end
  end
end
