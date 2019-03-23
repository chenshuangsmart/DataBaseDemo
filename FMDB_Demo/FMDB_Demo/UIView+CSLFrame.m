//
//  UIView+CSLFrame.m
//  BaseDemo
//
//  Created by cs on 2019/3/17.
//  Copyright © 2019年 ww. All rights reserved.
//

#import "UIView+CSLFrame.h"
#import <objc/runtime.h>

#define SCREEN_SCALE                    ([[UIScreen mainScreen] scale])
#define PIXEL_INTEGRAL(pointValue)      (round(pointValue * SCREEN_SCALE) / SCREEN_SCALE)

static void *BangLastSubviewBottom = (void *)@"BangLastSubviewBottom";

@implementation UIView (CSLFrame)

@dynamic x, y, width, height, origin, size;
@dynamic boundsWidth, boundsHeight, boundsX, boundsY;

// Setters
-(void)setX:(CGFloat)x{
    self.frame      = CGRectMake(PIXEL_INTEGRAL(x), self.y, self.width, self.height);
}

-(void)setY:(CGFloat)y{
    self.frame      = CGRectMake(self.x, PIXEL_INTEGRAL(y), self.width, self.height);
}

-(void)setWidth:(CGFloat)width{
    self.frame      = CGRectMake(self.x, self.y, PIXEL_INTEGRAL(width), self.height);
}

-(void)setHeight:(CGFloat)height{
    self.frame      = CGRectMake(self.x, self.y, self.width, PIXEL_INTEGRAL(height));
}

-(void)setOrigin:(CGPoint)origin{
    self.x          = origin.x;
    self.y          = origin.y;
}

-(void)setSize:(CGSize)size{
    self.width      = size.width;
    self.height     = size.height;
}

-(void)setRight:(CGFloat)right {
    self.x          = right - self.width;
}

-(void)setBottom:(CGFloat)bottom {
    self.y          = bottom - self.height;
}

-(void)setLeft:(CGFloat)left{
    self.x          = left;
}

-(void)setTop:(CGFloat)top{
    self.y          = top;
}

-(void)setCenterX:(CGFloat)centerX {
    self.center     = CGPointMake(PIXEL_INTEGRAL(centerX), self.center.y);
}

-(void)setCenterY:(CGFloat)centerY {
    self.center     = CGPointMake(self.center.x, PIXEL_INTEGRAL(centerY));
}

-(void)setBoundsX:(CGFloat)boundsX{
    self.bounds     = CGRectMake(PIXEL_INTEGRAL(boundsX), self.boundsY, self.boundsWidth, self.boundsHeight);
}

-(void)setBoundsY:(CGFloat)boundsY{
    self.bounds     = CGRectMake(self.boundsX, PIXEL_INTEGRAL(boundsY), self.boundsWidth, self.boundsHeight);
}

-(void)setBoundsWidth:(CGFloat)boundsWidth{
    self.bounds     = CGRectMake(self.boundsX, self.boundsY, PIXEL_INTEGRAL(boundsWidth), self.boundsHeight);
}

-(void)setBoundsHeight:(CGFloat)boundsHeight{
    self.bounds     = CGRectMake(self.boundsX, self.boundsY, self.boundsWidth, PIXEL_INTEGRAL(boundsHeight));
}

// Getters
-(CGFloat)x{
    return self.frame.origin.x;
}

-(CGFloat)y{
    return self.frame.origin.y;
}

-(CGFloat)width{
    return self.frame.size.width;
}

-(CGFloat)height{
    return self.frame.size.height;
}

-(CGPoint)origin{
    return CGPointMake(self.x, self.y);
}

-(CGSize)size{
    return CGSizeMake(self.width, self.height);
}

-(CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

-(CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

-(CGFloat)left{
    return self.x;
}

-(CGFloat)top{
    return self.y;
}

-(CGFloat)centerX {
    return self.center.x;
}

-(CGFloat)centerY {
    return self.center.y;
}

-(UIView *)lastSubviewOnX{
    if(self.subviews.count > 0){
        UIView *outView = self.subviews[0];
        
        for(UIView *v in self.subviews)
            if(v.x > outView.x)
                outView = v;
        
        return outView;
    }
    
    return nil;
}

-(UIView *)lastSubviewOnY{
    if(self.subviews.count > 0){
        UIView *outView = self.subviews[0];
        
        for(UIView *v in self.subviews)
            if(v.y > outView.y)
                outView = v;
        
        return outView;
    }
    
    return nil;
}

-(CGFloat)boundsX{
    return self.bounds.origin.x;
}

-(CGFloat)boundsY{
    return self.bounds.origin.y;
}

-(CGFloat)boundsWidth{
    return self.bounds.size.width;
}

-(CGFloat)boundsHeight{
    return self.bounds.size.height;
}

- (CGFloat)lastSubviewBottom {
    objc_getAssociatedObject(self, BangLastSubviewBottom);
    UIView *last = [[self subviews] lastObject];
    if (!last) return 0;
    return last.bottom;
}

-(void)setCenterToLeftPad:(CGFloat)centerToLeftPad{
    self.x = [UIScreen mainScreen].bounds.size.width/2.0 + centerToLeftPad;
    
}

-(void)setCenterToRightPad:(CGFloat)centerToRightPad{
    self.x = [UIScreen mainScreen].bounds.size.width/2.0 - self.width - centerToRightPad;
}


// Methods
-(void)centerToParent{
    if(self.superview){
        switch ([UIApplication sharedApplication].statusBarOrientation){
            case UIInterfaceOrientationLandscapeLeft:
            case UIInterfaceOrientationLandscapeRight:{
                self.origin     = CGPointMake((self.superview.height / 2.0) - (self.width / 2.0),
                                              (self.superview.width / 2.0) - (self.height / 2.0));
                break;
            }
            case UIInterfaceOrientationPortrait:
            case UIInterfaceOrientationPortraitUpsideDown:{
                self.origin     = CGPointMake((self.superview.width / 2.0) - (self.width / 2.0),
                                              (self.superview.height / 2.0) - (self.height / 2.0));
                break;
            }
            case UIInterfaceOrientationUnknown:
                return;
        }
    }
}

///与父view右对齐
-(void)alignmentRightToSuperview{
    //    self.x = self.superview.width - self.width;
    [self alignmentRightToSuperview:0];
}

///与父view左对齐
-(void)alignmentLeftToSuperview{
    self.x = 0;
}

///距父view右边
-(void)alignmentRightToSuperview:(CGFloat)rightPad{
    self.x = self.superview.width - self.width - rightPad;
}

///与父view下对齐
-(void)alignmentBottomToSuperview{
    [self alignmentBottomToSuperview:0];
}

///距父view下边
-(void)alignmentBottomToSuperview:(CGFloat)bottomPad{
    self.y = self.superview.height - self.height - bottomPad;
}

///把view的size设置成本来内容大小
-(void)setSizeToIntrinsicContentSize{
    [self setSize:[self intrinsicContentSize]];
}


///取最右点坐标
-(CGFloat)getMaxX{
    return CGRectGetMaxX(self.frame);
}

///取最下点坐标
-(CGFloat)getMaxY{
    return CGRectGetMaxY(self.frame);
}

///获取子view的最高Y
-(CGFloat)getMaxYOfSubview{
    float h = 0;
    for (UIView *v in [self subviews]) {
        float fh = [v getMaxY];
        h = MAX(fh, h);
    }
    return h;
}

///获取子view的最高X
-(CGFloat)getMaxXOfSubview{
    float w = 0;
    for (UIView *v in [self subviews]) {
        float fw = [v getMaxX];
        w = MAX(fw, w);
    }
    return w;
}

///Y轴上在superview居中
-(void)centerYToSuperview{
    self.centerY = self.superview.height/2.0;
}

///X轴上在superview居中
-(void)centerXToSuperview{
    self.centerX = self.superview.width/2.0;
}

@end
