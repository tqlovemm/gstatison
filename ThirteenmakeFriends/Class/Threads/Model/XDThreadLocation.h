//
//  XDThreadLocation.h
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/9/27.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void (^LocationSeviceOperation)(void);

@interface XDThreadLocation : NSObject<CLLocationManagerDelegate>
/** 国家*/
@property (copy, nonatomic) NSString * country;
/** 省份*/
@property (copy, nonatomic) NSString * province;
/** 城市*/
@property (copy, nonatomic) NSString * city;
/** 区/县*/
@property (copy, nonatomic) NSString * district;

@property (nonatomic, strong) CLLocationManager *locManager;
@property (nonatomic, strong) CLGeocoder *geoCoder;

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

/** 定位成功回调*/
@property (nonatomic, copy) LocationSeviceOperation locationOperation;

+ (instancetype)sharedInstance;

/**
 *  获取定位信息
 */
+ (XDThreadLocation *)getLocationInfo;


#pragma mark -  启动跟踪定位
- (void)start;

#pragma mark - 停止定位服务
- (void)stop;

#pragma mark - 是否定位成功
- (BOOL)locationAvailable;

+ (BOOL)isLocationServiceOpen;

@end
