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
    CGFloat _transformAngleDegree;
    CGFloat _headingAngleDegree;
}
-(void)changeHeadingByHeadingString:(NSString*)headingString;
-(id)initWithHeadingString:(NSString*)headingString;
@end
