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

@property (weak, nonatomic) IBOutlet PaddleView *paddleView;
@property (weak, nonatomic) IBOutlet BallView *ballView;

@property BlockView *blockView;
@property UIDynamicAnimator *dynamicAnimator;
@property UIPushBehavior *pushBehavior;
@property UICollisionBehavior *collisionBehavior;
@property UIDynamicItemBehavior *paddleDynamicBehavior;
@property UIDynamicItemBehavior *ballDynamicBehavior;
@property UIDynamicItemBehavior *blockDynamicBehavior;

@property NSMutableArray *blocks;
@property NSMutableArray *items;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createBlocks];
}

- (void) createBlocks
{
    self.blocks = [[NSMutableArray alloc] init];
    self.items = [[NSMutableArray alloc] init];

    for (int row = 1; row < 10; row++)
    {
        for (int col = 1; col < 6; col++)
        {
            self.blockView = [[BlockView alloc] initWithFrame:CGRectMake(23 * row + 40, 23 * col + 80, 20, 20)];
            self.blockView.backgroundColor = [UIColor darkGrayColor];
            [self.view addSubview:self.blockView];
            [self.blocks addObject:self.blockView];
        }
    }

    [self.items addObjectsFromArray:self.blocks];
    [self.items addObject:self.ballView];
    [self.items addObject:self.paddleView];

    self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];

    self.pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.ballView] mode:UIPushBehaviorModeInstantaneous];
    self.pushBehavior.pushDirection = CGVectorMake(0.5, 1.0);
    self.pushBehavior.active = YES;
    self.pushBehavior.magnitude = 0.1;
    [self.dynamicAnimator addBehavior:self.pushBehavior];

    self.collisionBehavior = [[UICollisionBehavior alloc] initWithItems:self.items];

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

    self.blockDynamicBehavior =[[UIDynamicItemBehavior alloc] initWithItems:self.blocks];
    self.blockDynamicBehavior.allowsRotation = NO;
    self.blockDynamicBehavior.density = 1000;
    [self.dynamicAnimator addBehavior:self.blockDynamicBehavior];
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

- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2 atPoint:(CGPoint)p
{
    UIView *item;

	if ([item2 isKindOfClass:[BlockView class]])
    {
        [self.collisionBehavior removeItem:item2];
        [self.dynamicAnimator updateItemUsingCurrentState:item2];
        item =(UIView *)item2;
        [item removeFromSuperview];
        [self shouldStartAgain];
    }

    if ([item1 isKindOfClass:[BlockView class]])
    {
        [self.collisionBehavior removeItem:item1];
        [self.dynamicAnimator updateItemUsingCurrentState:item1];
        item =(UIView *)item1;
        [item removeFromSuperview];
        [self shouldStartAgain];
    }
    [self shouldStartAgain];
}

 - (BOOL) shouldStartAgain
{
    for (UIView *view in self.view.subviews)
    {
        if ([view isKindOfClass:[BlockView class]])
        {
            return NO;
        }
    }
    [self createBlocks];
    self.ballView.center = self.view.center;
    return YES;
}

@end