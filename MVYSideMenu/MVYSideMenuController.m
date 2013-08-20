//
//  MVYSideMenuController.m
//  MVYSideMenuExample
//
//  Created by Álvaro Murillo del Puerto on 10/07/13.
//  Copyright (c) 2013 Mobivery. All rights reserved.
//

#import "MVYSideMenuController.h"
#import <QuartzCore/QuartzCore.h>


typedef NS_ENUM(NSInteger, MVYSideMenuAction){
	MVYSideMenuOpen,
	MVYSideMenuClose
};

typedef struct {
	MVYSideMenuAction menuAction;
	BOOL shouldBounce;
	CGFloat velocity;
} MVYSideMenuPanResultInfo;

@interface MVYSideMenuController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIViewController *menuViewController;
@property (nonatomic, strong) UIViewController *contentViewController;
@property (strong, nonatomic) UIView *contentContainerView;
@property (strong, nonatomic) UIView *menuContainerView;
@property (strong, nonatomic) UIView *opacityView;
@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;
@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;

@end

@implementation MVYSideMenuController

- (id)initWithCoder:(NSCoder *)aDecoder {
	
	self = [super initWithCoder:aDecoder];
	if (self) {
		_options = [[MVYSideMenuOptions alloc] init];
	}
	
	return self;
}

- (id)initWithMenuViewController:(UIViewController *)menuViewController
		   contentViewController:(UIViewController *)contentViewController {
	
	return [self initWithMenuViewController:menuViewController
					  contentViewController:contentViewController
									options:[[MVYSideMenuOptions alloc] init]];
}

- (id)initWithMenuViewController:(UIViewController *)menuViewController
		   contentViewController:(UIViewController *)contentViewController
						 options:(MVYSideMenuOptions *)options {
	
	self = [super init];
	if(self){
		_options = options;
		_menuViewController = menuViewController;
		_contentViewController = contentViewController;
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	[self setUpMenuViewController:_menuViewController];
	[self setUpContentViewController:_contentViewController];
	
	[self addGestures];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setMenuViewController:(UIViewController *)menuViewController {
	
	[self removeViewController:_menuViewController];
	
	_menuViewController = menuViewController;
	
	[self setUpMenuViewController:_menuViewController];
	
}

- (void)setContentViewController:(UIViewController *)contentViewController {
	
	[self removeViewController:_contentViewController];
	
	_contentViewController = contentViewController;
	
	[self setUpContentViewController:_contentViewController];
	
}

- (void)closeMenu {
	
	[self closeMenuWithVelocity:0.0f];
}

- (void)openMenu {
	
	[self openMenuWithVelocity:0.0f];
}

- (void)disable {
	self.panGesture.enabled = NO;
}

- (void)enable {
	self.panGesture.enabled = YES;
}

- (void)changeContentViewController:(UIViewController *)contentViewController closeMenu:(BOOL)closeMenu {
	
	self.contentViewController = contentViewController;
	closeMenu ? [self closeMenu] : nil;
}

- (void)changeMenuViewController:(UIViewController *)menuViewController closeMenu:(BOOL)closeMenu {
	self.menuViewController = menuViewController;
	closeMenu ? [self closeMenu] : nil;
}

#pragma mark – Private methods

- (void)removeViewController:(UIViewController *)menuViewController {
	
	if (menuViewController) {
		[menuViewController willMoveToParentViewController:nil];
		[menuViewController.view removeFromSuperview];
		[menuViewController removeFromParentViewController];
	}
}

- (void)setUpMenuViewController:(UIViewController *)menuViewController {
	
	if (menuViewController) {
		[self addChildViewController:menuViewController];
		menuViewController.view.frame = self.menuContainerView.bounds;
		[self.menuContainerView addSubview:menuViewController.view];
		[menuViewController didMoveToParentViewController:self];
	}
}

- (void)setUpContentViewController:(UIViewController *)contentViewController {
	
	if (contentViewController) {
		[self addChildViewController:contentViewController];
		contentViewController.view.frame = self.contentContainerView.bounds;
		[self.contentContainerView addSubview:contentViewController.view];
		[contentViewController didMoveToParentViewController:self];
	}
	
}

- (UIView *)opacityView {

	if (!_opacityView) {
		_opacityView = [[UIView alloc] initWithFrame:self.view.bounds];
        _opacityView.backgroundColor = [UIColor blackColor];
        _opacityView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		_opacityView.layer.opacity = 0.0;
        
        [self.view insertSubview:_opacityView atIndex:1];
	}
	
	return _opacityView;
}

- (UIView *)contentContainerView {
    if (!_contentContainerView) {
        _contentContainerView = [[UIView alloc] initWithFrame:self.view.bounds];
        _contentContainerView.backgroundColor = [UIColor clearColor];
        _contentContainerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        [self.view insertSubview:_contentContainerView atIndex:0];
    }
    
    return _contentContainerView;
}

- (UIView *)menuContainerView {
    if (!_menuContainerView) {
		CGRect frame = self.view.bounds;
		frame.size.width = frame.size.width - self.options.menuViewOverlapWidth;
		frame.origin.x = [self menuMinOrigin];
        _menuContainerView = [[UIView alloc] initWithFrame:frame];
        _menuContainerView.backgroundColor = [UIColor clearColor];
        _menuContainerView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
        [self.view insertSubview:_menuContainerView atIndex:2];
    }
    
    return _menuContainerView;
}

- (void)addGestures {
	
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
		[_panGesture setDelegate:self];
        [self.view addGestureRecognizer:_panGesture];
    }
	
	if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleMenu)];
        [_tapGesture setDelegate:self];
		[self.view addGestureRecognizer:_tapGesture];
    }
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture {
	
	static CGRect menuFrameAtStartOfPan;
	static CGPoint startPointOfPan;
	static BOOL menuWasOpenAtStartOfPan;
	static BOOL menuWasHiddenAtStartOfPan;
	
	switch (panGesture.state) {
		case UIGestureRecognizerStateBegan:
			menuFrameAtStartOfPan = self.menuContainerView.frame;
			startPointOfPan = [panGesture locationInView:self.view];
			menuWasOpenAtStartOfPan = [self isMenuOpen];
			menuWasHiddenAtStartOfPan = [self isMenuHidden];
			[self.menuViewController beginAppearanceTransition:menuWasHiddenAtStartOfPan animated:YES];
			[self addShadowToMenuView];
			break;
			
		case UIGestureRecognizerStateChanged:{
			CGPoint translation = [panGesture translationInView:panGesture.view];
			self.menuContainerView.frame = [self applyTranslation:translation toFrame:menuFrameAtStartOfPan];
			[self applyOpacity];
			[self applyContentViewScale];
			break;
		}
			
		case UIGestureRecognizerStateEnded:{
			[self.menuViewController beginAppearanceTransition:!menuWasHiddenAtStartOfPan animated:YES];
			
			CGPoint velocity = [panGesture velocityInView:panGesture.view];
			MVYSideMenuPanResultInfo panInfo = [self panResultInfoForVelocity:velocity];
			
			if (panInfo.menuAction == MVYSideMenuOpen) {
				[self openMenuWithVelocity:panInfo.velocity];
			} else {
				[self closeMenuWithVelocity:panInfo.velocity];
			}
			break;
		}
			
		default:
			break;
	}
}

- (MVYSideMenuPanResultInfo)panResultInfoForVelocity:(CGPoint)velocity {
	
	static CGFloat thresholdVelocity = 450.0f;
	CGFloat pointOfNoReturn = floorf([self menuMinOrigin] / 2.0f);
	CGFloat menuOrigin = self.menuContainerView.frame.origin.x;
	
	MVYSideMenuPanResultInfo panInfo = {MVYSideMenuClose, NO, 0.0f};
	
	panInfo.menuAction = menuOrigin <= pointOfNoReturn ? MVYSideMenuClose : MVYSideMenuOpen;
	
	if (velocity.x >= thresholdVelocity) {
		panInfo.menuAction = MVYSideMenuOpen;
		panInfo.velocity = velocity.x;
	} else if (velocity.x <= (-1.0f * thresholdVelocity)) {
		panInfo.menuAction = MVYSideMenuClose;
		panInfo.velocity = velocity.x;
	}
	
	return panInfo;
}

- (void)toggleMenu {
	
	[self isMenuOpen] ? [self closeMenu] : [self openMenu];
}

- (BOOL)isMenuOpen {
	return self.menuContainerView.frame.origin.x == 0.0f;
}

- (BOOL)isMenuHidden {
	return self.menuContainerView.frame.origin.x <= [self menuMinOrigin];
}

- (CGFloat)menuMinOrigin {
	return -(self.view.bounds.size.width - self.options.menuViewOverlapWidth);
}

- (CGRect)applyTranslation:(CGPoint)translation toFrame:(CGRect)frame {
	
	CGFloat newOrigin = frame.origin.x;
    newOrigin += translation.x;
	
    CGFloat minOrigin = [self menuMinOrigin];
    CGFloat maxOrigin = 0.0f;
    CGRect newFrame = frame;
    
    if (newOrigin < minOrigin) {
		newOrigin = minOrigin;
    } else if (newOrigin > maxOrigin) {
		newOrigin = maxOrigin;
    }
	
    newFrame.origin.x = newOrigin;
    return newFrame;
}

- (CGFloat)getOpenedMenuRatio {
	
	CGFloat width = self.view.bounds.size.width - self.options.menuViewOverlapWidth;
	CGFloat currentPosition = self.menuContainerView.frame.origin.x - [self menuMinOrigin];
	return currentPosition / width;
}

- (void)applyOpacity {
	
	CGFloat openedMenuRatio = [self getOpenedMenuRatio];
	CGFloat opacity = self.options.contentViewOpacity * openedMenuRatio;
	self.opacityView.layer.opacity = opacity;
}

- (void)applyContentViewScale {

	CGFloat openedMenuRatio = [self getOpenedMenuRatio];	
	CGFloat scale = 1.0 - ((1.0 - self.options.contentViewScale) * openedMenuRatio);
	
	[self.contentContainerView setTransform:CGAffineTransformMakeScale(scale, scale)];
}

- (void)openMenuWithVelocity:(CGFloat)velocity {
	
	CGFloat menuXOrigin = self.menuContainerView.frame.origin.x;
	CGFloat finalXOrigin = 0.0f;
	
	CGRect frame = self.menuContainerView.frame;
	frame.origin.x = finalXOrigin;
	
	NSTimeInterval duration;
	if (velocity == 0.0f) {
        duration = self.options.animationDuration;        
	} else {
		duration = fabs(menuXOrigin - finalXOrigin) / velocity;
		duration = fmax(0.1, fmin(1.0f, duration));
	}
	
	[self addShadowToMenuView];
	
	[UIView animateWithDuration:duration delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
		self.menuContainerView.frame = frame;
		self.opacityView.layer.opacity = self.options.contentViewOpacity;
		[self.contentContainerView setTransform:CGAffineTransformMakeScale(self.options.contentViewScale, self.options.contentViewScale)];
	} completion:^(BOOL finished) {
		[self disableContentInteraction];
	}];
}

- (void)closeMenuWithVelocity:(CGFloat)velocity {
	
	CGFloat menuXOrigin = self.menuContainerView.frame.origin.x;
	CGFloat finalXOrigin = [self menuMinOrigin];
	
	CGRect frame = self.menuContainerView.frame;
	frame.origin.x = finalXOrigin;
	
	NSTimeInterval duration;
	if (velocity == 0.0f) {
        duration = self.options.animationDuration;        
	} else {
		duration = fabs(menuXOrigin - finalXOrigin) / velocity;
		duration = fmax(0.1, fmin(1.0f, duration));
	}
	
	[UIView animateWithDuration:duration delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
		self.menuContainerView.frame = frame;
		self.opacityView.layer.opacity = 0.0f;
		[self.contentContainerView setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
	} completion:^(BOOL finished) {
		[self removeMenuShadow];
		[self enableContentInteraction];
	}];
}

- (BOOL)slideMenuForGestureRecognizer:(UIGestureRecognizer *)gesture withTouchPoint:(CGPoint)point {
	
	BOOL slide = [self isMenuOpen];
	
	slide |= self.options.panFromBezel && [self isPointContainedWithinBezelRect:point];
	
	slide |= self.options.panFromNavBar && [self isPointContainedWithinNavigationRect:point];
	
	return slide;
}

-(BOOL)isPointContainedWithinNavigationRect:(CGPoint)point {
    CGRect navigationBarRect = CGRectNull;
    if([self.contentViewController isKindOfClass:[UINavigationController class]]){
        UINavigationBar * navBar = [(UINavigationController*)self.contentViewController navigationBar];
        navigationBarRect = [navBar convertRect:navBar.frame toView:self.view];
        navigationBarRect = CGRectIntersection(navigationBarRect,self.view.bounds);
    }
    return CGRectContainsPoint(navigationBarRect,point);
}

-(BOOL)isPointContainedWithinBezelRect:(CGPoint)point {
    CGRect leftBezelRect;
    CGRect tempRect;
	CGFloat bezelWidth = self.options.bezelWidth;
	
    CGRectDivide(self.view.bounds, &leftBezelRect, &tempRect, bezelWidth, CGRectMinXEdge);
    
    return CGRectContainsPoint(leftBezelRect, point);
}

- (BOOL)isPointContainedWithinMenuRect:(CGPoint)point {
	return CGRectContainsPoint(self.menuContainerView.frame, point);
}

- (void)addShadowToMenuView {
	
	self.menuContainerView.layer.masksToBounds = NO;
	self.menuContainerView.layer.shadowOffset = self.options.shadowOffset;
	self.menuContainerView.layer.shadowOpacity = self.options.shadowOpacity;
    self.menuContainerView.layer.shadowRadius = self.options.shadowRadius;
	self.menuContainerView.layer.shadowPath = [[UIBezierPath
                                                 bezierPathWithRect:self.menuContainerView.bounds] CGPath];
}

- (void)removeMenuShadow {
	
	self.menuContainerView.layer.masksToBounds = YES;
	self.contentContainerView.layer.opacity = 1.0;
}

- (void)removeContentOpacity {
	self.opacityView.layer.opacity = 0.0;
}

- (void)addContentOpacity {
	self.opacityView.layer.opacity = self.options.contentViewOpacity;
}

- (void)disableContentInteraction {
	[self.contentContainerView setUserInteractionEnabled:NO];
}

- (void)enableContentInteraction {
	[self.contentContainerView setUserInteractionEnabled:YES];
}

#pragma mark – UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
	
	CGPoint point = [touch locationInView:self.view];
	
	if (gestureRecognizer == _panGesture) {
		return [self slideMenuForGestureRecognizer:gestureRecognizer withTouchPoint:point];
	} else if (gestureRecognizer == _tapGesture){
		return [self isMenuOpen] && ![self isPointContainedWithinMenuRect:point];
	}
	
	return YES;
}

@end

@implementation UIViewController (MVYSideMenuController)

- (MVYSideMenuController *)sideMenuController {
	
    UIViewController *viewController = self;
    
    while (viewController) {
        if ([viewController isKindOfClass:[MVYSideMenuController class]])
            return (MVYSideMenuController *)viewController;
        
        viewController = viewController.parentViewController;
    }
    return nil;
}

@end
