//
//  Gameplay.m
//  minigame
//
//  Created by Selina Wang on 8/7/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"

@implementation Gameplay {
    CCNode *_contentNode;
    CCNodeColor *_track1;
    CCNodeColor *_track2;
    CCNodeColor *_track3;
    NSMutableArray *trackPositionArray;
    NSMutableArray *enemyArray;
    CCNode *_player;
    float randomtimefloat;
    float timeSinceEnemy;
    float playerSize;
    float screenSizeRatio;
}

-(void)didLoadFromCCB {
   
    trackPositionArray = [NSMutableArray arrayWithObjects: [NSNumber numberWithFloat:_track1.position.x], [NSNumber numberWithFloat:_track2.position.x], [NSNumber numberWithFloat:_track3.position.x], nil];
    [self schedule:@selector(updateEnemyPosition) interval:0.5];
    [self generatePlayer];
    UISwipeGestureRecognizer *swiperight;
    UISwipeGestureRecognizer *swipeleft;
    
    swiperight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight)];
    swipeleft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft)];
    
    [swiperight setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [swipeleft setDirection:(UISwipeGestureRecognizerDirectionLeft)];

    [[[CCDirector sharedDirector] view] addGestureRecognizer:swiperight];
    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeleft];
    enemyArray = [NSMutableArray arrayWithObjects: nil];
    randomtimefloat = .5f;
    timeSinceEnemy = 1.f;
}


-(void)generatePlayer {
    int randomint = arc4random_uniform(3);
    NSNumber *X = [trackPositionArray objectAtIndex:randomint];
    float playerPositionX = [X floatValue];
    float playerPositionY = 0.2;
    _player = (CCNode*)[CCBReader load:@"Player"];
    CGPoint playerLocation = ccp(playerPositionX, playerPositionY);
    playerSize = _track1.contentSize.width;
    screenSizeRatio = [[CCDirector sharedDirector] viewSize].width / [[CCDirector sharedDirector] viewSize].height;
    _player.contentSize = CGSizeMake(playerSize, playerSize * screenSizeRatio);
    _player.positionType = CCPositionTypeNormalized;
    _player.position = playerLocation;
    [_contentNode addChild:_player];
    }

//generate enemy at one of the three x positions
-(void)generateEnemy {
    int randomint = arc4random_uniform(3);
    NSNumber *X = [trackPositionArray objectAtIndex:randomint];
    float enemyX = [X floatValue];
    float enemyY = 1;
    CGPoint enemyPosition = ccp(enemyX, enemyY);
    CCNode *enemy = (CCNode*)[CCBReader load:@"Enemy"];
    enemy.positionType = CCPositionTypeNormalized;
    enemy.position = enemyPosition;
    enemy.contentSize = CGSizeMake(playerSize, playerSize * screenSizeRatio);
    [_contentNode addChild:enemy];
    [enemyArray addObject:enemy];
    NSLog(@"enemy generated");
    
}

//generate enemy every few seconds
-(void)keepGeneratingEnemy:(CCTime)delta {
    srandom(time(NULL));
    
    timeSinceEnemy += delta;
    
    if (timeSinceEnemy > randomtimefloat) {
        [self generateEnemy];
        timeSinceEnemy = 0;
        randomtimefloat = clampf((CCRANDOM_0_1() * 2),0.1,2);
}
}


//move enemy down
-(void)updateEnemyPosition {
    for (CCNode *enemy in enemyArray) {
        enemy.position = ccp(enemy.position.x, (enemy.position.y - .05));
    }
}

//swipe to move the player left and right

-(void)swipeRight {
    if (_player.position.x < .75) {
    _player.position = ccp(_player.position.x + .25, _player.position.y);
    }
    
}

-(void)swipeLeft {
    if (_player.position.x > .25) {
    _player.position = ccp(_player.position.x - .25, _player.position.y);
    }
}

//when player's bounding box touches enemy's bounding box: game over
-(void)update:(CCTime)delta {
    for (CCNode* enemy in enemyArray) {
        if (CGRectIntersectsRect(_player.boundingBox, enemy.boundingBox)) {
            CCScene *deadScene = [CCBReader loadAsScene:@"GameOver"];
            [[CCDirector sharedDirector] replaceScene:deadScene];
        }
        
    }
    [self keepGeneratingEnemy:delta];
}

@end
