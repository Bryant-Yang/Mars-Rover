//
//  ReportViewController.h
//  MarsRover
//
//  Created by Bo on 12-5-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportViewController : UIViewController
{
    NSString *_roversStates;
    
    IBOutlet UITextView *_roversStatesView;
}
@property (assign, nonatomic) NSString* roversStates;
@end
