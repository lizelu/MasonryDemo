//
//  UpdateArrayViews.m
//  MasonryDemo
//
//  Created by Mr.LuDashi on 16/5/4.
//  Copyright © 2016年 zeluli. All rights reserved.
//

#import "UpdateArrayViews.h"
@interface UpdateArrayViews()

@property (nonatomic, assign) int width;
@property (nonatomic, strong) NSArray *views;

@end


@implementation UpdateArrayViews

-(instancetype)init {
    self = [super init];
    [self addView];
    return self;
}

- (void)addView {
    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"heart"]];
    [imageView1 setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:imageView1];
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"heart"]];
    [imageView2 setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:imageView2];
    
    UIImageView *imageView3= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"heart"]];
    [imageView3 setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:imageView3];
    
    self.views = @[imageView1, imageView2, imageView3];
    
    
    
    self.width = 100;
    [imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(-self.width);
        make.centerX.equalTo(self);
        make.width.equalTo(@(self.width));
        make.height.equalTo(imageView1.mas_width);
    }];
    
    
    [imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView1.mas_bottom);
        make.left.equalTo(imageView1.mas_left).offset(-self.width);
        make.size.equalTo(imageView1);
    }];

    [imageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView1.mas_bottom);
        make.right.equalTo(imageView1.mas_right).offset(self.width);
        make.size.equalTo(imageView1);
    }];


    
    
    
}

#pragma - mark 视图回调
//视图加载后开始动画
- (void)didMoveToWindow {
    [self animateWithInvertedInsets:NO];
}

//重写updateConstraints方法
-(void)updateConstraints {
    
    //更新数组约束
    [_views mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(self.width));
    }];
    
    [super updateConstraints];
}


- (void)animateWithInvertedInsets:(BOOL)invertedInsets {
    self.width = invertedInsets ? 50 : 200;
    
    
    // 告诉约束需要更新
    [self setNeedsUpdateConstraints];
    
    // 更新约束
    [self updateConstraintsIfNeeded];
    [UIView animateWithDuration:1 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        //repeat!
        [self animateWithInvertedInsets:!invertedInsets];
    }];
    
}

@end
