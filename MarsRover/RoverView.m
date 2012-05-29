//
//  RoverView.m
//  MarsRover
//
//  Created by Bo on 12-5-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RoverView.h"

NSDictionary *imageMap;
NSDictionary *angleMap;

@implementation RoverView
@synthesize blinking = _blinking;
@synthesize navigationCount = _navigationCount;
@synthesize running = _running;

-(void)changeHeadingByHeadingString:(NSString*)headingString
{
    CGFloat newAngle = [[[RoverView getAngleMap] objectForKey:headingString] floatValue];
    CGFloat turnAngle = newAngle - _headingAngleDegree;
    
    if(turnAngle != 0)
    {
        if(turnAngle > 90)
            turnAngle = -90;
        else if(turnAngle < -90)
            turnAngle = 90;
        
        _headingAngleDegree = newAngle;
        _transformAngleDegree += turnAngle;
        self.transform = CGAffineTransformMakeRotation(_transformAngleDegree * M_PI / 180);
    }
}

-(id)initWithHeadingString:(NSString*)headingString
{
    UIImage *image = [[RoverView getImageMap] objectForKey:headingString];
    NSNumber *angle = [[RoverView getAngleMap] objectForKey:headingString];
    
    if (image)
    {
        [self initWithImage:image];
        [self sizeToFit];
        
        _blinking = NO;
        _headingAngleDegree = [angle floatValue];
    }
    
    return self;
}

+(NSDictionary*)getImageMap
{
    imageMap = [NSDictionary dictionaryWithObjectsAndKeys:
                [UIImage imageNamed:@"rovernorth.png"], @"N",
                [UIImage imageNamed:@"roversouth.png"], @"S", 
                [UIImage imageNamed:@"rovereast.png"],  @"E",
                [UIImage imageNamed:@"roverwest.png"],  @"W",
                nil ];
    
    return imageMap;
}

+(NSDictionary*)getAngleMap
{
    angleMap = [NSDictionary dictionaryWithObjectsAndKeys:
                [NSNumber numberWithFloat:90],     @"N",
                [NSNumber numberWithFloat:270], @"S", 
                [NSNumber numberWithFloat:180],           @"E",
                [NSNumber numberWithFloat:0],              @"W",
                nil ];
    return angleMap;
}

@end
