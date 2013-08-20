//
//  MVYSideMenuOptions.h
//  MVYSideMenuExample
//
//  Created by Álvaro Murillo del Puerto on 10/07/13.
//  Copyright (c) 2013 Mobivery. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MVYSideMenuOptions : NSObject <NSCopying>

@property (nonatomic, assign) CGFloat menuViewOverlapWidth;
@property (nonatomic, assign) CGFloat bezelWidth;
@property (nonatomic, assign) CGFloat contentViewScale;
@property (nonatomic, assign) CGFloat contentViewOpacity;
@property (nonatomic, assign) CGFloat shadowOpacity;
@property (nonatomic, assign) CGFloat shadowRadius;
@property (nonatomic, assign) CGSize shadowOffset;
@property (nonatomic, assign) BOOL panFromBezel;
@property (nonatomic, assign) BOOL panFromNavBar;
@property (nonatomic, assign) CGFloat animationDuration;

@end
