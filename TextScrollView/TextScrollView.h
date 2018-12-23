//
//  TextScrollView.h
//  TextScrollView
//
//  Created by zhihuili on 2018/12/22.
//  Copyright © 2018 智慧  李. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ScrollComplete)(void);
typedef void(^CurrentText)(NSString *text);

@interface TextScrollView : UIView
/*
 *当前文字字体颜色
 */
+ (instancetype)creatWithSuperView:(UIView *)superView andFrame:(CGRect)frame andConfiguration:(void (^)(TextScrollView *textScroolView))configuration currentText:(CurrentText)currentText
                             complete:(ScrollComplete)scrollComplete;
/*
 *开始滚动
 */
-(void)startScroll;
/*
 *暂停滚动
 */
-(void)pauseScroll;
/*
 *结束滚动
 */
-(void)stopScroll;
/*
 *滚动完成
 */
@property(copy,nonatomic)CurrentText currentText;
/*
 *滚动完成
 */
@property(copy,nonatomic)ScrollComplete scrollComplete;
/*
 *显示的数据
 */
@property(nonatomic,copy)NSArray *titleArr;

/*
 *默认文字字体大小
 */
@property(assign,nonatomic)CGFloat normalFont;
/*
 *当前文字字体大小
 */
@property(assign,nonatomic)CGFloat currentFont;
/*
 *默认文字字体颜色
 */
@property(strong,nonatomic)UIColor *normalColor;
/*
 *当前文字字体颜色
 */
@property(strong,nonatomic)UIColor *currentColor;

@end
