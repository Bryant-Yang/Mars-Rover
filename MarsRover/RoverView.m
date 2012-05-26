//
//  RoverView.m
//  MarsRover
//
//  Created by Bo on 12-5-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RoverView.h"

@implementation RoverView

-(void)changeHeadingByHeadingString:(NSString*)headingString
{
    NSDictionary *imageMap = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [UIImage imageNamed:@"rovernorth.png"], @"N",
                                  [UIImage imageNamed:@"roversouth.png"], @"S", 
                                  [UIImage imageNamed:@"rovereast.png"], @"E",
                                  [UIImage imageNamed:@"roverwest.png"], @"W",
                                  nil ];
    
    UIImage* image = [imageMap objectForKey:headingString];
    
    if (image)
    {
        self.image = image;
        [self sizeToFit];
    }
}


@end
