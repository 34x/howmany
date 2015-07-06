//
//  ShapeView.h
//  HowManyC
//
//  Created by Max on 04/07/15.
//  Copyright (c) 2015 Max. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShapeView : UIView
- (instancetype) initWithFrame:(CGRect)frame withType:(NSString*)stype;
- (void) addShadow;
@end
