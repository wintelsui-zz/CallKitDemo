//
//  ViewController.m
//  OneCallKitDemo
//
//  Created by wintel on 16/8/17.
//  Copyright © 2016年 wintel. All rights reserved.
//

#import "HomeViewController.h"
#import "BaseNavigationViewController.h"


@interface HomeViewController ()
{
    NSArray *arraydata;
}
@end

@implementation HomeViewController





- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(performActionForShortcutItem:) name:@"performActionForShortcutItem" object:[UIApplication sharedApplication]];
    
    arraydata = @[@"黑名单和来电屏显", @"VoIP显示"];
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    NSDictionary *NotificationCenterRequired = [AppsDelegate ReadNotificationCenterRequired];
    if (NotificationCenterRequired != nil && [NotificationCenterRequired count]) {
        NSArray *performActionForShortcutItem = [NotificationCenterRequired objectForKey:@"performActionForShortcutItem"];
        if (performActionForShortcutItem != nil && [performActionForShortcutItem count]) {
            NSDictionary *userInfo = [performActionForShortcutItem objectAtIndex:0];
            
            [self performSelector:@selector(performActionForShortcutItemDuel:) withObject:userInfo afterDelay:0];
        }
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arraydata count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Identifier = @"Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    NSInteger row = indexPath.row;
    NSString *title = [arraydata objectAtIndex:row];
    [cell.textLabel setText:title];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableString *urlInfo = [[NSMutableString alloc] init];
    switch (indexPath.row) {
        case 0:
            [urlInfo appendString:insiderUrl];
            [urlInfo appendString:@"CallBlockingIdentificationViewController"];
            [((BaseNavigationViewController *)self.navigationController) pushViewController:urlInfo];
            break;
        case 1:
            [urlInfo appendString:insiderUrl];
            [urlInfo appendString:@"CallVoIPManagerViewController"];
            [((BaseNavigationViewController *)self.navigationController) pushViewController:urlInfo];
            break;
        default:
            break;
    }
    
}

- (void)performActionForShortcutItem:(NSNotification *)info{
    NSDictionary *actionary = info.userInfo;
    [self performSelector:@selector(performActionForShortcutItemDuel:) withObject:actionary afterDelay:0];
}

- (void)performActionForShortcutItemDuel:(NSDictionary *)userInfo{
    [AppsDelegate RemoveNotificationCenterRequired:@"performActionForShortcutItem"];
    NSDictionary *actionary = userInfo;
    if (actionary != nil && [actionary count]) {
        NSString *name = [actionary objectForKey:@"name"];
        
        NSDictionary *additionalUserInfo = [actionary objectForKey:@"userInfo"];
        if (name != nil && name.length > 0) {
            BaseNavigationViewController *vc = (BaseNavigationViewController *)self.navigationController;
            NSInteger count = [vc.viewControllers count];
            NSMutableString *urlInfo = [[NSMutableString alloc] init];
            if (count > 1) {
                id vcL = [vc.viewControllers lastObject];
                if ([vcL isKindOfClass:NSClassFromString(name)]) {
                    //打开应用就在要跳转的页面,无需任何造作
                }else{
                    [((BaseViewController *)vcL).navigationController popToRootViewControllerAnimated:NO];
                    [urlInfo appendString:insiderUrl];
                    [urlInfo appendString:name];
                    if (additionalUserInfo != nil && [additionalUserInfo count]) {
                        [urlInfo appendString:insiderUrlPartition];
                        [urlInfo appendString:[additionalUserInfo JSONString]];
                    }
                    [vc pushViewController:urlInfo];
                }
            }else{
                [urlInfo appendString:insiderUrl];
                [urlInfo appendString:name];
                if (additionalUserInfo != nil && [additionalUserInfo count]) {
                    [urlInfo appendString:insiderUrlPartition];
                    [urlInfo appendString:[additionalUserInfo JSONString]];
                }
                [vc pushViewController:urlInfo];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)unwindForSimulateIncomingCallSegue:(UIStoryboardSegue *)segue{
    id viewController = segue.sourceViewController;
    if ([viewController isKindOfClass:[CallVoIPManagerViewController class]]){
        
    }
}


@end
