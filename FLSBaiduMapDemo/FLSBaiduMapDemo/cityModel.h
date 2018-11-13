//
//  cityModel.h
//  baiduMaptest
//
//  Created by zhixian on 16/3/31.
//  Copyright © 2016年 zhixian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaiduMapHeader.h"
@interface cityModel : NSObject

@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *address;
@property(nonatomic,assign)CLLocationCoordinate2D location;

@end
