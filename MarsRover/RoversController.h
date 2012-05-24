//
//  RoversController.h
//  MarsRover
//
//  Created by bobo on 12-5-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Rover.h"

@class RoversControllerInterpreter;

@protocol RoversControllDelegate <NSObject>
-(BOOL) SetExplorationRangeUpperRight:(CGPoint)upperRight;
-(BOOL) DeployRoverWithPosition:(CGPoint)pos headingChar:(NSString*)headingString;
-(void) ExecuteNavigationByInputString:(NSString*)inputString;
@end


@interface RoversController : NSObject <RoversControllDelegate>
{
    CGPoint _explorationRangeUpperRight;
    Rover           *_currentRover;
    NSMutableArray  *_roversList;
}

-(NSString*) ReportRoversState;

@end
