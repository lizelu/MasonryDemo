//
//  UpdateConstraintView.m
//  MasonryDemo
//
//  Created by Mr.LuDashi on 16/5/3.
//  Copyright © 2016年 zeluli. All rights reserved.
//

#import "UpdateConstraintView.h"

@interface UpdateConstraintView()
@property (nonatomic, strong) UIButton * button;
@property (nonatomic, assign) CGSize buttonSize;

@end

@implementation UpdateConstraintView

-(instancetype)init {
    self = [super init];
    self.buttonSize = CGSizeMake(100, 100);
    [self addView];
    return self;
}

- (void)addView {
    self.button = [[UIButton alloc] init];
    [self.button addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
    self.button.backgroundColor = [UIColor redColor];
    self.button.layer.borderWidth = 5;
    self.button.layer.borderColor = [[UIColor blackColor] CGColor];
    [self.button setTitle:@"更新约束" forState:UIControlStateNormal];
    [self addSubview:self.button];
    
}


//添加这句话就会执行 updateConstraints方法
//约束的Layout方式是lazily使用的。如果你在-updateConstraints中来初始化你的约束，
//但是如果没有添加约束的话，系统就不会调用这个-updateConstraints接口。
//这个就是鸡和蛋的问题，所以用这个方法在自定义的view中返回YES，表示一定要用AL来约束。
+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

//重新该更新约束的方法
-(void)updateConstraints {
    [self.button mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(self.buttonSize);
    }];
    [super updateConstraints];
}

- (void)tapButton:(UIButton *)sender {
    static int i = 0;
    if (i == 0) {
        i = 1;
        self.buttonSize = CGSizeMake(300, 300);
    } else {
        i = 0;
        self.buttonSize = CGSizeMake(100, 100);
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
