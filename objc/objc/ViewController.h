//
//  ViewController.h
//  objc
//
//  Created by Dev on 17/04/2024.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *label;

@property (weak, nonatomic) IBOutlet UIButton *button;

- (IBAction)buttonAction:(UIButton *)sender;

@end

