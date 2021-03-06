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
#import "Database.h"

using namespace std;

@implementation DrawLine
@synthesize pageNumber = _pageNumber;
@synthesize headView = _headView;

- (void)dealloc
{
    [self.headView release];
    [arraySQL release];
    [noteFrame release];
    [textView release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initAllDataSetting];
        [self initAllSmallView];
    }
    return self;
}
- (void)incomingData:(QZEpubPage *)pObj
{
      pageObj = pObj;
}

- (void)composition
{
    [self readSQLData];
    [self setNeedsDisplay];
}

- (void)readSQLData
{
    [arraySQL setArray:[[Database sharedDatabase]selectData:self.pageNumber]];
}

- (void)initAllDataSetting
{
    pageObj = NULL;
    lineDictionary = [[NSMutableDictionary alloc]init];
    insertDate = [[NSMutableString alloc]init];
    arraySQL = [[NSMutableArray alloc]init];
    lineColor = [[NSMutableString alloc]init];
    
#pragma mark - 将线的颜色数据，读进来
    if ([[DataManager getStringFromPlist:[NSString stringWithFormat:@"/Documents/%@/UnderLineColor/UnderLineColor.plist",BOOKNAME]]retain])
    {
        [lineColor setString:[[DataManager getStringFromPlist:[NSString stringWithFormat:@"/Documents/%@/UnderLineColor/UnderLineColor.plist",BOOKNAME]]retain]];
    }else{
        [lineColor setString:@"red"];
        [lineColor writeToFile:[DataManager FileColorPath] atomically:YES encoding:1 error:NULL];
    }
#pragma mark - 标题视图
    self.headView = [[UIView alloc]init];
    self.headView.frame = CGRectMake(0,-44,DW,44);
    self.headView.backgroundColor = [UIColor blackColor];
    [self addSubview:self.headView];
    
#pragma mark- 长按
    _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    _longPressGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    _longPressGestureRecognizer.minimumPressDuration = 0.2f;
    [self addGestureRecognizer:_longPressGestureRecognizer];
    [_longPressGestureRecognizer release];
    isWord = NO;
    
#pragma mark - 单击手势
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTap:)];
    [self addGestureRecognizer:_tapGestureRecognizer];
    _tapGestureRecognizer.numberOfTapsRequired = 1;
    [_tapGestureRecognizer release];

}

- (void)initAllSmallView
{
    noteFrame = [[UIImageView alloc]initWithFrame:CGRectMake((self.bounds.size.width-400)/2, self.bounds.size.height, 440, 267)];//画完下划线后点笔记弹出的框框
    
    noteFrame.userInteractionEnabled = YES;
    noteFrame.image = [UIImage imageNamed:@"r_bijikuang.png"];
    [self addSubview:noteFrame];
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];//框框上的取消按钮
    cancelBtn.frame = CGRectMake(30, 20, 63, 30);
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"r_quxiao.png"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(quxiao) forControlEvents:UIControlEventTouchUpInside];
    [noteFrame addSubview:cancelBtn];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];//框框上的确定按钮
    confirmBtn.frame = CGRectMake(440-93, 20, 63, 30);
    [confirmBtn addTarget:self action:@selector(wancheng) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn setBackgroundImage:[UIImage imageNamed:@"r_wancheng.png"] forState:UIControlStateNormal];
    [noteFrame addSubview:confirmBtn];
    
    textView = [[UITextView alloc]initWithFrame:CGRectMake(30, 70, 380, 170)];//框框里的文本输入框
    textView.backgroundColor = [UIColor clearColor];
    textView.font = [UIFont systemFontOfSize:16.0];
    [noteFrame addSubview:textView];
}

- (void)quxiao
{
    CGRect frame = noteFrame.frame;
    frame.origin.y +=712;
    [UIView animateWithDuration:0.5 animations:^{
        noteFrame.frame = frame;
    }];
    [textView resignFirstResponder];
    textView.text = @"";

}

- (void)wancheng
{
    CGRect frame = noteFrame.frame;
    frame.origin.y +=712;
    [UIView animateWithDuration:0.5 animations:^{
    noteFrame.frame = frame;
    }];
    [textView resignFirstResponder];
    
}

static int tapIndex,tapWords;
-(void)handleSingleTap:(UITapGestureRecognizer *)gestureRecognizer
{
    CGPoint location = [gestureRecognizer locationInView:self];
    QZ_POS pos;
    pos.X = location.x;
    pos.Y = location.y;
    const PageBaseElements* pTapChar = pageObj->HitTestElement(pos);
    BOOL isTapWords;
    isTapWords = NO;
    const PageCharacter* pChar = NULL;
    if (pTapChar != NULL)
    {
        switch (pTapChar->m_elementType)
        {
            case PAGE_OBJECT_CHARACTER:
            {
                if (pTapChar != NULL && pTapChar->m_elementType == PAGE_OBJECT_CHARACTER)
                {
                    pChar = (PageCharacter*)pTapChar;
                }
                
                for (int i = 0; i < [arraySQL  count]; i++)
                {
                    QZLineDataModel * lineData = [arraySQL objectAtIndex:i];
                    if (pChar->nIndex.nCharacter >= [lineData.lineStartIndex intValue]
                                                 &&
                        pChar->nIndex.nCharacter <= [lineData.lineEndIndex intValue])
                    {
                        [insertDate setString:lineData.lineDate];
                        
                        oldColor = lineData.lineColor;
                        isTapWords = YES;
                        break;
                    }
                 }
            }
                break;
            default:
                break;
        }
     }
    
    if (!isTapWords && tapIndex % 2 == 0)
    {
        [UIView animateWithDuration:0.4 animations:^{
            [self removeFromSuperviewWithPop];
            self.headView.frame = CGRectMake(0,0,DW,44);
        }];
    }else{
        [UIView animateWithDuration:0.4 animations:^{
            [self removeFromSuperviewWithPop];
            self.headView.frame = CGRectMake(0,-44,DW,44);
        }];
    }
    if (isTapWords)
    {
        [self removeFromSuperviewWithPop];
        [self pushMenuWithPoint:CGPointMake((pChar->rect.X1 + pChar->rect.X0)/2,(pChar->rect.Y1 + pChar->rect.Y0)/2)];
    }
        
    if (isTapWords)
    {
        tapWords++;
    }else{
        tapIndex++;
    }
}

#pragma mark- 弹出颜色 笔记 删除笔记 菜单
- (void)pushMenuWithPoint:(CGPoint)pointTap
{
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(pointTap.x-108, pointTap.y-60, 217, 51)];
    if (pointTap.x-108+217>self.bounds.size.width)
    {
        //右边边缘处理
        pointTap.x = self.bounds.size.width - 220;
        imageV.frame = CGRectMake(pointTap.x, pointTap.y - 60, 217, 51);
    }
    if ((pointTap.x - 100)<0)
    {
        //左边边缘处理
        imageV.frame = CGRectMake(20, pointTap.y - 60, 217, 51);
    }
    imageV.userInteractionEnabled = YES;
    imageV.image = [UIImage imageNamed:@"r_kk.png"];
    imageV.tag = 1001;
    
    redBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [redBtn setBackgroundImage:[UIImage imageNamed:@"r_hong.png"] forState:UIControlStateNormal];
    [redBtn setBackgroundImage:[UIImage imageNamed:@"r_hongxuanzhong.png"] forState:UIControlStateSelected];
    redBtn.tag = RED;
    redBtn.frame = CGRectMake(20, 10, 22, 23);
    [redBtn addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchUpInside];
    [imageV addSubview:redBtn];
    blueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [blueBtn setBackgroundImage:[UIImage imageNamed:@"r_lan.png"] forState:UIControlStateNormal];
    [blueBtn setBackgroundImage:[UIImage imageNamed:@"r_lanxuanzhong.png"] forState:UIControlStateSelected];
    blueBtn.tag = BLUE;
    blueBtn.frame = CGRectMake(60, 10, 22, 23);
    [blueBtn addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchUpInside];
    [imageV addSubview:blueBtn];
    purpleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [purpleBtn setBackgroundImage:[UIImage imageNamed:@"r_zi.png"] forState:UIControlStateNormal];
    [purpleBtn setBackgroundImage:[UIImage imageNamed:@"r_zixuanzhong.png"] forState:UIControlStateSelected];
    purpleBtn.tag = PURPLE;
    purpleBtn.frame = CGRectMake(99, 10, 22, 23);
    [purpleBtn addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchUpInside];
    [imageV addSubview:purpleBtn];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"r_quchu.png"] forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(138, 10, 22, 23);
    [leftBtn addTarget:self action:@selector(deleteUnderLine:) forControlEvents:UIControlEventTouchUpInside];
    [imageV addSubview:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"r_zuobiji.png"] forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(176, 10, 22, 23);
    [rightBtn addTarget:self action:@selector(zuobiji:) forControlEvents:UIControlEventTouchUpInside];
    [imageV addSubview:rightBtn];
    [self addSubview:imageV];
    [imageV release];
}

- (void)changeColor:(UIButton *)button
{
    if (button.tag == RED)
    {
        [lineColor setString:@"red"];
    }else if (button.tag == BLUE){
        [lineColor setString:@"blue"];
    }else if (button.tag == PURPLE){
        [lineColor setString:@"green"];
    }
    //保存下划线颜色，下次画的时候是上次选择的颜色
    [lineColor writeToFile:[DataManager FileColorPath] atomically:YES encoding:1 error:NULL];
    newColor = lineColor;
    [self updeteLineColor];
    [UIView animateWithDuration:0.5 animations:^{
        [self removeFromSuperviewWithPop];
        [self setNeedsDisplay];
    }];
    
}

- (void)updeteLineColor
{
    int j = 0;
    BOOL isChangeColor;
    isChangeColor = NO;
    for (int i = 0; i < [arraySQL count]; i++)
    {
        QZLineDataModel * lineData = (QZLineDataModel *)[arraySQL objectAtIndex:i];
        
        if ([lineData.lineDate isEqualToString:insertDate])
        {
            if ([lineData.lineColor isEqualToString:oldColor])
            {
                j = i;
                isChangeColor = YES;
                break;
            }
        }
     }
    
    if (isChangeColor)
    {
        QZLineDataModel * lineData = [[QZLineDataModel alloc]init];
        QZLineDataModel * lineOldData = (QZLineDataModel *)[arraySQL objectAtIndex:j];
        [lineData setLineDate:[self date]];
        [lineData setLineColor:newColor];
        [lineData setLineStartIndex:lineOldData.lineStartIndex];
        [lineData setLineEndIndex:lineOldData.lineEndIndex];
        [lineData setLinePageNumber:lineOldData.linePageNumber];
        [lineData setLineWords:lineOldData.lineWords];
        [arraySQL removeObjectAtIndex:j];
        [arraySQL addObject:lineData];
        [lineData release];
    }
 }

- (void)deleteUnderLine:(id)sender
{
    
    for (int i = 0; i < [arraySQL count] ; i++)
    {
        QZLineDataModel * lineData = [arraySQL objectAtIndex:i];
        if ([lineData.lineDate isEqualToString: insertDate])
        {
            [arraySQL removeObjectAtIndex:i];
            break;
        }
    }
    [UIView animateWithDuration:0.5 animations:^{
        [self removeFromSuperviewWithPop];
        [self setNeedsDisplay];
    }];
}

- (void)removeFromSuperviewWithPop
{

    UIImageView *imageV = (UIImageView *)[self viewWithTag:1001];
    if (imageV)
    {
        [imageV removeFromSuperview];
    }
}

- (void)zuobiji:(id)sender
{
    UIView *temp = (UIView*)[self viewWithTag:1001];
    if (temp)
    {
    [temp removeFromSuperview];
    }
    
    CGRect frame = noteFrame.frame;
    frame.origin.y -=712;
    
    [UIView animateWithDuration:0.5 animations:^{
        noteFrame.frame = frame;
    }];
    [textView becomeFirstResponder];
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
        if ([lineDictionary objectForKey:@"vBoxes"])
        {
            [lineDictionary removeObjectForKey:@"vBoxes"];
        }
        if (pChChar != NULL && pChar != NULL)
        {
            vBoxes = pageObj->GetSelectTextRects(pChar->nIndex,pChChar->nIndex);
            endPos.X = pos.X;
            endPos.Y = pos.Y;
        }
        
        NSMutableArray * array = [NSMutableArray array];
        for (int i = 0; i < vBoxes.size(); i++)
        {
            [array addObject:NSStringFromCGRect(CGRectMake(vBoxes[i].X0, vBoxes[i].Y1, vBoxes[i].X1 - vBoxes[i].X0, vBoxes[i].Y1 - vBoxes[i].Y0))];
        }
        [lineDictionary setObject:array forKey:@"vBoxes"];
    }
    [self setNeedsDisplay];
}

- (void)longPressEnd:(UILongPressGestureRecognizer *)gestureRecognizer
{
//    数据操作，主要是存储操作
    if (pageObj)
    {
        const PageBaseElements* pBeginChar = pageObj->HitTestElement(startPos);
        PageCharacter* pChar = NULL;
        if (pBeginChar != NULL && pBeginChar->m_elementType == PAGE_OBJECT_CHARACTER)
        {
            pChar = (PageCharacter*)pBeginChar;
        }
        const PageCharacter* pChChar = NULL;
        const PageBaseElements* pChangeChar = pageObj->HitTestElement(endPos);
        pChChar = NULL;
        if (pChangeChar != NULL && pChangeChar->m_elementType == PAGE_OBJECT_CHARACTER)
        {
            pChChar = (PageCharacter*)pChangeChar;
        }
        if (pChar && pChChar)
        {
            RefPos refPos1([BOOKNAME UTF8String],0,0,0,pChar->nIndex.nCharacter);
            RefPos refPos2([BOOKNAME UTF8String],0,0,0,pChChar->nIndex.nCharacter);
            //    取出一段文字
            string strContent = pageObj->GetCharacterPiece(refPos1.GetAutoIndex(), refPos2.GetAutoIndex());
            QZLineDataModel *lineData = [[QZLineDataModel alloc]init];
            [lineData setLinePageNumber:[NSString  stringWithFormat:@"%d",self.pageNumber]];
            
            if (pChar->nIndex.nCharacter >= pChChar->nIndex.nCharacter)
            {
                [lineData setLineStartIndex:[NSString  stringWithFormat:@"%ld",pChChar->nIndex.nCharacter]];
                [lineData setLineEndIndex:[NSString  stringWithFormat:@"%ld",pChar->nIndex.nCharacter]];
            }else{
            [lineData setLineStartIndex:[NSString  stringWithFormat:@"%ld",pChar->nIndex.nCharacter]];
            [lineData setLineEndIndex:[NSString  stringWithFormat:@"%ld",pChChar->nIndex.nCharacter]];
            }
            
            [lineData setLineColor:lineColor];
            [lineData setLineWords:[NSString stringWithUTF8String:strContent.c_str()]];
            [lineData setLineDate:[self date]];
            [self insertObject:lineData];
            [lineData release];
        }
     }
    if (isWord)
    {
        [self setNeedsDisplay];
        isWord = NO;
    }
 
//    ReadingData readingData;
//    BookMark* bookMark = new BookMark(refPos1,strContentbookmark);
//    readingData.PushObj(bookMark);
//    BookComment* bookComent = new BookComment(refContent,"tingyouyisi");
//    readingData.PushObj(bookComent);
    
 }

- (void)insertObject:(QZLineDataModel *)lineData
{
    BOOL isAddData;
    isAddData = NO;
//    判断数据是否存在
    for (int i = 0; i < [arraySQL count ]; i++)
    {
        QZLineDataModel *newLineDate = [[QZLineDataModel alloc]init];
        QZLineDataModel *linData = (QZLineDataModel *)[arraySQL objectAtIndex:i];
        if ([lineData.lineStartIndex integerValue] <= [linData.lineStartIndex integerValue] && [lineData.lineEndIndex integerValue] <= [linData.lineEndIndex integerValue] && [lineData.lineEndIndex integerValue] >= [linData.lineStartIndex integerValue])
        {
            [newLineDate setLineColor:lineData.lineColor];
            [newLineDate setLineDate:[self date]];
            [newLineDate setLineStartIndex:lineData.lineStartIndex];
            [newLineDate setLineEndIndex:linData.lineEndIndex];
            [newLineDate setLinePageNumber:linData.linePageNumber];
            [arraySQL removeObjectAtIndex:i];
            [arraySQL addObject:newLineDate];
            
            isAddData = YES;
            return;
        }else if ([lineData.lineStartIndex integerValue] >= [linData.lineStartIndex integerValue] && [lineData.lineEndIndex integerValue] <= [linData.lineEndIndex integerValue])
        {
            isAddData = YES;
            return;
        }else if (([lineData.lineStartIndex integerValue] <= [linData.lineStartIndex integerValue]
                   &&
                   [lineData.lineStartIndex integerValue] <= [linData.lineEndIndex integerValue])
                  &&
                  ([lineData.lineEndIndex integerValue] >= [linData.lineStartIndex integerValue]
                      &&
                      [lineData.lineEndIndex integerValue] >= [linData.lineEndIndex integerValue]))
        {
            isAddData = YES;
            [arraySQL removeObjectAtIndex:i];
            [arraySQL addObject:lineData];
            return;
        }else if ([lineData.lineStartIndex integerValue] >= [linData.lineStartIndex integerValue] && [lineData.lineEndIndex integerValue] >= [linData.lineEndIndex integerValue] && [lineData.lineStartIndex integerValue] <= [linData.lineEndIndex integerValue])
        {
            isAddData = YES;
            [newLineDate setLineColor:lineData.lineColor];
            [newLineDate setLineDate:[self date]];
            [newLineDate setLineStartIndex:linData.lineStartIndex];
            [newLineDate setLineEndIndex:lineData.lineEndIndex];
            [newLineDate setLinePageNumber:linData.linePageNumber];
            [arraySQL removeObjectAtIndex:i];
            [arraySQL addObject:newLineDate];
            return;
        }
        [newLineDate release];
    }
    
    if (!isAddData)
    {
        [arraySQL addObject:lineData];
    }
}

- (void)drawRect:(CGRect)rect
{
    
    if (isWord)
    {
        [self lineWithArray:[lineDictionary objectForKey:@"vBoxes"] withColor:lineColor];
        [lineDictionary removeObjectForKey:@"vBoxes"];
    }
        for (int i = 0; i < [arraySQL  count]; i++)
        {
            QZLineDataModel * lineData = [arraySQL objectAtIndex:i];
            BookIndex startIndex;
            startIndex.nPage = [lineData.linePageNumber intValue];
            startIndex.nCharacter = [lineData.lineStartIndex intValue];
            BookIndex endIndex;
            endIndex.nPage = [lineData.linePageNumber intValue];
            endIndex.nCharacter = [lineData.lineEndIndex intValue];
            std::vector<QZ_BOX> vsBoxes = pageObj->GetSelectTextRects(startIndex,endIndex);
            
            NSMutableArray *array = [NSMutableArray array];
            for (int j = 0 ; j < vsBoxes.size(); j++)
            {
                [array addObject:NSStringFromCGRect(CGRectMake(vsBoxes[j].X0, vsBoxes[j].Y1, vsBoxes[j].X1 - vsBoxes[j].X0, vsBoxes[j].Y1 - vsBoxes[j].Y0))];
            }
            [self lineWithArray:array withColor:lineData.lineColor];
        }
}

- (void)lineWithArray:(NSArray *)lineArray  withColor:(NSString*)colorA
{
    CGMutablePathRef _path = CGPathCreateMutable();
    
    if ([colorA isEqualToString:@"red"])
    {
        [[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0]setFill];
    }
    else if([colorA isEqualToString:@"blue"])
    {
        [[UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:1.0]setFill];
    }
    else if([colorA isEqualToString:@"green"])
    {
        [[UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0]setFill];
    }
    
    for (int i = 0; i < [lineArray count]; i++)
    {
        CGRect fiRect = CGRectFromString([lineArray objectAtIndex:i]);
        fiRect.size.height = 1;
        CGPathAddRect(_path, NULL, fiRect);
    }
    
    //下划线结束位置的按钮的坐标
    CGRect lastRect = CGRectFromString([lineArray lastObject]);
    btnLastPosX = lastRect.origin.x + lastRect.size.width;
    btnLastPosY = lastRect.origin.y;
    
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
    return strDate;
}


- (void)saveData
{
    [[Database sharedDatabase]deletePageData:[NSString stringWithFormat:@"%d",self.pageNumber]];
    [[Database sharedDatabase]insertArray:arraySQL];
}

@end
