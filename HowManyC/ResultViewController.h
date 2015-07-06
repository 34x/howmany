//
//  ResultViewController.h
//  HowManyC
//
//  Created by Max on 05/07/15.
//  Copyright (c) 2015 Max. All rights reserved.
//

#import "ViewController.h"
#import "Game.h"

@interface ResultViewController : ViewController <UITableViewDataSource>
@property (readwrite) Game *game;
@end
