//
//  ViewController.m
//  MVVMWithoutRAC
//
//  Created by ssdd on 15/10/14.
//  Copyright © 2015年 ssdd. All rights reserved.
//

#import "ViewController.h"
#import "SDViewModel.h"
typedef NS_ENUM(NSInteger,GainStauts) {
    Succeed = 1,
    Proccessing,
    Failed,
    Cancel,
};

@interface ViewController ()
@property (nonatomic) SDViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UIButton *getDataButton;
@end

@implementation ViewController
#pragma mark - life cycle
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self handleViewModelUpdate];
}
- (void)dealloc {
    NSLog(@"dealloc");
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //离开页面时取消正在进行请求与当前的kvo
    [self.viewModel cancel];
    [self.KVOController unobserve:self.viewModel];
    
}

#pragma mark - delegates

#pragma mark - notifications

#pragma mark - event response
- (IBAction)getDataAction:(UIButton *)sender {
    [self.viewModel execute:@"10086"];
    
}

- (IBAction)cancel:(UIButton *)sender {
    [self.viewModel cancel];
}

#pragma mark - public methods

#pragma mark - private methods
/**
 *  监听model的变化
 */
- (void)handleViewModelUpdate {
    __weak typeof(self) weakSelf = self;
    
    [self.KVOController observe:self.viewModel keyPath:@"followCommand.result" options:NSKeyValueObservingOptionInitial| NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        
        id newValue = change[NSKeyValueChangeNewKey];
        NSLog(@"%@",newValue);
        
        if ([newValue isKindOfClass:[SDCommandResult class]]) {
            SDCommandResult *result = (SDCommandResult *)newValue;
            NSLog(@"%@",result.content);
            NSLog(@"%@",result.error);
            if (result.error) {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"获取状态" message:result.error.domain delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
                return ;
            }
            if (result.content) {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"获取状态" message:((NSArray *)result.content).description delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
            }
            
        }
    }];
    [self.KVOController observe:self.viewModel keyPath:@"followCommand.executing" options:NSKeyValueObservingOptionInitial| NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        __strong typeof(self) strongSelf = weakSelf;
        
        id newValue = change[NSKeyValueChangeNewKey];
        NSLog(@"%@",newValue);
        if (newValue && newValue != [NSNull null]) {
            GainStauts status = [newValue integerValue];
            switch (status) {
                case Succeed: {
                    [strongSelf.getDataButton setTitle:@"成功!" forState:UIControlStateNormal];
                    strongSelf.getDataButton.enabled = YES;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [strongSelf.getDataButton setTitle:@"再次获取" forState:UIControlStateNormal];
                        
                    });
                    break;
                }
                case Proccessing: {
                    [strongSelf.getDataButton setTitle:@"获取中..." forState:UIControlStateNormal];
                    strongSelf.getDataButton.enabled = NO;
                    break;
                }
                case Failed: {
                    [strongSelf.getDataButton setTitle:@"失败了!" forState:UIControlStateNormal];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        strongSelf.getDataButton.enabled = YES;
                        [strongSelf.getDataButton setTitle:@"获取数据" forState:UIControlStateNormal];
                        
                    });
                    
                    break;
                }
                case Cancel: {
                    [strongSelf.getDataButton setTitle:@"取消了!" forState:UIControlStateNormal];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        strongSelf.getDataButton.enabled = YES;
                        [strongSelf.getDataButton setTitle:@"获取数据" forState:UIControlStateNormal];
                        
                    });
                    
                    break;
                }
                default: {
                    
                    break;
                }
            }
        }
        
    }];
}

#pragma mark - getters and setters
- (SDViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[SDViewModel alloc]init];
    }
    return _viewModel;
}
@end
