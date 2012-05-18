//
//  ViewController.h
//  MarsRover
//
//  Created by bobo on 12-5-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MarsExplorationViewController : UIViewController <UITextFieldDelegate>
{
    IBOutlet UIImageView *_plateauView;
    IBOutlet UITextField *_instructionField;
    IBOutlet UIButton    *_overviewButton;
    
    CGRect  _plateauViewOriginalFrame;
    CGPoint _plateauViewBeginPoint;
    
    NSMutableArray *_roverViewsList;
}

//@property (nonatomic, retain) UIImageView *plateauView;
//@property (nonatomic, retain) UITextField *instructionField;

//Implement the protocol UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField;
-(void)textFieldDidEndEditing:(UITextField *)textField;
-(BOOL)textFieldShouldReturn:(UITextField *)textField;

@end
