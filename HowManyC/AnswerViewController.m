//
//  AnswerViewController.m
//  HowManyC
//
//  Created by Max on 05/07/15.
//  Copyright (c) 2015 Max. All rights reserved.
//

#import "AnswerViewController.h"
#import "ResultViewController.h"
#import "Utils.h"

@interface AnswerViewController ()
@property NSMutableArray *answers;
@property NSInteger choosenAnswer;

@property (weak, nonatomic) IBOutlet UITextView *thinkTwiceLabel;
@property (weak, nonatomic) IBOutlet UILabel *howManyLabel;
@end

@implementation AnswerViewController
@synthesize game;
@synthesize answers;
@synthesize choosenAnswer;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    game.minimum = (double)game.itemsCount - ((double)game.itemsCount / 20.0) - 1.0;
    game.maximum = (double)game.itemsCount + ((double)game.itemsCount / 20.0) + 1.0;

    answers = [[NSMutableArray alloc] init];
    
    for (int n = 0; n < 4; n++) {
        for (int a = 0; a < 100; a++) {
            NSNumber *guess = [NSNumber numberWithInteger:(NSInteger)[Utils rnd:game.minimum to:game.maximum]];

            if (NSNotFound == [answers indexOfObject:guess]) {
                [answers addObject:guess];
                break;
            }
        }
        // just for sure if we have less than 4 answers

        [self.view viewWithTag: n+1].hidden = true;
    }
    
    if (NSNotFound == [answers indexOfObject:[NSNumber numberWithInteger:game.itemsCount]]) {
        NSInteger idx = arc4random() % [answers count];
        [answers setObject:[NSNumber numberWithInteger:game.itemsCount] atIndexedSubscript:idx];
    }
    
    
    for (int idx = 0; idx < [answers count]; idx++) {
        NSNumber *guess = [answers objectAtIndex:idx];
        UIButton *v = (UIButton*)[self.view viewWithTag:idx+1];
        
        v.hidden = false;
//        [v setBackgroundColor:[UIColor redColor]];

        [v setTitle:[NSString stringWithFormat:@"%@", guess] forState: UIControlStateNormal];
        [v addTarget: self action: @selector(answerCheck:) forControlEvents: UIControlEventTouchUpInside];
    }
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.howManyLabel.text = NSLocalizedString(@"answer_how_many", nil);
    
    NSArray *thinkTwice = @[@"think1", @"think2", @"think3"];
    
    self.thinkTwiceLabel.text = NSLocalizedString(thinkTwice[arc4random() % [thinkTwice count]], nil);

}

- (void)answerCheck:(UIButton*)sender {
    choosenAnswer = [answers[sender.tag - 1] integerValue];
    [self performSegueWithIdentifier:@"show_result" sender:self];
    
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
    
    ResultViewController *c = (ResultViewController*)[segue destinationViewController];
    
    c.game = game;
    
    double errorlimit = 5.0;
    if (game.itemsCount < 24) {
        errorlimit = 10.0;
    }
    
    double p = ((double)game.itemsCount / 100.0) * errorlimit;
    game.answer = choosenAnswer;
    game.success = labs(game.itemsCount - choosenAnswer) < p;
}


@end
