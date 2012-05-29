//
//  RoversController.m
//  MarsRover
//
//  Created by bobo on 12-5-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RoversController.h"
#import "RoverNavigationCommand.h"

@implementation RoversController
@synthesize explorationRangeUpperRight = _explorationRangeUpperRight;
@synthesize currentRover = _currentRover;
@synthesize currentNavigationFinished = _currentNavigationFinished;

-(id)init
{
    if((self = [super init]))
    {
        _roversList = [[NSMutableArray alloc] init];
        _currentRoverCommandQueue = [[NSMutableArray alloc] init];
    }
    
    return self;
}

//Internal setter
-(void)setExplorationRangeUpperRight:(CGPoint)explorationRangeUpperRight
{
    _explorationRangeUpperRight = explorationRangeUpperRight;
}

-(BOOL)setRangeUpperRight:(CGPoint)upperRight
{
    if(upperRight.x < 0 || upperRight.y < 0)
    {
        return NO;   
    }
    else
    {
        self.explorationRangeUpperRight = upperRight;
        return YES;
    }
}

//Internal setter
-(void)setCurrentRover:(Rover *)currentRover
{
    _currentRover = currentRover;
}

-(BOOL)deployRoverWithPosition:(CGPoint)pos headingChar:(NSString*)headingString
{
    if(pos.x < 0 || pos.y < 0 || pos.x > _explorationRangeUpperRight.x || pos.y > _explorationRangeUpperRight.y)
    {
        return NO;
    }
    else
    {
        @autoreleasepool {
            Rover *rover = [[[Rover alloc] init] autorelease];
            rover.explorationRangeUpperRight = _explorationRangeUpperRight;
            rover.position = pos;
            [rover setHeadingStateByString:headingString];
            [_roversList addObject:rover];
            _currentRoverIndex = [_roversList count] - 1;
            self.currentRover = [_roversList objectAtIndex:_currentRoverIndex];
            self.currentNavigationFinished = NO;
        }
        return YES;
    }
}

-(void)executeNavigationByInputString:(NSString *)inputString
{
    [_currentRoverCommandQueue removeAllObjects];
    if(inputString)
    {
        NSUInteger stringIndex = 0;
        
        while (stringIndex < [inputString length])
        {
            NSString *commandString = [inputString substringWithRange:NSMakeRange(stringIndex, 1)];

            RoverNavigationCommand *roverNavCmd = [RoverNavigationCommandFactory createRoverNavCommandByString:commandString andRover:self.currentRover];

            [_currentRoverCommandQueue addObject:roverNavCmd];
            stringIndex++;
        }
        
        for (RoverNavigationCommand *roverNavCmd in _currentRoverCommandQueue) {
            [roverNavCmd executeCommand];
        }
        
        self.currentNavigationFinished = YES;
    }
}

-(NSUInteger)getCurrentRoverIndex
{
    return _currentRoverIndex;
}

-(NSUInteger)getRoversCount
{
    return [_roversList count];
}

-(NSString*)reportRoversState
{
    NSString *roversState = [[[NSString alloc] init] autorelease];
    for (Rover* rover in _roversList) {
        roversState = [roversState stringByAppendingFormat:@"%@\n", [rover reportState]]; 
    }
    return roversState;
}

-(void)dealloc
{
    [_roversList release];
    _roversList = nil;
    [_currentRoverCommandQueue release];
    _currentRoverCommandQueue = nil;
    [super dealloc];
}

@end
