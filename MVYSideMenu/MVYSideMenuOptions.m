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
        _menuViewOverlapWidth = 60.0f;
		_bezelWidth = 20.0f;
		_contentViewOpacity = 0.4f;
		_contentViewScale = 0.96f;
		_panFromBezel = YES;
		_panFromNavBar = YES;
        _animationDuration = 0.4f;
        _shadowOffset = CGSizeMake(8,0);
        _shadowOpacity = 0.5;
        _shadowRadius = 3;
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
	options.shadowOffset = self.shadowOffset;
    options.shadowOpacity = self.shadowOpacity;
    options.shadowRadius = self.shadowRadius;
    return options;
}


@end
