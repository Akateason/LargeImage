//
//  RootCtrl.m
//  Teason
//
//  Created by ; on 14-8-21.
//  Copyright (c) 2014年 TEASON. All rights reserved.
//

#import "RootCtrl.h"
#import "XTlibConfig.h"

@interface RootCtrl ()

@end


@implementation RootCtrl

- (void)prepare {
    // prepare when initial
}

- (void)prepareUI {
    // prepare UI
}

#pragma mark--
#pragma mark - Life

- (void)dealloc {
    xt_LOG_DEBUG(@"xt : dealloc --- %@\n -----", NSStringFromClass(self.class));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    xt_LOG_DEBUG(@"xt WARN : didReceiveMemoryWarning --- %@\n -----", NSStringFromClass(self.class));
}

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self) {
        [self prepare];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self prepare];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self prepare];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customTitle];
    [self prepareUI];
    xt_LOG_DEBUG(@"xt : viewDidLoad --- %@", NSStringFromClass(self.class)) ;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([XTlibConfig sharedInstance].isShowControllerLifeCycle) {xt_LOG_DEBUG(@"xt : viewWillAppear --- %@", NSStringFromClass(self.class))};
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([XTlibConfig sharedInstance].isShowControllerLifeCycle) {xt_LOG_DEBUG(@"xt : viewWillDisappear --- %@", NSStringFromClass(self.class))};
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([XTlibConfig sharedInstance].isShowControllerLifeCycle) {xt_LOG_DEBUG(@"xt : viewDidAppear --- %@", NSStringFromClass(self.class))};
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if ([XTlibConfig sharedInstance].isShowControllerLifeCycle) {xt_LOG_DEBUG(@"xt : viewDidDisappear --- %@", NSStringFromClass(self.class))};
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if ([XTlibConfig sharedInstance].isShowControllerLifeCycle) {xt_LOG_DEBUG(@"xt : viewWillLayoutSubviews --- %@", NSStringFromClass(self.class))};
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if ([XTlibConfig sharedInstance].isShowControllerLifeCycle) {xt_LOG_DEBUG(@"xt : viewDidLayoutSubviews --- %@", NSStringFromClass(self.class))};
}

#pragma mark--
#pragma mark - prop

- (NSString *)customTitle {
    if (!_customTitle) _customTitle = self.title;
    return _customTitle;
}

@end
