//
//  MovieView.h
//  MovieDemo
//
//  Created by qanzone on 13-9-18.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#include "QZEpubPageObjs.h"
#import "CTView.h"
@interface MovieView : UIView<UIGestureRecognizerDelegate>
{
    PageVideo *pVideo;
    CTView *ctv;
    CGFloat titHeight;
    
//    标题
    UILabel * musicTitle;
    
    UIRotationGestureRecognizer *_rotationGesture;
    UIPanGestureRecognizer *_panGesture;
    UIPinchGestureRecognizer *_pinchGesture;
    
    CGRect startRect;
    CGRect endRect;
    CGPoint firstPoint;
    
    UIView *fRView;
    CGPoint distancePoint;
    
//    点击视图
    UIImageView * pressView;
    
//    设置监听
    BOOL isPanNow;
    BOOL isPinchNow;
    BOOL isRotationNow;
    
//    是否是最大屏幕显示
    BOOL isMovieBig;
}
@property (nonatomic, retain) MPMoviePlayerController *moviePlayer;
@property (nonatomic, retain) UIView *fRView;
@property (nonatomic, assign) CGFloat lastRotation;
@property (nonatomic, assign) CGFloat scale;


- (void)initIncomingData:(PageVideo *)pageVideo;
- (void)composition;
@end
