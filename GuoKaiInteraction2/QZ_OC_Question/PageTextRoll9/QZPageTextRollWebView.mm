//
//  QZPageTextRollWebView.m
//  GuoKaiInteraction
//
//  Created by qanzone on 13-10-18.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "QZPageTextRollWebView.h"

@implementation QZPageTextRollWebView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
    }
    return self;
}

- (void)initIncomingData:(PageTextRoll *)pageTextRoll
{
    pTextRoll = pageTextRoll;
}

- (void)composition
{
    UIWebView *webView = [[UIWebView alloc]initWithFrame:self.bounds];
    [webView setBackgroundColor:[UIColor clearColor]];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithUTF8String:pTextRoll->strFilePath.c_str()]]];
    [webView loadRequest:request];
    [self addSubview: webView];
    [webView release];
}


@end
