//
//  BaicView.m
//  MasonryDemo
//
//  Created by ZeluLi on 16/5/2.
//  Copyright © 2016年 zeluli. All rights reserved.
//

#import "BaicView.h"

@implementation BaicView
-(instancetype)init {
    self = [super init];
    [self addView];
    return self;
}

- (void)addView {
    UIView *greenView = [UIView new];
    greenView.backgroundColor = [UIColor greenColor];
    greenView.layer.borderWidth = 2;
    greenView.layer.borderColor = [[UIColor blackColor] CGColor];
    [self addSubview:greenView];
    
    UIView *redView = [UIView new];
    redView.backgroundColor = [UIColor redColor];
    redView.layer.borderWidth = 2;
    redView.layer.borderColor = [[UIColor blackColor] CGColor];
    [self addSubview:redView];
    
    UIView *blueView = [UIView new];
    blueView.backgroundColor = [UIColor blueColor];
    blueView.layer.borderWidth = 2;
    blueView.layer.borderColor = [[UIColor blackColor] CGColor];
    [self addSubview:blueView];
    
    int padding = 10;
    
    NSArray *array = [greenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);                                                  //equalTo的参数可以是NSValue类型
        make.left.equalTo(self).offset(padding);                                //equalTo的参数可以是View
        make.bottom.equalTo(blueView.mas_top).offset(-padding);
        make.right.equalTo(redView.mas_left).offset(-padding);
        make.width.equalTo(redView.mas_width);
        
        make.height.equalTo(@[redView, blueView]);
        //make.height.equalTo(blueView.mas_height);
    }];
    
    NSLog(@"%@", array);
    
    [redView mas_makeConstraints:^(MASConstraintMaker *make) {
        
       // make.top.equalTo(self.mas_top).offset(padding);                         //equalTo的参数是MASViewAttribute
        make.left.equalTo(greenView.mas_right).offset(padding);
        make.right.equalTo(self.mas_right).offset(-padding);
        make.bottom.equalTo(blueView.mas_top).offset(-padding);
        make.width.equalTo(greenView.mas_width);
        
        //make.height.equalTo(@[greenView, blueView]);                            //equalTo的参数为数组的情况
    }];
    
    [blueView mas_makeConstraints:^(MASConstraintMaker *make) {
       // make.top.equalTo(redView.mas_bottom).offset(padding);
        make.left.equalTo(self.mas_left).offset(padding);
        make.right.equalTo(self.mas_right).offset(-padding);
        make.bottom.equalTo(self.mas_bottom).offset(-padding);
        
        //make.height.equalTo(@[greenView, redView]);
    }];
    
    //NSLog(@"%@, %@, %@", greenView.mas_key, redView.mas_key, blueView.mas_key);
    NSLog(@"%@", [MASViewConstraint installedConstraintsForView:blueView]);
    
}

@end
