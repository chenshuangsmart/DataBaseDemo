//
//  UIView+CSLFrame.h
//  BaseDemo
//
//  Created by cs on 2019/3/17.
//  Copyright © 2019年 ww. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CSLFrame)

/** View's X Position */
@property (nonatomic, assign) CGFloat   x;

/** View's Y Position */
@property (nonatomic, assign) CGFloat   y;

/** View's width */
@property (nonatomic, assign) CGFloat   width;

/** View's height */
@property (nonatomic, assign) CGFloat   height;

/** View's origin - Sets X and Y Positions */
@property (nonatomic, assign) CGPoint   origin;

/** View's size - Sets Width and Height */
@property (nonatomic, assign) CGSize    size;

/** Y value representing the bottom of the view **/
@property (nonatomic, assign) CGFloat   bottom;

/** X Value representing the right side of the view **/
@property (nonatomic, assign) CGFloat   right;

/** X Value representing the top of the view (alias of x) **/
@property (nonatomic, assign) CGFloat   left;

/** Y Value representing the top of the view (alias of y) **/
@property (nonatomic, assign) CGFloat   top;

/** X value of the object's center **/
@property (nonatomic, assign) CGFloat   centerX;

/** Y value of the object's center **/
@property (nonatomic, assign) CGFloat   centerY;

/** Returns the Subview with the heighest X value **/
@property (nonatomic, strong, readonly) UIView *lastSubviewOnX;

/** Returns the Subview with the heighest Y value **/
@property (nonatomic, strong, readonly) UIView *lastSubviewOnY;

/** View's bounds X value **/
@property (nonatomic, assign) CGFloat   boundsX;

/** View's bounds Y value **/
@property (nonatomic, assign) CGFloat   boundsY;

/** View's bounds width **/
@property (nonatomic, assign) CGFloat   boundsWidth;

/** View's bounds height **/
@property (nonatomic, assign) CGFloat   boundsHeight;

@property (nonatomic) CGFloat lastSubviewBottom;

/**
 Centers the view to its parent view (if exists)
 */
-(void) centerToParent;

-(void)setCenterToLeftPad:(CGFloat)centerToLeftPad;

-(void)setCenterToRightPad:(CGFloat)centerToRightPad;

///与父view右对齐
-(void)alignmentRightToSuperview;

///与父view左对齐
-(void)alignmentLeftToSuperview;

///距父view右边
-(void)alignmentRightToSuperview:(CGFloat)rightPad;

///与父view下对齐
-(void)alignmentBottomToSuperview;

///距父view下边
-(void)alignmentBottomToSuperview:(CGFloat)bottomPad;

///把view的size设置成本来内容大小
-(void)setSizeToIntrinsicContentSize;

///取最右点坐标
-(CGFloat)getMaxX;

///取最下点坐标
-(CGFloat)getMaxY;

///获取子view的最高Y
-(CGFloat)getMaxYOfSubview;

///获取子view的最高X
-(CGFloat)getMaxXOfSubview;

///Y轴上在superview居中
-(void)centerYToSuperview;

///X轴上在superview居中
-(void)centerXToSuperview;

@end
