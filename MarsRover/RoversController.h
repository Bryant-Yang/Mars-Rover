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
@class RoverNavigationCommand;

@protocol RoversControllDelegate <NSObject>
-(BOOL) setRangeUpperRight:(CGPoint)upperRight;
-(BOOL) deployRoverWithPosition:(CGPoint)pos headingChar:(NSString*)headingString;
-(void) executeNavigationByInputString:(NSString*)inputString;
@end


@interface RoversController : NSObject <RoversControllDelegate>
{
    CGPoint _explorationRangeUpperRight;
    NSUInteger      _currentRoverIndex;
    NSMutableArray  *_roversList;
    Rover           *_currentRover;
    
    NSMutableArray  *_currentRoverCommandQueue;
    BOOL            _currentNavigationFinished;
}
@property (assign, nonatomic) CGPoint explorationRangeUpperRight;
@property (assign, nonatomic) Rover* currentRover;
@property (assign, nonatomic) BOOL currentNavigationFinished;

-(NSUInteger)getCurrentRoverIndex;
-(NSUInteger)getRoversCount;
-(NSString*)reportRoversState;
@end
