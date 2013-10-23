//
//  GalleryView.h
//  ImageGesture
//
//  Created by qanzone on 13-9-27.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageGV.h"
#import "PageImageList1.h"
#import "PageImageListSubImage1.h"
#import "QZEpubPageObjs.h"

@interface GalleryView : UIView<UIScrollViewDelegate,MutualDelegate,closeImageDelegate>
{
    UIScrollView *_gallerySCV;
    //    图片数据源
    NSMutableArray * _mArrayImages;
    //    标题
    UILabel * _mTitleText;
    //    翻页指示
    UIPageControl * _mPageCtrol;
    //    背景色UIView
    UIView * _mTipView;
    UITapGestureRecognizer *_tapOneGesture;
    
#pragma mark - 数据
    PageImageList1 *_pageImageList;
    PageImageList *pImageList;
    CGFloat titHeight;
    CTView *ctv;
    
//    判断是否是全屏
    BOOL isBigScreen;
}

@property (nonatomic, retain) UIScrollView *gallerySCV;
@property (nonatomic, retain) NSMutableArray *imageArray;
@property (retain, nonatomic) NSArray * mArrayImages;
@property (retain, nonatomic) UILabel * mTitleText;
@property (retain, nonatomic) UIPageControl * mPageControl;
@property (retain, nonatomic) UIView * mTipView;
@property (retain, nonatomic) PageImageList1 *pageImageList;

- (void)composition;
- (void)initIncomingData:(PageImageList *)pageImageList;

@end
