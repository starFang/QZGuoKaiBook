//
//  QZRootViewController.h
//  GuoKaiInteraction
//
//  Created by qanzone on 13-10-17.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "QZPageListView.h"

@interface QZRootViewController : UIViewController
<UIScrollViewDelegate>

{
    QZPageListView *pageListView;
    NSMutableArray * arrayImage;
    NSInteger indexImage;
}

@end
