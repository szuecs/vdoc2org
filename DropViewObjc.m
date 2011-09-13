
#import "DropViewObjc.h"
//#import <MacRuby/MacRuby.h>


@implementation DropViewObjc

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"initWithFrame");
        [self registerForDraggedTypes:[NSArray arrayWithObject:@"public.data"]];
    }
    return self;
}

// will be called once before draggingEnded
- (void)concludeDragOperation:(id < NSDraggingInfo >)sender {
  NSLog(@"concludeDragOperation");  
}

// will be called at drop
- (void)draggingEnded:(id < NSDraggingInfo >)sender {
  NSLog(@"draggingEnded");  
}

// will be called at start
- (NSDragOperation)draggingEntered:(id < NSDraggingInfo >)sender {
  NSLog(@"draggingEntered");
  return YES;
}

- (void)draggingExited:(id < NSDraggingInfo >)sender {
  NSLog(@"draggingExited");
}

// will be called continously
- (NSDragOperation)draggingUpdated:(id < NSDraggingInfo >)sender {
  NSLog(@"draggingUpdated");
  return YES;
}

// will be called on drop
- (BOOL)performDragOperation:(id < NSDraggingInfo >)sender {
	NSLog(@"performDragOperation");
  
  NSPasteboard *pboard = [sender draggingPasteboard];
  
  if ( [[pboard types] containsObject:NSFilenamesPboardType] ) {
    NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];
    
    unsigned int numberOfFiles = [files count];
    unsigned int index = 0;
    NSString *filename , *eval_ruby_str;
    
    for(; index < numberOfFiles; index += 1) {
      id	object = [files objectAtIndex:index];
      filename = [object description];
      NSLog( filename );
//      eval_ruby_str = [NSString stringWithFormat:@"Vdoc2Org::Main.main(:vdoc_xml_file => '%@', :orgfile => '/tmp/foo.org')", filename];
//      NSLog( eval_ruby_str );
//      [[MacRuby sharedRuntime] evaluateString: eval_ruby_str ];
    }
        
  }
  
  // (NSURL *)URLFromPasteboard:(NSPasteboard *)pasteboard
  //NSDraggingInfo: (NSArray *)namesOfPromisedFilesDroppedAtDestination:(NSURL *)dropDestination
	
	return YES;
}

//NSArray * descriptionsFromList( NSArray *list) {
//  return [list map:^(id obj){ return [obj description]; }];
//}


// will be called once before concludeDragOperation and draggingEnded
- (BOOL)prepareForDragOperation:(id < NSDraggingInfo >)sender {
  NSLog(@"prepareForDragOperation");
  
  return YES;
}

// will be called continously (egal ob YES oder NO auch draggingUpdated)
- (BOOL)wantsPeriodicDraggingUpdates {
  NSLog(@"wantsPeriodicDraggingUpdates");
  return YES;
}


- (void)drawRect:(NSRect)dirtyRect {
    // Drawing code here.
}

// debug garbage
void print( NSArray *array ) {
  NSEnumerator *enumerator = [array objectEnumerator];
  id obj;
  
  while ( obj = [enumerator nextObject] ) {
    printf( "print: %s\n", [[obj description] cString] );
  }
}
@end
