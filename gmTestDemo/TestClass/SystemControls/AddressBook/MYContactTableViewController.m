//
//  MYContactTableViewController.m
//  test
//
//  Created by lemonmgy on 2016/11/10.
//  Copyright © 2016年 lemonmgy. All rights reserved.
//

#import "MYContactTableViewController.h"
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>

@interface MYContactTableViewController ()

@end

@implementation MYContactTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor redColor];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuseIdentifier"];
//    [self loadPerson];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    return cell;
}

- (void)loadPerson
{
    
    if (1) {
        //判断授权状态
        if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusNotDetermined) {
            
            CNContactStore *store = [[CNContactStore alloc] init];
            [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (granted) {
                    NSLog(@"授权成功");
                    // 2. 获取联系人仓库
                    CNContactStore * store = [[CNContactStore alloc] init];
                    
                    // 3. 创建联系人信息的请求对象
                    NSArray * keys = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
                    
                    // 4. 根据请求Key, 创建请求对象
                    CNContactFetchRequest * request = [[CNContactFetchRequest alloc] initWithKeysToFetch:keys];
                    
                    // 5. 发送请求
                    [store enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
                        
                        // 6.1 获取姓名
                        NSString * givenName = contact.givenName;
                        NSString * familyName = contact.familyName;
                        NSLog(@"%@--%@", givenName, familyName);
                        
                        // 6.2 获取电话
                        NSArray * phoneArray = contact.phoneNumbers;
                        for (CNLabeledValue * labelValue in phoneArray) {
                            
                            CNPhoneNumber * number = labelValue.value;
                            NSLog(@"%@--%@", number.stringValue, labelValue.label);
                        }
                    }];
                } else {
                    NSLog(@"授权失败");
                }
            }];
        }


}
}
@end
