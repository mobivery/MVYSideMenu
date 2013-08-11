//
//  MVYSideMenuOptions.m
//  MVYSideMenuExample
//
//  Created by Álvaro Murillo del Puerto on 10/07/13.
//  Copyright (c) 2013 Mobivery. All rights reserved.
//

#import "MVYSideMenuOptions.h"

@implementation MVYSideMenuOptions

- (id)init {
    if (self = [super init]) {
        self.menuViewOverlapWidth = 60.0f;
		self.bezelWidth = 20.0f;
		self.contentViewOpacity = 0.4f;
		self.contentViewScale = 0.96f;
		self.panFromBezel = YES;
		self.panFromNavBar = YES;
        _animationDuration = CGFLOAT_MAX;
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
	
    MVYSideMenuOptions *options = [[MVYSideMenuOptions alloc] init];
    options.menuViewOverlapWidth = self.menuViewOverlapWidth;
	options.bezelWidth = self.bezelWidth;
	options.contentViewOpacity = self.contentViewOpacity;
	options.contentViewScale = self.contentViewScale;
    options.panFromBezel = self.panFromBezel;
	options.panFromNavBar = self.panFromNavBar;
    options.animationDuration = self.animationDuration;
	
    return options;
}


@end
