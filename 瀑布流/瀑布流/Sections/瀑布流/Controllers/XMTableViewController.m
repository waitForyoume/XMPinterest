//
//  XMTableViewController.m
//  瀑布流
//
//  Created by 街路口等你 on 17/6/14.
//  Copyright © 2017年 街路口等你. All rights reserved.
//

#import "XMTableViewController.h"
#import "XMCollectionViewController.h"

@interface XMTableViewController ()

@property (nonatomic, strong) NSArray *positionArray;
@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation XMTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    self.title = @"瀑布流";
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if ([self isViewLoaded] && !self.view.window) {
        self.view = nil;
    }
}

// MARK: - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    
    cell.textLabel.text = self.titleArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:16 weight:5.0f];
    cell.textLabel.textColor = [UIColor purpleColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    XMCollectionViewController *collectionView = [[XMCollectionViewController alloc] init];
    collectionView.location = self.positionArray[indexPath.row];
    
    [self.navigationController pushViewController:collectionView animated:YES];
}

- (NSArray *)positionArray {
    if (!_positionArray) {
        self.positionArray = @[@"6393", @"6508", @"6395", @"6452", @"6510", @"6625", @"21458", @"3806", @"15640", @"14143", @"154004", @"8970"];
    }
    return _positionArray;
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        self.titleArray = @[@"云南丽江古城游记鉴赏", @"大理古城游记鉴赏", @"束河古镇游记鉴赏", @"玉龙雪山游记鉴赏", @"洱海游记鉴赏", @"普达措森林公园游记鉴赏", @"西湖游记鉴赏", @"青海湖游记鉴赏", @"敦煌月牙泉游记鉴赏", @"凤凰古城游记鉴赏", @"婺源游记鉴赏", @"九寨沟游记鉴赏"];
    }
    return _titleArray;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
