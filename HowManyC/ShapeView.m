//
//  ShapeView.m
//  HowManyC
//
//  Created by Max on 04/07/15.
//  Copyright (c) 2015 Max. All rights reserved.
//

#import "ShapeView.h"

@interface ShapeView()

@property CGMutablePathRef path;
@property CGMutablePathRef pathMargin;
@property NSString *type;
@property CGRect frame1;

@end

@implementation ShapeView
@synthesize path;
@synthesize pathMargin;
@synthesize type;

- (instancetype) initWithFrame:(CGRect)frame withType:(NSString*)stype {
    CGRect frame2 = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width * 2.0, frame.size.height * 2.0);
    self.frame1 = frame;
    self = [super initWithFrame:frame2];

    if (self) {
        

        
        // to make clear color transparent!
        self.opaque = NO;
        
        self.alpha = 1.0;
        
        if (!stype) {
            type = @"circle";
        } else {
            type = stype;
        }
        
        
        pathMargin = CGPathCreateMutable();

        CGPathAddArc(self.pathMargin, nil, frame2.size.width / 2.0, frame2.size.height / 2.0, frame2.size.width / 2.0, 0.0, M_PI * 2.0, YES);

        CGPathCloseSubpath(pathMargin);
        
        
        path = CGPathCreateMutable();
        CGFloat centerX  = frame2.size.width / 2;
        CGFloat centerY = frame2.size.height / 2;
        
        
        CGFloat radius = frame.size.height / 2.0;
        
        CGFloat boxSideHalf = radius / sqrt(2.0);
        
        CGFloat side = radius * sqrt(3.0);
        CGFloat height = (sqrt(3.0) / 2.0) * side; // triangle height
        CGFloat sideHalf = side / 2.0;
        
        if ([@"box" isEqualToString:type] ) {
            CGPathMoveToPoint(path, nil, centerX - boxSideHalf, centerY - boxSideHalf);
            CGPathAddLineToPoint(path, nil, centerX + boxSideHalf, centerY - boxSideHalf);
            CGPathAddLineToPoint(path, nil, centerX + boxSideHalf, centerY + boxSideHalf);
            CGPathAddLineToPoint(path, nil, centerX - boxSideHalf, centerY + boxSideHalf);
            
            
        } else if ([@"triangle" isEqualToString: type]) {
            
            CGPathMoveToPoint(path, nil, centerX, centerY - radius);
            CGPathAddLineToPoint(path, nil, centerX + sideHalf, (centerY - radius) +  height);
            CGPathAddLineToPoint(path, nil, centerX - sideHalf, (centerY - radius) + height);
            
            
        } else {
            
            CGPathAddArc(path, nil, frame2.size.width / 2.0, frame2.size.height / 2.0, frame.size.width / 2.0, 0.0, M_PI * 2.0, YES);
        }
        
        CGPathCloseSubpath(path);

        
    }
    
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

    UIColor *color;
    NSInteger rnd = arc4random() % 5;
    
    if (0 == rnd) {
        color = [UIColor colorWithRed: 102.0 / 255.0 green: 102.0 / 255 blue: 255.0 / 255.0 alpha: 1];
    } else if (1 == rnd) {
        color = [UIColor colorWithRed: 255.0 / 255 green: 128.0 / 255 blue: 0 / 255 alpha: 0.9];
    } else if (2 == rnd) {
        color = [UIColor colorWithRed: 0 / 255 green: 128.0 / 255 blue: 128.0 / 255 alpha: 0.9];
    } else if (3 == rnd) {
        color = [UIColor colorWithRed: 0 / 255 green: 64.0 / 255 blue: 128.0 / 255 alpha: 1.0];
    } else {
        color = [UIColor colorWithRed: 255.0 / 255 green: 0 / 255 blue: 0 / 255 alpha: 0.7]; // red
    }

    CGContextRef context  = UIGraphicsGetCurrentContext();
    
    
    CGContextBeginPath(context);
    
    
    CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);
    //        CGContextAddPath(context, pathMargin)
    //        CGContextFillPath(context)
    
    //        var tr = CGPathCreateMutable()
    //        CGPathAddArc(tr, nil, frame.width / 2.0, frame.height / 2.0, frame.width / 4.0, 0.0, CGFloat(M_PI) * 2.0, true)
    //        CGPathCloseSubpath(tr)
    //        CGContextAddPath(context, tr)
    //        CGContextFillPath(context)
    
    
    CGContextBeginPath(context);
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextAddPath(context, path);
    CGContextFillPath(context);
    
    
    
    
    CGContextSaveGState(context);
    
    self.layer.shouldRasterize = true;
    self.layer.rasterizationScale =  [UIScreen mainScreen].scale;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (CGPathContainsPoint(pathMargin, nil, point, true)) {
        return self;
    } else {
        return nil;
    }
}

- (void) addShadow {
    // add shadow
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.layer.shadowOpacity = 0.6;

//    self.layer.shadowPath = [[UIBezierPath bezierPathWithRect:b] CGPath];
}


@end
