//
//  HelloWorldLayer.m
//  HammerFight
//
//  Created by Student Student on 17.07.12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#import "CCTouchDispatcher.h"

NSMutableArray *array;
int countOfHamsters;
int countOfDestroyedHamsters;
CCLabelTTF *label;
int tagCount;
#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        tagCount = 0;
		countOfHamsters = 0;
        countOfDestroyedHamsters = 0;
        array = [[NSMutableArray alloc] init];
        CCSprite *bgImage = [CCSprite spriteWithFile:@"backgroundImage.jpg"];
        bgImage.anchorPoint = ccp(0, 0);
        [self addChild:bgImage];
		label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:32];

		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
	
		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , size.height-20 );
        label.tag = 400;
		
		// add the label as a child to this Layer
		[self addChild: label];
        
		
		
		
		//
		// Leaderboards and Achievements
		//
		
		// Default font size will be 28 points.
		[CCMenuItemFont setFontSize:28];
		
		// Achievement Menu Item using blocks
		/*CCMenuItem *itemAchievement = [CCMenuItemFont itemWithString:@"Achievements" block:^(id sender) {
			
			
			GKAchievementViewController *achivementViewController = [[GKAchievementViewController alloc] init];
			achivementViewController.achievementDelegate = self;
			
			AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
			
			[[app navController] presentModalViewController:achivementViewController animated:YES];
			
			[achivementViewController release];
		}
									   ];

		// Leaderboard Menu Item using blocks
		CCMenuItem *itemLeaderboard = [CCMenuItemFont itemWithString:@"Leaderboard" block:^(id sender) {
			
			
			GKLeaderboardViewController *leaderboardViewController = [[GKLeaderboardViewController alloc] init];
			leaderboardViewController.leaderboardDelegate = self;
			
			AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
			
			[[app navController] presentModalViewController:leaderboardViewController animated:YES];
			
			[leaderboardViewController release];
		}
									   ];
		
		CCMenu *menu = [CCMenu menuWithItems:itemAchievement, itemLeaderboard, nil];
		
		[menu alignItemsHorizontallyWithPadding:20];
		[menu setPosition:ccp( size.width/2, size.height/2 - 50)];
		
		// Add the menu to the layer
		[self addChild:menu];*/
        //[self schedule:@selector(drawnHamster) interval:1.0f];
        [self scheduleOnce:@selector(drawnHamster) delay:0];
        
        self.isTouchEnabled = YES;

	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void)drawnHamster{
    CCSprite *hamster = [CCSprite spriteWithFile:@"hamster.png"];
    hamster.position = ccp(arc4random()%(480 - 93), arc4random()%(320 - 57));
    tagCount++;
    hamster.tag = tagCount;
    NSNumber *num = [NSNumber numberWithInt:tagCount];
    int k = (int)num;
    [array addObject:num];
    NSLog(@"%d", k);
    [self addChild:hamster];
    [hamster runAction:[CCMoveTo actionWithDuration:1.5f position:ccp(arc4random()%(480 - 93), arc4random()%(320 - 57))]];
    countOfHamsters++;
    CCLabelTTF *textLabel = (CCLabelTTF *)[self getChildByTag:400];
    [textLabel setString:[NSString stringWithFormat:@"%d/%d", countOfHamsters, countOfDestroyedHamsters]];
    [self performSelector:@selector(retainHamster:) withObject:num afterDelay:1.5f];
    if (countOfHamsters == 10) {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        CCSprite *cat = [CCSprite spriteWithFile:@"cat.png"];
        cat.position = ccp(0, winSize.height/2);
        [self addChild:cat];
        [cat runAction:[CCMoveTo actionWithDuration:5.0f position:ccp(500, cat.position.y)]];
        cat.tag = 555555555;
        [self scheduleOnce:@selector(deleteKote) delay:5.0f];
    }

}

-(void)deleteKote{
    [self removeChildByTag:555555555 cleanup:YES];
}

-(void)retainHamster:(NSInteger *) spriteTag{
    [self removeChildByTag:[spriteTag intValue] cleanup:YES];
    [self scheduleOnce:@selector(drawnHamster) delay:0.5];
}

-(void)deleteHammer{
    [self removeChildByTag:5000000000 cleanup:YES];
}


-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    for( UITouch *touch in touches ) {
		CGPoint location = [touch locationInView: [touch view]];
		location = [[CCDirector sharedDirector] convertToGL: location];
        CCSprite *hammer = [CCSprite spriteWithFile:@"hammer.png"];
        hammer.position = location;
        hammer.tag = 5000000000;
        [self addChild:hammer];
        [self scheduleOnce:@selector(deleteHammer) delay:0.1f];
        for (id spriteTag in array) {
            CCSprite *mySprite=(CCSprite *) [self getChildByTag:[spriteTag intValue]];
            if(mySprite) {
                
                // check to see if the touch occured over mySprite
                if(CGRectContainsPoint([mySprite boundingBox], location)) {
                    NSLog(@"Succes!!!");
                    countOfDestroyedHamsters++;
                    CCLabelTTF *textLabel = (CCLabelTTF *)[self getChildByTag:400];
                    [textLabel setString:[NSString stringWithFormat:@"%d/%d", countOfHamsters, countOfDestroyedHamsters]];
                    [self unschedule:@selector(retainHamster:)];
                    [self retainHamster:spriteTag];
                    //[array removeObject:spriteTag];
                }
            }
        }
		
	}
}


@end
