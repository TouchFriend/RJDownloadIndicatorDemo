//
//  RJDownloadIndicator.m
//  RJDownloadIndicatorDemo
//
//  Created by TouchWorld on 2020/7/22.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import "RJDownloadIndicator.h"

static NSString * const RJDownloadIndicatorAnimationKey = @"progressAnimation";
static NSString * const RJDownloadIndicatorDefaultResumeImageName = @"icon_suspend";
static NSString * const RJDownloadIndicatorDefaultSuspendtImageName = @"icon_startDownload";

@interface RJDownloadIndicator ()

/// <#Desription#>
@property (nonatomic, weak) CAShapeLayer *progressLayer;
/// <#Desription#>
@property (nonatomic, weak) UIImageView *iconImageV;
@property (nonatomic, assign, readwrite) CGFloat progress;
/// <#Desription#>
@property (nonatomic, strong) NSMutableDictionary *stateImages;
/// 状态
@property (nonatomic, assign, readwrite) RJDownloadIndicatorState state;

@end

@implementation RJDownloadIndicator

- (void)drawRect:(CGRect)rect {
    CGFloat lineWidth = self.lineWidth;
    CGPoint center = CGPointMake(CGRectGetWidth(rect) * 0.5, CGRectGetHeight(rect) * 0.5);
    CGFloat radius = MIN(CGRectGetWidth(rect), CGRectGetHeight(rect)) * _diameterPercent * 0.5 - lineWidth;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddArc(context, center.x, center.y, radius, 0, 2 * M_PI, 1);
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(context, _backgroundCircleStrokeColor.CGColor);
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextDrawPath(context, kCGPathFillStroke);
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupInit];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = self.frame;
    CGFloat lineWidth = self.lineWidth;
    CGPoint center = CGPointMake(CGRectGetWidth(frame) * 0.5, CGRectGetHeight(frame) * 0.5);
    CGFloat radius = MIN(CGRectGetWidth(frame), CGRectGetHeight(frame)) * _diameterPercent * 0.5 - lineWidth;
    CGFloat startAngle = -M_PI_2;
    CGFloat endAngle = startAngle + 2 * M_PI;
    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:self.progressLayer.path];
    [path removeAllPoints];
    [path addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    self.progressLayer.path = path.CGPath;
    
    CGFloat iconWidth = MIN(CGRectGetWidth(frame), CGRectGetHeight(frame)) * _diameterPercent;
    CGRect iconFrame = CGRectMake(center.x - iconWidth * 0.5, center.y - iconWidth * 0.5, iconWidth, iconWidth);
    self.iconImageV.frame = iconFrame;
}

#pragma mark - Setup Init

- (void)setupInit {
    _lineWidth = 1.0;
    _diameterPercent = 1.0;
    _animationDuration = 0.2;
    _backgroundCircleStrokeColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
    _foregroundCircleStrokeColor = [UIColor colorWithRed:36.0/255.0 green:153.0/255.0 blue:255.0/255.0 alpha:1.0];
    self.backgroundColor = [UIColor whiteColor];
    
    [self setupProgressLayer];
    [self setupIconImageV];
    [self addTapGesture];
}

- (void)setupProgressLayer {
    UIBezierPath *path = [UIBezierPath bezierPath];
    CAShapeLayer *progressLayer = [CAShapeLayer layer];
    self.progressLayer = progressLayer;
    progressLayer.path = path.CGPath;
    progressLayer.strokeColor = _foregroundCircleStrokeColor.CGColor;
    progressLayer.fillColor = [UIColor clearColor].CGColor;
    progressLayer.lineWidth = _lineWidth;
    progressLayer.lineCap = kCALineCapRound;
    progressLayer.strokeEnd = 0.0;
    [self.layer addSublayer:progressLayer];
}

- (void)setupIconImageV {
    UIImageView *iconImageV = [[UIImageView alloc] init];
    [self addSubview:iconImageV];
    self.iconImageV = iconImageV;
    [self changeState:RJDownloadIndicatorStateSuspend];
}

- (void)addTapGesture {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    [self addGestureRecognizer:tapGesture];
}

#pragma mark - Target Methods

- (void)tapView:(UITapGestureRecognizer *)gesture {
    RJDownloadIndicatorState newState = _state == RJDownloadIndicatorStateResume ? RJDownloadIndicatorStateSuspend : RJDownloadIndicatorStateResume;
    [self changeState:newState];
    if (self.clickBlock) {
        self.clickBlock(_state);
    }
    
    if ([self.delegate respondsToSelector:@selector(indicator:didClick:)]) {
        [self.delegate indicator:self didClick:_state];
    }
}

#pragma mark - Public Methods

- (void)changeProgress:(CGFloat)progress animation:(BOOL)isAnimation {
    CGFloat oldProgress = _progress;
    _progress = MAX(MIN(progress, 1.0), 0.0);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @(oldProgress);
    animation.toValue = @(_progress);
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
//    animation.duration = fabs(_progress - oldProgress);
    animation.duration = isAnimation ? _animationDuration : 0.01;
    [self.progressLayer addAnimation:animation forKey:RJDownloadIndicatorAnimationKey];
}

- (void)setImage:(UIImage *)image forState:(RJDownloadIndicatorState)state {
    [self.stateImages setObject:image forKey:@(state)];
    if (self.state == state) {
        self.iconImageV.image = image;
    }
}

- (UIImage *)imageForState:(RJDownloadIndicatorState)state {
    return [self.stateImages objectForKey:@(state)];
}

- (void)changeState:(RJDownloadIndicatorState)state {
    _state = state;
    switch (_state) {
        case RJDownloadIndicatorStateResume:
        {
            self.progressLayer.hidden = NO;
        }
            break;
        case RJDownloadIndicatorStateSuspend:
        {
            self.progressLayer.hidden = YES;
        }
            break;
            
        default:
            break;
    }
    self.iconImageV.image = [self.stateImages objectForKey:@(_state)];
}

#pragma mark - Property Methods

- (void)setBackgroundCircleStrokeColor:(UIColor *)backgroundCircleStrokeColor {
    _backgroundCircleStrokeColor = backgroundCircleStrokeColor;
    [self setNeedsDisplay]; // 重绘背景circle
}

- (void)setForegroundCircleStrokeColor:(UIColor *)foregroundCircleStrokeColor {
    _foregroundCircleStrokeColor = foregroundCircleStrokeColor;
    self.progressLayer.strokeColor = _foregroundCircleStrokeColor.CGColor;
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    _progressLayer.lineWidth = lineWidth;
    [self setNeedsLayout];
    [self layoutIfNeeded];
    [self setNeedsDisplay]; // 重绘背景circle
}

- (void)setDiameterPercent:(CGFloat)diameterPercent {
    _diameterPercent = diameterPercent;
    [self setNeedsLayout];
    [self layoutIfNeeded];
    [self setNeedsDisplay]; // 重绘背景circle
}

- (NSMutableDictionary *)stateImages {
    if (!_stateImages) {
        _stateImages = [NSMutableDictionary dictionary];
        [_stateImages setObject:[UIImage imageNamed:RJDownloadIndicatorDefaultResumeImageName] forKey:@(RJDownloadIndicatorStateResume)];
        [_stateImages setObject:[UIImage imageNamed:RJDownloadIndicatorDefaultSuspendtImageName] forKey:@(RJDownloadIndicatorStateSuspend)];
    }
    return _stateImages;
}

@end
