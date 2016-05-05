//
//  UserMarginView.m
//  MasonryDemo
//
//  Created by Mr.LuDashi on 16/5/4.
//  Copyright © 2016年 zeluli. All rights reserved.
//

#import "UserMarginView.h"

@implementation UserMarginView

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    UIView *lastView = self;
    for (int i = 0; i < 20; i++) {
        UIView *view = UIView.new;
        view.backgroundColor = [self randomColor];
        view.layer.borderColor = UIColor.blackColor.CGColor;
        view.layer.borderWidth = 2;
        view.layoutMargins = UIEdgeInsetsMake(10, 5, 10, 5);
        [self addSubview:view];

        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastView.mas_topMargin);
            make.bottom.equalTo(lastView.mas_bottomMargin);
            make.left.equalTo(lastView.mas_leftMargin);
            make.right.equalTo(lastView.mas_rightMargin);
        }];
        
        lastView = view;
    }
    
    return self;
}

- (UIColor *)randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

@end
