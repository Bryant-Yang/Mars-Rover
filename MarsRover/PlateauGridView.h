//
//  PlateauGridView.h
//  MarsRover
//
//  Created by Bo on 12-5-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlateauGridView : UIView

+(CGSize)getProperSizeByUpperLeftPoint:(CGPoint)upperLeft;
-(CGPoint)getPositionInGridByRoverPosition:(CGPoint)roverPos;

@end
