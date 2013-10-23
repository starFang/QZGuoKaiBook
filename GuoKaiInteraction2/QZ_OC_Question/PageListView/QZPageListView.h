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

@protocol QZPageListViewDelegate <NSObject>

- (void)skipPage:(QZ_INT)pageNum;
@end

@interface QZPageListView : UIView<QZPageToolTipImageViewDelegate,QZPageNavRectViewDelegate,QZPageNavButtonViewDelegate>

{
    NSArray *array;
    QZEpubPage pageObj;
    QZPageToolTipView *pageToolTip;
    QZToolTipImageview *pToolTipImageview;
    QZPageNavButtonView *pNavButtonView;
    QZPageNavRectView *pNavRectView;
    id<QZPageListViewDelegate>delegate;
}
@property (nonatomic, copy)NSString *pageName;
@property (nonatomic, assign)id<QZPageListViewDelegate>delegate;
- (void)composition;
- (void)initIncomingData:(NSArray *)imageName;

@end
