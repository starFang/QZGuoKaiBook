//
//  QZPageToolTipView.m
//  GuoKaiInteraction
//
//  Created by qanzone on 13-10-18.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "QZPageToolTipView.h"

@implementation QZPageToolTipView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initIncomingData:(PageToolTip *)pageToolTip
{
 pToolTip = pageToolTip;
}

- (void)createView
{
    textView = [[UIView alloc]init];
    textView.hidden = YES;
    textView.backgroundColor = [UIColor colorWithRed:pToolTip->bgColor.rgbRed green:pToolTip->bgColor.rgbGreen blue:pToolTip->bgColor.rgbBlue alpha:pToolTip->bgColor.rgbAlpha];
    CGRect tRect;
    if (pToolTip->rect.X0 <= DW/2.0 && pToolTip->rect.Y0 <= DH/2.0)
    {
        tRect = CGRectMake(0,SFSH,pToolTip->nWidth,pToolTip->nHeight);
    }else if (pToolTip->rect.X0 <= DW/2.0 && pToolTip->rect.Y0 > DH/2.0)
    {
        tRect = CGRectMake(SFSW - pToolTip->nWidth,SFSH,pToolTip->nWidth,pToolTip->nHeight);
    }else if(pToolTip->rect.X0 > DW/2.0 && pToolTip->rect.Y0 <= DH/2.0)
    {
     tRect = CGRectMake(SFSW - pToolTip->nWidth,SFSH,pToolTip->nWidth,pToolTip->nHeight);
    }else{
    tRect = CGRectMake(SFSW - pToolTip->nWidth,SFSH-pToolTip->nHeight,pToolTip->nWidth,pToolTip->nHeight);
    }
    textView.frame = tRect;
    [self addSubview:textView];
    [self textLabel];
}

- (void)textLabel
{
    UILabel *label = [[UILabel alloc]init];
    label.frame = textView.bounds;
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.text = [NSString stringWithUTF8String:pToolTip->strTipText.strText.c_str()];
    [textView addSubview:label];
    [label release];
}
- (void)createPress
{
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = self.bounds;
    [button addTarget:self action:@selector(handleSingleTap:) forControlEvents:UIControlEventTouchUpInside];
    button.selected = NO;
    [self addSubview:button];
}
- (void)composition
{
    [self createView];
    [self createPress];
 }

- (void)handleSingleTap:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (btn.selected)
    {
        textView.hidden = NO;
    }else{
        textView.hidden = YES;
    }
}

- (void)closeTheTextViewWithToolTipView
{
    textView.hidden = YES;
}


- (void)dealloc
{
    [textView release];
    [super dealloc];
}


@end
