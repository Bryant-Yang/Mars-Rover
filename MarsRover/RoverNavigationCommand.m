//
//  RoverNavigationCommand.m
//  MarsRover
//
//  Created by Bo on 12-5-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RoverNavigationCommand.h"
#import "Rover.h"

@implementation RoverNavigationCommand
@synthesize rover = _rover;

-(RoverNavigationCommand*)initWithRover:(Rover *)rover
{
    if((self = [super init]))
    {
        self.rover = rover;
    }
    return self;
}

//Override this method
-(void)executeCommand{}

-(void)dealloc
{
    self.rover = nil;
    [super dealloc];
}
@end

@interface RoverTurnLeftCommand : RoverNavigationCommand
-(void)executeCommand;
@end

@interface RoverTurnRightCommand : RoverNavigationCommand
-(void)executeCommand;
@end

@interface RoverMoveCommand : RoverNavigationCommand
-(void)executeCommand;
@end

@implementation RoverTurnLeftCommand
-(void)executeCommand
{
    if(_rover)
    {
        [_rover turnLeft];
    }
}
@end

@implementation RoverTurnRightCommand
-(void)executeCommand
{
    if(_rover)
    {
        [_rover turnRight];
    }
}
@end

@implementation RoverMoveCommand
-(void)executeCommand
{
    if(_rover)
    {
        [_rover move];
    }
}
@end

@implementation RoverNavigationCommandFactory

+(RoverNavigationCommand*)createRoverNavCommandByString:(NSString *)roverNavCmdString andRover:(Rover*)rover
{
    RoverNavigationCommand* roverNavCommand = nil;
    if(roverNavCmdString && rover)
    {
        RoverNavigationCommand* (^createCommand)(Rover *rover);
        NSDictionary *funcMap = [NSDictionary dictionaryWithObjectsAndKeys:
                                 ^(Rover* rover){return [[[RoverTurnLeftCommand alloc] initWithRover:rover] autorelease];}, kTurnLeft,
                                 ^(Rover* rover){return [[[RoverTurnRightCommand alloc] initWithRover:rover] autorelease];},kTurnRight,
                                 ^(Rover* rover){return [[[RoverMoveCommand alloc] initWithRover:rover] autorelease];},kMove,
                                 nil];
        
        createCommand = [funcMap objectForKey:[roverNavCmdString uppercaseString]];
        if(createCommand)
        {
           roverNavCommand = createCommand(rover);
        }
    }
    
    return roverNavCommand;
}
@end


