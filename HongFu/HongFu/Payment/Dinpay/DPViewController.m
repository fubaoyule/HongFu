//
//  DPViewController.m
//  DinpayPurse
//
//  Created by yangliang on 14-4-10.
//  Copyright (c) 2014年 yangliang. All rights reserved.
//

#import "DPViewController.h"

@interface DPViewController ()
{
    
}
@end

@implementation DPViewController

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
    [self registerForKeyboardNotifications];
    self.view.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1.0];
    [self.navigationController.navigationBar setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor whiteColor]}];
    _originY = self.view.frame.origin.y;
    
    
}

//- (BOOL)shouldAutorotate{
//    return NO;
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)dealloc
{
    //    [[NSNotificationCenter defaultCenter] removeObserver:self
    //                                                    name:UIKeyboardDidShowNotification
    //                                                  object:nil];
    //
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillChangeFrameNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}


///**
// *
// *     键盘的出现的NSNotification
// *
// *
// */
//- (void)keyboardWasShown:(NSNotification*)nc
//{
//
//
//}

- (void)keyboardWillChangeFrame:(NSNotification*)nc
{
    
    NSDictionary* dic = [nc userInfo];
    CGRect kbRect = [[dic objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    if (kbRect.origin.y >= [[UIScreen mainScreen]bounds].size.height) {
        return;
    }
    _isKeyboardShow = YES;
    _keybardY = [[UIScreen mainScreen]bounds].size.height  -kbRect.size.height;
    if ([[UIDevice currentDevice]systemVersion].doubleValue>=7.0) {
        _keybardY -= 64;
    }
    _riseHeight = _originY - self.view.frame.origin.y;
    CGFloat curY = self.currentFieldRect.origin.y + self.currentFieldRect.size.height -_riseHeight;
    if (_keybardY < curY) {
        _riseHeight = curY - _keybardY ;
        
        [UIView beginAnimations:@"rise" context:nil];
        [UIView setAnimationDuration:0.35];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-_riseHeight, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    
}
/**
 *
 *     键盘的将要隐藏的NSNotification
 *
 *
 */
- (void)keyboardWillBeHidden:(NSNotification*)nc
{
    _isKeyboardShow = NO;
    CGFloat temp = self.view.frame.origin.y;
    if (temp != _originY) {
        [UIView beginAnimations:@"drop" context:nil];
        [UIView setAnimationDuration:0.35];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        
        self.view.frame =  CGRectMake(self.view.frame.origin.x, _originY, self.view.frame.size.width, self.view.frame.size.height);
        
        [UIView commitAnimations];
    }
}
/**
 *
 *     注册键盘的监听事件
 *
 *
 */
- (void)registerForKeyboardNotifications
{
    //    [[NSNotificationCenter defaultCenter] addObserver:self
    //                                             selector:@selector(keyboardWasShown:)
    //                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChangeFrame:)
                                                 name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


@end
