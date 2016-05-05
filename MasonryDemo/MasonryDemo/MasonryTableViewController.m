//
//  MasonryTableViewController.m
//  MasonryDemo
//
//  Created by ZeluLi on 16/5/2.
//  Copyright © 2016年 zeluli. All rights reserved.
//

#import "MasonryTableViewController.h"
#import "SubViewController.h"
#import "BaicView.h"
#import "UpdateConstraintView.h"
#import "RemakeConstraintView.h"
#import "UseConstantsView.h"
#import "UseEdgesInsetView.h"
#import "AspectFitWithRatioView.h"
#import "BasicAnimatedView.h"
#import "UpdateArrayViews.h"
#import "UserMarginView.h"

static NSString * const CellReuseIdentifier = @"kCellReuseIdentifier";

@interface MasonryTableViewController ()

@property (nonatomic, strong) NSArray *viewClasses;
@property (nonatomic, strong) NSDictionary *cellTitles;

@end

@implementation MasonryTableViewController

-(instancetype)init {
    if (self == nil) {
        self = [super init];
    }
    self.title = @"示例";
    self.viewClasses = @[BaicView.class,
                         UpdateConstraintView.class,
                         RemakeConstraintView.class,
                         UseConstantsView.class,
                         UseEdgesInsetView.class,
                         AspectFitWithRatioView.class,
                         BasicAnimatedView.class,
                         UpdateArrayViews.class,
                         UserMarginView.class];
    
    self.cellTitles = @{NSStringFromClass(BaicView.class): @"基本布局",
                        NSStringFromClass(UpdateConstraintView.class): @"约束更新",
                        NSStringFromClass(RemakeConstraintView.class): @"重加约束",
                        NSStringFromClass(UseConstantsView.class): @"使用链式调用添加常量约束值",
                        NSStringFromClass(UseEdgesInsetView.class): @"使用内边距",
                        NSStringFromClass(AspectFitWithRatioView.class): @"使用宽高比",
                        NSStringFromClass(BasicAnimatedView.class): @"基本动画",
                        NSStringFromClass(UpdateArrayViews.class): @"使用数组更新动画",
                        NSStringFromClass(UserMarginView.class): @"使用外边距"};

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:CellReuseIdentifier];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewClasses.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.cellTitles[NSStringFromClass(self.viewClasses[indexPath.row])];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Class viewClass = self.viewClasses[indexPath.row];
    NSString *title = self.cellTitles[NSStringFromClass(self.viewClasses[indexPath.row])];
    SubViewController *subViewController = [[SubViewController alloc] initWithTitle:title viewClass:viewClass];
    [self.navigationController pushViewController:subViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
