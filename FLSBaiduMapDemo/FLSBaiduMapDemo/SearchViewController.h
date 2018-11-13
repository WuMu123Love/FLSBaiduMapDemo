//
//  SearchViewController.h
//  FLSBaiduMapDemo
//
//  Created by 天立泰 on 2018/9/7.
//  Copyright © 2018年 天立泰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaiduMapHeader.h"
@interface SearchViewController : UIViewController
@property(nonatomic,copy)void(^backLocationBlick)(CLLocationCoordinate2D location);


@end
