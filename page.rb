require 'nokogiri'

module Vdoc2Org
  class Page
    attr_reader :display_name
    attr_accessor :lines

    def initialize(el)
      vdoc_page_name = el.search('displayName').text
      @display_name = vdoc_page_name.gsub(" ","_").downcase
      content = el.search('content').text
      @lines = content.split("\n")
    end
  
    def to_s
      "#{display_name}\n" + lines.join("\n")
    end

    def <=>(other)
      display_name <=> other.display_name
    end

    # return a uniy word list of the content of this page
    def words
      word_list = @lines.map do |line|
        line.split(" ")
      end
      word_list.uniq
    end

    # [[file:tools.org][see tools.org]]
    # [[libcloud]]
    def word_to_orglink(word)
      result = word.gsub(" ","_").downcase
      pre = post = ""

      if word.match( /(\().*(\))/ ) or word.match( /(\().*|.*(\))/ )
        pre_match = $1
        post_match = $2
        pre  = " " + pre_match if pre_match
        post = " " + post_match if post_match
      end
      result = pre + "[[" + result + "]]" + post

      return result
    end

    def change_words_to_links(vdoc)
      @lines.map! do |line|
        if line.match(/^  /)
          line
        else
          line.split(" ").map do |word|
            if vdoc.include? word
              word_to_orglink(word)
            else
              word
            end
          end.join(" ")
        end
      end.join("\n")

      @lines
    end

  end
end
