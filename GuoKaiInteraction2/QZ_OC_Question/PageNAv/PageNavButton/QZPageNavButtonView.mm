//
//  QZPageNavButtonView.m
//  GuoKaiInteraction
//
//  Created by qanzone on 13-10-18.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "QZPageNavButtonView.h"

#define NVACHILDBUTTON 120

@implementation QZPageNavButtonView

@synthesize fist;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initIncomingData:(PageNavButton *)pageNavButton
{
    pNavButton = pageNavButton;
}

- (void)composition
{
    [self popTheView];
    [self pressButton];
}

- (void)popTheView
{
    
    CGRect rectPress;
    CGRect rectPop;
    if (fist == 1)
    {
        rectPress = CGRectMake(0,0,
                pNavButton->rect.X1 - pNavButton->rect.X0,
                pNavButton->rect.Y1 - pNavButton->rect.Y0);
        rectPop = CGRectMake(0,
            pNavButton->rect.Y1 - pNavButton->rect.Y0+80,pNavButton->nWidth,
                pNavButton->nHeight);
    }else if (fist == 2){
        rectPress = CGRectMake(
        SFSW-(pNavButton->rect.X1 - pNavButton->rect.X0),0,pNavButton->rect.X1 - pNavButton->rect.X0,pNavButton->rect.Y1 - pNavButton->rect.Y0);
        
        rectPop = CGRectMake(0,
            pNavButton->rect.Y1 - pNavButton->rect.Y0+80,pNavButton->nWidth,
                pNavButton->nHeight);
    
    }else if (fist == 3){
        rectPress = CGRectMake(0,
        SFSH-(pNavButton->rect.Y1 - pNavButton->rect.Y0),pNavButton->rect.X1 - pNavButton->rect.X0,pNavButton->rect.Y1 - pNavButton->rect.Y0);
        
        rectPop = CGRectMake(0,0,pNavButton->nWidth,pNavButton->nHeight);
    }else{
        rectPress = CGRectMake(
        SFSW-(pNavButton->rect.X1 - pNavButton->rect.X0),
        SFSH-(pNavButton->rect.Y1 - pNavButton->rect.Y0),pNavButton->rect.X1 - pNavButton->rect.X0,pNavButton->rect.Y1 - pNavButton->rect.Y0
                               );
        rectPop = CGRectMake(0,0,pNavButton->nWidth,pNavButton->nHeight);
    }
    
    pressView = [UIButton buttonWithType:UIButtonTypeCustom];
    pressView.frame = rectPress;
    [pressView addTarget:self action:@selector(handleSingleTap:) forControlEvents:UIControlEventTouchUpInside];
    pressView.selected = NO;
    [self addSubview:pressView];
    
    popView = [[UIView alloc]init];
    popView.frame = rectPop;
    popView.hidden = YES;
    [self addSubview:popView];
}

- (void)pressButton
{
    CGSize size = [[NSString stringWithUTF8String:pNavButton->strTipText.c_str()] sizeWithFont:QUESTION_TITLE_FONT constrainedToSize:CGSizeMake(popView.FSW, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    
    UIScrollView * svc = [[UIScrollView alloc]init];
    svc.frame = popView.bounds;
    svc.contentSize = CGSizeMake(popView.FSW, size.height+120);
    for (int i = 0; i < pNavButton->vBtnList.size(); i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.tag =  NVACHILDBUTTON + i;
        [button setTitle:[NSString stringWithUTF8String:pNavButton->vBtnList[i].strBtnText.c_str()] forState:UIControlStateNormal];
        button.frame = CGRectMake((pressView.FSW/pNavButton->vBtnList.size())*i, size.height+30, pressView.FSW/pNavButton->vBtnList.size(), 80);
        [button addTarget:self action:@selector(pressButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [svc addSubview:button];
    }
    [popView addSubview:svc];
}

- (void)pressButton:(UIButton *)button
{
    NSLog(@"%d%d",pNavButton->vBtnList[button.tag-NVACHILDBUTTON].nChapterIndex,pNavButton->vBtnList[button.tag-NVACHILDBUTTON].nPageIndex);
}

- (void)handleSingleTap:(UIButton *)button
{
    button.selected = !button.selected;
    
    if (button.selected)
    {
        popView.hidden = NO;
    }else{
        popView.hidden = YES;
    }
}

- (void)closeThePopView
{
    
    NSLog(@"closePopView");
    popView.hidden = YES;
}

- (void)dealloc
{
    [popView release];
    [super dealloc];
}

@end
