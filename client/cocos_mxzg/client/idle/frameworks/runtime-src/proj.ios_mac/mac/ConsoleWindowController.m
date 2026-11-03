
#import "ConsoleWindowController.h"


@interface ColorRGBA()
@end

@implementation ColorRGBA
@end


@interface ConsoleWindowController ()

@end

#define SKIP_LINES_COUNT    3
#define MAX_LINE_LEN        4096
#define MAX_LINES_COUNT     200

@implementation ConsoleWindowController
@synthesize textView;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self)
    {
        // Initialization code here.
        linesCount = [[NSMutableArray arrayWithCapacity:MAX_LINES_COUNT + 1] retain];
    }

    return self;
}

- (void)dealloc
{
    [linesCount release];
    [super dealloc];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}


- (ColorRGBA*)getColorRGB:(NSColor*)color
{
    CGFloat R = 0, G = 0, B = 0, A = 0;
    CGColorRef color1 = color.CGColor;
    NSInteger numComponents = CGColorGetNumberOfComponents(color1);
    if (numComponents == 4)
    {
        const CGFloat *components = CGColorGetComponents(color1);
        R = components[0];
        G = components[1];
        B = components[2];
        A = components[3];
    }
    
    [[NSString alloc] init];
    
    ColorRGBA *data = [[ColorRGBA alloc] init];
    data.r = R;
    data.g = G;
    data.b = B;
    data.a = A;
    
    return data;
}


- (void) trace:(NSString*)msg
{
    if (traceCount >= SKIP_LINES_COUNT && [msg length] > MAX_LINE_LEN)
    {
        msg = [NSString stringWithFormat:@"%@ ...", [msg substringToIndex:MAX_LINE_LEN - 4]];
    }
    traceCount++;
    //    NSLog(@"r= %f,g=%f,b=%f",R,G,B);
    
    NSColor* color = nil;
    
    ColorRGBA* backgroundColor = [self getColorRGB:[textView backgroundColor]];
    if (backgroundColor.r < 40 &&
        backgroundColor.g < 40 &&
        backgroundColor.b < 40) {
        color = [NSColor whiteColor];
    } else {
        color = [NSColor blackColor];
    }
    
    NSFont *font = [NSFont fontWithName:@"Monaco" size:12.0];
    //    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    //    [attrsDictionary setValue:color forKey:NSForegroundColorAttributeName];
    
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                     font, NSFontAttributeName,
                                     color, NSForegroundColorAttributeName,
                                     nil];
    
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:msg attributes:attrsDictionary];
    NSNumber *len = [NSNumber numberWithUnsignedInteger:[string length]];
    [linesCount addObject:len];
    
    NSTextStorage *storage = [textView textStorage];
    [storage beginEditing];
    [storage appendAttributedString:string];
    
    if ([linesCount count] >= MAX_LINES_COUNT)
    {
        len = [linesCount objectAtIndex:0];
        [storage deleteCharactersInRange:NSMakeRange(0, [len unsignedIntegerValue])];
        [linesCount removeObjectAtIndex:0];
    }
    
    [storage endEditing];
    [self changeScroll];
}

- (void) changeScroll
{
    BOOL scroll = [checkScroll state] == NSOnState;
    if(scroll)
    {
        [self.textView scrollRangeToVisible: NSMakeRange(self.textView.string.length, 0)];
    }
}

- (IBAction)onClear:(id)sender
{
    NSTextStorage *storage = [textView textStorage];
    [storage setAttributedString:[[[NSAttributedString alloc] initWithString:@""] autorelease]];
}

- (IBAction)onScrollChange:(id)sender
{
    [self changeScroll];
}

- (IBAction)onTopChange:(id)sender
{
    BOOL isTop = [topCheckBox state] == NSOnState;
    if(isTop)
    {
        [self.window setLevel:NSFloatingWindowLevel];
    }
    else
    {
        [self.window setLevel:NSNormalWindowLevel];
    }
}

@end
