//
//  RoverState.m
//  MarsRover
//
//  Created by Bo on 12-5-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RoverHeadingState.h"
#import "Rover.h"

@implementation RoverHeadingState
@synthesize headingString = _headingString;
@synthesize position = _position;
@synthesize upperRight = _upperRight;
@end

#pragma mark States of different headings
@interface RoverStateNorth : RoverHeadingState
@end

@interface RoverStateEast  : RoverHeadingState
@end

@interface RoverStateSouth : RoverHeadingState
@end

@interface RoverStateWest  : RoverHeadingState
@end

#pragma mark State of heading to north
@implementation RoverStateNorth
-(RoverStateNorth*)init
{
    if((self = [super init]))
    {
        self.headingString = kNorth;
    }
    return  self;
}
-(void)turnLeftRover:(Rover *)rover
{
    @autoreleasepool {
        rover.headingState = [[[RoverStateWest alloc] init] autorelease];
    }
}
-(void)turnRightRover:(Rover *)rover
{
    @autoreleasepool {
        rover.headingState = [[[RoverStateEast alloc] init] autorelease];
    }
}
-(void)moveRover:(Rover *)rover
{
    if(rover.position.y < rover.explorationRangeUpperRight.y )
    {
        rover.position = CGPointMake(rover.position.x, rover.position.y + 1);   
    }
}
@end

#pragma mark State of heading to east
@implementation RoverStateEast
-(RoverStateEast*)init
{
    if((self = [super init]))
    {
        self.headingString = kEast;
    }
    return  self;
}
-(void)turnLeftRover:(Rover *)rover
{
    @autoreleasepool {
        rover.headingState = [[[RoverStateNorth alloc] init] autorelease];
    }
}
-(void)turnRightRover:(Rover *)rover
{
    @autoreleasepool {
        rover.headingState = [[[RoverStateSouth alloc] init] autorelease];
    }
}
-(void)moveRover:(Rover *)rover
{
    if(rover.position.x < rover.explorationRangeUpperRight.x )
    {
        rover.position = CGPointMake(rover.position.x + 1, rover.position.y);   
    }
}
@end

#pragma mark State of heading to south
@implementation RoverStateSouth
-(RoverStateSouth*)init
{
    if((self = [super init]))
    {
        self.headingString = kSouth;
    }
    return  self;
}
-(void)turnLeftRover:(Rover *)rover
{
    @autoreleasepool {
        rover.headingState = [[[RoverStateWest alloc] init] autorelease];
    }
}
-(void)turnRightRover:(Rover *)rover
{
    @autoreleasepool {
        rover.headingState = [[[RoverStateEast alloc] init] autorelease];
    }
}
-(void)moveRover:(Rover *)rover
{
    if(rover.position.y > 0)
    {
        rover.position = CGPointMake(rover.position.x, rover.position.y - 1);   
    }
}
@end

#pragma mark State of Heading to west
@implementation RoverStateWest
-(RoverStateWest*)init
{
    if((self = [super init]))
    {
        self.headingString = kWest;
    }
    return  self;
}
-(void)turnLeftRover:(Rover *)rover
{
    @autoreleasepool {
        rover.headingState = [[[RoverStateSouth alloc] init] autorelease];
    }
}
-(void)turnRightRover:(Rover *)rover
{
    @autoreleasepool {
        rover.headingState = [[[RoverStateNorth alloc] init] autorelease];
    }
}
-(void)moveRover:(Rover *)rover
{
    if(rover.position.x > 0 )
    {
        rover.position = CGPointMake(rover.position.x - 1, rover.position.y);   
    }
}
@end

@implementation RoverHeadingStateFactory
+(RoverHeadingState*)createStateByHeadingString:(NSString *)headingString
{
    RoverHeadingState* (^createState)();
    NSDictionary *funcMap = [NSDictionary dictionaryWithObjectsAndKeys:
                             ^(){return [[[RoverStateNorth alloc] init] autorelease];}, kNorth,
                             ^(){return [[[RoverStateEast alloc] init] autorelease];}, kEast,
                             ^(){return [[[RoverStateSouth alloc] init] autorelease];}, kSouth,
                             ^(){return [[[RoverStateWest alloc] init] autorelease];}, kWest,
                             nil];
    
    createState = [funcMap objectForKey:headingString];
    
    if(createState)
       return createState();
    else 
       return nil;
}
@end
