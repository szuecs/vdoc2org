require 'optparse'

require 'rubygems'
#require 'bundler/setup'

require 'nokogiri'
require 'vdoc'
require 'org_mode'
require 'drop_view'

module Vdoc2Org
  VERSION = '11.8.23'
  
  class Main
    def initialize
      @exit_code = 0
    end
  
    attr_accessor :window, :quit_button, :import_button, :drop_view
    
    # should open a new view.
    def version(sender)
      v = ::Vdoc2Org::VERSION
      puts "version: #{v}"
      v
    end
    
    def quit_action(sender)
      puts "Quit Action"
      exit(@exit_code)
    end
    
    # button action
    def import_action(sender)
      filename = drop_view.filenames.detect {|fname| File.extname(fname) == ".xml"}
      if filename
        import(filename)
      else
        import_dialog
      end
    end
    
    # click import button
    def import_dialog
      dialog = NSOpenPanel.new
      dialog.allowedFileTypes = ["xml"]
      if dialog.runModal == NSOKButton
        import(dialog.filename)
      end
    end
    
    def import(filename)
      begin
        fd = File.open(filename, 'r:utf-8')
        @vdoc = Vdoc.new(fd)
        puts "@vdoc.pages.sizes: #{@vdoc.pages.sizes}"
      ensure
        fd.close()
      end
    end
    
    # "save File"-dialog
    def export_action(sender)
      dialog = NSSavePanel.new
      dialog.allowedFileTypes = ["org"]
      if dialog.runModal == NSOKButton
        export(dialog.filename)
      end
    end
    
    def export(filename)
      begin
        org = OrgMode.new(:filename => filename, :doc => @vdoc)
        org.vdoclinks_to_orglinks!
        org.write_out
      rescue Exception => e
        STDERR.puts e
        STDERR.puts e.backtrace
        @exit_code = 1
      end
    end
    
    def drop_action(sender)
      puts "drop_action: got filenames: #{drop_view.filenames.join(', ')}"
    end
    
    # command line style
    class << self
      def default_options
        {
          :orgfile => "/tmp/vdoc.org",
          :vdoc_xml_file => "", #"/Users/sszuecs/Documents/plan_backup_upgrade3.vpdoc.xml",
        }
      end
    
      def parse_options
        options = default_options
        
        executable_name = File.basename(__FILE__).sub(/\.rb$/,'')
        
        OptionParser.new do |opts|
          opts.banner  = "% #{executable_name} [options]"
          opts.version = ::Vdoc2Org::VERSION
          opts.separator ""
          opts.separator "Specific options:"
          opts.separator ""
          
          opts.on('-h', '--help', 'Display this help.') do
            abort "#{opts}"
          end
          opts.on('-V', '--version', 'Print version.') do |s|
            abort("#{executable_name} #{::NameSpace::VERSION}")
          end
          
          opts.on('--vdoc <name>', 'VoodooPad vdoc xml file.') do |s|
            options[:vdoc_xml_file] = s
          end
          
          opts.on('--org <name>', 'Org-Mode output file.') do |s|
            options[:orgfile] = s
          end
          
          begin
            opts.parse!
            rescue => e
            abort "#{e}\n\n#{opts}"
          end
        end
        options
      end
      
      def main(options)
        begin
          fd = File.open(options[:vdoc_xml_file], 'r:utf-8')
          vdoc = Vdoc.new(fd) 
          
          org = OrgMode.new(:filename => options[:orgfile], :doc => vdoc)
          org.vdoclinks_to_orglinks!
          org.write_out
        rescue Exception => e
          STDERR.puts e
          STDERR.puts e.backtrace
          return 1
        else
          return 0
        ensure
          fd.close
        end
      end
	  
    end # class methods end    

  end # class Main
end

