//
//  MASAttribute.h
//  Masonry
//
//  Created by Jonas Budelmann on 21/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "MASUtilities.h"

/**
 *  An immutable tuple which stores the view and the related NSLayoutAttribute.
 *  Describes part of either the left or right hand side of a constraint equation
 */
@interface MASViewAttribute : NSObject

/**
 *  The view which the reciever relates to. Can be nil if item is not a view.
 *  
 *  所要约束的View
 */
@property (nonatomic, weak, readonly) MAS_VIEW *view;

/**
 *  The item which the reciever relates to.
 *
 *  可约束的对象（UIView就是其本身，而UIViewController就是 
 *  self.topLayoutGuide 和 self.bottomLayoutGuide
 *  item是为UIViewController准备的。
 */
@property (nonatomic, weak, readonly) id item;

/**
 *  The attribute which the reciever relates to
 *  
 *  View所接触的布局属性（NSLayoutAttributeLeft，NSLayoutAttributeTop等）
 */
@property (nonatomic, assign, readonly) NSLayoutAttribute layoutAttribute;

/**
 *  Convenience initializer.
 *
 *  UIView一般调用下方的方法，因为UIView的 view == item
 *  也就是当前View就是接受布局关系的对象
 */
- (id)initWithView:(MAS_VIEW *)view layoutAttribute:(NSLayoutAttribute)layoutAttribute;

/**
 *  The designated initializer.
 *
 *  下方的方法一般是UIViewController调用的方法，在UIViewController中接受约束的是self.topLayoutGuide
 *  和self.BottomLayoutGuide， 此时View != item
 */
- (id)initWithView:(MAS_VIEW *)view item:(id)item layoutAttribute:(NSLayoutAttribute)layoutAttribute;

/**
 *	Determine whether the layoutAttribute is a size attribute
 *
 *	@return	YES if layoutAttribute is equal to NSLayoutAttributeWidth or NSLayoutAttributeHeight
 *
 *  判断是否为NSLayoutAttributeWidth和NSLayoutAttributeHeight类型的约束
 *  如果是的话就不需要其他参考的View, 将上述两种类型的约束直接添加到本View上即可
 */
- (BOOL)isSizeAttribute;

@end
