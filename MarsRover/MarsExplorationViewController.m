//
//  ViewController.m
//  MarsRover
//
//  Created by bobo on 12-5-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MarsExplorationViewController.h"
#import "RoversControllerInterpreter.h"

@implementation MarsExplorationViewController

//@synthesize plateauView = _plateauView;
//@synthesize instructionField = _instructionField;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _plateauView.image = [UIImage imageNamed:@"marsface.jpg"];
    _plateauViewOriginalFrame = [_plateauView frame];
    [_plateauView sizeToFit];
    _plateauView.userInteractionEnabled = YES;
    
    _instructionField.delegate = self;
}

- (void)viewDidUnload
{
    [_plateauView release];
    _plateauView = nil;
    [_instructionField release];
    _instructionField = nil;
    [_overviewButton release];
    _overviewButton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)dealloc {
    [_plateauView release];
    [_instructionField release];
    [_overviewButton release];
    [super dealloc];
}

#pragma mark Scroll image in UIImageview
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _plateauViewBeginPoint = [[touches anyObject] locationInView:_plateauView];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint pt = [[touches anyObject] locationInView:_plateauView];
    CGRect plateauViewFrame = [_plateauView frame];
    CGPoint plateauViewNewOrigin = plateauViewFrame.origin;
    
    if(plateauViewFrame.size.width > _plateauViewOriginalFrame.size.width)
    {
        plateauViewNewOrigin.x += pt.x - _plateauViewBeginPoint.x;
        
        GLfloat imageRight = plateauViewNewOrigin.x + plateauViewFrame.size.width;
        GLfloat originalViewRight = _plateauViewOriginalFrame.origin.x + _plateauViewOriginalFrame.size.width;
        
        if(plateauViewNewOrigin.x > _plateauViewOriginalFrame.origin.x)
        {
            plateauViewNewOrigin.x = _plateauViewOriginalFrame.origin.x;
        }
        
        if(imageRight < originalViewRight)
        {
            plateauViewNewOrigin.x += originalViewRight - imageRight;
        }
    }
    
    if(plateauViewFrame.size.height > _plateauViewOriginalFrame.size.height)
    {
        plateauViewNewOrigin.y += pt.y - _plateauViewBeginPoint.y;
        
        GLfloat imageBottom = plateauViewNewOrigin.y + plateauViewFrame.size.height;
        GLfloat originalViewBottom = _plateauViewOriginalFrame.origin.y + _plateauViewOriginalFrame.size.height;
        
        if(plateauViewNewOrigin.y > _plateauViewOriginalFrame.origin.y)
        {
            plateauViewNewOrigin.y = _plateauViewOriginalFrame.origin.y;
        }
        
        if(imageBottom < originalViewBottom)
        {
            plateauViewNewOrigin.y += originalViewBottom - imageBottom;
        }
    }
    
    plateauViewFrame.origin = plateauViewNewOrigin;
    
    [_plateauView setFrame:plateauViewFrame];
}


#pragma mark Avoid keyboard covering

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
#define kIphoneKeyboardHeightPortrait 216
    
    const int movementDistance = kIphoneKeyboardHeightPortrait; 
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self animateTextField:_instructionField up:YES];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self animateTextField:_instructionField up:NO];
}

#pragma mark Handle input texts
-(BOOL)textFieldShouldReturn:(UITextField *)textField{    
    [textField resignFirstResponder];
#define kMarginOfGridOnBackground 20
#define kGridUnitDistance   50
    
    UIGraphicsBeginImageContext(_plateauView.frame.size);
    
    GLfloat bgWidth  = _plateauView.frame.size.width;
    GLfloat bgHeight = _plateauView.frame.size.height; 
    //keep the background picture remaining
    [_plateauView.image drawInRect:CGRectMake(0, 0, bgWidth, bgHeight)];

    CGContextRef ctx = UIGraphicsGetCurrentContext();

    CGContextSetLineCap(ctx, kCGLineCapButt);
    CGContextSetLineWidth(ctx,2.0);
    CGContextSetRGBStrokeColor(ctx, 0.0, 0.0, 0.0, 1.0);

    CGContextBeginPath(ctx);
    CGPoint leftBottom = {kMarginOfGridOnBackground, bgHeight - kMarginOfGridOnBackground};
    GLfloat startPointX = leftBottom.x;
    GLfloat startPointY = leftBottom.y;
    //draw vertical line
    int columnNumber = 0;
    @autoreleasepool {
        while(startPointX < bgWidth - kMarginOfGridOnBackground)
        {
            NSString *strColNum = [[[NSString alloc] initWithFormat:@"%d", columnNumber] autorelease];
            
            CGContextMoveToPoint(ctx, startPointX, leftBottom.y);
            CGContextAddLineToPoint(ctx, startPointX, kMarginOfGridOnBackground);
            CGContextStrokePath(ctx);
            
            [strColNum drawAtPoint:CGPointMake(startPointX, leftBottom.y) withFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]];
            
            startPointX += kGridUnitDistance;
            columnNumber++;
        }
    }
    //draw horizon line
    int rowNumber = 0;
    @autoreleasepool {
        while(startPointY > kMarginOfGridOnBackground)
        {
            NSString *strRowNum = [[[NSString alloc] initWithFormat:@"%d", rowNumber] autorelease];
            CGContextMoveToPoint(ctx, leftBottom.x, startPointY);
            CGContextAddLineToPoint(ctx, bgWidth - kMarginOfGridOnBackground, startPointY);
            CGContextStrokePath(ctx);
            
            [strRowNum drawAtPoint:CGPointMake(leftBottom.x, startPointY) withFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]];
            
            startPointY -= kGridUnitDistance;
            rowNumber++;
        }
    }

    _plateauView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); 
    
    //test code
    RoversController *roversController = [[RoversController alloc] init];
    RoversControllerInterpreter *rcInterpreter = [[RoversControllerInterpreter alloc] initWithRoversController:roversController];
    [rcInterpreter receiveInputText:@"5 5"];
    [rcInterpreter receiveInputText:@"5 5 N"];
    
    //
    
    return YES;    
}   

@end
