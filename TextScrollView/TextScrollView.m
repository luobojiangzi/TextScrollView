//
//  TextScrollView.m
//  TextScrollView
//
//  Created by zhihuili on 2018/12/22.
//  Copyright © 2018 智慧  李. All rights reserved.
//

#import "TextScrollView.h"
#import "ZHWeakProxy.h"

@interface TextScrollView ()<UIScrollViewDelegate>

@property(nonatomic,strong)UIScrollView *scrollView;

/*
 *每行文字高度
 */
@property(assign,nonatomic)CGFloat eachLabelH;

@property(nonatomic,assign)NSInteger currentTag;

@property(nonatomic,weak)UILabel *currentLab;

@property(nonatomic,strong)CADisplayLink *displayLink;

@property(nonatomic,assign)int ms;

@end

@implementation TextScrollView

+ (instancetype)creatWithSuperView:(UIView *)superView andFrame:(CGRect)frame andConfiguration:(void (^)(TextScrollView *textScroolView))configuration currentText:(CurrentText)currentText
                          complete:(ScrollComplete)scrollComplete{
    TextScrollView *textScroolView = [[TextScrollView alloc] initWithFrame:frame];
    if (configuration){
        configuration(textScroolView);
    }
    [superView addSubview:textScroolView];
    textScroolView.currentText = currentText;
    textScroolView.scrollComplete = scrollComplete;
    [textScroolView setupScrollView];
    return textScroolView;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.scrollView];
        self.ms = 0;//滚动毫秒值
        self.eachLabelH = 30;//设置60或者30
        self.normalFont = 14;
        self.currentFont = 20;
        self.normalColor = [UIColor colorWithRed:0.671 green:0.776 blue:0.922 alpha:1.00];
        self.currentColor = [UIColor colorWithRed:0.937 green:0.957 blue:0.984 alpha:1.00];
        self.displayLink = [CADisplayLink displayLinkWithTarget:[ZHWeakProxy proxyWithTarget:self] selector:@selector(displayLinkTriggered:)];
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        self.displayLink.paused = YES;
    }
    return self;
}
-(void)displayLinkTriggered:(CADisplayLink *)link{
    //CADisplayLink 每秒60次 滚动self.eachLabelH/60
    [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.contentOffset.y+self.eachLabelH/60.0) animated:NO];
    self.ms+=1;
    //滚动完成
    if (self.ms==(self.titleArr.count-1)*60+30) {
        [self invalidateDisplayLink];
        if (self.scrollComplete) {
            self.scrollComplete();
        }
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.ms<30) {
                if (self.ms==1) {
                    if (self.currentText) {
                        self.currentText(self.currentLab.text);
                    }
                }
                self.currentLab.font = [UIFont systemFontOfSize:self.currentFont-self.ms/30.f*(self.currentFont-self.normalFont)];
            } else {
                int currentMS = self.ms-30;
                self.currentTag = (currentMS)/60+1;
                UILabel *lab = (UILabel *)[self.scrollView viewWithTag:self.currentTag];
                //处理文字大小
                //在label的中间的上面还是下面
                int count = currentMS%60/30;
                //下面 文字开始从大变到小
                if (count) {
                    lab.font = [UIFont systemFontOfSize:self.currentFont-currentMS%30/30.f*(self.currentFont-self.normalFont)];
                } else {
                    //上面 文字开始从小变到大
                    lab.font = [UIFont systemFontOfSize:self.normalFont+currentMS%30/30.f*(self.currentFont-self.normalFont)];
                }
                //处理文字颜色
                if (self.currentLab!=lab) {
                    self.currentText(lab.text);
                    self.currentLab.textColor = self.normalColor;
                    lab.textColor = self.currentColor;
                    self.currentLab = lab;
                }
            }
        });
    }
}
- (void)invalidateDisplayLink{
    [self.displayLink invalidate];
    self.displayLink = nil;
}
/*
 *开始滚动
 */
-(void)startScroll{
    if (self.displayLink.isPaused) {
        self.displayLink.paused = NO;
    }
}
/*
 *暂停滚动
 */
-(void)pauseScroll{
    if (!self.displayLink.isPaused) {
        self.displayLink.paused = YES;
    }
}
/*
 *结束滚动
 */
-(void)stopScroll{
    [self invalidateDisplayLink];
}
-(void)setupScrollView{
    NSAssert(self.titleArr, @"数据不能为空");
    self.scrollView.contentInset = UIEdgeInsetsMake(self.frame.size.height*0.5, 0, 0, 0);
    self.scrollView.contentSize = CGSizeMake(0, self.titleArr.count*self.eachLabelH+self.frame.size.height*0.5-self.eachLabelH*0.5);
    for (int i = 0; i<self.titleArr.count; ++i) {
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.text = self.titleArr[i];
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.frame = CGRectMake(0, i*self.eachLabelH, self.frame.size.width, self.eachLabelH);
        titleLab.tag = i;
        [_scrollView addSubview:titleLab];
        if (i==0) {
            self.currentTag = i;
            self.currentLab = titleLab;
            titleLab.textColor = self.currentColor;
            titleLab.font = [UIFont systemFontOfSize:self.currentFont];
        }else{
            titleLab.textColor = self.normalColor;
            titleLab.font = [UIFont systemFontOfSize:self.normalFont];
        }
    }
}
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _scrollView.backgroundColor = [UIColor colorWithRed:0.365 green:0.573 blue:0.859 alpha:1.00];
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.userInteractionEnabled = NO;
    }
    return _scrollView;
}
-(void)dealloc{
    NSLog(@"销毁");
}
@end
