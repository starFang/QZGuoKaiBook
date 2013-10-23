//
//  QZPageNavButtonView.h
//  GuoKaiInteraction
//
//  Created by qanzone on 13-10-18.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "QZEpubPageObjs.h"


@interface QZPageNavButtonView : UIView
{
    PageNavButton *pNavButton;
    UIButton *pressView;
    UIView *popView;
    NSInteger fist;    
}

@property (nonatomic, assign)NSInteger fist;
- (void)initIncomingData:(PageNavButton *)pageNavButton;
- (void)composition;
- (void)closeThePopView;
@end
