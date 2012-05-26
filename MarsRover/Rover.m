//
//  Rover.m
//  MarsRover
//
//  Created by Bo on 12-5-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Rover.h"
#import "RoverHeadingState.h"

@implementation Rover
@synthesize headingState = _headingState;
@synthesize position = _position;
@synthesize explorationRangeUpperRight = _explorationRangeUpperRight;

-(void)setHeadingStateByString:(NSString*)headingString
{
    self.headingState = [RoverHeadingStateFactory createStateByHeadingString:headingString];
}

-(void)turnLeft
{
    if(_headingState)
        [_headingState turnLeftRover:self];
}

-(void)turnRight
{
    if(_headingState)
        [_headingState turnRightRover:self];
}

-(void)move
{
    if(_headingState)
        [_headingState moveRover:self];
}

-(NSString*)getHeadingString
{
    return _headingState.headingString;
}

-(NSString*)reportState
{
    if(_headingState){
        NSString* roverState = [[[NSString alloc] initWithFormat:@"%d %d %@", (int)_position.x, (int)_position.y, _headingState.headingString] autorelease];
        
        return roverState;
    }
    else 
    {
        return nil;
    }
}

@end
