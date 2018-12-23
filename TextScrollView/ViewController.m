//
//  ViewController.m
//  ScrollText
//
//  Created by zhihuili on 2018/12/22.
//  Copyright © 2018 智慧  李. All rights reserved.
//

#import "ViewController.h"
#import "TextScrollView.h"

@interface ViewController ()
@property(weak,nonatomic)TextScrollView *textScroolView;
@end

#define KTitleColorNormal [UIColor colorWithRed:0.671 green:0.776 blue:0.922 alpha:1.00]
#define KTitleColorCurrent [UIColor colorWithRed:0.937 green:0.957 blue:0.984 alpha:1.00]

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"TextScroolView";
    [self addBtn];
    /* test */
}
-(void)addBtn{
    self.view.backgroundColor = [UIColor colorWithRed:93 green:146 blue:219 alpha:1];
    NSArray *arr = @[@"添加",@"删除",@"开始",@"暂停"];
    int col;
    int row;
    for (int i = 0; i<arr.count; ++i) {
        row = i/2;
        col = i%2;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20+120*col, 90+50*row, 100, 30)];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.layer.borderColor = [UIColor orangeColor].CGColor;
        btn.layer.borderWidth = 1;
        btn.layer.cornerRadius = 4;
        btn.layer.masksToBounds = YES;
        btn.tag = i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}
-(void)btnClick:(UIButton *)sender{
    switch (sender.tag) {
        case 0:{
            if (!self.textScroolView) {
                self.textScroolView = [TextScrollView creatWithSuperView:self.view andFrame:CGRectMake(0, 190, [UIScreen mainScreen].bounds.size.width, 400) andConfiguration:^(TextScrollView *textScroolView) {
                    textScroolView.titleArr = @[@"开始筛选案例",@"英国 硕士",@"安徽财经大学",@"开始筛选案例",@"英国 硕士",@"安徽财经大学",@"开始筛选案例",@"英国 硕士",@"安徽财经大学",@"筛选完成"];
                    textScroolView.normalFont = 14;
                    textScroolView.currentFont = 20;
                    textScroolView.currentColor = KTitleColorCurrent;
                    textScroolView.normalColor = KTitleColorNormal;
                } currentText:^(NSString *text) {
                    NSLog(@"--text=%@--",text);
                } complete:^{
                    NSLog(@"--滚动完成--");
                }];
                [self.textScroolView startScroll];
            }
        }
            break;
        case 1:{
            [self.textScroolView removeFromSuperview];
        }
            break;
        case 2:{
            [self.textScroolView startScroll];
        }
            break;
        case 3:{
            [self.textScroolView pauseScroll];
        }
            break;
        default:
            break;
    }
}

@end
