//
//  EndScene.m
//  BreakingBricks
//
//  Created by Xu He on 1/21/15.
//  Copyright (c) 2015 Xu He. All rights reserved.
//

#import "EndScene.h"
#import "MyScene.h"

@implementation EndScene

-(instancetype)initWithSize:(CGSize)size{
    if (self = [super initWithSize:size]) {
        
        self.backgroundColor =[SKColor blackColor];
        
        SKAction *endSound=[SKAction playSoundFileNamed:@"gameover.caf" waitForCompletion:NO];
        [self runAction:endSound];
        //create message
        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
        label.text=@"GAME OVER!";
        label.fontColor=[SKColor whiteColor];
        label.fontSize=50;
        label.position=CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:label];
        
        SKLabelNode *tryAgain = [SKLabelNode labelNodeWithFontNamed:@"Futura Medium"];
        tryAgain.text=@"Tap to play again!";
        tryAgain.fontColor=[SKColor whiteColor];
        tryAgain.fontSize=24;
        tryAgain.position=CGPointMake(CGRectGetMidX(self.frame), -50);
        
        SKAction *moveLabel = [SKAction moveToY:self.frame.size.height/2-40 duration:2.0];
        [tryAgain runAction:moveLabel];
        [self addChild:tryAgain];
        
    }
    
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    MyScene *mainScene=[MyScene sceneWithSize:self.size];
    [self.view presentScene:mainScene transition:[SKTransition doorsOpenHorizontalWithDuration:1.5]];
}

@end
