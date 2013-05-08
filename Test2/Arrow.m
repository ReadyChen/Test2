//
//  Arrow.m
//  Test2
//
//  Created by Chen WeiTing on 13/5/7.
//  Copyright (c) 2013年 Chen WeiTing. All rights reserved.
//

#import "Common.h"
#import "Arrow.h"

@implementation Arrow

@synthesize fAngle;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    DebugLog(@" Arrow.angle = %f", fAngle);
    //Get the CGContext from this view
    CGContextRef context = UIGraphicsGetCurrentContext();
    //Set the stroke (pen) color
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    //Set the width of the pen mark
    CGContextSetLineWidth(context, 2.0);
    
    
    // 定義 箭頭的
    NSInteger iOriginX = 30; // 原點 X(橫)
    NSInteger iOriginY = 30;  // 原點 Y(直)
    NSInteger iArrowMiddleLength = 30; // 中間線的長度
    NSInteger iArrowSpreadAngle = 20;  // 尖頭分岔角度 <= 有 bug , 不靈光 , 但顯示上 符合需求 , 待查
    NSInteger iArrowSpreadLength = 10; // 尖頭線的長度
    
    float fOffSetX = iArrowMiddleLength*cosf( fAngle * M_PI / 180 );
    float fOffSetY = iArrowMiddleLength*sinf( fAngle * M_PI / 180 )*-1;
    
    float fArrowA2ngle;
    if (fAngle<180) {
        fArrowA2ngle = fAngle+180;
    }else{
        fArrowA2ngle = fAngle-180;
    }
    
    float fArrowA2ngle1 = fArrowA2ngle+iArrowSpreadAngle;
    float fArrowA2ngle2 = fArrowA2ngle-iArrowSpreadAngle;
    
    float fOffSetA1X = iArrowSpreadLength * cosf( fArrowA2ngle1 * M_PI / 180 );
    float fOffSetA1Y = iArrowSpreadLength * sinf( fArrowA2ngle1 * M_PI / 180 )*-1;
    float fOffSetA2X = iArrowSpreadLength * cosf( fArrowA2ngle2 * M_PI / 180 );
    float fOffSetA2Y = iArrowSpreadLength * sinf( fArrowA2ngle2 * M_PI / 180 )*-1;
    
    // Draw a line
    //Start at this point
    CGContextMoveToPoint(context, iOriginX, iOriginY);
    
    //Give instructions to the CGContext
    //(move "pen" around the screen)
    CGContextAddLineToPoint(context, iOriginX+fOffSetX, iOriginY+fOffSetY);
    
    // 由尖端 畫兩條開衩線條 , 使圖形成為 箭頭
    CGContextMoveToPoint(context, iOriginX+fOffSetX, iOriginY+fOffSetY);
    CGContextAddLineToPoint(context, iOriginX+fOffSetA1X, iOriginY+fOffSetA1Y);
    CGContextMoveToPoint(context, iOriginX+fOffSetX, iOriginY+fOffSetY);
    CGContextAddLineToPoint(context, iOriginX+fOffSetA2X, iOriginY+fOffSetA2Y);
    
    //Draw it
    CGContextStrokePath(context);
}


@end
