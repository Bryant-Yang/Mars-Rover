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
    if(interpreter)
    {
        if([self isFormatMatchWithInput:interpreter.currentInput])
            result = [self operateRoversControllerByInterpreter:interpreter];
        else 
            result = NO;
        
        if(result)
        {
            interpreter.validCommandLineCount++;
        }
    }
    return result;
}
-(BOOL) isFormatMatchWithInput:(NSString*)inputText
{
    if(inputText)
    {
        NSError *error=NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:_regExPattern options:0 error:&error];
        
        NSArray *matches = [regex matchesInString:inputText
                                  options:0
                                  range:NSMakeRange(0, [inputText length])];
        
        return ([matches count] == 1);
    }
    else
    {
        return NO;
    }
}
//Override this method.
-(BOOL)operateRoversControllerByInterpreter:(RoversControllerInterpreter*)interpreter
{
    return NO;
}
//Override this method
-(NSString*)getErrorMessage
{
    return @"";
}
@end

#pragma mark The 3 different states of RoversControllerInterpreter
@implementation StateNeedExplorationRange
-(StateNeedExplorationRange*)init
{
    if((self = [super init]))
        _regExPattern =  @"^\\d+ \\d+$";
    
    return self;
}

-(BOOL)operateRoversControllerByInterpreter:(RoversControllerInterpreter*)interpreter
{
    BOOL result = NO;
        
    if (interpreter && interpreter.validCommandLineCount == 0)
    {
        int spacePos = [interpreter.currentInput rangeOfString:@" "].location;
        NSString *strX = [interpreter.currentInput substringToIndex:spacePos];
        NSString *strY = [interpreter.currentInput substringFromIndex:spacePos + 1];
        int right = [strX intValue];
        int top = [strY intValue];
        if([interpreter.roversControllerDelegate setRangeUpperRight:CGPointMake(right, top)])
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

-(NSString*)getErrorMessage
{
    return @"Set upper right position failed.";
}
@end

@implementation StateWaitingRoverDeployment
-(StateWaitingRoverDeployment*)init
{
    if((self = [super init]))
        _regExPattern =  @"^\\d+ \\d+ [NnEeSsWw]$";
    
    return self;
}
-(BOOL)operateRoversControllerByInterpreter:(RoversControllerInterpreter*)interpreter
{
    BOOL result = NO;
    
    if (interpreter && interpreter.validCommandLineCount % 2)
    {
        int spacePos1 = [interpreter.currentInput rangeOfString:@" "].location;
        int spacePos2 = [interpreter.currentInput rangeOfString:@" " options:NSBackwardsSearch].location;
        
        int x = [[interpreter.currentInput substringToIndex:spacePos1] intValue];
        int y = [[interpreter.currentInput substringWithRange:NSMakeRange(spacePos1+1, spacePos2-spacePos1-1)] intValue];
        
        NSString *heading = [interpreter.currentInput substringFromIndex:spacePos2 + 1];
        
        if([interpreter.roversControllerDelegate deployRoverWithPosition:CGPointMake(x, y) headingChar:heading])
        {
            @autoreleasepool {
                interpreter.currentState = [[[StateWaitingRoverNavigation alloc] init] autorelease];
            }
            result = YES;   
        }
    }
    return result;
}

-(NSString*)getErrorMessage
{
    return @"Deploy rover failed.";
}
@end

@implementation StateWaitingRoverNavigation
-(StateWaitingRoverNavigation*)init
{
    if((self = [super init]))
        _regExPattern =  @"^[LlRrMm]+$";
    
    return self;
}
-(BOOL)operateRoversControllerByInterpreter:(RoversControllerInterpreter*)interpreter
{
    
    if (interpreter && interpreter.validCommandLineCount > 0 && interpreter.validCommandLineCount % 2 == 0) 
    {
        [interpreter.roversControllerDelegate executeNavigationByInputString:interpreter.currentInput];
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
-(NSString*)getErrorMessage
{
    return @"Navigate rover failed.";
}
@end