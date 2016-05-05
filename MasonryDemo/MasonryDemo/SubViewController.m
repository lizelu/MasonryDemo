//
//  SubViewController.m
//  MasonryDemo
//
//  Created by ZeluLi on 16/5/2.
//  Copyright © 2016年 zeluli. All rights reserved.
//

#import "SubViewController.h"

@interface SubViewController ()
@property (nonatomic, strong) Class viewClass;
@end

@implementation SubViewController

- (instancetype)initWithTitle:(NSString *)title viewClass:(Class)viewClass {
    if (self == nil) {
        self = [super init];
    }
    
    self.title = title;
    self.viewClass = viewClass;
    
    return self;
}

-(void)loadView {
    self.view = self.viewClass.new;
    self.view.backgroundColor = [UIColor whiteColor];
}

@end
