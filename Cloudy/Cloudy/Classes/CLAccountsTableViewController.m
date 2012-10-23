//
//  CLAccountsTableViewController.m
//  Cloudy
//
//  Created by Parag Dulam on 23/10/12.
//  Copyright (c) 2012 Parag Dulam. All rights reserved.
//

#import "CLAccountsTableViewController.h"

@interface CLAccountsTableViewController ()

@end

@implementation CLAccountsTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    CGRect rect = self.view.frame;
//    rect.size.width -= 40.f;
//    self.view.frame = rect;
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont boldSystemFontOfSize:20.f];
    titleLabel.text = @"Accounts";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel sizeToFit];
    CGRect titleLabelFrame = titleLabel.frame;
    titleLabelFrame.size.width += 40.f;
    titleLabel.frame = titleLabelFrame;
    
    [self.navigationItem setTitleView:titleLabel];
    
    accountsTableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                     style:UITableViewStyleGrouped];
    accountsTableView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    
    
    accountsTableView.dataSource = self;
    accountsTableView.delegate = self;
    [self.view addSubview:accountsTableView];
    
    accounts = [[NSMutableArray alloc] initWithObjects:@"Dropbox",@"SkyDrive", nil];
    [accountsTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"CELL"];
    }
    [cell.textLabel setText:[accounts objectAtIndex:indexPath.section]];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [accounts count];
}

@end
