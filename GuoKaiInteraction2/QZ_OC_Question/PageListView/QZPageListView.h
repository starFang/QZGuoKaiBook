//
//  QZPageListView.h
//  GuoKaiInteraction
//
//  Created by qanzone on 13-10-18.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "QZEpubPage.h"
#import "MovieView.h"

#import "QZPageToolTipView.h"
#import "QZToolTipImageview.h"
#import "QZPageNavButtonView.h"
#include "QZPageNavRectView.h"
#include <vector>

@protocol QZPageListViewDelegate <NSObject>

- (void)skipPage:(QZ_INT)pageNum;
- (void)up:(id)sender;
- (void)down:(id)sender;

@end

@interface QZPageListView : UIView<QZPageToolTipImageViewDelegate,QZPageNavRectViewDelegate,QZPageNavButtonViewDelegate,MoviePlayDelegate,QZPageToolTipDelegate>

{
    std::vector<PageVideo*> m_vpVideo;
    UIButton *leftButton;
    UIButton *rightButton;
    NSArray *array;
    QZEpubPage pageObj;
    
    id<QZPageListViewDelegate>delegate;
//    用来记录各种交互的数量的TAG值
    NSInteger indexToolTip;
    NSInteger indexToolImageTip;
    NSInteger indexNavRect;
    NSInteger indexNavButton;
    NSInteger indexVideo;
    NSInteger indexQuestion;
    NSInteger indexImage;
    NSInteger indeximageList;
    NSInteger indexVoice;
    NSInteger indexTextRoll;
    NSInteger indexWebLink;
    
}
@property (nonatomic, copy)NSString *pageName;
@property (nonatomic, assign)id<QZPageListViewDelegate>delegate;
- (void)composition;
- (void)initIncomingData:(NSArray *)imageName;

@end
