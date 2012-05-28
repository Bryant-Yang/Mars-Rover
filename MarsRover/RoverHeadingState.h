//
//  RoverState.h
//  MarsRover
//
//  Created by Bo on 12-5-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Rover;

#pragma mark Constant strings of different heading
static NSString* const kNorth = @"N";
static NSString* const kEast  = @"E";
static NSString* const kSouth = @"S";
static NSString* const kWest  = @"W";

#pragma mark Turnning and moving protocol
@protocol RoverOperations <NSObject>
@optional
-(void)turnLeftRover:(Rover*)rover;
-(void)turnRightRover:(Rover*)rover;
-(void)moveRover:(Rover*)rover;
@end

#pragma mark Abstract class of rover state
@interface RoverHeadingState : NSObject <RoverOperations>
{
    NSString *_headingString;
}

@property (assign, nonatomic)   NSString* headingString;
@property (assign, nonatomic)   CGPoint   position;
@property (readonly, nonatomic) CGPoint   upperRight;
@end

@interface RoverHeadingStateFactory : NSObject
+(RoverHeadingState*)createStateByHeadingString:(NSString*)headingString;
@end
