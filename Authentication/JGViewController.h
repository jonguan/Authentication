//
//  JGViewController.h
//  Authentication
//
//  Created by Jon Guan on 4/11/14.
//  Copyright (c) 2014 Scanadu, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGViewController : UIViewController <NSURLConnectionDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *certOneButton;
@property (weak, nonatomic) IBOutlet UIButton *certTwoButton;

- (IBAction)didClickButton:(UIButton *)sender;


@end
