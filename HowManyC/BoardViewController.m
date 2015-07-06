//
//  BoardViewController.m
//  HowManyC
//
//  Created by Max on 04/07/15.
//  Copyright (c) 2015 Max. All rights reserved.
//

#import "BoardViewController.h"
#import "ShapeView.h"
#import "Utils.h"
#import "AnswerViewController.h"

@interface BoardViewController ()
@property (weak, nonatomic) IBOutlet UIView *boardView;
@property (nonatomic) NSMutableArray *items;
@property (nonatomic) NSInteger animationDoneCount;
@property (nonatomic) NSTimer *checkAnimationTimer;
@end

@implementation BoardViewController
@synthesize boardView;
@synthesize items;
@synthesize game;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    ShapeView *shape = [[ShapeView alloc] initWithFrame:CGRectMake(100, 100, 100, 100) withType:@"triangle"];
    
//    [self.boardView addSubview:shape];
    
    if (!game) {
        game = [[Game alloc] init];
    }
    
    items = [[NSMutableArray alloc] init];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self initGame];
}

- (void) initGame {
    NSLog(@"init game");
    game.success = false;
    game.answer = 0;
    
    NSArray *shapeTypes;
    
    if (game.itemsCount < 6) {
        shapeTypes = @[@"circle"];
    } else if (game.itemsCount < 16) {
        shapeTypes = @[@"circle", @"box"];
    } else {
        shapeTypes = @[@"circle", @"box", @"triangle"];
    }
    
    CGRect bounds = boardView.frame;
    double width;

    if (game.itemsCount < 6) {
        width = bounds.size.width / (game.itemsCount * 2);
    } else {
        width = bounds.size.height / ((double)game.itemsCount / 1.2);
    }
    
    if (width < 32.0) {
        width = 32.0;
    }
    
    double height = width;
    double margin = 8.0;
    self.animationDoneCount = 0;
    
    for (int idx = 0; idx < game.itemsCount; idx++) {
        // search for coords
        int attempt = 150;
        double coordX = 0.0;
        double coordY = 0.0;
        
        while (attempt > 0 && 0.0 == coordX && 0.0 == coordY) {
            attempt--;
            
            
            CGFloat guessX = [Utils rnd:width / 2.0 + margin to: bounds.size.width - (width / 2.0 + margin)];
            CGFloat guessY = [Utils rnd:height / 2.0 + margin to: bounds.size.height - (height / 2.0 + margin)];

            // check that coord is free
            BOOL busy = false;
            for (UIView *sub in items) {
                
                CGPoint point = [boardView convertPoint: CGPointMake(guessX, guessY) toView: sub];
                if (nil != [sub hitTest:point withEvent: nil]) {
                    busy = true;
                    break;
                }
            }
            
            if (!busy) {
                coordX = guessX;
                coordY = guessY;
                break;
            }
        }
        
        NSString *type = shapeTypes[arc4random() % [shapeTypes count]];
        
        if (0.0 != coordX && 0.0 != coordY) {

            ShapeView *v = [[ShapeView alloc] initWithFrame: CGRectMake(coordX, coordY, width, height) withType: type];
            v.center = CGPointMake(coordX, coordY);
            v.userInteractionEnabled = false;
            

            [boardView addSubview:v];
            CGFloat valpha = v.alpha;
            [items addObject:v];

            CGAffineTransform transform = v.transform;
            
            
            // iOS 7.0 >=

            if ([UIView respondsToSelector:@selector(animateKeyframesWithDuration:delay:options:animations:completion:)]) {
                v.transform = CGAffineTransformScale(transform, 10, 10);
                v.alpha = 0.0;
                
                double duration;
                if (idx < 20) {
                    duration = 0.6;
                } else if (idx < 30) {
                    duration = 0.5;
                } else if (idx < 50) {
                    duration = 0.4;
                } else if (idx < 100) {
                    duration = 0.3;
                } else {
                    duration = 0.2;
                }

                [UIView animateKeyframesWithDuration: duration delay: [Utils rnd:((double)idx*(duration / 10.0)) to:((double)idx*(duration / 6.0))] options: UIViewKeyframeAnimationOptionCalculationModeLinear animations: ^{
                    

                    [UIView addKeyframeWithRelativeStartTime:0 relativeDuration: 0.2 animations: ^{
                        v.transform = CGAffineTransformScale(transform, 5, 5);
                        v.alpha = 0.6;
                    }];
                    
                    [UIView addKeyframeWithRelativeStartTime:0.2 relativeDuration: 0.3 animations: ^{
                        v.transform = CGAffineTransformScale(transform, 0.4, 0.4);
                        
                    }];
                    
                        [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration: 0.3 animations: ^{
                            v.transform = CGAffineTransformScale(transform, 1.4, 1.4);
                        }];
//
                    [UIView addKeyframeWithRelativeStartTime:0.8 relativeDuration: 0.2 animations: ^{
                        v.transform = CGAffineTransformScale(transform, 1, 1);
                        v.alpha = valpha;
                        [v addShadow];
                        
                    }];

                    
                    
                } completion: ^(BOOL finished){
                    self.animationDoneCount++;
                    
                }];
            } else {
                v.alpha = 0.0;
                v.transform = CGAffineTransformScale(transform, 10, 10);
                [UIView animateWithDuration:0.4 animations:^{
                    v.transform = transform;
                    v.alpha = valpha;
                } completion:^(BOOL finished){
                    [v addShadow];
                    self.animationDoneCount++;
                }];
            }
            
        } else {
            //                println("busy")
        }
    }
    
    NSLog(@"items count actual: %li", (unsigned long)[items count]);
    game.itemsCount = [items count];
    
    self.checkAnimationTimer = [NSTimer scheduledTimerWithTimeInterval: 0.4 target: self selector: @selector(checkAnimationDone) userInfo: nil repeats: true];
    
}

- (void) checkAnimationDone {
    if (self.animationDoneCount == [self.items count]) {
        [self.checkAnimationTimer invalidate];
        [NSTimer scheduledTimerWithTimeInterval: 3.0 target: self selector: @selector(askAnswer) userInfo: nil repeats: false];
    }
}

- (void) askAnswer {
    [self performSegueWithIdentifier:@"ask_answer" sender:self];
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
    
    AnswerViewController *c = (AnswerViewController*)[segue destinationViewController];
    c.game = game;
    
}


@end
