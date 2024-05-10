//
//  ViewController.m
//  objc
//
//  Created by Dev on 17/04/2024.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)buttonAction:(UIButton *)sender {
    //NSLog(@"hi");
    self.label.text = @"Welcome";
}
@end
