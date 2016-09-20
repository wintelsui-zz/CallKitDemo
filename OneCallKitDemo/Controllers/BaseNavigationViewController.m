//
//  BaseNavigationViewController.m
//  OneCallKitDemo
//
//  Created by wintel on 16/8/18.
//  Copyright © 2016年 wintel. All rights reserved.
//

#import "BaseNavigationViewController.h"

@interface BaseNavigationViewController ()

@end

@implementation BaseNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    [super pushViewController:viewController animated:animated];
}

- (void)pushViewController:(NSString *)info{
    id viewController;
    if (info != nil && [[info lowercaseString] hasPrefix:insiderUrl]) {
        NSString *urlString = [info substringFromIndex:insiderUrl.length];
        NSArray *arrayInfo = [urlString componentsSeparatedByString:insiderUrlPartition];
        NSInteger count = [arrayInfo count];
        if (arrayInfo != nil && count) {
            NSString *controllerName = [arrayInfo objectAtIndex:0];
            viewController = [self.storyboard instantiateViewControllerWithIdentifier:controllerName];
            if (viewController == nil) {
                viewController = [[NSClassFromString(controllerName) alloc] init];
            }
            if (count > 1) {
                NSString *controllerAdditional = [arrayInfo objectAtIndex:1];
                if ([viewController isKindOfClass:[BaseViewController class]]) {
                    ((BaseViewController *)viewController).additionalInfo = controllerAdditional;
                }
            }
        }
    }
    if (viewController != nil) {
        [self pushViewController:viewController animated:YES];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
