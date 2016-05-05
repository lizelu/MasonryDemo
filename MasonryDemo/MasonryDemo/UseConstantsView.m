//
//  UseConstantsView.m
//  MasonryDemo
//
//  Created by Mr.LuDashi on 16/5/3.
//  Copyright © 2016年 zeluli. All rights reserved.
//

#import "UseConstantsView.h"

@implementation UseConstantsView

-(instancetype)init {
    self = [super init];
    [self addView];
    return self;
}

- (void)addView {
    
    UIView *redView = [UIView new];
    redView.backgroundColor = [UIColor redColor];
    redView.layer.borderWidth = 2;
    redView.layer.borderColor = [[UIColor blackColor] CGColor];
    [self addSubview:redView];
    
    
    [redView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@20);
        make.left.equalTo(@20);
        make.right.equalTo(@-20);
        make.bottom.equalTo(@-20);
        
        //下方链式调用也是可以的
        //make.top.left.right.bottom.equalTo(@20);
    }];

    
    
    
    UIView *greenView = [UIView new];
    greenView.backgroundColor = [UIColor greenColor];
    greenView.layer.borderWidth = 2;
    greenView.layer.borderColor = [[UIColor blackColor] CGColor];
    [self addSubview:greenView];
    
    
    [greenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(CGPointMake(0, 0));
        make.size.mas_equalTo(CGSizeMake(200, 100));
    }];
    
}

@end
