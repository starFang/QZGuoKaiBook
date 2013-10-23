//
//  QZPageToolTipView.h
//  GuoKaiInteraction
//
//  Created by qanzone on 13-10-18.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "QZEpubPageObjs.h"

@protocol QZPageToolTipViewDelegate <NSObject>

- (void)closeTheTextView;

@end

@interface QZPageToolTipView : UIView<QZPageToolTipViewDelegate>

{
    PageToolTip *pToolTip;
    UIView *textView;
    id<QZPageToolTipViewDelegate>delegate;
    UIButton *button;
}
@property (nonatomic, assign)id<QZPageToolTipViewDelegate>delegate;
- (void)composition;
- (void)initIncomingData:(PageToolTip *)pageToolTip;
- (void)closeTheTextViewWithToolTipView;

@end
