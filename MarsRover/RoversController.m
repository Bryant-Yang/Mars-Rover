//
//  RoversController.m
//  MarsRover
//
//  Created by bobo on 12-5-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RoversController.h"

@implementation RoversController
//@synthesize explorationRange = _explorationRange;

-(id)init
{
    if((self = [super init]))
    {
        
    }
    
    return self;
}

-(void)SetExplorationRange:(Rect)rangeRect
{
    _explorationRange = rangeRect;
}

-(Rect)GetExplorationRange
{
    return _explorationRange;
}

-(BOOL)DeployRoverWithPosition:(CGPoint)pos Heading:(char)heading
{
    return YES;
}

-(void)ExecuteNavigation
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
