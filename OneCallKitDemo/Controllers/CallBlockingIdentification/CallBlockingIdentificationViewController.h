//
//  CallBlockingIdentificationViewController.h
//  OneCallKitDemo
//
//  Created by wintel on 16/8/17.
//  Copyright © 2016年 wintel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CallBlockingIdentificationViewController : UIViewController
<
UITableViewDelegate,
UITableViewDataSource
>
{
    NSMutableDictionary *dicMuBlock;
    NSMutableDictionary *dicMuIdentification;
    NSMutableDictionary *dicMuIdentification2;
    NSArray *arrBlockPhones;
    NSArray *arrIdentificationPhones;
    NSArray *arrIdentificationPhones2;
    
}
@property (weak, nonatomic) IBOutlet UIScrollView *basescrollview;
@property (weak, nonatomic) IBOutlet UIButton *addBlockButton;
@property (weak, nonatomic) IBOutlet UIButton *addIdentificationButton;
@property (weak, nonatomic) IBOutlet UIButton *addIdentificationButton2;
@property (weak, nonatomic) IBOutlet UITableView *blockTableView;
@property (weak, nonatomic) IBOutlet UITableView *identificationTableView;
@property (weak, nonatomic) IBOutlet UITableView *identificationTableView2;
@end
