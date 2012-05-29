//
//  RoverView.h
//  MarsRover
//
//  Created by Bo on 12-5-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoverView : UIImageView
{
    CGFloat     _transformAngleDegree;
    CGFloat     _headingAngleDegree;
    BOOL        _blinking;
    NSUInteger  _navigationCount;
    BOOL        _running;
}
@property (assign, nonatomic) BOOL blinking;
@property (assign, nonatomic) NSUInteger navigationCount;
@property (assign, nonatomic) BOOL running;

-(void)changeHeadingByHeadingString:(NSString*)headingString;
-(id)initWithHeadingString:(NSString*)headingString;
@end
