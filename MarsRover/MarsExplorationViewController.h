//
//  ViewController.h
//  MarsRover
//
//  Created by bobo on 12-5-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RoversController;
@class RoversControllerInterpreter;
@class PlateauGridView;

@interface MarsExplorationViewController : UIViewController <UITextFieldDelegate>
{
    IBOutlet UIImageView *_plateauView;
    IBOutlet UITextField *_instructionField;
    //IBOutlet UIButton    *_overviewButton;
    
    PlateauGridView      *_plateauGridView;
    
    CGRect  _plateauViewOriginalFrame;
    CGPoint _plateauViewBeginPoint;
    
    NSMutableArray       *_roverViewList;
    NSUInteger           _currentRoverViewIndex;
    
    RoversController            *_roversController;
    RoversControllerInterpreter *_rcInterpreter; 
    
    NSMutableArray      *_roverStateTrackList;
}
@property (retain, nonatomic) RoversController* roversController;

//Implement the protocol UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
-(void)textFieldDidBeginEditing:(UITextField *)textField;
-(void)textFieldDidEndEditing:(UITextField *)textField;
-(BOOL)textFieldShouldReturn:(UITextField *)textField;

@end
