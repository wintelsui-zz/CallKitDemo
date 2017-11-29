//
//  CallBlockingIdentificationViewController.m
//  OneCallKitDemo
//
//  Created by wintel on 16/8/17.
//  Copyright © 2016年 wintel. All rights reserved.
//

#import "CallBlockingIdentificationViewController.h"
#import <CallKit/CallKit.h>

#import "MBProgressHUD.h"

enum : NSUInteger {
    PhoneEditModeAddBlock           = 1 << 1,
    PhoneEditModeAddIdentification  = 1 << 2,
    PhoneEditModeEditIdentification = 1 << 3,
} PhoneEditMode;

@interface CallBlockingIdentificationViewController ()
{
    //typedef void(^<#name#>)(success);
}
@end

@implementation CallBlockingIdentificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
//    NSString *pathLibrary = [paths objectAtIndex:0];
    [self test];
    
    
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    dicMuBlock = [[NSMutableDictionary alloc] init];
    dicMuIdentification = [[NSMutableDictionary alloc] init];
    dicMuIdentification2 = [[NSMutableDictionary alloc] init];
    
    NSString *filePathBlock = [self readPathBlock];
    NSString *filePathIdentification = [self readPathIdentification];
    NSString *filePathIdentification2 = [self readPathIdentification2];
    
    NSDictionary *dicBlock = [[NSDictionary alloc] initWithContentsOfFile:filePathBlock];
    NSDictionary *dicIdentification = [[NSDictionary alloc] initWithContentsOfFile:filePathIdentification];
    NSDictionary *dicIdentification2 = [[NSDictionary alloc] initWithContentsOfFile:filePathIdentification2];
    
    if (dicBlock != nil && [dicBlock count]) {
        [dicMuBlock setDictionary:dicBlock];
        arrBlockPhones = [dicMuBlock allKeys];
    }
    
    if (dicIdentification != nil && [dicIdentification count]) {
        [dicMuIdentification setDictionary:dicIdentification];
        arrIdentificationPhones = [dicMuIdentification allKeys];
    }
    if (dicIdentification2 != nil && [dicIdentification2 count]) {
        [dicMuIdentification2 setDictionary:dicIdentification2];
        arrIdentificationPhones2 = [dicMuIdentification2 allKeys];
    }
}
- (IBAction)segmentedControlChanged:(id)sender {
    UISegmentedControl *sc = (UISegmentedControl *)sender;
    switch (sc.selectedSegmentIndex) {
        case 0:
            [_basescrollview setContentOffset:CGPointMake(0, 0)];
            break;
        case 1:
            [_basescrollview setContentOffset:CGPointMake(CGRectGetWidth(_basescrollview.frame) * 1, 0)];
            break;
        case 2:
            [_basescrollview setContentOffset:CGPointMake(CGRectGetWidth(_basescrollview.frame) * 2, 0)];
            break;
        default:
            break;
    }
}

- (void)test{
    NSString *filePathBlock = [self readPathBlock];
    NSDictionary *dicBlock = [[NSDictionary alloc] initWithContentsOfFile:filePathBlock];
    NSArray *arrBlockPhones1 = [dicBlock allKeys];
    NSUInteger count = [arrBlockPhones1 count];
    
    
    NSMutableArray *arrayPhone = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < count; i += 1) {
        //CXCallDirectoryPhoneNumber phoneNumber = phoneNumbers[index];
        NSString *phone = [arrBlockPhones1 objectAtIndex:i];
        CXCallDirectoryPhoneNumber phoneNumber = [phone integerValue];
    }
}

- (IBAction)RelaodCallBlockingInfo:(id)sender {
    __weak typeof(self) weakSelf = self;
    [[CXCallDirectoryManager sharedInstance] getEnabledStatusForExtensionWithIdentifier:@"com.wintel.OneCallKitDemo.OneCallBlocking" completionHandler:^(CXCallDirectoryEnabledStatus enabledStatus, NSError * _Nullable error) {
        if (enabledStatus == CXCallDirectoryEnabledStatusEnabled) {
            [[CXCallDirectoryManager sharedInstance] reloadExtensionWithIdentifier:@"com.wintel.OneCallKitDemo.OneCallBlocking" completionHandler:^(NSError * _Nullable error) {
                if (error) {
                    NSLog(@"error:%@",error);
                    if (error.code == 6) {
                        [weakSelf performSelectorOnMainThread:@selector(showMessage:) withObject:@"请到\"设置-电话-来电阻止和身份识别\"中打开权限开关" waitUntilDone:YES];
                    }else{
                        [weakSelf performSelectorOnMainThread:@selector(showMessage:) withObject:error.description waitUntilDone:YES];
                    }
                }else{
                    [weakSelf performSelectorOnMainThread:@selector(showMessage:) withObject:@"黑名单设置成功" waitUntilDone:YES];
                }
                [weakSelf ReadDataByFileManager];
            }];
        }else{
            [weakSelf performSelectorOnMainThread:@selector(showMessage:) withObject:@"请到\"设置-电话-来电阻止和身份识别\"中打开权限开关" waitUntilDone:YES];
        }
    }];
}
- (IBAction)RelaodCallIdentificationInfo:(id)sender {
    __weak typeof(self) weakSelf = self;
    [[CXCallDirectoryManager sharedInstance] getEnabledStatusForExtensionWithIdentifier:@"com.wintel.OneCallKitDemo.OneCallIdentification" completionHandler:^(CXCallDirectoryEnabledStatus enabledStatus, NSError * _Nullable error) {
        if (enabledStatus == CXCallDirectoryEnabledStatusEnabled) {
            [[CXCallDirectoryManager sharedInstance] reloadExtensionWithIdentifier:@"com.wintel.OneCallKitDemo.OneCallIdentification" completionHandler:^(NSError * _Nullable error) {
                if (error) {
                    NSLog(@"error:%@",error);
                    if (error.code == 6) {
                        [weakSelf performSelectorOnMainThread:@selector(showMessage:) withObject:@"请到\"设置-电话-来电阻止和身份识别\"中打开权限开关" waitUntilDone:YES];
                    }else{
                        [weakSelf performSelectorOnMainThread:@selector(showMessage:) withObject:error.description waitUntilDone:YES];
                    }
                }else{
                    [weakSelf performSelectorOnMainThread:@selector(showMessage:) withObject:@"来电识别设置成功" waitUntilDone:YES];
                }
                [weakSelf ReadDataByFileManager];
            }];
        }else{
            [weakSelf performSelectorOnMainThread:@selector(showMessage:) withObject:@"请到\"设置-电话-来电阻止和身份识别\"中打开权限开关" waitUntilDone:YES];
        }
    }];
}

- (IBAction)RelaodCallIdentificationInfo2:(id)sender {
    __weak typeof(self) weakSelf = self;
    [[CXCallDirectoryManager sharedInstance] getEnabledStatusForExtensionWithIdentifier:@"com.wintel.OneCallKitDemo.OneCallIdentification2" completionHandler:^(CXCallDirectoryEnabledStatus enabledStatus, NSError * _Nullable error) {
        if (enabledStatus == CXCallDirectoryEnabledStatusEnabled) {
            [[CXCallDirectoryManager sharedInstance] reloadExtensionWithIdentifier:@"com.wintel.OneCallKitDemo.OneCallIdentification2" completionHandler:^(NSError * _Nullable error) {
                if (error) {
                    NSLog(@"error:%@",error);
                    if (error.code == 6) {
                        [weakSelf performSelectorOnMainThread:@selector(showMessage:) withObject:@"请到\"设置-电话-来电阻止和身份识别\"中打开权限开关" waitUntilDone:YES];
                    }else{
                        [weakSelf performSelectorOnMainThread:@selector(showMessage:) withObject:error.description waitUntilDone:YES];
                    }
                }else{
                    [weakSelf performSelectorOnMainThread:@selector(showMessage:) withObject:@"来电识别设置成功" waitUntilDone:YES];
                }
                [weakSelf ReadDataByFileManager];
            }];
        }else{
            [weakSelf performSelectorOnMainThread:@selector(showMessage:) withObject:@"请到\"设置-电话-来电阻止和身份识别\"中打开权限开关" waitUntilDone:YES];
        }
    }];
}

- (void)showMessage:(NSString *)message{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.detailsLabel.text = message;
    hud.mode = MBProgressHUDModeText;
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        sleep(2);
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
        });
    });
    
}

- (void)ReadDataByFileManager{
    NSURL *fileUrl = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.wintel.OneCallKitDemo"];
    NSString *filePath = [fileUrl.absoluteString stringByAppendingString:@"write.dat"];
    filePath = [filePath substringFromIndex:(@"file://".length)];
    {
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        NSDictionary *oldInfo = [unarchiver decodeObjectForKey:@"Info"];
        NSLog(@"\n%@",oldInfo);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _blockTableView){
        return (arrBlockPhones != nil ? [arrBlockPhones count] : 0);
    }else if (tableView == _identificationTableView){
            return (arrIdentificationPhones != nil ? [arrIdentificationPhones count] : 0);
    }
    return (arrIdentificationPhones2 != nil ? [arrIdentificationPhones2 count] : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    NSInteger row = indexPath.row;
    if (tableView == _blockTableView){
        static NSString *blockIdentifier = @"blockIdentifier";
        cell = [tableView dequeueReusableCellWithIdentifier:blockIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:blockIdentifier];
        }
        NSString *phone = [arrBlockPhones objectAtIndex:row];
        [cell.textLabel setText:phone];
    }else if (tableView == _identificationTableView){
        static NSString *identificationIdentifier = @"identificationIdentifier";
        cell = [tableView dequeueReusableCellWithIdentifier:identificationIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identificationIdentifier];
        }
        NSString *phone = [arrIdentificationPhones objectAtIndex:row];
        NSString *desc = [dicMuIdentification objectForKey:phone];
        [cell.textLabel setText:phone];
        [cell.detailTextLabel setText:desc];
    }else{
        static NSString *identificationIdentifier = @"identificationIdentifier2";
        cell = [tableView dequeueReusableCellWithIdentifier:identificationIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identificationIdentifier];
        }
        NSString *phone = [arrIdentificationPhones2 objectAtIndex:row];
        NSString *desc = [dicMuIdentification2 objectForKey:phone];
        [cell.textLabel setText:phone];
        [cell.detailTextLabel setText:desc];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _blockTableView){
        [_identificationTableView setEditing:NO animated:YES];
        [_identificationTableView2 setEditing:NO animated:YES];
    }else if (tableView == _identificationTableView){
        [_blockTableView setEditing:NO animated:YES];
        [_identificationTableView2 setEditing:NO animated:YES];
    }else{
        [_identificationTableView setEditing:NO animated:YES];
        [_blockTableView setEditing:NO animated:YES];
    }
    return UITableViewCellEditingStyleDelete;
}
    
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    NSInteger row = indexPath.row;
    if (tableView == _blockTableView){
        NSString *phone = [arrBlockPhones objectAtIndex:row];
        [dicMuBlock removeObjectForKey:phone];
        arrBlockPhones = [dicMuBlock allKeys];
        
        [self changeBlockCompletion:^(BOOL success) {
            if(success){
                [weakSelf performSelector:@selector(RelaodCallBlockingInfo:) withObject:nil afterDelay:1];
            }else{
                
            }
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            [_blockTableView beginUpdates];
            [_blockTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            [_blockTableView endUpdates];
        }];
    }else if (tableView == _identificationTableView){
        NSString *phone = [arrIdentificationPhones objectAtIndex:row];
        [dicMuIdentification removeObjectForKey:phone];
        arrIdentificationPhones = [dicMuIdentification allKeys];
        
        [self changeIdentificationCompletion:^(BOOL success) {
            if(success){
                [weakSelf performSelector:@selector(RelaodCallIdentificationInfo:) withObject:nil afterDelay:1];
            }else{
                
            }
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            [_identificationTableView beginUpdates];
            [_identificationTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            [_identificationTableView endUpdates];
            
        }];
    }else{
        NSString *phone = [arrIdentificationPhones2 objectAtIndex:row];
        [dicMuIdentification2 removeObjectForKey:phone];
        arrIdentificationPhones2 = [dicMuIdentification2 allKeys];
        
        [self changeIdentification2Completion:^(BOOL success) {
            if(success){
                [weakSelf performSelector:@selector(RelaodCallIdentificationInfo2:) withObject:nil afterDelay:1];
            }else{
                
            }
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            [_identificationTableView2 beginUpdates];
            [_identificationTableView2 deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            [_identificationTableView2 endUpdates];

        }];
    }
}



- (IBAction)pressedAddButton:(id)sender {
    UIButton *bt = (UIButton *)sender;
    
    __weak typeof(self) weakSelf = self;
    if (bt == _addBlockButton) {
        UIAlertControllerStyle style = UIAlertControllerStyleAlert;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"添加黑名单"
                                                                       message:@"\n\n"
                                                                preferredStyle:style];
        
        UITextField * text = [[UITextField alloc] initWithFrame:CGRectMake(15, 54, 240, 30)];
        text.keyboardType = UIKeyboardTypePhonePad;
        text.borderStyle = UITextBorderStyleRoundedRect;
        text.placeholder = @"电话号码(无需要86)";
        [alert.view addSubview:text];
        
        UIAlertAction *ok0Action = [UIAlertAction actionWithTitle:@"添加"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              [self.view endEditing:YES];
                                                              NSString *inputPhone = text.text;
                                                              if (inputPhone != nil && inputPhone.length > 7) {
                                                                  [weakSelf performSelector:@selector(addBlockingWithPhone:) withObject:inputPhone withObject:nil];
                                                              }
                                                          }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action) {
                                                                 [weakSelf.view endEditing:YES];
                                                             }];
        [alert addAction:cancelAction];
        [alert addAction:ok0Action];
        [self presentViewController:alert animated:YES completion:^{}];
    }else if (bt == _addIdentificationButton) {
        UIAlertControllerStyle style = UIAlertControllerStyleAlert;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"添加屏显"
                                                                       message:@"\n\n\n\n"
                                                                preferredStyle:style];
        
        UITextField * text = [[UITextField alloc] initWithFrame:CGRectMake(15, 54, 240, 30)];
        text.keyboardType = UIKeyboardTypePhonePad;
        text.borderStyle = UITextBorderStyleRoundedRect;
        text.placeholder = @"电话号码(无需要86)";
        [alert.view addSubview:text];
        
        UITextField * text2 = [[UITextField alloc] initWithFrame:CGRectMake(15, 90, 240, 30)];
        text2.borderStyle = UITextBorderStyleRoundedRect;
        text2.placeholder = @"显示内容";
        [alert.view addSubview:text2];
        
        UIAlertAction *ok0Action = [UIAlertAction actionWithTitle:@"添加"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              [weakSelf.view endEditing:YES];
                                                              NSString *inputPhone = text.text;
                                                              NSString *inputDesc = text2.text;
                                                              if ((inputPhone != nil && inputPhone.length > 7) && (inputDesc != nil && inputDesc.length > 0)) {
                                                                  [weakSelf performSelector:@selector(addIdentificationWithPhone:desc:) withObject:inputPhone withObject:inputDesc];
                                                              }
                                                          }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action) {
                                                                 [weakSelf.view endEditing:YES];
                                                             }];
        [alert addAction:cancelAction];
        [alert addAction:ok0Action];
        [self presentViewController:alert animated:YES completion:^{}];
    }else if (bt == _addIdentificationButton2){
        UIAlertControllerStyle style = UIAlertControllerStyleAlert;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"添加屏显2"
                                                                       message:@"\n\n\n\n"
                                                                preferredStyle:style];
        
        UITextField * text = [[UITextField alloc] initWithFrame:CGRectMake(15, 54, 240, 30)];
        text.keyboardType = UIKeyboardTypePhonePad;
        text.borderStyle = UITextBorderStyleRoundedRect;
        text.placeholder = @"电话号码(无需要86)";
        [alert.view addSubview:text];
        
        UITextField * text2 = [[UITextField alloc] initWithFrame:CGRectMake(15, 90, 240, 30)];
        text2.borderStyle = UITextBorderStyleRoundedRect;
        text2.placeholder = @"显示内容2";
        [alert.view addSubview:text2];
        
        UIAlertAction *ok0Action = [UIAlertAction actionWithTitle:@"添加"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              [weakSelf.view endEditing:YES];
                                                              NSString *inputPhone = text.text;
                                                              NSString *inputDesc = text2.text;
                                                              if ((inputPhone != nil && inputPhone.length > 7) && (inputDesc != nil && inputDesc.length > 0)) {
                                                                  [weakSelf performSelector:@selector(addIdentification2WithPhone:desc:) withObject:inputPhone withObject:inputDesc];
                                                              }
                                                          }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action) {
                                                                 [weakSelf.view endEditing:YES];
                                                             }];
        [alert addAction:cancelAction];
        [alert addAction:ok0Action];
        [self presentViewController:alert animated:YES completion:^{}];
    }
}

- (void)addBlockingWithPhone:(NSString *)phone{
    __weak typeof(self) weakSelf = self;
    NSString *stringPhone = [self fixPhone:phone];
    if (![arrBlockPhones containsObject:stringPhone]) {
        //添加
        [dicMuBlock setObject:@"phone" forKey:stringPhone];
        arrBlockPhones = [dicMuBlock allKeys];
        
        NSInteger index = [arrBlockPhones indexOfObject:stringPhone];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [_blockTableView beginUpdates];
        [_blockTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [_blockTableView endUpdates];
        
        
        [self changeBlockCompletion:^(BOOL success) {
            if(success){
                [weakSelf performSelector:@selector(RelaodCallBlockingInfo:) withObject:nil afterDelay:1];
            }else{
                
            }
        }];
    }
}

- (void)addIdentificationWithPhone:(NSString *)phone desc:(NSString *)desc{
    __weak typeof(self) weakSelf = self;
    NSString *stringPhone = [self fixPhone:phone];
    if (![arrIdentificationPhones containsObject:stringPhone]) {
        //添加
        [dicMuIdentification setObject:desc forKey:stringPhone];
        arrIdentificationPhones = [dicMuIdentification allKeys];
        
        NSInteger index = [arrIdentificationPhones indexOfObject:stringPhone];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [_identificationTableView beginUpdates];
        [_identificationTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        [_identificationTableView endUpdates];
        
        [self changeIdentificationCompletion:^(BOOL success) {
            if(success){
                [weakSelf performSelector:@selector(RelaodCallIdentificationInfo:) withObject:nil afterDelay:1];
            }else{
                
            }
        }];
    }else{
        //重复
        [dicMuIdentification setObject:desc forKey:stringPhone];
        NSInteger index = [arrIdentificationPhones indexOfObject:stringPhone];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [_identificationTableView beginUpdates];
        [_identificationTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [_identificationTableView endUpdates];
        
        [self changeIdentificationCompletion:^(BOOL success) {
            if(success){
                [weakSelf performSelector:@selector(RelaodCallIdentificationInfo:) withObject:nil afterDelay:1];
            }else{
                
            }
        }];
    }
}

- (void)addIdentification2WithPhone:(NSString *)phone desc:(NSString *)desc{
    __weak typeof(self) weakSelf = self;
    NSString *stringPhone = [self fixPhone:phone];
    if (![arrIdentificationPhones2 containsObject:stringPhone]) {
        //添加
        [dicMuIdentification2 setObject:desc forKey:stringPhone];
        arrIdentificationPhones2 = [dicMuIdentification2 allKeys];
        
        NSInteger index = [arrIdentificationPhones2 indexOfObject:stringPhone];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [_identificationTableView2 beginUpdates];
        [_identificationTableView2 insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        [_identificationTableView2 endUpdates];
        
        [self changeIdentification2Completion:^(BOOL success) {
            if(success){
                [weakSelf performSelector:@selector(RelaodCallIdentificationInfo2:) withObject:nil afterDelay:1];
            }else{
                
            }
        }];
    }else{
        //重复
        [dicMuIdentification2 setObject:desc forKey:stringPhone];
        NSInteger index = [arrIdentificationPhones2 indexOfObject:stringPhone];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [_identificationTableView2 beginUpdates];
        [_identificationTableView2 reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [_identificationTableView2 endUpdates];
        
        [self changeIdentification2Completion:^(BOOL success) {
            if(success){
                [weakSelf performSelector:@selector(RelaodCallIdentificationInfo2:) withObject:nil afterDelay:1];
            }else{
                
            }
        }];
    }
}

- (NSString *)fixPhone:(NSString *)phone{
    NSString *stringPhone = [phone stringByReplacingOccurrencesOfString:@"+" withString:@""];
    stringPhone = [stringPhone stringByReplacingOccurrencesOfString:@" " withString:@""];
    stringPhone = [stringPhone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    stringPhone = [stringPhone stringByReplacingOccurrencesOfString:@"(" withString:@""];
    stringPhone = [stringPhone stringByReplacingOccurrencesOfString:@")" withString:@""];
    if (stringPhone != nil && stringPhone.length > 0) {
        NSString *stringFinal = [NSString stringWithFormat:@"%@%@",([stringPhone hasPrefix:@"86"]?@"":@"86"),stringPhone];
        return stringFinal;
    }
    return stringPhone;
}


- (NSString *)readPathBlock{
    NSURL *fileUrl = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.wintel.OneCallKitDemo"];
    NSString *filePath = [fileUrl.absoluteString substringFromIndex:(@"file://".length)];
    NSString *filePathBlock = [filePath stringByAppendingString:@"Block.plist"];
    return filePathBlock;
    
}

- (NSString *)readPathIdentification{
    NSURL *fileUrl = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.wintel.OneCallKitDemo"];
    NSString *filePath = [fileUrl.absoluteString substringFromIndex:(@"file://".length)];
    NSString *filePathIdentification = [filePath stringByAppendingString:@"Identification.plist"];
    return filePathIdentification;
}

- (NSString *)readPathIdentification2{
    NSURL *fileUrl = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.wintel.OneCallKitDemo"];
    NSString *filePath = [fileUrl.absoluteString substringFromIndex:(@"file://".length)];
    NSString *filePathIdentification2 = [filePath stringByAppendingString:@"Identification2.plist"];
    return filePathIdentification2;
}

- (void)changeBlockCompletion:(void(^)(BOOL success))completion{
    NSString *filePathBlock = [self readPathBlock];
    [[NSFileManager defaultManager] removeItemAtPath:filePathBlock error:nil];
    if (dicMuBlock != nil && [dicMuBlock count]) {
        BOOL success = [dicMuBlock writeToFile:filePathBlock atomically:YES];
        completion(success);
    }else{
        completion(YES);
    }
}

- (void)changeIdentificationCompletion:(void(^)(BOOL success))completion{
    NSString *filePathIdentification = [self readPathIdentification];
    [[NSFileManager defaultManager] removeItemAtPath:filePathIdentification error:nil];
    if (dicMuIdentification != nil && [dicMuIdentification count]) {
        BOOL success = [dicMuIdentification writeToFile:filePathIdentification atomically:YES];
        completion(success);
    }else{
        completion(YES);
    }
}

- (void)changeIdentification2Completion:(void(^)(BOOL success))completion{
    NSString *filePathIdentification2 = [self readPathIdentification2];
    [[NSFileManager defaultManager] removeItemAtPath:filePathIdentification2 error:nil];
    if (dicMuIdentification2 != nil && [dicMuIdentification2 count]) {
        BOOL success = [dicMuIdentification2 writeToFile:filePathIdentification2 atomically:YES];
        completion(success);
    }else{
        completion(YES);
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
