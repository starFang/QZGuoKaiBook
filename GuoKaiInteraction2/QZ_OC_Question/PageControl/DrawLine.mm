//
//  drawLine.m
//  GuoKaiInteraction
//
//  Created by qanzone on 13-10-26.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "DrawLine.h"
#import "DataManager.h"
#include "ReadingData.h"
#include <iostream>
#import "QZLineDataModel.h"

using namespace std;

@implementation DrawLine

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        pageObj = NULL;
        [self initAllDataSetting];
    }
    return self;
}
- (void)incomingData:(QZEpubPage *)pObj
{
    pageObj = pObj;
}

- (void)composition
{

}

- (void)initAllDataSetting
{
#pragma mark- 长按
    _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    _longPressGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    _longPressGestureRecognizer.minimumPressDuration = 0.1f;
    [self addGestureRecognizer:_longPressGestureRecognizer];
    [_longPressGestureRecognizer release];
    
    isWord = NO;
}

- (void)longPress:(UILongPressGestureRecognizer *)gestureRecognizer
{

    switch (gestureRecognizer.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            [self longPressBegin:gestureRecognizer];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            [self longPressChange:gestureRecognizer];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            [self longPressEnd:gestureRecognizer];
        }
            break;
        case UIGestureRecognizerStateCancelled:
        {
            [self longPressEnd:gestureRecognizer];
        }
            break;
        case UIGestureRecognizerStateFailed:
        {
            [self longPressEnd:gestureRecognizer];
        }
            break;
            
        default:
            break;
    }
}

- (void)longPressBegin:(UILongPressGestureRecognizer *)gestureRecognizer
{
    
    CGPoint location = [gestureRecognizer locationInView:self];
    QZ_POS pos;
    pos.X = location.x;
    pos.Y = location.y;
    const PageBaseElements* pBeginChar = pageObj->HitTestElement(pos);
    if (pBeginChar != NULL)
    {
        switch (pBeginChar->m_elementType)
        {
            case PAGE_OBJECT_CHARACTER:
            {
                isWord = YES;
                startPos.X = pos.X;
                startPos.Y = pos.Y;
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)longPressChange:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (pageObj == NULL)
    {
        NSLog(@"pageObj pointer in DrawLine is Null ,return!");
        return;
    }
    const PageBaseElements* pBeginChar = pageObj->HitTestElement(startPos);
          PageCharacter* pChar = NULL;
    if (pBeginChar != NULL && pBeginChar->m_elementType == PAGE_OBJECT_CHARACTER)
    {
        pChar = (PageCharacter*)pBeginChar;
    }
    CGPoint location = [gestureRecognizer locationInView:self];
    QZ_POS pos;
    pos.X = location.x;
    pos.Y = location.y;
    if (isWord)
    {
        const PageBaseElements* pChangeChar = pageObj->HitTestElement(pos); 
        const PageCharacter* pChChar = NULL;
        if (pChangeChar != NULL && pChangeChar->m_elementType == PAGE_OBJECT_CHARACTER)
        {
            pChChar = (PageCharacter*)pChangeChar;
        }
        if (pChChar != NULL && pChar != NULL)
        {
            vBoxes = pageObj->GetSelectTextRects(pChar->nIndex,pChChar->nIndex);
        }  
    }
    [self setNeedsDisplay];
}

- (void)longPressEnd:(UILongPressGestureRecognizer *)gestureRecognizer
{
//    画线操作
    if (isWord)
    {
        [self setNeedsDisplay];
        isWord = NO;
    }
//    数据操作，主要是存储操作
    if (pageObj)
    {
        const PageBaseElements* pBeginChar = pageObj->HitTestElement(startPos);
        PageCharacter* pChar = NULL;
        if (pBeginChar != NULL && pBeginChar->m_elementType == PAGE_OBJECT_CHARACTER)
        {
            pChar = (PageCharacter*)pBeginChar;
        }
        
        CGPoint location = [gestureRecognizer locationInView:self];
        QZ_POS pos;
        pos.X = location.x;
        pos.Y = location.y;
        const PageCharacter* pChChar = NULL;
        if (isWord)
        {
            const PageBaseElements* pChangeChar = pageObj->HitTestElement(pos);
            pChChar = NULL;
            if (pChangeChar != NULL && pChangeChar->m_elementType == PAGE_OBJECT_CHARACTER)
            {
                pChChar = (PageCharacter*)pChangeChar;
            }
        }
        
        if (pChar && pChChar)
        {
            RefPos refPos1([BOOKNAME UTF8String],0,0,0,pChar->nIndex.nCharacter);
            RefPos refPos2([BOOKNAME UTF8String],0,0,0,pChChar->nIndex.nCharacter);
            //    取出一段文字
            string strContent = pageObj->GetCharacterPiece(refPos1.GetAutoIndex(), refPos2.GetAutoIndex());
        }
    }
    
    NSLog(@"%@",[self date]);
//    //    引用内容
//    RefContent refContent(refPos1,refPos2,strContent);
//    string strContent1 = pageObj->GetCharacterPiece(refPos1.GetAutoIndex(), refPos2.GetAutoIndex());
//    
//    string strContentbookmark = pageObj->GetCharacterPiece(0,10);
//    
//    ReadingData readingData;
//    BookMark* bookMark = new BookMark(refPos1,strContentbookmark);
//    readingData.PushObj(bookMark);
//    
//    BookComment* bookComent = new BookComment(refContent,"tingyouyisi");
//    readingData.PushObj(bookComent);
    
    
}

//遍历一下数据，看一下数据是否存在
- (void)isAtThePlist
{
    NSMutableArray *array = [DataManager getArrayFromPlist:@"content/lineArray.plist"];
    for (int i = 0; i < [array  count]; i++)
    {
        CGRect rect = CGRectFromString([array objectAtIndex:i]);
        
        if (rect.origin.x + rect.size.width < vBoxes[0].X0)
        {
            
        }
    }
    
    DataManager *lineData = [[ DataManager alloc]init];
    NSMutableArray *lineArray = [NSMutableArray array];
    
    for (int i = 0; i < vBoxes.size(); i++)
    {
        [lineArray addObject:NSStringFromCGRect(CGRectMake(vBoxes[i].X0,vBoxes[i].Y1,vBoxes[i].X1-vBoxes[i].X0,vBoxes[i].Y1-vBoxes[i].Y0))];
    }
    [lineArray writeToFile:[lineData FileContentLinePath:BOOKNAME] atomically:YES];
    [lineData release];
    
}


- (void)drawRect:(CGRect)rect
{    
    [self linewithColor:@"red"];
}


- (void)linewithColor:(NSString*)colorA
{
    CGMutablePathRef _path = CGPathCreateMutable();
    
    if ([colorA isEqualToString:@"red"])//3种颜色
    {
        [[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0]setFill];
    }
    else if([colorA isEqualToString:@"blue"])
    {
        [[UIColor colorWithRed:32/255.0 green:131/255.0 blue:196/255.0 alpha:1.0]setFill];
    }
    else if([colorA isEqualToString:@"purple"])
    {
        [[UIColor colorWithRed:76/255.0 green:26/255.0 blue:222/255.0 alpha:1.0]setFill];
    }
    for (int i = 0; i < vBoxes.size(); i++)
    {
        CGRect firstRect = CGRectMake(vBoxes[i].X0,vBoxes[i].Y1,vBoxes[i].X1-vBoxes[i].X0,vBoxes[i].Y1-vBoxes[i].Y0);
        firstRect.size.height = 1;
        CGPathAddRect(_path, NULL, firstRect);
    }
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddPath(ctx, _path);
    CGContextFillPath(ctx);
    CGPathRelease(_path);
}


- (NSString *)date
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"G:yyyy-MM-dd(EEE) k:mm:ss"];
    NSString *strDate = [formatter stringFromDate:date];
    [formatter release];
    NSLog(@"%@",strDate);
    return strDate;
}

@end
