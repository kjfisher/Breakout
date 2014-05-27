//
//  ViewController.m
//  Breakout
//
//  Created by Kristen L. Fisher on 5/22/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "ViewController.h"
#import "PaddleView.h"
#import "BallView.h"
#import "BlockView.h"

@interface ViewController () <UICollisionBehaviorDelegate>
@property (weak, nonatomic) IBOutlet UIView *blockView;

@property (weak, nonatomic) IBOutlet UIView *paddleView;
@property (weak, nonatomic) IBOutlet UIView *ballView;

@property UIDynamicAnimator *dynamicAnimator;
@property UIPushBehavior *pushBehavior;
@property UICollisionBehavior *collisionBehavior;
@property UIDynamicItemBehavior *paddleDynamicBehavior;
@property UIDynamicItemBehavior *ballDynamicBehavior;
@property UIDynamicItemBehavior *blockDynamicBehavior;

@property (strong, nonatomic) IBOutlet BlockView *blockOne;
@property (strong, nonatomic) IBOutlet BlockView *blockTwo;
@property (strong, nonatomic) IBOutlet BlockView *blockThree;
@property (strong, nonatomic) IBOutlet BlockView *blockFour;
@property (strong, nonatomic) IBOutlet BlockView *blockFive;
@property (strong, nonatomic) IBOutlet BlockView *blockSix;
@property (strong, nonatomic) IBOutlet BlockView *blockSeven;
@property (strong, nonatomic) IBOutlet BlockView *blockEight;

@property IBOutletCollection (BlockView) NSMutableArray *blocksArray;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];

    self.pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.ballView] mode:UIPushBehaviorModeInstantaneous];
    self.pushBehavior.pushDirection = CGVectorMake(0.5, 1.0);
    self.pushBehavior.active = YES;
    self.pushBehavior.magnitude = 0.1;
    [self.dynamicAnimator addBehavior:self.pushBehavior];

    self.collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.paddleView, self.ballView]];
    for (BlockView *block in self.blocksArray)
    {
        [self.collisionBehavior addItem:block];
    }
    self.collisionBehavior.collisionDelegate = self;
    self.collisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
    self.collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    [self.dynamicAnimator addBehavior:self.collisionBehavior];

    self.paddleDynamicBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.paddleView]];
    self.paddleDynamicBehavior.allowsRotation = NO;
    self.paddleDynamicBehavior.density = 1000;
    [self.dynamicAnimator addBehavior:self.paddleDynamicBehavior];

    self.ballDynamicBehavior =[[UIDynamicItemBehavior alloc] initWithItems:@[self.ballView]];
    self.ballDynamicBehavior.allowsRotation = NO;
    self.ballDynamicBehavior.elasticity = 1.0;
    self.ballDynamicBehavior.friction = 0.0;
    self.ballDynamicBehavior.resistance = 0.0;
    [self.dynamicAnimator addBehavior:self.ballDynamicBehavior];

    self.collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.paddleView, self.ballView]];
    for (BlockView *block in self.blocksArray)
    {
        self.blockDynamicBehavior =[[UIDynamicItemBehavior alloc] initWithItems:@[block]];
        self.blockDynamicBehavior.allowsRotation = NO;
        self.blockDynamicBehavior.density = 1000;
        [self.dynamicAnimator addBehavior:self.blockDynamicBehavior];
    }
}

- (IBAction)dragPaddle:(UIPanGestureRecognizer *)gestureRecognizer
{
    self.paddleView.center = CGPointMake([gestureRecognizer locationInView:self.view].x,  self.paddleView.center.y);
    [self.dynamicAnimator updateItemUsingCurrentState:self.paddleView];
}

-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p
{
    int height = self.view.frame.size.height;
    if (p.y > height - 20)
    {
        self.ballView.center = self.view.center;
        [self.dynamicAnimator updateItemUsingCurrentState:self.ballView];
    }
}

- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2 atPoint:(CGPoint)p {
    UIView *item;

	if ([item2 isKindOfClass:[BlockView class]])
    {
        [self.collisionBehavior removeItem:item2];
       [self.blocksArray removeObject:item2];
        item =(UIView *)item2;
        [item removeFromSuperview];
        [self shouldStartAgain];


    }
    if ([item1 isKindOfClass:[BlockView class]])
    {
        [self.collisionBehavior removeItem:item1];
       [self.blocksArray removeObject:item1];
        item =(UIView *)item1;
        [item removeFromSuperview];
        [self shouldStartAgain];
    }
}

 - (BOOL) shouldStartAgain
{
    if (self.blocksArray.count == 0)
    {

    }
    return YES;
}

@end