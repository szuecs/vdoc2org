require 'set'
require 'nokogiri'

require 'page'
require 'file_link'

module Vdoc2Org
  class Vdoc
    attr_reader :pages, :file_links

    def initialize(io)
      doc = Nokogiri::XML(io)
      node_set = doc.elements
      xml_pages = node_set.search('//data').select {|el| el.search('type').text == 'page' }
      @pages = xml_pages.map {|xml_page| Page.new(xml_page) }
      puts "@pages.size: #{@pages.size}"
      xml_links = node_set.search('//item').select {|el| el.search('type').text == 'fileAlias' }
      @file_links = xml_links.map {|xml_link| FileLink.new(xml_link) }
      puts "@file_links.size: #{@file_links.size}"
    end

    # Returns a set of Vdoc-Page-Names. It uses a cache.
    def vdoc_links
      return @link_set if defined? @link_set
      
      @link_set = Set.new
      pages.each {|page| @link_set << page.display_name }
      @link_set
    end

    def include? word
      if word.match( /(\().*(\))/ ) or word.match( /(\().*|.*(\))/ )
        pre_match = $1
        post_match = $2
        word.sub!(pre_match, "") if pre_match
        word.sub!(post_match, "") if post_match
      end
      word.downcase!

      vdoc_links.include? word.downcase
    end
  end
end
