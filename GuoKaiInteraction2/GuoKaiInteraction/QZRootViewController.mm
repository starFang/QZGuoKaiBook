
//
//  QZRootViewController.m
//  GuoKaiInteraction
//
//  Created by qanzone on 13-10-17.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "QZRootViewController.h"
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
        indexImage = 0;
        arrayImage = [[NSMutableArray alloc]init];
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
    
    
   [arrayImage setArray:[DataManager getArrayFromPlist:[NSString stringWithFormat:@"%@/content/imageArray.plist",BOOKNAME]]];    
    UIScrollView *sc = [[UIScrollView alloc]initWithFrame:CGRectMake(ZERO, ZERO , DW, DH - 20)];
    sc.delegate = self;
    sc.contentSize = CGSizeMake(DW+1,DH-20);
    indexImage = 54;
    pageListView = [[QZPageListView alloc]init];
    pageListView.frame = CGRectMake(0, 0, 1024, 748);
    [pageListView initIncomingData:[arrayImage objectAtIndex:indexImage]];
    [pageListView composition];
    [sc addSubview:pageListView];
    [pageListView release];
    
    [self.view addSubview:sc];
    [sc release];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    NSLog(@"%d",[scrollView.subviews count]);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.x > 100)
    {
        if (indexImage >= [arrayImage count] - 1)
        {
            
            indexImage = [arrayImage count] - 1;
        }else{
            
        indexImage++;
        }
        
        [pageListView initIncomingData:[arrayImage objectAtIndex:indexImage]];
        [pageListView composition];
    }
    else if (scrollView.contentOffset.x < -100)
    {
        if (indexImage <= 0)
        {
            indexImage = 0;
        }
        else
        {
            indexImage--;
        }
        
        [pageListView initIncomingData:[arrayImage objectAtIndex:indexImage]];
        [pageListView composition];
    }
    

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
