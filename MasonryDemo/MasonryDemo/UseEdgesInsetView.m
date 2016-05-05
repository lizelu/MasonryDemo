//
//  UseEdgesInsetView.m
//  MasonryDemo
//
//  Created by Mr.LuDashi on 16/5/3.
//  Copyright © 2016年 zeluli. All rights reserved.
//

#import "UseEdgesInsetView.h"

@implementation UseEdgesInsetView
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
    
    UIView *greenView = [UIView new];
    greenView.backgroundColor = [UIColor greenColor];
    greenView.layer.borderWidth = 2;
    greenView.layer.borderColor = [[UIColor blackColor] CGColor];
    [self addSubview:greenView];
    
    
    [redView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(50, 50, 50, 50));
    }];
    
    
    [greenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(redView).insets(UIEdgeInsetsMake(50, 50, 50, 50));
    }];

}

@end
