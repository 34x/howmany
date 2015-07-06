//
//  ResultViewController.m
//  HowManyC
//
//  Created by Max on 05/07/15.
//  Copyright (c) 2015 Max. All rights reserved.
//

#import "ResultViewController.h"
#import "BoardViewController.h"
#import "Utils.h"
#import "GCHelper.h"

@interface ResultViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelInfo;
@property (weak, nonatomic) IBOutlet UITableView *scoresTable;
@property (weak, nonatomic) IBOutlet UIView *scoreView;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property NSArray *scores;
@property NSMutableDictionary *playersAliases;
@end

@implementation ResultViewController
@synthesize game;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.nextButton setTitle:NSLocalizedString(@"result_next_button_title", nil) forState:UIControlStateNormal];
    
    // Do any additional setup after loading the view.
    NSString *infoText;
    if (game.success) {
        
        if (game.answer == game.itemsCount) {
            
            self.labelInfo.backgroundColor = [UIColor colorWithRed: 255.0 / 255.0 green: 128.0 / 255 blue: 0 / 255 alpha: 0.9];
            

            game.score = game.score + pow(game.itemsCount,  2);
            infoText = [NSString stringWithFormat:NSLocalizedString(@"%li is preciesely %li", nil), game.answer, game.itemsCount];
        } else {
            game.score = game.score + game.itemsCount;
            infoText = [NSString stringWithFormat:NSLocalizedString(@"%li is almost %li", nil), game.answer, game.itemsCount];
            
            self.labelInfo.backgroundColor = [UIColor colorWithRed: 0 / 255 green: 128.0 / 255.0 blue: 64.0 / 255.0 alpha: 0.8];
            

        }
        
        // send only increase
        [[GCHelper sharedInstance] reportScore:game.score];
    } else {
        infoText = [NSString stringWithFormat:NSLocalizedString(@"%li is too far from %li", nil), game.answer, game.itemsCount];
        NSInteger minus = game.score / 2;
        
        if (game.score > minus) {
            game.score = game.score - minus;
        }
        // red
        self.labelInfo.backgroundColor = [UIColor colorWithRed: 255 / 255 green: 0 / 255 blue: 0 / 255 alpha: 0.7];
    }
    
    self.labelInfo.text = infoText;

    
    
    GKScore *score;
    
    if ([GKScore instancesRespondToSelector:@selector(initWithLeaderboardIdentifier:)]) {
        score = [[GKScore alloc] initWithLeaderboardIdentifier:@"default"];
    } else {
        score = [[GKScore alloc] initWithCategory:@"default"];
    }
    
    score.value = game.score;

    self.scores = @[score];
    
    self.scoresTable.dataSource = self;
    [self.scoresTable reloadData];
    

    [[GCHelper sharedInstance] getLeaderboardWithCompletionHandler:^(NSArray *scores){
        
        NSMutableArray *playersIds = [[NSMutableArray alloc] init];
        for (int i = 0; i < [scores count]; i++) {
            GKScore *score = [scores objectAtIndex:i];
            NSLog(@"recieved score: %@", score.formattedValue);
            [playersIds addObject:score.playerID];
        }
        
        [GKPlayer loadPlayersForIdentifiers:playersIds withCompletionHandler:^(NSArray *players, NSError *error){
            self.playersAliases = [[NSMutableDictionary alloc] init];
            
            for (int i = 0; i < [players count]; i++) {
                GKPlayer *player = [players objectAtIndex:i];
                
                NSLog(@"Player loaded %@", player.alias);
                [self.playersAliases setObject:player.alias forKey:player.playerID];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.scoresTable reloadData];
            });
        }];
        
        
        
//        GKLeaderboard *localLeaderboard;
//        if ([GKLeaderboard instancesRespondToSelector:@selector(initWithPlayers:)]) {
//            localLeaderboard = [[GKLeaderboard alloc] initWithPlayers:@[[GKLocalPlayer localPlayer]]];
//            localLeaderboard.identifier = @"default";
//        } else {
//            localLeaderboard = [[GKLeaderboard alloc] initWithPlayerIDs:@[[GCHelper sharedInstance].localPlayerId]];
//            localLeaderboard.category = @"default";
//        }
//        
//        localLeaderboard.playerScope = GKLeaderboardPlayerScopeGlobal;
//        
//        [localLeaderboard loadScoresWithCompletionHandler:^(NSArray *scores, NSError * error){
//            
//            if (nil == error) {
//                
//                GKScore *score = [scores firstObject];
//                if (nil != score) {
//
//                    
//                }
//            }
//        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            CGRect frame = self.scoreView.frame;
            UILabel *rankLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height - 20, frame.size.width, 16)];
            
            rankLabel.font = [UIFont fontWithName:@"Helvetica" size:18];
            rankLabel.textColor = [UIColor whiteColor];
            rankLabel.backgroundColor = [UIColor clearColor];
            rankLabel.textAlignment = NSTextAlignmentCenter;
            
            rankLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Your rank is %li", nil), (long)[GCHelper sharedInstance].localPlayerRank];
            
            rankLabel.layer.shouldRasterize = true;
            rankLabel.alpha = 0.0;
            [UIView animateWithDuration:0.8 animations:^{
                rankLabel.alpha = 1.0;
            }];
            
            [self.scoreView addSubview:rankLabel];
            
            self.scores = scores;
            [self.scoresTable reloadData];
        
            
        });
    }];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    CGRect frame = self.scoreView.frame;
    
    
    
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Helvetica" size:64.0];
    label.text = [NSString stringWithFormat:@"%li", (long)game.score];
    
    label.layer.shouldRasterize = true;
    
    CGAffineTransform transform = label.transform;
    
    label.transform = CGAffineTransformScale(transform, 10, 10);
    label.alpha = 0.0;

    [self.scoreView addSubview:label];
    
    [UIView animateWithDuration:0.4 animations:^{
        label.transform = transform;
        label.alpha = 1.0;
    }];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    BoardViewController *c = [segue destinationViewController];
    c.game = game;
    
    if (game.success) {
        NSInteger plus;
        if (game.itemsCount < 6) {
            plus = 2;
        } else if (game.itemsCount < 12) {
            plus = round([Utils rnd:2.0 to: 4.0]);
        } else {
            plus = round([Utils rnd:1.0 to: ((double)game.itemsCount / 2.0)]);
        }

        game.itemsCount = game.itemsCount + plus;
        
    } else {
        if (game.itemsCount > 4) {
            NSInteger minus = (NSInteger)[Utils rnd:(double)game.itemsCount / 4.0 to: (double)game.itemsCount / 2.0];
            game.itemsCount = game.itemsCount - minus;
        } else {
            game.itemsCount = 2;
        }
    }
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (nil == self.scores) {
        return 0;
    } else {
        return [self.scores count];
    }
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"scoreItem"];

    if (nil != self.scores) {
        GKScore *score = [self.scores objectAtIndex: indexPath.row];
        if (nil != score) {


            cell.textLabel.text = [NSString stringWithFormat:@"%li", (long)score.value];

            cell.detailTextLabel.text = NSLocalizedString(@"Login to game center to se other players", nil);
            
            if (nil != self.playersAliases) {
                NSString *alias = [self.playersAliases objectForKey:score.playerID];
                cell.detailTextLabel.text = alias;
            }

        }
    }
    
    return cell;
}

@end
