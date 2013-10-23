
//
//  QZRootViewController.m
//  GuoKaiInteraction
//
//  Created by qanzone on 13-10-17.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "QZRootViewController.h"
#import "QZPageListView.h"
#import "QZParsingAndExtractingData.h"
#import "DataManager.h"

@interface QZRootViewController ()

@end

@implementation QZRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
        return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    
    
    QZParsingAndExtractingData * pEData = [[QZParsingAndExtractingData alloc]init];
    [pEData initIncomingData:BOOKNAME];
    [pEData composition];
    [pEData release];
    
    NSMutableArray * array = [DataManager getArrayFromPlist:[NSString stringWithFormat:@"%@/content/imageArray.plist",BOOKNAME]];
    
    UIScrollView *sc = [[UIScrollView alloc]initWithFrame:CGRectMake(ZERO, ZERO , DW+1, DH - 19)];
    sc.delegate = self;
    sc.contentSize = CGSizeMake(DW,DH-20);
    [self.view addSubview:sc];
    [sc release];
    
//    QZPageListView *pageListView = [[QZPageListView alloc]init];
//    pageListView.backgroundColor = [UIColor redColor];
//    pageListView.frame = CGRectMake(0, 0, 1024, 748);
//    [pageListView initIncomingData:array];
//    [pageListView composition];
//    [self.view addSubview:pageListView];
//    [pageListView release]; 
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [super dealloc];
}


@end
