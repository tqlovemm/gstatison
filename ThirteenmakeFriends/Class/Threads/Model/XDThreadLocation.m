//
//  XDThreadLocation.m
//  ThirteenmakeFriends
//
//  Created by Xudongdong on 16/9/27.
//  Copyright © 2016年 ThirtyOneDay. All rights reserved.
//

#import "XDThreadLocation.h"

@implementation XDThreadLocation

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static XDThreadLocation *instance;
    
    // dispatch_once是线程安全的，onceToken默认为0
    static dispatch_once_t onceToken;
    // dispatch_once宏可以保证块代码中的指令只会被执行一次
    dispatch_once(&onceToken, ^{
        // 永远只执行一次，instance只会被实例化一次
        instance = [super allocWithZone:zone];
    });
    
    return instance;
}

+ (id)sharedInstance {
    return [[self alloc]init];
}

/******************************************** 定位 *****************************************************/

- (CLLocationManager *)locManager {
    
    // 判断定位服务是否可用，非常有用
    if(![CLLocationManager locationServicesEnabled]) return nil;
    
    if (!_locManager) {
        // 创建定位管理器
        _locManager = [[CLLocationManager alloc]init];
        // 设置代理
        _locManager.delegate = self;
        // 设置允许后台定位参数，保持不会被系统挂起
        [_locManager setPausesLocationUpdatesAutomatically:NO];
    }
    return _locManager;
}

- (CLGeocoder *)geoCoder {
    if (_geoCoder == nil) {
        _geoCoder = [[CLGeocoder alloc]init];
    }
    return _geoCoder;
}
//==========================================================

#pragma mark -  启动跟踪定位
- (void)start{
    
    [[self locManager] startUpdatingLocation];
    
    //在ios 8.0下要授权
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        
        [self.locManager requestWhenInUseAuthorization];  //调用了这句,就会弹出允许框了.
    }
}

#pragma mark - 停止定位服务
- (void)stop {
    
    [[self locManager] stopUpdatingLocation];
}

/**
 *  获取到用户位置调用
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    // 取得位置对象
    CLLocation * loc = [locations firstObject];
    // 取得经纬度
    //    CLLocationCoordinate2D coordinate = loc.coordinate;
    self.coordinate = loc.coordinate;
    
    [self.geoCoder reverseGeocodeLocation:loc completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error) {
            NSLog(@"定位发生错误，重新定位");
        } else {
            CLPlacemark *pm = [placemarks firstObject];
            NSLog(@"定位信息--%@",pm);
            NSString *country = pm.country;
            NSString *province = pm.administrativeArea;
            NSString *city = pm.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = pm.administrativeArea;
                
            } else {
                
            }
            
            // 赋值定位信息
            self.country = country;
            self.province = province;
            self.city = city;
            self.district = pm.subLocality;
        }
        
        // 回调
        if (self.locationOperation) {
            self.locationOperation();
        }
        
    }];
    
    // 停止定位(省电)
    [self stop];
}



+ (XDThreadLocation *)getLocationInfo {
    return [[self alloc]init];
}

- (BOOL)locationAvailable {
    if (self.province) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)isLocationServiceOpen {
    if ([ CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        return NO;
    } else
        return YES;
}

@end
