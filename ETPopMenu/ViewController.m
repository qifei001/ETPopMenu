//
//  ViewController.m
//  ETPopMenu
//
//  Created by Flameliu liu on 2024/7/15.
//

#import "ViewController.h"
#import "ETPopMenuManager.h"

@interface ViewController () <ETPopMenuViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"test";
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"right" style:UIBarButtonItemStylePlain target:self action:@selector(onClick:)];
    self.navigationItem.rightBarButtonItem = item;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"click" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(100, 100, 200, 100);
    [self.view addSubview:button];
}

- (void)onClick:(id)sender {
    ETPopMenuManager *manager = [ETPopMenuManager defaultManager];
    manager.actions = @[
        [[ETPopMenuDefaultAction alloc] initWithTitle:@"123" image:[UIImage imageNamed:@"Heart"] color:UIColor.yellowColor],
        [[ETPopMenuDefaultAction alloc] initWithTitle:@"456" image:[UIImage imageNamed:@"Download"] color:nil],
        [[ETPopMenuDefaultAction alloc] initWithTitle:@"789" image:nil color:UIColor.blueColor didSelect:^(id<ETPopMenuAction>  _Nonnull action) {
            NSLog(@"action: %@ -------------- click", action.title);
        }],
    ];
    manager.popMenuShouldDismissOnSelection = sender == self.navigationItem.rightBarButtonItem;
    manager.popMenuDelegate = self;
    [manager presentFromSourceView:sender];
}

// MARK: ETPopMenuViewControllerDelegate
- (void)et_popMenuDidSelectItem:(ETPopMenuViewController *)popMenuViewController atIndex:(NSInteger)index {
    NSLog(@"click -------------- %ld", index);
}

@end
