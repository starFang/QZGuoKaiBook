//
//  QZPageToolTipView.h
//  GuoKaiInteraction
//
//  Created by qanzone on 13-10-18.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "QZEpubPageObjs.h"
#import "CTView.h"


@interface QZPageToolTipView : UIView

{
    PageToolTip *pToolTip;
    UIView *textView;
    UIButton *button;
}
@property (nonatomic, retain) CTView *ctv;
- (void)composition;
- (void)initIncomingData:(PageToolTip *)pageToolTip;
- (void)closeTheTextViewWithToolTipView;

@end
