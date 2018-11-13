//
//  BaiduMapHeader.h
//  FLSBaiduMapDemo
//
//  Created by 天立泰 on 2018/9/7.
//  Copyright © 2018年 天立泰. All rights reserved.
//

#ifndef BaiduMapHeader_h
#define BaiduMapHeader_h
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件
#import <BMKLocationkit/BMKLocationComponent.h>

#define widthScale ([UIScreen mainScreen].bounds.size.width/375.0f)
#define heightScale ([UIScreen mainScreen].bounds.size.height/667.0f)
#define BMKMapVersion @"百度地图iOS SDK 4.2"
//屏幕宽度
#define KScreenWidth  ([UIScreen mainScreen].bounds.size.width)
//屏幕高度
#define KScreenHeight ([UIScreen mainScreen].bounds.size.height)
//状态栏高度
#define KStatuesBarHeight  ([UIApplication sharedApplication].statusBarFrame.size.height)
//导航栏高度
#define KNavigationBarHeight 44.0
//导航栏高度+状态栏高度
#define kViewTopHeight (KStatuesBarHeight + KNavigationBarHeight)
//iphoneX适配差值
#define KiPhoneXSafeAreaDValue ([[UIApplication sharedApplication] statusBarFrame].size.height>20?34:0)

#define COLOR(rgbValue)     [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kHeight_SegMentBackgroud  60
#define kHeight_BottomControlView  60
#define kHeight_BottomControlView  60

#endif /* BaiduMapHeader_h */
