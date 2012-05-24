//
//  Rover.h
//  MarsRover
//
//  Created by Bo on 12-5-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RoverHeadingState;

@interface Rover : NSObject
{
    RoverHeadingState *_headingState;
    CGPoint _position;
    CGPoint _explorationRangeUpperRight;
}

@property (retain, nonatomic) RoverHeadingState* headingState;
@property (assign, nonatomic) CGPoint position;
@property (assign, nonatomic) CGPoint explorationRangeUpperRight;

-(void)setHeadingStateByString:(NSString*)headingString;
-(void)turnLeft;
-(void)turnRight;
-(void)move;
-(NSString*)reportState;

@end
