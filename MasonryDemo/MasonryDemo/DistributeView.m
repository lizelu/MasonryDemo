//
//  DistributeView.m
//  MasonryDemo
//
//  Created by Mr.LuDashi on 16/5/4.
//  Copyright © 2016年 zeluli. All rights reserved.
//

#import "DistributeView.h"

@implementation DistributeView

- (instancetype)init {
    self = [super init];
    
    UIView *view = UIView.new;
    view.backgroundColor = [UIColor greenColor];
    view.layer.borderColor = UIColor.blackColor.CGColor;
    view.layer.borderWidth = 2;
    [self addSubview:view];

    [view mas_makeConstraints:^(MASConstraintMaker *make) {
    }];
    

    return self;
}

@end
