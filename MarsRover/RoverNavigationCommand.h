//
//  RoverNavigationCommand.h
//  MarsRover
//
//  Created by Bo on 12-5-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString* const kTurnLeft  = @"L";
static NSString* const kTurnRight = @"R";
static NSString* const kMove      = @"M";

@class Rover;

@interface RoverNavigationCommand : NSObject
{
    Rover *_rover;
}
@property (retain, nonatomic) Rover *rover;
-(void)executeCommand;
@end

@interface RoverNavigationCommandFactory : NSObject
+(RoverNavigationCommand*)createRoverNavCommandByString:(NSString*)roverNavCmdString andRover:(Rover*)rover;
@end