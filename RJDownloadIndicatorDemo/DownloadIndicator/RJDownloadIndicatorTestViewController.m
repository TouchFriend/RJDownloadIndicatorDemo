//
//  RJDownloadIndicatorTestViewController.m
//  RJDownloadIndicatorDemo
//
//  Created by TouchWorld on 2020/7/22.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import "RJDownloadIndicatorTestViewController.h"
#import "RJDownloadIndicator.h"

@interface RJDownloadIndicatorTestViewController ()
/// <#Desription#>
@property (nonatomic, weak) RJDownloadIndicator *indicator;
@end

@implementation RJDownloadIndicatorTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    RJDownloadIndicator *indicator = [[RJDownloadIndicator alloc] init];
    [self.view addSubview:indicator];
    self.indicator = indicator;
    indicator.bounds = CGRectMake(0, 0, 100, 100);
    indicator.center = CGPointMake(self.view.center.x, self.view.center.y - 64.0);
    indicator.backgroundColor = [UIColor orangeColor];
    indicator.diameterPercent = 1.0;
    indicator.lineWidth = 5.0;
    [indicator changeProgress:0.35 animation:NO];
//    indicator.lineWidth = 2.0;
//    indicator.diameterPercent = 0.3;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    CGFloat progress = MIN(self.indicator.progress + 0.01, 1.0);
//    [self.indicator changeState:RJDownloadIndicatorStateResume];

}



@end
