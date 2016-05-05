//
//  BasicAnimatedView.m
//  MasonryDemo
//
//  Created by Mr.LuDashi on 16/5/3.
//  Copyright © 2016年 zeluli. All rights reserved.
//

#import "BasicAnimatedView.h"

@interface BasicAnimatedView()

@property (nonatomic, assign) int width;
@property (nonatomic, strong) UIView *view;

@end

@implementation BasicAnimatedView
-(instancetype)init {
    self = [super init];
    [self addView];
    return self;
}

- (void)addView {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"heart"]];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:imageView];
    
    self.width = 50;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(self.width));
        make.height.equalTo(imageView.mas_width);
        make.centerY.equalTo(self).offset(-30);
        make.centerX.equalTo(self);
    }];
    
    _view = imageView;
 
    
}

#pragma - mark 视图回调
//视图加载后开始动画
- (void)didMoveToWindow {
    [self animateWithInvertedInsets:NO];
}


- (void)animateWithInvertedInsets:(BOOL)invertedInsets {
    self.width = invertedInsets ? 50 : 200;
    
    //更新约束
    [_view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(self.width));
    }];
    
    [UIView animateWithDuration:1 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        //repeat!
        [self animateWithInvertedInsets:!invertedInsets];
    }];

}



@end
