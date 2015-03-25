//
//  MVYSideMenuOptions.h
//  MVYSideMenuExample
//
//  Created by Álvaro Murillo del Puerto on 10/07/13.
//  Copyright (c) 2013 Mobivery. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MVYSideMenuOptions : NSObject <NSCopying>

@property (nonatomic, assign) CGFloat menuViewOverlapWidth __attribute__((deprecated("Use menuFrame attribute in MVYSideMenuController instead")));

/** Pan gesture bezel width in pixel when menu is closed. Default 20.0 */
@property (nonatomic, assign) CGFloat bezelWidth;

/** Content view scale factor when menu is opened. 0.0 max scale, 1.0 disable scale. Default 0.96 */
@property (nonatomic, assign) CGFloat contentViewScale;

/** Content view opacity when menu is opened. 1.0 opaque 0.0 clear. Default 0.4 */
@property (nonatomic, assign) CGFloat contentViewOpacity;

/** Shadow opacity for menu view when is opened. 1.0 opaque 0.0 clear. Default 0.5 */
@property (nonatomic, assign) CGFloat shadowOpacity;

/** Shadow radio in pixel for menu view when is opened. 1.0 opaque 0.0 clear. Default 3. */
@property (nonatomic, assign) CGFloat shadowRadius;

/** Shadow offset size. Default CGSizeMake(8,0) */
@property (nonatomic, assign) CGSize shadowOffset;

/** Enable pan gesture from bezel. Default YES. */
@property (nonatomic, assign) BOOL panFromBezel;

/** Enable pan gesture from navigation bar. Default YES. */
@property (nonatomic, assign) BOOL panFromNavBar;

/** Open/close animation duration in seconds. Default 0.4 */
@property (nonatomic, assign) CGFloat animationDuration;

/** Blur background radius. Default 10px set to 0 to deactivate */
@property (nonatomic, assign) CGFloat blurRadius;
@end
