//
//  DeviceInfo.m
//  WiseTV
//
//  Created by Ran on 14-10-20.
//  Copyright (c) 2014年 tjgdMobilez. All rights reserved.
//

#import "DeviceInfo.h"
#import <sys/utsname.h>

@implementation DeviceInfo

+ (instancetype)info {
    static dispatch_once_t onceToken;
    static DeviceInfo * info = nil;
    dispatch_once(&onceToken, ^{
        info = [[self alloc] initInfo];
    });
    return info;
}

- (instancetype)init {
    NSAssert(NO, @"Singleton class, use shared method");
    return nil;
}

- (id)initInfo {
    self = [super init];
    if (!self) return nil;
    return self;
}

+ (NSDictionary*)deviceNamesByCode {
    static NSDictionary* deviceNamesByCode = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        deviceNamesByCode = @{
                              @"iPhone3,1" :[NSNumber numberWithInteger:iPhone4],
                              @"iPhone4,1" :[NSNumber numberWithInteger:iPhone4S],
                              @"iPhone5,1" :[NSNumber numberWithInteger:iPhone5],
                              @"iPhone5,2" :[NSNumber numberWithInteger:iPhone5],
                              @"iPhone5,3" :[NSNumber numberWithInteger:iPhone5C],
                              @"iPhone5,4" :[NSNumber numberWithInteger:iPhone5C],
                              @"iPhone6,1" :[NSNumber numberWithInteger:iPhone5S],
                              @"iPhone7,2" :[NSNumber numberWithInteger:iPhone6],
                              @"iPhone7,1" :[NSNumber numberWithInteger:iPhone6Plus],
                              @"i386"      :[NSNumber numberWithInteger:Simulator],
                              @"x86_64"    :[NSNumber numberWithInteger:Simulator]
                              };
    });
    
    return deviceNamesByCode;
}

- (void)gatherDeviceInfomation {
    self.screenBounds = [UIScreen mainScreen].bounds;
    self.screenSize = self.screenBounds.size;
    self.screenWidth = self.screenSize.width;
    self.screenHeight = self.screenSize.height;
    self.systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *code = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    self.deviceVersion = (DeviceVersion)[[DeviceInfo deviceNamesByCode][code] integerValue];
    
    if (StringEqual(code, @"x86_64") || StringEqual(code, @"i386")) {
        code = @"Simulator";
    }
    self.deviceName = code;
}

@end
