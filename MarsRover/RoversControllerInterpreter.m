//
//  RoverControllerInterpreter.m
//  MarsRover
//
//  Created by Bo on 12-5-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RoversControllerInterpreter.h"

//State design pattern used for RoversControllerInterpreter class
//There are 3 states:
//                      StateNeedExplorationRange
//                      StateWaitingRoverDeployment
//                      StateWaitingRoverNavigation

#pragma mark State class and sub classes used in RoversControllerInterpreter

@interface  InterpreterState : NSObject
-(BOOL)InterpreterExecute:(RoversControllerInterpreter*)interpreter;
@end
@implementation InterpreterState
-(BOOL)InterpreterExecute:(RoversControllerInterpreter*)interpreter
{
    return NO;
}
@end

@interface StateNeedExplorationRange : InterpreterState
@end

@interface StateWaitingRoverDeployment : InterpreterState
@end

@interface StateWaitingRoverNavigation : InterpreterState
@end

@implementation StateNeedExplorationRange
-(BOOL)InterpreterExecute:(RoversControllerInterpreter*)interpreter
{
    @autoreleasepool {
        if (interpreter.validCommandLineCount == 0) {
            //TODO:Get the parameter and set range rect;
            Rect rangeRect;
            [interpreter.roversControllerDelegate SetExplorationRange:rangeRect];
            interpreter.validCommandLineCount++;
            interpreter.currentState = [[[StateWaitingRoverDeployment alloc] init] autorelease];
            return YES;
        }
        else
        {
            return NO;
        }
    }
}
@end

@implementation StateWaitingRoverDeployment
-(BOOL)InterpreterExecute:(RoversControllerInterpreter*)interpreter
{
    @autoreleasepool {
        if (interpreter.validCommandLineCount % 2 == 0) {
            //TODO: 
            interpreter.validCommandLineCount++;
            interpreter.currentState = [[[StateWaitingRoverNavigation alloc] init] autorelease];
            return YES;
        }
        else
        {
            return NO;
        }
    }
}
@end

@implementation StateWaitingRoverNavigation
-(BOOL)InterpreterExecute:(RoversControllerInterpreter*)interpreter
{
    @autoreleasepool {
        if (interpreter.validCommandLineCount > 0 && interpreter.validCommandLineCount % 2 != 0) {
            //TODO: 
            interpreter.validCommandLineCount++;
            interpreter.currentState = [[[StateWaitingRoverDeployment alloc] init] autorelease];
            return YES;
        }
        else
        {
            return NO;
        }
    }
}
@end


#pragma mark Implementation of class RoversControllerInterpreter

@implementation RoversControllerInterpreter
@synthesize roversControllerDelegate = _roversControllerDelegate;
@synthesize validCommandLineCount = _validCommandLineCount;
@synthesize currentState = _currentState;
@synthesize currentInput = _currentInput;

-(id)InitWithRoversController:(RoversController *)roversController
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

-(BOOL)ReceiveInputText:(NSString *)inputLine
{
    self.currentInput = inputLine;
    return [self InterpreterExecute];
}

-(BOOL)InterpreterExecute
{
    return [_currentState InterpreterExecute:self];
}


-(void)dealloc{
    self.currentInput = nil;
    self.currentState = nil;
    [super dealloc];
}


@end


