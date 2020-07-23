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

@class RJDownloadIndicator;

@protocol RJDownloadIndicatorDelegate <NSObject>

@optional

/// 点击指示器
/// @param indicator 指示器
/// @param state 点击后的状态
- (void)indicator:(RJDownloadIndicator *_Nonnull)indicator didClick:(RJDownloadIndicatorState)state;

@end

NS_ASSUME_NONNULL_BEGIN

@interface RJDownloadIndicator : UIView

/// 代理
@property (nonatomic, weak) id <RJDownloadIndicatorDelegate> delegate;
/// 线宽 默认1.0
@property (nonatomic, assign) CGFloat lineWidth;
/// 进度 默认0
@property (nonatomic, assign, readonly) CGFloat progress;
/// 直径百分比，也就是圆圈直径跟整个view的比例 默认1.0
@property (nonatomic, assign) CGFloat diameterPercent;
/// 背景圆圈颜色 [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0]
@property (nonatomic, strong) UIColor *backgroundCircleStrokeColor;
/// 前面圆圈原色 [UIColor colorWithRed:36.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1.0]
@property (nonatomic, strong) UIColor *foregroundCircleStrokeColor;
/// 动画持续时间 默认0.2
@property (nonatomic, assign) CGFloat animationDuration;
/// 状态 默认RJDownloadIndicatorStateSuspend
@property (nonatomic, assign, readonly) RJDownloadIndicatorState state;
/// 点击回调
@property (nonatomic, copy) void (^clickBlock)(RJDownloadIndicatorState state);


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
