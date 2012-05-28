//
//  ViewController.m
//  MarsRover
//
//  Created by bobo on 12-5-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MarsExplorationViewController.h"
#import "RoversControllerInterpreter.h"
#import "PlateauGridView.h"
#import "RoverView.h"

@interface RoverState : NSObject
{
    CGPoint     _position;
    NSString    *_headingString;
}
@property (assign, nonatomic) CGPoint position;
@property (assign, nonatomic) NSString* headingString; 
-(id)initWithPosition:(CGPoint)position andHeadingString:(NSString*)headingString;
@end

@implementation RoverState
@synthesize position = _position;
@synthesize headingString = _headingString;
-(id)initWithPosition:(CGPoint)position andHeadingString:(NSString *)headingString
{
    if((self = [super init]))
    {
        self.position = position;
        self.headingString = headingString;
    }
    return self;
}
@end

@implementation MarsExplorationViewController

@synthesize roversController = _roversController;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _plateauView.image = [UIImage imageNamed:@"marsface.jpg"];
    _plateauViewOriginalFrame = [_plateauView frame];
    [_plateauView sizeToFit];
    _plateauView.userInteractionEnabled = YES;
    
    _plateauGridView = [PlateauGridView alloc];
    
    _instructionField.delegate = self;
    
    _roversController = [[RoversController alloc] init];
    _rcInterpreter = [[RoversControllerInterpreter alloc] initWithRoversController:_roversController];
    _roverViewList = [[NSMutableArray alloc] init];
    
    _roverStateTrackList =[[NSMutableArray alloc] init];
        
    [self addObserver:self
           forKeyPath:@"roversController.explorationRangeUpperRight"
              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
              context:NULL];
    
    [self addObserver:self
           forKeyPath:@"roversController.currentRover"
              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
              context:NULL];
    
    [self addObserver:self
           forKeyPath:@"roversController.currentRover.position"
              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
              context:NULL];
    
    [self addObserver:self
           forKeyPath:@"roversController.currentRover.headingState"
              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
              context:NULL];
    
    [self addObserver:self
           forKeyPath: @"roversController.currentNavigationFinished"
              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
              context:NULL];
}

- (void)viewDidUnload
{
    [self removeObserver:self forKeyPath:@"roversController.explorationRangeUpperRight"];
    [self removeObserver:self forKeyPath:@"roversController.currentRover"];
    [self removeObserver:self forKeyPath:@"roversController.currentRover.position"];
    [self removeObserver:self forKeyPath:@"roversController.currentRover.headingState"];
    [self removeObserver:self forKeyPath:@"roversController.currentNavigationFinished"];
    [_plateauGridView release];
    _plateauGridView = nil;
    [_plateauView release];
    _plateauView = nil;
    [_instructionField release];
    _instructionField = nil;
    [_overviewButton release];
    _overviewButton = nil;
    [_roversController release];
    _roversController = nil;
    [_rcInterpreter release];
    _rcInterpreter = nil;
    [_roverViewList release];
    _roverViewList = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)dealloc {
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

- (void)movePlateauViewToLeftBottom
{
    const float movementDuration = 0.3f;
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    
    CGPoint newOrigin;
    newOrigin.x = 0;
    newOrigin.y = _plateauViewOriginalFrame.size.height - _plateauView.frame.size.height;
    CGRect  newFrame = CGRectMake(newOrigin.x, newOrigin.y, _plateauView.frame.size.width,  _plateauView.frame.size.height);
    [_plateauView setFrame:newFrame];
    [UIView commitAnimations];
}

-(void)showGridWithRoverExplorationRange:(CGPoint)roverUpperRight
{
    GLfloat bgHeight = _plateauView.frame.size.height; 


    CGSize  gridSize = [PlateauGridView getProperSizeByUpperLeftPoint:roverUpperRight];
    CGFloat gridFrameLeft   = 0;
    CGFloat gridFrameTop    = bgHeight - gridSize.height;
    CGRect  gridFrame = CGRectMake(gridFrameLeft, gridFrameTop, gridSize.width, gridSize.height);
    [_plateauGridView initWithFrame:gridFrame];
    [_plateauGridView setBackgroundColor:[UIColor clearColor]];
    [_plateauView addSubview:_plateauGridView];
    
    [self movePlateauViewToLeftBottom];
}

-(void)addRoverViewByCurrentRover:(Rover*)rover
{
    @autoreleasepool 
    {
        RoverView *roverView = [[[RoverView alloc] initWithHeadingString:[rover getHeadingString]] autorelease];
        [roverView sizeToFit];
        [roverView changeHeadingByHeadingString:[rover getHeadingString]];

        roverView.center = [_plateauGridView getPositionInGridByRoverPosition:rover.position];
        
        [_plateauGridView addSubview:roverView];
        [_roverViewList addObject:roverView];
        _currentRoverViewIndex++;
    }
}

-(void)animateRoverMovement:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {

    if(_roverViewAnimationIndex < [_roverStateTrackList count])
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelay:0];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animateRoverMovement:finished:context:)];
        RoverView *currentRoverView = [_roverViewList objectAtIndex:[_roversController getCurrentRoverIndex]];
        RoverState *roverState = [_roverStateTrackList objectAtIndex:_roverViewAnimationIndex];
        [currentRoverView changeHeadingByHeadingString:roverState.headingString];
        currentRoverView.center = [_plateauGridView getPositionInGridByRoverPosition:roverState.position];
        _roverViewAnimationIndex++;
        [UIView commitAnimations];
    }
    else
    {
        [_roverStateTrackList removeAllObjects];
        _roverViewAnimationIndex = 0;
    }
}

#pragma mark Handle input texts
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
   
    if(![_rcInterpreter receiveInputText:[textField text]])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Can't execute input command" 
                                                        message:[_rcInterpreter getErrorMessage] 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    return YES;    
}   

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if([keyPath isEqualToString:@"roversController.explorationRangeUpperRight"])
    {
        [self showGridWithRoverExplorationRange:self.roversController.explorationRangeUpperRight];
    }
    
    if([keyPath isEqualToString:@"roversController.currentRover"])
    {
        [self addRoverViewByCurrentRover:self.roversController.currentRover];
    }
    
    if([keyPath isEqualToString:@"roversController.currentRover.position"] || [keyPath isEqualToString:@"roversController.currentRover.headingState"])
    {
        if([_roversController getRoversCount] == [_roverViewList count])
        {
            RoverState *roverState = [[[RoverState alloc] initWithPosition:self.roversController.currentRover.position andHeadingString:[self.roversController.currentRover getHeadingString]] autorelease];
            [_roverStateTrackList addObject:roverState];
        }
    }
    
    if([keyPath isEqualToString:@"roversController.currentNavigationFinished"])
    {
        if(self.roversController.currentNavigationFinished)
        {
            _roverViewAnimationIndex = 0;
            [self animateRoverMovement:nil finished:nil context:nil];
        }
    }
}

@end
