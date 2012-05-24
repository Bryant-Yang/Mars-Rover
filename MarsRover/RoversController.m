//
//  RoversController.m
//  MarsRover
//
//  Created by bobo on 12-5-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RoversController.h"

@implementation RoversController

-(id)init
{
    if((self = [super init]))
    {
        
    }
    
    return self;
}

-(BOOL)SetExplorationRangeUpperRight:(CGPoint)upperRight
{
    if(upperRight.x < 0 || upperRight.y < 0)
    {
        return NO;   
    }
    else
    {
        _explorationRangeUpperRight = upperRight;
        return YES;
    }
}


-(BOOL)DeployRoverWithPosition:(CGPoint)pos headingChar:(NSString*)headingString
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
        }
        return YES;
    }
}

-(void)ExecuteNavigationByInputString:(NSString *)inputString
{
    
}

-(NSString*)ReportRoversState
{
    return @"";
}

-(void)dealloc
{
    [super dealloc];
}

@end
