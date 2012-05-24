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
    [_headingState turnLeftRover:self];
}

-(void)turnRight
{
    [_headingState turnRightRover:self];
}

-(void)move
{
    [_headingState moveRover:self];
}

-(NSString*)reportState
{
    return [[[NSString alloc] initWithFormat:@"%d %d %@", _position.x, _position.y, _headingState.headingString] autorelease];
}

@end
