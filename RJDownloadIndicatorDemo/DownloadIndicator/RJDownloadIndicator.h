//
//  RJDownloadIndicator.h
//  RJDownloadIndicatorDemo
//
//  Created by TouchWorld on 2020/7/22.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, RJDownloadIndicatorState) {
    RJDownloadIndicatorStateResume = 0,         // 启动
    RJDownloadIndicatorStateSuspend             // 暂停
};

NS_ASSUME_NONNULL_BEGIN

@interface RJDownloadIndicator : UIView

/// 线宽
@property (nonatomic, assign) CGFloat lineWidth;
/// 进度
@property (nonatomic, assign, readonly) CGFloat progress;
/// 直径百分比，也就是圆圈直径跟整个view的比例
@property (nonatomic, assign) CGFloat diameterPercent;
/// 背景圆圈颜色
@property (nonatomic, strong) UIColor *backgroundCircleStrokeColor;
/// 前面圆圈原色
@property (nonatomic, strong) UIColor *foregroundCircleStrokeColor;
/// 动画持续时间
@property (nonatomic, assign) CGFloat animationDuration;
/// 状态
@property (nonatomic, assign, readonly) RJDownloadIndicatorState state;

/// 更改进度
/// @param progress 进度
/// @param isAnimation 是否动画
- (void)changeProgress:(CGFloat)progress animation:(BOOL)isAnimation;

/// 设置指定状态使用的图片
/// @param image 图片
/// @param state 状态
- (void)setImage:(UIImage * _Nullable)image forState:(RJDownloadIndicatorState)state;

/// 获取指定状态对应的图片
/// @param state 状态
/// @return 指定状态对应的图片
- (UIImage *_Nullable)imageForState:(RJDownloadIndicatorState)state;

/// 更改状态
/// @param state 新的状态
- (void)changeState:(RJDownloadIndicatorState)state;

@end

NS_ASSUME_NONNULL_END
