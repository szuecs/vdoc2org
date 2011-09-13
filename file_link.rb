require 'nokogiri'

module Vdoc2Org
  class FileLink
    attr_reader :display_name, :path

    def initialize(el)
      @display_name = el.search('displayName').text
      unpacked_blob = el.search('blob').text.unpack("m").first
      unpacked_blob.force_encoding("ISO-8859-1").encode!("UTF-8")
      match = unpacked_blob.match( /Users\/.*\/#{@display_name}/u )
      @path = "/" + match.to_s
    end
  
    # [[file://path/data|description]]
    def to_s
      "[[file://#{path}|#{display_name}]]"
    end
  end

end
