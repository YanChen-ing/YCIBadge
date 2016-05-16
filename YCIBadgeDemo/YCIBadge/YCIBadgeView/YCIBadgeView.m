//
//  YCIBadgeView.m
//  YCIBadge
//
//  Created by yanchen on 15/8/13.
//  Copyright (c) 2015年 yanchen. All rights reserved.
//

#import "YCIBadgeView.h"
#import <QuartzCore/QuartzCore.h>

const static CGFloat animationDuration = 0.2;
const static NSInteger maxNum = 99;

@interface YCIBadgeView ()
@property (nonatomic, strong) NSString *text;

@end

@implementation YCIBadgeView
{
    CATextLayer  *_textLayer;
    CAShapeLayer *_backgroundLayer;
    
}

#pragma mark - ------- init

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configureDefaultData];
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureDefaultData];
        self.frame =frame;
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configureDefaultData];
        [self setup];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect textFrame;
    
    CGFloat roundScale = 1 / [UIScreen mainScreen].scale;
    textFrame = CGRectMake(0,
                           roundf(((self.frame.size.height - _font.lineHeight) / 2) / roundScale) * roundScale,
                           self.frame.size.width,
                           _font.lineHeight);
    
    _textLayer.frame       = textFrame;
    _backgroundLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    
    //
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:_cornerRadius];
    
    _backgroundLayer.path = path.CGPath;
    
}

#pragma mark - ------- logic

//配置默认数据
- (void)configureDefaultData{
    
    _textColor = [UIColor whiteColor];
    _font      = [UIFont systemFontOfSize:11.0f];
    _badgeBackgroundColor = [UIColor redColor];
    _cornerRadius  = self.frame.size.height/2;
    _hidesWhenZero = YES;
    
    self.frame    = CGRectMake(0, 0, 16, 16);
    
    _maximumWidth = CGFLOAT_MAX;
    
}

- (void)setup{
    
    //Create text layer
    _textLayer                 = [CATextLayer layer];
    _textLayer.foregroundColor = _textColor.CGColor;
    _textLayer.font            = (__bridge CFTypeRef)(_font.fontName);
    _textLayer.fontSize        = _font.pointSize;
    _textLayer.alignmentMode   = kCAAlignmentCenter;
    _textLayer.truncationMode  = kCATruncationEnd;
    
    _textLayer.wrapped  = NO;
    _textLayer.frame    = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _textLayer.contentsScale = [UIScreen mainScreen].scale;
    
    //Create background layer
    _backgroundLayer           = [CAShapeLayer layer];
    _backgroundLayer.fillColor = _badgeBackgroundColor.CGColor;
    _backgroundLayer.frame     = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _backgroundLayer.contentsScale = [UIScreen mainScreen].scale;
    
    [self.layer addSublayer:_backgroundLayer];
    [self.layer addSublayer:_textLayer];
    
    //Setup animations
    CABasicAnimation *frameAnimation = [CABasicAnimation animation];
    frameAnimation.duration          = animationDuration;
    frameAnimation.timingFunction    = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    NSDictionary *actions = @{@"path":frameAnimation};
    
    _backgroundLayer.actions = actions;
    
}

//调整徽章尺寸
- (void)adjustBadgeFrame{
    
    CGRect frame     = self.frame;
    
    frame.size.width = [self sizeForString:_text].width;
    
    if (frame.size.width < frame.size.height) {
        //宽度不小于高度
        frame.size.width = frame.size.height;
    }else if(frame.size.width > _maximumWidth){
        frame.size.width = _maximumWidth;
    }
    
    //根据动画方向,调整frame
    //目标位置 = 原位置 + 改变量
    if (_animatePin == YCIBadgeAnimatePinLeft) {
        
    }else if (_animatePin == YCIBadgeAnimatePinCenter){
        frame.origin.x += (self.frame.size.width - frame.size.width)/2;
    }else if (_animatePin == YCIBadgeAnimatePinRight){
        frame.origin.x += (self.frame.size.width - frame.size.width);
    }
    
    _cornerRadius = self.frame.size.height / 2;
    
    CGFloat roundScale = 1 / [UIScreen mainScreen].scale;
    frame = CGRectMake(roundf(frame.origin.x / roundScale) * roundScale,
                       roundf(frame.origin.y / roundScale) * roundScale,
                       roundf(frame.size.width / roundScale) * roundScale,
                       roundf(frame.size.height / roundScale) * roundScale);
    
    //
    self.frame       = frame;
    CGRect tempFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    _backgroundLayer.frame = tempFrame;
    
    CGRect textFrame = CGRectMake(0, roundf(((self.frame.size.height - _font.lineHeight) / 2) / roundScale) * roundScale, self.frame.size.width, _font.lineHeight);
    
    _textLayer.frame = textFrame;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:tempFrame  cornerRadius:_cornerRadius];
    
    _backgroundLayer.path = path.CGPath;
}



//字符串尺寸
- (CGSize)sizeForString:(NSString *)str{
    
    if (!_font) {
        return CGSizeMake(0, 0);
    }
    
    //
    CGFloat roundScale   = 1 / [UIScreen mainScreen].scale;
    CGFloat widthPadding = roundf((_font.pointSize * .375) / roundScale) *roundScale;
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:(str ? str : @"") attributes:@{NSFontAttributeName:_font}];
    CGSize textSize = [attributedString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    textSize.width  += widthPadding *2;
    
    textSize.width  = roundf(textSize.width / roundScale) *roundScale;
    textSize.height = roundf(textSize.height / roundScale) *roundScale;
    
    return textSize;
}

- (void)hideForZeroIfNeeded{
    self.hidden = ([_text isEqualToString:@"0"]&& _hidesWhenZero);
}

#pragma mark - ------- interface Method

- (void)showIntValue:(NSInteger)num{
    
    NSString *str = [NSString stringWithFormat:@"%@",@(num)];
    if (num > maxNum) {
        str = [NSString stringWithFormat:@"%@",@(maxNum)];
    }
    
    [self showText:str];
    
}
- (void)showText:(NSString *)text{
    
    self.hidden = NO;
    _text = text;
    
    if ([self sizeForString:_textLayer.string].width >= [self sizeForString:text].width) {
        //新字符串尺寸短
        _textLayer.string = text;
        [self setNeedsDisplay];
    }else{
        //新字符串尺寸长
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animationDuration * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            _textLayer.string = text;
        });
    }
    
    //Update the frame
    [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self adjustBadgeFrame];
    } completion:nil];
    
    [self hideForZeroIfNeeded];
    
}

#pragma mark - ------- setter & getter

- (void)setFont:(UIFont *)font{
    _font = font;
    _textLayer.font = (__bridge CFTypeRef)(_font.fontName);
    _textLayer.fontSize = font.pointSize;
}



@end
