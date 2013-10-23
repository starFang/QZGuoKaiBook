//
//  QZPageListView.h
//  GuoKaiInteraction
//
//  Created by qanzone on 13-10-18.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "QZEpubPage.h"
#import "QZPageToolTipView.h"
#import "QZToolTipImageview.h"
#import "QZPageNavButtonView.h"
#include "QZPageNavRectView.h"

@interface QZPageListView : UIView<QZPageToolTipViewDelegate,QZPageToolTipImageViewDelegate>

{
    NSArray *array;
    QZEpubPage pageObj;
    
    QZPageToolTipView *pageToolTip;
    QZToolTipImageview *pToolTipImageview;
    QZPageNavButtonView *pNavButtonView;
    QZPageNavRectView *pNavRectView;
}
@property (nonatomic, copy)NSString *pageName;

- (void)composition;
- (void)initIncomingData:(NSArray *)pageName;

@end
