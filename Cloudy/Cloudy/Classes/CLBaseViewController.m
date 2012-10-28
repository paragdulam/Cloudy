//
//  CLBaseViewController.m
//  Cloudy
//
//  Created by Parag Dulam on 23/10/12.
//  Copyright (c) 2012 Parag Dulam. All rights reserved.
//

#import "CLBaseViewController.h"
#import "AppDelegate.h"

@interface CLBaseViewController ()

@end

@implementation CLBaseViewController

-(AppDelegate *) appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication ]delegate];
}


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
    self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:30.f/255.f green:30.f/255.f blue:30.f/255.f alpha:1.f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
