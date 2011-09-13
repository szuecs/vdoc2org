framework 'Cocoa'

class DropView < NSView
  DEBUG = false
  
  attr_accessor :filenames

  # here is the problem
  def initWithFrame(frame)
    puts "initWithFrame: #{frame.inspect}" if DEBUG
    super 
    @filenames = []
    registerForDraggedTypes [NSFilenamesPboardType, nil]
    
    self
  end
    
  # // will be called once before draggingEnded
  def concludeDragOperation(sender)
    puts "concludeDragOperation" if DEBUG
  end

  # // will be called at drop
  def draggingEnded(sender)
    puts "draggingEnded" if DEBUG
  end

  #// will be called at start
  def draggingEntered(sender)
    puts "draggingEntered" if DEBUG
    return true
  end

  def draggingExited(sender)
    purts "draggingExited" if DEBUG
  end

  def draggingUpdated(sender)
    puts "draggingUpdated" if DEBUG
    return true
  end

  # // will be called on drop
  def performDragOperation(sender)
    # NSLog(@"performDragOperation");
    puts "performDragOperation" if DEBUG
  
    #NSPasteboard *pboard = [sender draggingPasteboard];
    pboard = sender.draggingPasteboard
  
    #if pboard.types.contains? NSFilenamesPboardType
      files = pboard.propertyListForType NSFilenamesPboardType
      filename = ""
      files.each do |file|
        filename = file.description
        puts "filename: #{filename}" if DEBUG
        @filenames << filename
      end
    #end
	
    return true
  end

  # // will be called once before concludeDragOperation and draggingEnded
  def prepareForDragOperation(sender)
    # NSLog(@"prepareForDragOperation");
    return true
  end

  # will be called continously (egal ob YES oder NO auch draggingUpdated)
  def wantsPeriodicDraggingUpdates 
    true
  end

  # NSView settings
  def drawRect(rect)
    #NSColor.redColor.set
    NSColor.grayColor.set
    NSBezierPath.fillRect(rect)
    #draw_text "Put Help Text Here" #, true
    draw_image rect, "file://localhost/Users/sszuecs/Programmierung/ruby/macruby/vdoc2org/document-import-2.png"
  end

  def temp_context(&block)
    context = NSGraphicsContext.currentContext
    context.saveGraphicsState
    yield
    context.restoreGraphicsState
  end
  
  def draw_text(text, shadow=false)
    temp_context do
      if shadow
        shadow = NSShadow.alloc.init
        shadow.shadowOffset = [4, -4]
        shadow.set
      end
      font = NSFont.fontWithName("Helvetica", size:24)
      attributes = {NSFontAttributeName => font, NSForegroundColorAttributeName => NSColor.whiteColor}
      text.drawAtPoint([60, 120], withAttributes: attributes)
    end
  end
  
  def draw_image(rect, url='http://bit.ly/apple_logo_png')
    temp_context do
      img_url = NSURL.URLWithString(url)
      img = NSImage.alloc.initWithContentsOfURL(img_url)
      img.drawInRect(rect, fromRect: NSZeroRect, operation: NSCompositeSourceOver, fraction: 0.25)
    end
  end
end
