//
//  MovieView.m
//  MovieDemo
//
//  Created by qanzone on 13-9-18.
//  Copyright (c) 2013年 star. All rights reserved.
//

#import "MovieView.h"
#import <QuartzCore/QuartzCore.h>
#import "MarkupParser.h"

@implementation MovieView

@synthesize lastRotation = _lastRotation;
@synthesize scale = _scalel;
@synthesize moviePlayer = _moviePlayer;
@synthesize fRView = _fRView;

- (void)dealloc
{
    [self.moviePlayer release];
    self.moviePlayer = nil;
    [self.fRView release];
    self.fRView = nil;
    [pressView release];
    [musicTitle release];
    [super dealloc];
}

- (void)first
{
    isPanNow = NO;
    isPinchNow = NO;
    isRotationNow = NO;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}

- (void)initIncomingData:(PageVideo *)pageVideo
{
    pVideo = pageVideo;
}
- (void)composition
{
    [self initTitle:self.frame];
    [self initSelfInfo:self.frame];
    [self initPressPlay:self.frame];
    [self loadMovie];
    [self pressViewImage];
}

- (void)initTitle:(CGRect)frame
{
    
    if (pVideo->stTitle.isRichText == YES)
    {
        [self isYesRichText:frame];
    }else{
        [self isNoRichText:frame];
    }
}

- (void)isYesRichText:(CGRect)frame
{
    NSMutableString *strBegin = [[NSMutableString alloc]initWithString:@""];
    NSMutableString *string = [[NSMutableString alloc]initWithString:@""];
    NSMutableString * strFont = [NSMutableString string];
    CGFloat fontsize;
    MarkupParser *p = [[[MarkupParser alloc]init]autorelease];
    for (int i = 0; i < pVideo->stTitle.vTextItemList.size(); i++)
    {
        switch (pVideo->stTitle.vTextItemList[i].pieceType)
        {
            case PAGE_RICH_TEXT_PIECE_PARAGRAPH_BEGIN:
            {
                if (![strBegin length])
                {}else{
                    [strBegin appendString:@"\n"];
                    [string appendString:@"\n"];
                }
                UIFont *font = [UIFont fontWithName:[NSString stringWithUTF8String:pVideo->stTitle.vTextItemList[i].fontFamily.c_str()] size:pVideo->stTitle.vTextItemList[i].fontSize];
                
                CGSize sizek = [@" " sizeWithFont:font constrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
                NSInteger countK = (int)ceilf(pVideo->stTitle.vTextItemList[i].nLength/sizek.width);
                for (int j =0 ; j < countK; j++)
                {
                    [strBegin appendString:@" "];
                    [string appendString:@" "];
                }
                
            }
                break;
            case PAGE_RICH_TEXT_PIECE_TEXT:
            {
                [string appendString:[NSString stringWithFormat:@"%@",[NSString stringWithUTF8String:pVideo->stTitle.vTextItemList[i].strText.c_str()]]];
                NSString * strText = [NSString stringWithFormat:@"<font color=\"%d,%d,%d,%d\">%@",pVideo->stTitle.vTextItemList[i].fontColor.rgbRed,pVideo->stTitle.vTextItemList[i].fontColor.rgbGreen,pVideo->stTitle.vTextItemList[i].fontColor.rgbBlue,pVideo->stTitle.vTextItemList[i].fontColor.rgbAlpha,[NSString stringWithUTF8String:pVideo->stTitle.vTextItemList[i].strText.c_str()]];
                [strBegin appendString:strText];
                [strFont setString:[NSString stringWithUTF8String:pVideo->stTitle.vTextItemList[i].fontFamily.c_str()]];
                fontsize = (float)pVideo->stTitle.vTextItemList[i].fontSize;
                
            }
                break;
            case PAGE_RICH_TEXT_PIECE_PARAGRAPH_END:
            {
                
            }
                break;
            case PAGE_RICH_TEXT_PIECE_DOT:
            {
                
            }
                break;
            default:
                break;
         }
    }
    [p setFont:strFont];
    [p setSize:fontsize];
    CGSize size = [string sizeWithFont:[UIFont fontWithName:strFont size:fontsize] constrainedToSize:CGSizeMake(SFSW, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    NSAttributedString *attString = [p attrStringFromMarkup:strBegin];
    ctv = [[CTView alloc]initWithFrame:CGRectMake(0, 0, SFSW, size.height)];
    ctv.backgroundColor = [UIColor clearColor];
    [ctv setAttString:attString];
    [self addSubview:ctv];
    titHeight = size.height;
}

- (void) isNoRichText:(CGRect)frame
{
    musicTitle = [[UILabel alloc]init];
    musicTitle.backgroundColor = [UIColor underPageBackgroundColor];
    musicTitle.tag = MOVIEVIEW_TITLE_TAG;
    musicTitle.text = [NSString stringWithUTF8String:pVideo->stTitle.strText.c_str()];
    musicTitle.numberOfLines = 0;
    musicTitle.textColor = [UIColor blueColor];
    musicTitle.textAlignment = NSTextAlignmentLeft;
    UIFont *fontTt = [UIFont fontWithName:@"Helvetica" size:15];
    CGSize sizeTt = [musicTitle.text sizeWithFont:fontTt constrainedToSize:CGSizeMake(FSW, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    musicTitle.frame = CGRectMake(0, 0, FSW, sizeTt.height+1);
    [self addSubview:musicTitle];
     titHeight = musicTitle.FSH;
}

- (void)initSelfInfo:(CGRect)frame
{
    firstPoint = self.fRView.center;
    self.fRView.layer.backgroundColor = [UIColor clearColor].CGColor;
    CGRect frameMovie;
 
    if ((frame.size.height-MOVIEVIEW_DISTANT-titHeight)/3 >frame.size.width/4 )
    {
        frameMovie= CGRectMake(0, titHeight + MOVIEVIEW_DISTANT+(frame.size.height-titHeight-MOVIEVIEW_DISTANT-3.0*frame.size.width/4)/2, frame.size.width, frame.size.width*3.0/4.0);
    }else if((frame.size.height-MOVIEVIEW_DISTANT-titHeight)/3 <= frame.size.width/4)
    {
        frameMovie= CGRectMake(frame.size.width/2-(frame.size.height-MOVIEVIEW_DISTANT-titHeight)*2.0/3.0, titHeight + MOVIEVIEW_DISTANT, (frame.size.height-MOVIEVIEW_DISTANT-titHeight)*4.0/3.0,
                               frame.size.height - titHeight - MOVIEVIEW_DISTANT);
    }
    
    startRect = frameMovie;
    self.fRView = [[UIView alloc]initWithFrame:frameMovie];
//    设置阴影效果
    [self.fRView.layer setShadowOffset:CGSizeMake(1, 1)];
    [self.fRView.layer setShadowRadius:10.0];
    [self.fRView.layer setShadowColor:[UIColor clearColor].CGColor];
    [self.fRView.layer setShadowOpacity:0.0];
    [self addSubview:self.fRView];
    
    isMovieBig = NO;
  }

- (void)initPressPlay:(CGRect)frame
{
    CGRect frameMovie;
    if ((frame.size.height-MOVIEVIEW_DISTANT-titHeight)/3 >frame.size.width/4 )
    {
        frameMovie= CGRectMake(0, titHeight + MOVIEVIEW_DISTANT+(frame.size.height-titHeight-MOVIEVIEW_DISTANT-3.0*frame.size.width/4)/2, frame.size.width, frame.size.width*3.0/4.0);
    }else if((frame.size.height-MOVIEVIEW_DISTANT-titHeight)/3 <= frame.size.width/4)
    {
    frameMovie= CGRectMake(frame.size.width/2-(frame.size.height-MOVIEVIEW_DISTANT-titHeight)*2.0/3.0, titHeight + MOVIEVIEW_DISTANT, (frame.size.height-MOVIEVIEW_DISTANT-titHeight)*4.0/3.0,
        frame.size.height - titHeight - MOVIEVIEW_DISTANT);
    }
    
    pressView = [[UIImageView alloc]init];
    pressView.frame = frameMovie;
    pressView.userInteractionEnabled = YES;
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [pressView addSubview:button];
    button.frame = CGRectMake(0, 0, 70, 70);
    button.center = CGPointMake(frameMovie.size.width/2,frameMovie.size.height/2 );
    [button setBackgroundImage:[UIImage imageNamed:@"1_1.jpg"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(pressButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:pressView];
}

- (void)pressViewImage
{
    NSString *bookPath = [[[[DOCUMENT stringByAppendingPathComponent:BOOKNAME]  stringByAppendingPathComponent:@"OPS"] stringByAppendingPathComponent:@"images"] stringByAppendingPathComponent:[NSString stringWithUTF8String:pVideo->strStartImage.c_str()]];
    UIImage *image = [UIImage imageWithContentsOfFile:bookPath];
    [pressView setImage:image];
}

-(void)pressButton:(id)sender
{
    [pressView sendSubviewToBack:self];
    pressView.alpha = 0;
    pressView.hidden = YES;
    [self.fRView bringSubviewToFront:self];
    [self.moviePlayer play];
}

- (void)loadMovie
{
    NSString *bookPath = [[[[DOCUMENT stringByAppendingPathComponent:BOOKNAME] stringByAppendingPathComponent:@"OPS"] stringByAppendingPathComponent:@"medias"] stringByAppendingPathComponent:[NSString stringWithUTF8String:pVideo->strPath.c_str()]];
    NSURL *url = [NSURL fileURLWithPath:bookPath];
    self.moviePlayer = [[MPMoviePlayerController  alloc]initWithContentURL:url];
    [self playMovie];
}

-(void)playMovie
{
    self.moviePlayer.scalingMode = MPMovieScalingModeAspectFill;
    self.moviePlayer.view.backgroundColor = [UIColor clearColor];
//    设置播放器风格
    [self.moviePlayer setControlStyle:MPMovieControlStyleEmbedded];
    [self.moviePlayer.view setFrame:self.fRView.bounds];
    self.moviePlayer.initialPlaybackTime = -1;
    [self.fRView addSubview:self.moviePlayer.view];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

- (void)moviePlayBackDidFinish:(NSNotification*)notification
{
    self.moviePlayer.currentPlaybackTime = 0;
    [self.moviePlayer pause];
    
    if (self.fRView.frame.origin.x == self.frame.origin.x && self.fRView.frame.origin.y == self.frame.origin.y)
    {
    
        [self endStateTwoCase:nil];
    }
    
//    MPMoviePlayerController * theMovie = [notification object];
////    销毁播放通知中心
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:theMovie];
//    [theMovie.view removeFromSuperview];
//    [theMovie release];
}

- (void)endStateTwoCase:(UIGestureRecognizer *)gestureRecognizer
{
    
    [self.moviePlayer setControlStyle:MPMovieControlStyleEmbedded];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5f];
    self.fRView.transform = CGAffineTransformScale(gestureRecognizer.view.transform, 1.0, 1.0);
    self.fRView.transform = CGAffineTransformMakeRotation(M_PI * 2);
    self.fRView.frame = startRect;
    self.moviePlayer.view.frame =self.fRView.bounds;
    self.lastRotation = 0;
    self.fRView.layer.shadowOpacity = 0.0;
    distancePoint = CGPointMake(0, 0);
    isMovieBig = YES;
    self.backgroundColor = [UIColor clearColor];
    [UIView commitAnimations];
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return  YES;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}
@end
