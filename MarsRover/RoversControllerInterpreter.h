//
//  RoverControllerInterpreter.h
//  MarsRover
//
//  Created by Bo on 12-5-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

//Interpret input text and execute valid command for RoversController
//The valid command is executed by RoverController delegation.

#import <Foundation/Foundation.h>
#import "RoversController.h"

@class InterpreterState;

@interface RoversControllerInterpreter : NSObject
{
    NSString                    *_currentInput;
    unsigned int                _validCommandLineCount;
    InterpreterState            *_currentState;
    id<RoversControllDelegate>  _roversControllerDelegate;
}
@property (assign, nonatomic) id<RoversControllDelegate> roversControllerDelegate;
@property (assign, nonatomic) unsigned int validCommandLineCount;
@property (retain, nonatomic) InterpreterState *currentState;
@property (retain, nonatomic) NSString *currentInput;

-(id)InitWithRoversController:(RoversController*)roversController;
-(BOOL)ReceiveInputText:(NSString*)inputText;

@end
