//
//  RoverControllerInterpreter.m
//  MarsRover
//
//  Created by Bo on 12-5-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RoversControllerInterpreter.h"
#import "RCInterpreterState.h"


#pragma mark Implementation of class RoversControllerInterpreter

@implementation RoversControllerInterpreter
@synthesize roversControllerDelegate = _roversControllerDelegate;
@synthesize validCommandLineCount = _validCommandLineCount;
@synthesize currentState = _currentState;
@synthesize currentInput = _currentInput;

-(id)initWithRoversController:(RoversController *)roversController
{
    if((self = [super init]))
    {
        if(roversController != nil)
        {
            self.roversControllerDelegate = roversController;
            _validCommandLineCount = 0;
            @autoreleasepool {
                self.currentState = [[[StateNeedExplorationRange alloc] init] autorelease];
            }
        }
    }
    
    return self;
}

-(BOOL)receiveInputText:(NSString *)inputLine
{
    self.currentInput = inputLine;
    return [self InterpreterExecute];
}

-(BOOL)InterpreterExecute
{
    return [_currentState interpreterExecute:self];
}


-(void)dealloc{
    self.currentInput = nil;
    self.currentState = nil;
    [super dealloc];
}


@end


