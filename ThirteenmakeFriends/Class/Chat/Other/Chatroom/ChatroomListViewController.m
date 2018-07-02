/************************************************************
  *  * EaseMob CONFIDENTIAL
  * __________________
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
  *
  * NOTICE: All information contained herein is, and remains
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "ChatroomListViewController.h"

#import "EMSearchBar.h"
#import "SRRefreshView.h"
#import "EMSearchDisplayController.h"
//#import "ChatViewController.h"
#import "RealtimeSearchUtil.h"
#import "EMPageResult.h"

@interface ChatroomListViewController ()<UISearchBarDelegate, UISearchDisplayDelegate, SRRefreshDelegate, EMChatManagerDelegate>

@property (nonatomic) NSInteger page;
@property (strong, nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) SRRefreshView *slimeView;
@property (strong, nonatomic) EMSearchBar *searchBar;
@property (strong, nonatomic) EMSearchDisplayController *searchController;
@property (strong, nonatomic) UIButton *nextButton;

@end

@implementation ChatroomListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    // Uncomment the following line to preserve selection between presentations.
    self.title = NSLocalizedString(@"title.chatroomlist",@"chatroom list");

    _page = 0;
    _dataSource = [NSMutableArray array];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.tableHeaderView = self.searchBar;
    [self.tableView addSubview:self.slimeView];
    [self searchController];

    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    backButton.accessibilityIdentifier = @"back";
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    self.nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    [self.nextButton setTitle:@"下一页" forState:UIControlStateNormal];
    [self.nextButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.nextButton setBackgroundColor:[UIColor redColor]];
    [self.nextButton addTarget:self action:@selector(nextPageAction) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = self.nextButton;

    [self reloadDataSource];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    //由于离开页面时可能有大量聊天室对象需要释放，所以把释放操作放到一个独立线程
    if ([self.dataSource count])
    {
        NSMutableArray *chatrooms = self.dataSource;
        self.dataSource = nil;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [chatrooms removeAllObjects];
        });
    }
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

#pragma mark - getter

- (SRRefreshView *)slimeView
{
    if (_slimeView == nil) {
        _slimeView = [[SRRefreshView alloc] init];
        _slimeView.delegate = self;
        _slimeView.upInset = 0;
        _slimeView.slimeMissWhenGoingBack = YES;
        _slimeView.slime.bodyColor = [UIColor grayColor];
        _slimeView.slime.skinColor = [UIColor grayColor];
        _slimeView.slime.lineWith = 1;
        _slimeView.slime.shadowBlur = 4;
        _slimeView.slime.shadowColor = [UIColor grayColor];
    }

    return _slimeView;
}

- (UISearchBar *)searchBar
{
    if (_searchBar == nil) {
        _searchBar = [[EMSearchBar alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 44)];
        if (@available(iOS 11.0, *)) { // ios11 searchbar高度
            _searchBar.height = 56;
        } else {
            _searchBar.height = 44;
        }
        _searchBar.delegate = self;
        _searchBar.placeholder = NSLocalizedString(@"search", @"Search");
        _searchBar.backgroundColor = [UIColor colorWithRed:0.747 green:0.756 blue:0.751 alpha:1.000];
    }

    return _searchBar;
}

- (EMSearchDisplayController *)searchController
{
    if (_searchController == nil) {
        _searchController = [[EMSearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
        _searchController.delegate = self;
        _searchController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        __weak ChatroomListViewController *weakSelf = self;
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            static NSString *CellIdentifier = @"ContactListCell";
            BaseTableViewCell *cell = (BaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

            // Configure the cell...
            if (cell == nil) {
                cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }

            EMChatroom *chatroom = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
            NSString *imageName =  @"groupPublicHeader";
            cell.imageView.image = [UIImage imageNamed:imageName];
            cell.textLabel.text = chatroom.chatroomSubject;

            return cell;
        }];

        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return 50;
        }];

        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [weakSelf.searchController.searchBar endEditing:YES];

            EMChatroom *myChatroom = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];
//            ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:myChatroom.chatroomId conversationType:eConversationTypeChatRoom];
//            chatController.title = myChatroom.chatroomSubject;
//            [weakSelf.navigationController pushViewController:chatController animated:YES];
        }];
    }

    return _searchController;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GroupCell";
    BaseTableViewCell *cell = (BaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    // Configure the cell...
    if (cell == nil) {
        cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    EMChatroom *chatroom = [self.dataSource objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"groupPublicHeader"];
    if ([chatroom.chatroomSubject length]) {
        cell.textLabel.text = chatroom.chatroomSubject;
    }
    else {
        cell.textLabel.text = chatroom.chatroomId;
    }

    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    EMChatroom *myChatroom = [self.dataSource objectAtIndex:indexPath.row];
//    ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:myChatroom.chatroomId conversationType:eConversationTypeChatRoom];
//    chatController.title = myChatroom.chatroomSubject;
//    [self.navigationController pushViewController:chatController animated:YES];
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];

    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    __weak typeof(self) weakSelf = self;
    [[RealtimeSearchUtil currentUtil] realtimeSearchWithSource:self.dataSource searchText:(NSString *)searchText collationStringSelector:@selector(chatroomSubject) resultBlock:^(NSArray *results) {
        if (results) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.searchController.resultsSource removeAllObjects];
                [weakSelf.searchController.resultsSource addObjectsFromArray:results];
                [weakSelf.searchController.searchResultsTableView reloadData];
            });
        }
    }];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];

//    [[EaseMob sharedInstance].chatManager asyncSearchPublicGroupWithGroupId:searchBar.text completion:^(EMGroup *group, EMError *error) {
//        if (!error) {
//            [self.searchController.resultsSource removeAllObjects];
//            [self.searchController.resultsSource addObject:group];
//            [self.searchController.searchResultsTableView reloadData];
//        }
//    } onQueue:nil];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [[RealtimeSearchUtil currentUtil] realtimeSearchStop];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

#pragma mark - UISearchDisplayDelegate

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    self.tableView.tableHeaderView = nil;
    self.tableView.tableHeaderView = self.searchBar;
}

#pragma mark - SRRefreshDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_slimeView scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_slimeView scrollViewDidEndDraging];
}

- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    [self reloadDataSource];
    [_slimeView endRefresh];
}

#pragma mark - data

- (void)loadDataWithPage:(NSInteger)aPage
{
    [self hideHud];
    [self showHudInView:self.view hint:NSLocalizedString(@"loadData", @"Load data...")];
    
    __weak typeof(self) weakSelf = self;
    [[EaseMob sharedInstance].chatManager asyncFetchChatroomsFromServerWithPage:aPage pageSize:10 completion:^(EMPageResult *result, EMError *error) {
        ChatroomListViewController *strongSelf = weakSelf;
        if (!error && strongSelf) {
            if (strongSelf.page == 1) {
                [strongSelf.dataSource removeAllObjects];
            }
            
            if (result.count == 0 || result.count < 10) {
                strongSelf.tableView.tableFooterView = nil;
            } else if (strongSelf.tableView.tableFooterView == nil) {
                strongSelf.tableView.tableFooterView = strongSelf.nextButton;
            }
            
            [strongSelf hideHud];
            [strongSelf.dataSource addObjectsFromArray:result.list];
            [strongSelf.tableView reloadData];
        }
    }];
}

- (void)nextPageAction
{
    ++self.page;
    [self loadDataWithPage:self.page];
}

- (void)reloadDataSource
{
    self.page = 1;
    [self loadDataWithPage:self.page];
}

- (void)beKickedOutFromChatroom:(EMChatroom *)leavedChatroom reason:(EMChatroomBeKickedReason)reason
{
    if (reason != eChatroomBeKickedReason_Destroyed)
    {
        return;
    }

    [self.dataSource enumerateObjectsUsingBlock:^(EMChatroom *chatroom, NSUInteger idx, BOOL *stop){
        if ([leavedChatroom.chatroomId isEqualToString:chatroom.chatroomId])
        {
            [self.dataSource removeObjectAtIndex:idx];
            *stop = YES;
        }
    }];
    [self.tableView reloadData];
}

@end
