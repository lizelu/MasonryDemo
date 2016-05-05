//
//  RemakeConstraintView.m
//  MasonryDemo
//
//  Created by Mr.LuDashi on 16/5/3.
//  Copyright © 2016年 zeluli. All rights reserved.
//

#import "RemakeConstraintView.h"

@interface RemakeConstraintView()
@property (nonatomic, strong) UIButton * button;
@property (nonatomic, assign) CGPoint buttonCenter;

@end

@implementation RemakeConstraintView

-(instancetype)init {
    self = [super init];
    self.buttonCenter = CGPointMake(-100, -100);
    [self addView];
    return self;
}

- (void)addView {
    self.button = [[UIButton alloc] init];
    [self.button addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
    self.button.backgroundColor = [UIColor redColor];
    self.button.layer.borderWidth = 5;
    self.button.layer.borderColor = [[UIColor blackColor] CGColor];
    [self.button setTitle:@"重加约束" forState:UIControlStateNormal];
    [self addSubview:self.button];
    
}


//添加这句话就会执行 updateConstraints方法
+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

//重新该更新约束的方法 -- mas_remakeConstraints
-(void)updateConstraints {
    [self.button mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.buttonCenter);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    [super updateConstraints];
}

- (void)tapButton:(UIButton *)sender {
    static int i = 0;
    if (i == 0) {
        i = 1;
        self.buttonCenter = CGPointMake(100, 100);
    } else {
        i = 0;
        self.buttonCenter = CGPointMake(-100, -100);
    }
    
    // 告诉约束需要更新
    [self setNeedsUpdateConstraints];
    
    // 更新约束
    [self updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.4 animations:^{
        [self layoutIfNeeded];
    }];
}

@end
