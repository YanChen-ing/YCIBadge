//
//  YCIBadgeView.h
//  YCIBadge
//
//  Created by yanchen on 15/8/13.
//  Copyright (c) 2015年 yanchen. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  badge 动画固定位置
 */
typedef NS_ENUM(NSUInteger, YCIBadgeAnimatePin){
    YCIBadgeAnimatePinLeft,
    YCIBadgeAnimatePinCenter,
    YCIBadgeAnimatePinRight,
};

@interface YCIBadgeView : UIView

/* 动画时,固定的位置*/
@property (nonatomic,       ) YCIBadgeAnimatePin animatePin;

/**@name Text*/
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIColor  *textColor;
@property (nonatomic, strong) UIFont   *font;

/**@name Badge*/
@property (nonatomic, strong) UIColor *badgeBackgroundColor;
@property (nonatomic,       ) CGFloat cornerRadius;

@property (nonatomic,       ) CGFloat maximumWidth;
@property (nonatomic,       ) BOOL    hidesWhenZero;

- (void)showText:(NSString *)text;

@end
