//
//  RoversController.h
//  MarsRover
//
//  Created by bobo on 12-5-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RoversControllerInterpreter;

@protocol RoversControllDelegate <NSObject>
-(void) SetExplorationRange:(Rect)rangeRect;
-(Rect) GetExplorationRange;
-(BOOL) DeployRoverWithPosition:(CGPoint)pos Heading:(char)heading;
-(void) ExecuteNavigation;
@end


@interface RoversController : NSObject <RoversControllDelegate>
{
    Rect _explorationRange;
    RoversControllerInterpreter *_inputInterpreter;
}
//@property (assign, nonatomic) Rect explorationRange;

-(BOOL)ExecuteInputText:(NSString*)inputText;
-(NSString*) ReportRoversState;

@end
