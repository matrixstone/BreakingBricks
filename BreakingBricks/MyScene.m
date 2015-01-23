//
//  MyScene.m
//  BreakingBricks
//
//  Created by Xu He on 1/19/15.
//  Copyright (c) 2015 Xu He. All rights reserved.
//

#import "MyScene.h"
#import "EndScene.h"

@interface MyScene ()

@property (nonatomic) SKSpriteNode *paddle;

@end

static const uint32_t ballCategory =1;
static const uint32_t brickCategory=2;
static const uint32_t paddleCategory = 4;
static const uint32_t edgeCategory = 8;
static const uint32_t bottomEdgeCategory = 16;
/***
  = 0x1;
  = 0x1 << 1;
  = 0x1 << 2;
  = 0x1 << 3;
 **/

@implementation MyScene

-(void)didBeginContact:(SKPhysicsContact *)contact{
    
    
    SKPhysicsBody *notTheBall;
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        notTheBall=contact.bodyB;
    }else{
        notTheBall=contact.bodyA;
    }
    if (notTheBall.categoryBitMask == brickCategory) {
//        SKAction *playSFX =[SKAction playSoundFileNamed:@"brickhit.caf" waitForCompletion:NO];
//        [self runAction:playSFX];
        [contact.bodyA.node removeFromParent];
    }
    
    if (notTheBall.categoryBitMask == paddleCategory) {
//        SKAction *playSFX =[SKAction playSoundFileNamed:@"blip.caf" waitForCompletion:NO];
//        [self runAction:playSFX];
    }
    if (notTheBall.categoryBitMask == bottomEdgeCategory) {
        EndScene *end=[EndScene sceneWithSize:self.size];
        [self.view presentScene:end transition:[SKTransition doorwayWithDuration:(1.0)]];

    }
    
}

-(void)addBottomEdge:(CGSize)size{
    SKNode *bottomEdge=[SKNode node];
    bottomEdge.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0, 1) toPoint:CGPointMake(size.width, 1)];
    bottomEdge.physicsBody.categoryBitMask=bottomEdgeCategory;
    [self addChild:bottomEdge];
    
}

- (void)addBall:(CGSize)size {
    //create a new sprite node from image
    SKSpriteNode *ball=[SKSpriteNode spriteNodeWithImageNamed:@"ball"];
    
    CGPoint myPoint=CGPointMake(size.width/2, size.height/2);
    ball.position=myPoint;
    
    //add a physical body to the ball
    ball.physicsBody=[SKPhysicsBody bodyWithCircleOfRadius:ball.frame.size.width/2];
    ball.physicsBody.friction=0;
    ball.physicsBody.linearDamping=0;
    ball.physicsBody.restitution=1.0f;
    ball.physicsBody.categoryBitMask = ballCategory;
    ball.physicsBody.contactTestBitMask=brickCategory | paddleCategory | bottomEdgeCategory;
//    ball.physicsBody.collisionBitMask=edgeCategory | brickCategory;
    
    //add sprite
    [self addChild:ball];
    
    CGVector myVector=CGVectorMake(12, 12);
    
    [ball.physicsBody applyImpulse:myVector];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *touch in touches) {
        CGPoint location=[touch locationInNode:self];
        CGPoint newPosition = CGPointMake(location.x, 100);
        if (newPosition.x < self.paddle.size.width/2) {
            newPosition.x=self.paddle.size.width/2;
        }
        if (newPosition.x > self.size.width-self.paddle.size.width/2) {
            newPosition.x=self.size.width-self.paddle.size.width/2;
        }
        self.paddle.position=newPosition;
    }
}

-(void)addBricks:(CGSize) size{
    for (int i=0; i<4; i++) {
        SKSpriteNode *brick =[SKSpriteNode spriteNodeWithImageNamed:@"brick"];
        
        brick.physicsBody=[SKPhysicsBody bodyWithRectangleOfSize:brick.frame.size];
        brick.physicsBody.dynamic=  NO;
        brick.physicsBody.categoryBitMask=brickCategory;
        
        int xPos=size.width/5*(i+1);
        int yPos=size.height-50;
        brick.position=CGPointMake(xPos, yPos);
        
        [self addChild:brick];
        
    }
}

-(void) addPlayer:(CGSize) size{
    //create paddle sprite
    self.paddle = [SKSpriteNode spriteNodeWithImageNamed:@"paddle"];
    //position it
    self.paddle.position=CGPointMake(size.width/2, 100);
    //add a physics body
    self.paddle.physicsBody=[SKPhysicsBody bodyWithRectangleOfSize:self.paddle.frame.size];
    self.paddle.physicsBody.dynamic=NO;
    self.paddle.physicsBody.categoryBitMask=paddleCategory;
    
    [self addChild:self.paddle];
    
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        self.backgroundColor =[SKColor colorWithRed:0.73 green:0.88 blue:0.88 alpha:1.0];
        
        //adding a physical body to the scene
        self.physicsBody=[SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.physicsBody.categoryBitMask=edgeCategory;
        
        //changing gravity setting of the physical world
        self.physicsWorld.gravity=CGVectorMake(0, 0);
        self.physicsWorld.contactDelegate=self;
        
        [self addBall:size];
        [self addPlayer:size];
        [self addBricks:size];
        [self addBottomEdge:size];
    }
    return self;
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
