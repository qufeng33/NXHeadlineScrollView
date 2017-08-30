//
//  ViewController.m
//  NXHeadlineScrollViewDemo
//
//  Created by 蒋瞿风 on 16/7/27.
//  Copyright © 2016年 nightx. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < 5; i++) {
        
        NSAttributedString *string = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"这是第%@个头条",[NSNumber numberWithInt:i]] attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
        [array addObject:string];
    }
    self.headlineView.style = HeadlineStyleTwoLine;
    self.headlineView.titleArray   = array;
    self.headlineView.showLeftView = YES;
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)changeLeftWithWidth:(UISlider *)sender{
    self.headlineView.leftViewWidth = sender.value;
}

@end
