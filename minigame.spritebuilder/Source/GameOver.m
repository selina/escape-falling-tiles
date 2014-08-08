//
//  GameOver.m
//  minigame
//
//  Created by Selina Wang on 8/8/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameOver.h"

@implementation GameOver

-(void)replay {
    CCScene *mainScene = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:mainScene];

}

@end
