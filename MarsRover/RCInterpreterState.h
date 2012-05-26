//
//  RoversControllerInterpreterState.h
//  MarsRover
//
//  Created by Bo on 12-5-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RoversControllerInterpreter;

//State of RoversControllerInterpreter
//There are 3 states when runing input commands:
//       StateNeedExplorationRange
//       StateWaitingRoverDeployment
//       StateWaitingRoverNavigation
@interface  RCInterpreterState : NSObject
{
    NSString *_regExPattern;
}
-(BOOL)interpreterExecute:(RoversControllerInterpreter*)interpreter;
-(NSString*)getErrorMessage;
@end


@interface StateNeedExplorationRange : RCInterpreterState
@end

@interface StateWaitingRoverDeployment : RCInterpreterState
@end

@interface StateWaitingRoverNavigation : RCInterpreterState
@end

