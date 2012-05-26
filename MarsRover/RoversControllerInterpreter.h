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

@class RCInterpreterState;

@interface RoversControllerInterpreter : NSObject
{
    NSString                    *_currentInput;
    unsigned int                _validCommandLineCount;
    RCInterpreterState          *_currentState;
    id<RoversControllDelegate>  _roversControllerDelegate;
    
    NSString                    *_errorMessage;
}
@property (assign, nonatomic) id<RoversControllDelegate> roversControllerDelegate;
@property (assign, nonatomic) unsigned int validCommandLineCount;
@property (retain, nonatomic) RCInterpreterState *currentState;
@property (retain, nonatomic) NSString *currentInput;

-(id)initWithRoversController:(RoversController*)roversController;
-(BOOL)receiveInputText:(NSString*)inputText;
-(NSString*)getErrorMessage;

@end
