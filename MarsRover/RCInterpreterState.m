//
//  RoversControllerInterpreterState.m
//  MarsRover
//
//  Created by Bo on 12-5-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RCInterpreterState.h"
#import "RoversControllerInterpreter.h"

#pragma mark Super class of RoversControllerInterpreter's state
@implementation RCInterpreterState
-(BOOL)interpreterExecute:(RoversControllerInterpreter*)interpreter
{
    BOOL result = NO;
    if([self isFormatMatchWithInput:interpreter.currentInput])
        result = [self operateRoversController:interpreter];
    else 
        result = NO;
    
    if(result)
    {
        interpreter.validCommandLineCount++;
    }
    
    return result;
}
-(BOOL) isFormatMatchWithInput:(NSString*)inputText
{
    NSError *error=NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:_regExPattern options:0 error:&error];
    
    NSArray *matches = [regex matchesInString:inputText
                                      options:NSRegularExpressionCaseInsensitive
                                        range:NSMakeRange(0, [inputText length])];
    return ([matches count] == 1);
}
//Override this method.
-(BOOL)operateRoversController:(RoversControllerInterpreter*)interpreter
{
    return NO;
}
@end

#pragma mark The 3 different states of RoversControllerInterpreter
@implementation StateNeedExplorationRange
-(StateNeedExplorationRange*)init
{
    if((self = [super init]))
        _regExPattern =  @"\\d+ \\d+";
    
    return self;
}

-(BOOL)operateRoversController:(RoversControllerInterpreter*)interpreter
{
    BOOL result = NO;
    
    
    if (interpreter.validCommandLineCount == 0)
    {
        int spacePos = [interpreter.currentInput rangeOfString:@" "].location;
        NSString *strX = [interpreter.currentInput substringToIndex:spacePos];
        NSString *strY = [interpreter.currentInput substringFromIndex:spacePos + 1];
        int right = [strX intValue];
        int top = [strY intValue];
        if([interpreter.roversControllerDelegate SetExplorationRangeUpperRight:CGPointMake(right, top)])
        {
            @autoreleasepool
            {
                interpreter.currentState = [[[StateWaitingRoverDeployment alloc] init] autorelease];
            }
            result = YES;   
        }
    }
    return result;
}
@end

@implementation StateWaitingRoverDeployment
-(StateWaitingRoverDeployment*)init
{
    if((self = [super init]))
        _regExPattern =  @"\\d+ \\d+ [NESW]";
    
    return self;
}
-(BOOL)operateRoversController:(RoversControllerInterpreter*)interpreter
{
    BOOL result = NO;
    
    if (interpreter.validCommandLineCount % 2)
    {
        int spacePos1 = [interpreter.currentInput rangeOfString:@" "].location;
        int spacePos2 = [interpreter.currentInput rangeOfString:@" " options:NSBackwardsSearch].location;
        
        int x = [[interpreter.currentInput substringToIndex:spacePos1] intValue];
        int y = [[interpreter.currentInput substringWithRange:NSMakeRange(spacePos1+1, spacePos2-spacePos1-1)] intValue];
        
        NSString *heading = [interpreter.currentInput substringFromIndex:spacePos2 + 1];
        
        if([interpreter.roversControllerDelegate DeployRoverWithPosition:CGPointMake(x, y) headingChar:heading])
        {
            @autoreleasepool {
                interpreter.currentState = [[[StateWaitingRoverDeployment alloc] init] autorelease];
            }
            result = YES;   
        }
    }
    return result;
}
@end

@implementation StateWaitingRoverNavigation
-(StateWaitingRoverNavigation*)init
{
    if((self = [super init]))
        _regExPattern =  @"[NESW]+";
    
    return self;
}
-(BOOL)operateRoversController:(RoversControllerInterpreter*)interpreter
{
    
    if (interpreter.validCommandLineCount > 0 && interpreter.validCommandLineCount % 2 == 0) 
    {
        [interpreter.roversControllerDelegate ExecuteNavigationByInputString:interpreter.currentInput];
        @autoreleasepool {
            interpreter.currentState = [[[StateWaitingRoverDeployment alloc] init] autorelease];
        }
        return YES;
    }
    else
    {
        return NO;
    }
}
@end