framework 'Cocoa'

begin
  Sandbox.no_internet.apply!
  # Loading all the Ruby project files.
  main = File.basename(__FILE__, File.extname(__FILE__))
  dir_path = NSBundle.mainBundle.resourcePath.fileSystemRepresentation
  Dir.glob(File.join(dir_path, '*.{rb,rbo}')).map { |x| File.basename(x, File.extname(x)) }.uniq.each do |path|
    if path != main
      require(path)
    end
  end

  # where do I get the frame from?
  #drag_drop  = DropView.alloc.initWithFrame( $Frame )
  # Starting the Cocoa main loop.
  NSApplicationMain(0, nil)
rescue SystemCallError => exception
  puts exception
end
