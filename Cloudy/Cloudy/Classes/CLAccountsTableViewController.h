//
//  CLAccountsTableViewController.h
//  Cloudy
//
//  Created by Parag Dulam on 23/10/12.
//  Copyright (c) 2012 Parag Dulam. All rights reserved.
//

#import "CLBaseViewController.h"

@interface CLAccountsTableViewController : CLBaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *accountsTableView;
    NSMutableArray *accounts;
}
@end
