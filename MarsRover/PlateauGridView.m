//
//  PlateauGridView.m
//  MarsRover
//
//  Created by Bo on 12-5-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PlateauGridView.h"

@implementation PlateauGridView


static const NSUInteger kGridUnitDistance = 50;
static const NSUInteger kMarginOfGridOnBackground = 20;
static const NSUInteger kMaxRowNum = 50;
static const NSUInteger kMaxColumnNum = 50;

+(CGSize)getProperSizeByUpperRightPoint:(CGPoint)upperRight
{
    upperRight.x = MIN(upperRight.x, kMaxColumnNum);
    upperRight.y = MIN(upperRight.y, kMaxRowNum);
    
    return CGSizeMake(upperRight.x * kGridUnitDistance + 2 * kMarginOfGridOnBackground, upperRight.y * kGridUnitDistance + 2 * kMarginOfGridOnBackground);
}

-(CGPoint)getPositionInGridByRoverPosition:(CGPoint)roverPos
{
    GLfloat uiPosX = self.bounds.origin.x + kMarginOfGridOnBackground + roverPos.x * kGridUnitDistance;
    GLfloat uiPosY = self.bounds.origin.y + self.bounds.size.height - kMarginOfGridOnBackground - roverPos.y * kGridUnitDistance;
    return CGPointMake(uiPosX, uiPosY);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(ctx, kCGLineCapButt);
    CGContextSetLineWidth(ctx,2.0);
    CGContextSetRGBStrokeColor(ctx, 0.0, 0.0, 0.0, 1.0);
    
    CGContextBeginPath(ctx);

    CGPoint gridLeftBottom = CGPointMake(self.bounds.origin.x + kMarginOfGridOnBackground, self.bounds.origin.y + self.bounds.size.height - kMarginOfGridOnBackground);
    CGPoint gridUpperRight = CGPointMake(self.bounds.origin.x + self.bounds.size.width - kMarginOfGridOnBackground, self.bounds.origin.y + kMarginOfGridOnBackground);
    
    GLfloat startPointX = gridLeftBottom.x;
    GLfloat startPointY = gridLeftBottom.y;
    //draw vertical line
    int columnNumber = 0;
    while(startPointX <= gridUpperRight.x)
    {
        NSString *strColNum = [NSString stringWithFormat:@"%d", columnNumber];
        
        CGContextMoveToPoint(ctx, startPointX, gridLeftBottom.y);
        CGContextAddLineToPoint(ctx, startPointX, gridUpperRight.y);
        CGContextStrokePath(ctx);
        
        [strColNum drawAtPoint:CGPointMake(startPointX, gridLeftBottom.y) withFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]];
        
        startPointX += kGridUnitDistance;
        columnNumber++;
    }
    //draw horizon line
    int rowNumber = 0;
    while(startPointY >= gridUpperRight.y)
    {
        NSString *strRowNum = [NSString stringWithFormat:@"%d", rowNumber];
        CGContextMoveToPoint(ctx, gridLeftBottom.x, startPointY);
        CGContextAddLineToPoint(ctx, gridUpperRight.x, startPointY);
        CGContextStrokePath(ctx);
        
        [strRowNum drawAtPoint:CGPointMake(gridLeftBottom.x, startPointY) withFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]];
        
        startPointY -= kGridUnitDistance;
        rowNumber++;
    }
}


@end
