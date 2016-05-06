//
//  MASConstraint.m
//  Masonry
//
//  Created by Jonas Budelmann on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "MASViewConstraint.h"
#import "MASConstraint+Private.h"
#import "MASCompositeConstraint.h"
#import "MASLayoutConstraint.h"
#import "View+MASAdditions.h"
#import <objc/runtime.h>





/**
 *  UIView+MASConstraints, 私有类目，只有MASConstraints类用到该类目
 */

@interface MAS_VIEW (MASConstraints)

@property (nonatomic, readonly) NSMutableSet *mas_installedConstraints;

@end

@implementation MAS_VIEW (MASConstraints)

static char kInstalledConstraintsKey;       //动态添加属性的key, 用来表示动态添加的属性
/**
 *  通过运行时动态的添加或者获取约束集合（NSMutableSet constraints）
 *
 *  @return NSMutableSet类型的约束
 */
- (NSMutableSet *)mas_installedConstraints {
    
    //通过kInstalledConstraintsKey获取动态添加的已安装的约束集合
    NSMutableSet *constraints = objc_getAssociatedObject(self, &kInstalledConstraintsKey);
    
    //如果constants == nil, 说明未动态绑定该成员变量，就进行动态绑定
    if (!constraints) {
        
        constraints = [NSMutableSet set];
        
        //动态为View添加已安装的约束集合(constraints)，并且为该成员指定唯一标示(kInstalledConstraintsKey)
        //OBJC_ASSOCIATION_RETAIN_NONATOMIC == (strong, nonatomic)
        objc_setAssociatedObject(self, &kInstalledConstraintsKey, constraints, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return constraints;
}

@end










@interface MASViewConstraint ()

@property (nonatomic, strong, readwrite) MASViewAttribute *secondViewAttribute; //相对视图的约束
@property (nonatomic, weak) MAS_VIEW *installedView;                            //布局约束所添加的视图
@property (nonatomic, weak) MASLayoutConstraint *layoutConstraint;              //约束对象: left, top, bottom等
@property (nonatomic, assign) NSLayoutRelation layoutRelation;                  //约束关系：=，>=，<=
@property (nonatomic, assign) MASLayoutPriority layoutPriority;                 //约束的优先级：Low, High等
@property (nonatomic, assign) CGFloat layoutMultiplier;                         //倍数
@property (nonatomic, assign) CGFloat layoutConstant;                           //约束的值：top = 10（布局常量）
@property (nonatomic, assign) BOOL hasLayoutRelation;                           //标记是否有布局关系
@property (nonatomic, strong) id mas_key;
@property (nonatomic, assign) BOOL useAnimator;

@end

@implementation MASViewConstraint

- (id)initWithFirstViewAttribute:(MASViewAttribute *)firstViewAttribute {
    self = [super init];
    if (!self) return nil;
    
    _firstViewAttribute = firstViewAttribute;
    self.layoutPriority = MASLayoutPriorityRequired;        //约束等级默认为“必须的”
    self.layoutMultiplier = 1;                              //倍数默认为“1”
    
    return self;
}

#pragma mark - NSCoping
/**
 *  实现拷贝协议，支持MASViewConstraint对象的拷贝
 *
 *  @param zone
 *
 *  @return 拷贝后的MASViewConstraint对象
 */
- (id)copyWithZone:(NSZone __unused *)zone {
    MASViewConstraint *constraint = [[MASViewConstraint alloc] initWithFirstViewAttribute:self.firstViewAttribute];
    constraint.layoutConstant = self.layoutConstant;
    constraint.layoutRelation = self.layoutRelation;
    constraint.layoutPriority = self.layoutPriority;
    constraint.layoutMultiplier = self.layoutMultiplier;
    constraint.delegate = self.delegate;
    return constraint;
}

#pragma mark - Public
/**
 *  获取传入View的所有被Install的约束
 *
 *  @param view 约束所安装的视图
 *
 *  @return NSArray<MASViewConstraint>
 */
+ (NSArray *)installedConstraintsForView:(MAS_VIEW *)view {
    return [view.mas_installedConstraints allObjects];
}

#pragma mark - Private

/**
 *  布局常量（layoutConstant）的Setter方法
 *
 *  @param layoutConstant 布局常量的值
 */
- (void)setLayoutConstant:(CGFloat)layoutConstant {
    _layoutConstant = layoutConstant;

#if TARGET_OS_MAC && !(TARGET_OS_IPHONE || TARGET_OS_TV)
    if (self.useAnimator) {
        [self.layoutConstraint.animator setConstant:layoutConstant];
    } else {
        self.layoutConstraint.constant = layoutConstant;
    }
#else
    //为成员变量-布局约束layoutConstraint设置constant值，该布局约束的值，类似于top.constant = 10;
    self.layoutConstraint.constant = layoutConstant;
#endif
}



/**
 *  设置布局关系
 *
 *  @param layoutRelation 
 *  布局关系值
 *      NSLayoutRelationEqual
 *      NSLayoutRelationLessThanOrEqual
 *      NSLayoutRelationGreaterThanOrEqual
 *
 */
- (void)setLayoutRelation:(NSLayoutRelation)layoutRelation {
    _layoutRelation = layoutRelation;       //设置约束关系
    self.hasLayoutRelation = YES;           //标记已设置约束关系
}

/**
 *  判断layoutConstraint是否可以使用“isActive”方法
 *
 *  @return <#return value description#>
 */
- (BOOL)supportsActiveProperty {
    return [self.layoutConstraint respondsToSelector:@selector(isActive)];
}

/**
 *  判断布局是否被激活
 *
 *  @return 激活状态
 */
- (BOOL)isActive {
    BOOL active = YES;
    if ([self supportsActiveProperty]) {
        active = [self.layoutConstraint isActive];
    }

    return active;
}


/**
 *  判断布局是否被安装
 *
 *  @return 布尔值
 */
- (BOOL)hasBeenInstalled {
    return (self.layoutConstraint != nil) && [self isActive];
}



/**
 *  成员属性secondViewAttribute的setter方法
 *
 *  @param secondViewAttribute
 */
- (void)setSecondViewAttribute:(id)secondViewAttribute {
    if ([secondViewAttribute isKindOfClass:NSValue.class]) {        //直接传过来的是Value
        [self setLayoutConstantWithValue:secondViewAttribute];
    } else if ([secondViewAttribute isKindOfClass:MAS_VIEW.class]) { //传过来的是一个UIView
        _secondViewAttribute = [[MASViewAttribute alloc] initWithView:secondViewAttribute layoutAttribute:self.firstViewAttribute.layoutAttribute];
    } else if ([secondViewAttribute isKindOfClass:MASViewAttribute.class]) {//传过来的是一个约束，如mas_top
        _secondViewAttribute = secondViewAttribute;
    } else {
        NSAssert(NO, @"attempting to add unsupported attribute: %@", secondViewAttribute);
    }
}

#pragma mark - NSLayoutConstraint multiplier proxies

- (MASConstraint * (^)(CGFloat))multipliedBy {
    return ^id(CGFloat multiplier) {
        NSAssert(!self.hasBeenInstalled,
                 @"Cannot modify constraint multiplier after it has been installed");
        
        self.layoutMultiplier = multiplier;
        return self;
    };
}


- (MASConstraint * (^)(CGFloat))dividedBy {
    return ^id(CGFloat divider) {
        NSAssert(!self.hasBeenInstalled,
                 @"Cannot modify constraint multiplier after it has been installed");

        self.layoutMultiplier = 1.0/divider;
        return self;
    };
}

#pragma mark - MASLayoutPriority proxy

- (MASConstraint * (^)(MASLayoutPriority))priority {
    return ^id(MASLayoutPriority priority) {
        NSAssert(!self.hasBeenInstalled,
                 @"Cannot modify constraint priority after it has been installed");
        
        self.layoutPriority = priority;
        return self;
    };
}

#pragma mark - NSLayoutRelation proxy

- (MASConstraint * (^)(id, NSLayoutRelation))equalToWithRelation {
    return ^id(id attribute, NSLayoutRelation relation) {
        
        if ([attribute isKindOfClass:NSArray.class]) {      //参数为数组的情况
            
            NSAssert(!self.hasLayoutRelation, @"Redefinition of constraint relation");
            
            //将不变数组转换成可变数组
            NSMutableArray *children = NSMutableArray.new;
            for (id attr in attribute) {
                MASViewConstraint *viewConstraint = [self copy];
                viewConstraint.secondViewAttribute = attr;          //将数组中的元素转换成MASViewAttribute对象
                [children addObject:viewConstraint];
            }
            
            //将数NSArray<MASViewAttribute>换成MASCompositeConstraint
            MASCompositeConstraint *compositeConstraint = [[MASCompositeConstraint alloc] initWithChildren:children];
            compositeConstraint.delegate = self.delegate;
            [self.delegate constraint:self shouldBeReplacedWithConstraint:compositeConstraint];
            return compositeConstraint;
        } else {
            NSAssert(!self.hasLayoutRelation || self.layoutRelation == relation && [attribute isKindOfClass:NSValue.class], @"Redefinition of constraint relation");
            self.layoutRelation = relation;
            self.secondViewAttribute = attribute;
            return self;
        }
    };
}

#pragma mark - Semantic properties

- (MASConstraint *)with {
    return self;
}

- (MASConstraint *)and {
    return self;
}

#pragma mark - attribute chaining

- (MASConstraint *)addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute {
    NSAssert(!self.hasLayoutRelation, @"Attributes should be chained before defining the constraint relation");

    return [self.delegate constraint:self addConstraintWithLayoutAttribute:layoutAttribute];
}

#pragma mark - Animator proxy

#if TARGET_OS_MAC && !(TARGET_OS_IPHONE || TARGET_OS_TV)

- (MASConstraint *)animator {
    self.useAnimator = YES;
    return self;
}

#endif

#pragma mark - debug helpers

- (MASConstraint * (^)(id))key {
    return ^id(id key) {
        self.mas_key = key;
        return self;
    };
}

#pragma mark - NSLayoutConstraint constant setters

- (void)setInsets:(MASEdgeInsets)insets {
    NSLayoutAttribute layoutAttribute = self.firstViewAttribute.layoutAttribute;
    switch (layoutAttribute) {
        case NSLayoutAttributeLeft:
        case NSLayoutAttributeLeading:
            self.layoutConstant = insets.left;
            break;
        case NSLayoutAttributeTop:
            self.layoutConstant = insets.top;
            break;
        case NSLayoutAttributeBottom:
            self.layoutConstant = -insets.bottom;
            break;
        case NSLayoutAttributeRight:
        case NSLayoutAttributeTrailing:
            self.layoutConstant = -insets.right;
            break;
        default:
            break;
    }
}

- (void)setOffset:(CGFloat)offset {
    self.layoutConstant = offset;
}

- (void)setSizeOffset:(CGSize)sizeOffset {
    NSLayoutAttribute layoutAttribute = self.firstViewAttribute.layoutAttribute;
    switch (layoutAttribute) {
        case NSLayoutAttributeWidth:
            self.layoutConstant = sizeOffset.width;
            break;
        case NSLayoutAttributeHeight:
            self.layoutConstant = sizeOffset.height;
            break;
        default:
            break;
    }
}

- (void)setCenterOffset:(CGPoint)centerOffset {
    NSLayoutAttribute layoutAttribute = self.firstViewAttribute.layoutAttribute;
    switch (layoutAttribute) {
        case NSLayoutAttributeCenterX:
            self.layoutConstant = centerOffset.x;
            break;
        case NSLayoutAttributeCenterY:
            self.layoutConstant = centerOffset.y;
            break;
        default:
            break;
    }
}

#pragma mark - MASConstraint

- (void)activate {
    [self install];
}

- (void)deactivate {
    [self uninstall];
}

- (void)install {
    //如果已经添加过约束，就return
    if (self.hasBeenInstalled) {
        return;
    }
    
    //如果layoutConstraint可以使用“isActive”方法，并且self.layoutConstraint不为nil
    if ([self supportsActiveProperty] && self.layoutConstraint) {
        
        //激活约束
        self.layoutConstraint.active = YES;
        
        //将已激活的约束添加到当前View的已安装约束的数组中
        [self.firstViewAttribute.view.mas_installedConstraints addObject:self];
        return;
    }
    
    MAS_VIEW *firstLayoutItem = self.firstViewAttribute.item;
    NSLayoutAttribute firstLayoutAttribute = self.firstViewAttribute.layoutAttribute;
    
    MAS_VIEW *secondLayoutItem = self.secondViewAttribute.item;
    NSLayoutAttribute secondLayoutAttribute = self.secondViewAttribute.layoutAttribute;

    // alignment attributes must have a secondViewAttribute
    // therefore we assume that is refering to superview
    // eg make.left.equalTo(@10)
    if (!self.firstViewAttribute.isSizeAttribute && !self.secondViewAttribute) {
        secondLayoutItem = self.firstViewAttribute.view.superview;
        secondLayoutAttribute = firstLayoutAttribute;
    }
    
    
#pragma -- Mark 使用NSLayoutConstraint添加约束
    
    //创建约束
    MASLayoutConstraint *layoutConstraint
        = [MASLayoutConstraint constraintWithItem:firstLayoutItem
                                        attribute:firstLayoutAttribute
                                        relatedBy:self.layoutRelation
                                           toItem:secondLayoutItem
                                        attribute:secondLayoutAttribute
                                       multiplier:self.layoutMultiplier
                                         constant:self.layoutConstant];
    
    layoutConstraint.priority = self.layoutPriority;
    layoutConstraint.mas_key = self.mas_key;
    
    //寻找约束添加的View
    if (self.secondViewAttribute.view) {
        
        //寻找两个视图的公共父视图
        MAS_VIEW *closestCommonSuperview = [self.firstViewAttribute.view mas_closestCommonSuperview:self.secondViewAttribute.view];
        
        NSAssert(closestCommonSuperview,@"couldn't find a common superview for %@ and %@",self.firstViewAttribute.view, self.secondViewAttribute.view);
        self.installedView = closestCommonSuperview;
    } else if (self.firstViewAttribute.isSizeAttribute) {
        self.installedView = self.firstViewAttribute.view;
    } else {
        self.installedView = self.firstViewAttribute.view.superview;
    }


    MASLayoutConstraint *existingConstraint = nil;
    if (self.updateExisting) {
        existingConstraint = [self layoutConstraintSimilarTo:layoutConstraint];
    }
    
    if (existingConstraint) {
        // just update the constant
        //更新约束
        existingConstraint.constant = layoutConstraint.constant;
        self.layoutConstraint = existingConstraint;
    } else {
        //添加约束
        [self.installedView addConstraint:layoutConstraint];
        self.layoutConstraint = layoutConstraint;
        
        [firstLayoutItem.mas_installedConstraints addObject:self];      //约束所在的View增加被添加的约束
    }
}

- (MASLayoutConstraint *)layoutConstraintSimilarTo:(MASLayoutConstraint *)layoutConstraint {
    // check if any constraints are the same apart from the only mutable property constant

    // go through constraints in reverse as we do not want to match auto-resizing or interface builder constraints
    // and they are likely to be added first.
    for (NSLayoutConstraint *existingConstraint in self.installedView.constraints.reverseObjectEnumerator) {
        if (![existingConstraint isKindOfClass:MASLayoutConstraint.class]) continue;
        if (existingConstraint.firstItem != layoutConstraint.firstItem) continue;
        if (existingConstraint.secondItem != layoutConstraint.secondItem) continue;
        if (existingConstraint.firstAttribute != layoutConstraint.firstAttribute) continue;
        if (existingConstraint.secondAttribute != layoutConstraint.secondAttribute) continue;
        if (existingConstraint.relation != layoutConstraint.relation) continue;
        if (existingConstraint.multiplier != layoutConstraint.multiplier) continue;
        if (existingConstraint.priority != layoutConstraint.priority) continue;

        return (id)existingConstraint;
    }
    return nil;
}

- (void)uninstall {
    if ([self supportsActiveProperty]) {
        self.layoutConstraint.active = NO;
        [self.firstViewAttribute.view.mas_installedConstraints removeObject:self];
        return;
    }
    
    [self.installedView removeConstraint:self.layoutConstraint];
    self.layoutConstraint = nil;
    self.installedView = nil;
    
    [self.firstViewAttribute.view.mas_installedConstraints removeObject:self];
}

@end
