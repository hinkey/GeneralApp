#import "AppUserInfo.h"
#import "NSString+UAExtension.h"
//#import "LibraryManager.h"

static AppUserInfo *userInstance = nil;

@interface AppUserInfo ()
{
    NSLock *_accessLock;
}

@end

@implementation AppUserInfo

@synthesize needsAutoLogin = _needsAutoLogin;
@synthesize name = _name;
@synthesize codeTime = _codeTime;
@synthesize nick = _nick;
@synthesize gatewayArray = _gatewayArray;
@synthesize selectedIndex = _selectedIndex;
@synthesize groupInfoArray = _groupInfoArray;
@synthesize subDeviceData = _subDeviceData;

+ (AppUserInfo *)userInfo
{
    if (userInstance) {
        return userInstance;
    }
    
    userInstance = [[AppUserInfo alloc]init];
    
    return userInstance;
}

#pragma mark - Singleton

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized (self) {
        if (userInstance == nil) {
            userInstance = [super allocWithZone:zone];
            return userInstance;
        }
    }
    return nil;
}

- (id)init
{
    @synchronized(self) {
        self = [super init];
        if (self) {
            _selectedIndex = 8;
            _accessLock = [[NSLock alloc]init];
        }
        return self;
    }
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

#pragma mark - Properties

- (NSString *)name
{
    return getUserDefaults(@"login_name");
}

- (void)setName:(NSString *)name
{
    NSString *key = @"login_name";
    if ([name isKindOfClass:[NSString class]]) {
        setUserDefaults(key, name);
    } else {
        setUserDefaults(key, @"");
    }
    // 写入文件
    saveUserDefaults();
}

- (NSString *)registerName
{
    return getUserDefaults(@"register_name");
}

- (void)setRegisterName:(NSString *)name
{
    NSString *key = @"register_name";
    if ([name isKindOfClass:[NSString class]]) {
        setUserDefaults(key, name);
    } else {
        setUserDefaults(key, @"");
    }
    
    // 写入文件
    saveUserDefaults();
}

- (NSString *)password
{
    return getUserDefaults(@"login_password");
}

- (void)setEmail:(NSString *)email
{
    _email = ([email isEmailFormat]?email:@"");
}

- (void)setMobile:(NSString *)mobile
{
    _mobile = ([mobile isMobileFormat]?mobile:@"");
}

- (NSInteger)codeTime
{
    if (self.registerName) {
        NSString *key = [NSString stringWithFormat:@"%@_codetime",self.registerName];
        _codeTime = [getUserDefaults(key) integerValue];
        return _codeTime;
    }
    
    return 0;
}

- (void)setPassword:(NSString *)password
{
    NSString *key = @"login_password";
    if ([password isKindOfClass:[NSString class]]) {
        setUserDefaults(key, password);
    } else {
        setUserDefaults(key, @"");
    }
    // 写入文件
    saveUserDefaults();
}

- (NSString *)nick
{
    NSString *key = [NSString stringWithFormat:@"%@_nick", self.userId];
    NSString *nick = getUserDefaults(key);
    
    // 如果没有设置昵称，那么就默认显示登录名
    if (!checkClass(nick, NSString) || nick.length == 0) {
        [self setNick:self.name];
    }
    
    return nick;
}

- (void)setNick:(NSString *)nick
{
    NSString *key = [NSString stringWithFormat:@"%@_nick", self.userId];
    setUserDefaults(key, nick);
    saveUserDefaults();
}

- (BOOL)needsAutoLogin
{
    if ([self.name isKindOfClass:[NSString class]] && self.name.length > 0) {
        NSString *key = [NSString stringWithFormat:@"%@_autologin", self.name];
        NSString *object = getUserDefaults(key);
        return [object boolValue];
    }
    
    return NO;
}

- (void)setNeedsAutoLogin:(BOOL)needs
{
    _needsAutoLogin = needs;
    
    NSString *key = [NSString stringWithFormat:@"%@_autologin", self.name];
    NSString *object = needs?@"1":@"0";
    setUserDefaults(key, object);
    saveUserDefaults();
}

- (NSString *)userId
{
    return getUserDefaults(@"last_userid");
}

- (void)setUserId:(NSString *)userId
{
    if (!userId) {
        userId = @"";
    }
    
    setUserDefaults(@"last_userid", userId);
    saveUserDefaults();
}

- (NSArray *)groups
{
    NSString *key = [NSString stringWithFormat:@"%@_groups", self.userId];
    return getUserDefaults(key);
}

- (void)setGroups:(NSArray *)groups
{
    if (self.userId == nil) {
        return;
    }
    
    NSString *key = [NSString stringWithFormat:@"%@_groups", self.userId];
    NSArray *groupArray = @[];
    if (checkClass(groups, NSArray)) {
        if (self.userId) {
            NSMutableArray *mArray = [NSMutableArray array];
            for (NSDictionary *item in groups) {
                NSString *creator = [NSString stringWithFormat:@"%@", [item objectForKey:@"Creator"]];
                if ([creator isEqualToString:self.userId]) {
                    // 我是创建者
                    [mArray addObject:item];
                }
            }
            self.groupsOfMine = mArray;
        }
        groupArray = groups;
    }
    
    setUserDefaults(key, groupArray);
    saveUserDefaults();
}

- (NSArray *)groupsOfMine
{
    NSString *key = [NSString stringWithFormat:@"%@_groupsofmine", self.userId];
    return getUserDefaults(key);
}

- (void)setGroupsOfMine:(NSArray *)groups
{
    NSString *key = [NSString stringWithFormat:@"%@_groupsofmine", self.userId];
    NSArray *groupArray = @[];
    if (checkClass(groups, NSArray)) {
        groupArray = groups;
    }
    
    setUserDefaults(key, groupArray);
    saveUserDefaults();
}

- (NSArray*)gatewayArray
{
    NSString *key = [NSString stringWithFormat:@"%@_gateway", self.userId];
    return getUserDefaults(key);
}

- (void)setGatewayArray:(NSArray *)array
{
    NSString *key = [NSString stringWithFormat:@"%@_gateway", self.userId];
    NSArray *object = @[];
    if (checkClass(array, NSArray)) {
        object = array;
    }
    
    setUserDefaults(key, object);
    saveUserDefaults();
}

- (NSString *)gatewayId
{
    NSString *key = [NSString stringWithFormat:@"%@_gatewayid", self.userId];
    return getUserDefaults(key);
}

- (void)setGatewayId:(NSString *)gatewayId
{
    NSString *key = [NSString stringWithFormat:@"%@_gatewayid", self.userId];
    NSString *object = @"";
    if (checkClass(gatewayId, NSString)) {
        object = gatewayId;
    }
    
    setUserDefaults(key, object);
    saveUserDefaults();
    
    if (object.length > 0) {
        // 启用该设备
        [self enableDevice:gatewayId];
    }
}

//- (NSArray *)gatewayArrayOfInvalidate
//{
//    NSString *key = [NSString stringWithFormat:@"%@_gatewayofinvalidate", self.userId];
//    return getUserDefaults(key);
//}
//
//- (void)setGatewayArrayOfInvalidate:(NSArray *)array
//{
//    NSString *key = [NSString stringWithFormat:@"%@_gatewayofinvalidate", self.userId];
//    NSArray *object = @[];
//    if (checkClass(array, NSArray)) {
//        object = array;
//    }
//
//    setUserDefaults(key, object);
//    saveUserDefaults();
//}

- (NSInteger)selectedIndex
{
    NSString *gatewayId = self.gatewayId;
    if (gatewayId && gatewayId.length == 16) {
        gatewayId = [gatewayId substringFromIndex:gatewayId.length - 6];
        NSString *key = [NSString stringWithFormat:@"%@%@_selectedindex", self.userId, gatewayId];
        NSString *index = getUserDefaults(key);
        if (!index || index.length == 0) {
            [self setSelectedIndex:8];
        } else {
            return [getUserDefaults(key) integerValue];
        }
    }
    
    return _selectedIndex;
}

- (void)setSelectedIndex:(NSInteger)index
{
    index = (index < 0)?0:index;
    index = (index > 8)?8:index;
    
    NSString *gatewayId = self.gatewayId;
    if (gatewayId && gatewayId.length == 16) {
        gatewayId = [gatewayId substringFromIndex:gatewayId.length - 6];
        NSString *key = [NSString stringWithFormat:@"%@%@_selectedindex", self.userId, gatewayId];
        
        setUserDefaults(key, [NSNumber numberWithInteger:index]);
        saveUserDefaults();
    } else {
        _selectedIndex = index;
    }
}

- (NSArray *)groupInfoArray
{
    NSString *gatewayId = self.gatewayId;
    if (gatewayId && gatewayId.length == 16) {
        gatewayId = [gatewayId substringFromIndex:gatewayId.length - 6];
        NSString *key = [NSString stringWithFormat:@"%@%@_groupinfoarray", self.userId, gatewayId];
        _groupInfoArray = getUserDefaults(key);
    }
    
    if (_groupInfoArray == nil || _groupInfoArray.count != 9) {
        _groupInfoArray = @[@{@"plot":@[],@"device":@[],@"name":@"分组一"},   // 0
                            @{@"plot":@[],@"device":@[],@"name":@"分组二"},   // 1
                            @{@"plot":@[],@"device":@[],@"name":@"分组三"},   // 2
                            @{@"plot":@[],@"device":@[],@"name":@"分组四"},   // 3
                            @{@"plot":@[],@"device":@[],@"name":@"分组五"},   // 4
                            @{@"plot":@[],@"device":@[],@"name":@"分组六"},   // 5
                            @{@"plot":@[],@"device":@[],@"name":@"分组七"},   // 6
                            @{@"plot":@[],@"device":@[],@"name":@"分组八"},   // 7
                            @{@"plot":@[],@"device":@[],@"name":@"所有灯饰"}]; // 8 all plots and devices
        _selectedIndex = 8;
    }
    
    return _groupInfoArray;
}

- (void)setGroupInfoArray:(NSArray *)data
{
    NSString *gatewayId = self.gatewayId;
    if (gatewayId && gatewayId.length == 16) {
        gatewayId = [gatewayId substringFromIndex:gatewayId.length - 6];
        NSString *key = [NSString stringWithFormat:@"%@%@_groupinfoarray", self.userId, gatewayId];
        
        if (checkClass(data, NSArray) && data.count == 9) {
            _groupInfoArray = data;
        } else {
            _groupInfoArray = @[];
        }
        
        setUserDefaults(key, data);
        saveUserDefaults();
    } else {
        _groupInfoArray = @[];
    }
}

- (NSDictionary *)subDeviceData
{
    if (_subDeviceData) {
        @autoreleasepool
        {
            [_accessLock lock];
            NSDictionary *copy = [[NSDictionary alloc]initWithDictionary:_subDeviceData];
            [_accessLock unlock];
            
            return copy;
        }
    }
    
    return _subDeviceData;
}

- (void)setSubDeviceData:(NSDictionary *)data
{
    [_accessLock lock];
    
    _subDeviceData = data;
    
    [_accessLock unlock];
}

#pragma mark - Out Method

- (NSInteger)getCodeTimeWithName:(NSString *)name
{
    if (name && checkClass(name, NSString)) {
        NSString *key = [NSString stringWithFormat:@"%@_codetime", name];
        return [getUserDefaults(key) integerValue];
    }
    
    return 0;
}

- (void)recordCodeTime
{
    if ([self.registerName isKindOfClass:[NSString class]] && self.registerName.length > 0) {
        NSString *key = [NSString stringWithFormat:@"%@_codetime",self.registerName];
        NSInteger currentTime = [[NSDate date]timeIntervalSince1970];
        setUserDefaults(key, [NSNumber numberWithInteger:currentTime]);
        saveUserDefaults();
    }
}

- (void)clearCodeTime
{
    NSString *key = [NSString stringWithFormat:@"%@_codetime",self.registerName];
    setUserDefaults(key, [NSNumber numberWithInteger:0]);
    saveUserDefaults();
}

// 添加一个设备（网关）
- (BOOL)addDeviceId:(NSDictionary *)dict
{
    for (NSDictionary *item in self.gatewayArray) {
        NSString *gatewayId = [item objectForKey:@"did"];
        if ([gatewayId isEqualToString:[dict objectForKey:@"did"]]) {
            return NO;
        }
    }
    
    // 添加新设备
    NSMutableArray *muteArray = nil;
    if (self.gatewayArray) {
        muteArray = [NSMutableArray arrayWithArray:self.gatewayArray];
    } else {
        muteArray = [NSMutableArray array];
    }
    
    [muteArray addObject:dict];
    self.gatewayArray = muteArray;
    
    return YES;
}

// 删除一个设备
- (void)removeDeviceId:(NSString *)deviceId
{
    if (!deviceId || deviceId.length < 7) {
        return;
    }
    
    [self disableDevice:deviceId];
    
    BOOL needsToDel = NO;
    // 从网关列表里面移除
    for (NSString *item in self.gatewayArray) {
        if ([item isEqualToString:deviceId]) {
            needsToDel = YES;
        }
    }
    
    if (needsToDel) {
        NSMutableArray *muteArray = [NSMutableArray arrayWithArray:self.gatewayArray];
        [muteArray removeObject:deviceId];
        self.gatewayArray = muteArray;
    }
    
    // 从所有组里面移除
    int index = 0;
    NSArray *myGroups = [NSArray arrayWithArray:self.groupsOfMine];
    for (NSDictionary *group in myGroups) {
        NSArray *devids = [group objectForKey:@"Devids"];
        
        BOOL find = NO;
        for (NSDictionary *item in devids) {
            NSString *did = [item objectForKey:@"did"];
            if ([deviceId isEqualToString:did]) {
                find = YES;
                break;
            }
        }
        
        if (find) {
            NSMutableArray *marray = [NSMutableArray arrayWithArray:self.groups];
            [marray replaceObjectAtIndex:index withObject:group];
            self.groups = marray;
        }
        
        index ++;
    }
}

// 启用一个设备
- (void)enableDevice:(NSString *)deviceId
{
    if (!checkClass(self.gatewayArrayOfInvalidate, NSArray) ||
        !checkClass(deviceId, NSString) ||
        deviceId.length < 7)
    {
        return;
    }
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.gatewayArrayOfInvalidate];
    for (int i = 0; i < array.count; i ++) {
        NSString *gatewayId = array[i];
        if ([gatewayId isEqualToString:deviceId]) {
            [array removeObject:gatewayId];
            break;
        }
    }
    
    self.gatewayArrayOfInvalidate = array;
}

// 禁用一个设备
- (void)disableDevice:(NSString *)deviceId
{
    if (!checkClass(deviceId, NSString) || deviceId.length < 7) {
        return;
    }
    
    for (NSString *item in self.gatewayArrayOfInvalidate) {
        if ([item isEqualToString:deviceId]) {
            return;
        }
    }
    
    // 记录无效设备
    NSMutableArray *muteArray = nil;
    if (self.gatewayArrayOfInvalidate) {
        muteArray = [NSMutableArray arrayWithArray:self.gatewayArrayOfInvalidate];
    } else {
        muteArray = [NSMutableArray array];
    }
    [muteArray addObject:deviceId];
    self.gatewayArrayOfInvalidate = muteArray;
}

- (NSArray *)getGatewayOfMine
{
    if (checkClass(self.gatewayArray, NSArray)) {
        NSMutableArray *deviceArray = [NSMutableArray arrayWithArray:self.gatewayArray];
        for (NSDictionary *item in self.groups) {
            NSString *creator = [NSString stringWithFormat:@"%@", [item objectForKey:@"Creator"]];
            if (![creator isEqualToString:self.userId]) {
                // 不是我的组
                NSArray *deviceIds = [item objectForKey:@"Devids"];
                for (NSDictionary *deviceInfo in deviceIds) {
                    NSString *deviceId = [deviceInfo objectForKey:@"did"];
                    [deviceArray removeObject:deviceId];
                }
            }
        }
        
        return deviceArray;
    }
    
    return nil;
}

- (void)removeGatewaysWith:(NSDictionary *)group
{
    // 剔除该组的网关
    NSMutableArray *gateArray = nil;
    if (group && self.gatewayArray) {
        gateArray = [NSMutableArray arrayWithArray:self.gatewayArray];
        NSArray *groupDevices = [group objectForKey:@"Devids"];
        for (NSDictionary *item in groupDevices) {
            NSString *deviceId = [NSString stringWithFormat:@"%@",[item objectForKey:@"did"]];
            for (NSString *theid in self.gatewayArray) {
                if ([theid isEqualToString:deviceId]) {
                    // 有该组的Id,移除
                    [gateArray removeObject:theid];
                    
                    // 如果该Id为当前Id
                    if ([self.gatewayId isEqualToString:theid]) {
                        self.gatewayId = nil;
                        self.groupInfoArray = nil;
                    }
                }
            }
        }
        
        // 更新网关
        self.gatewayArray = gateArray;
        
        if (!self.gatewayId || self.gatewayId.length > 0) {
            if (checkClass(self.gatewayArray, NSArray) && self.gatewayArray.count > 0) {
                self.gatewayId = self.gatewayArray[0];
            }
        }
    }
}

- (void)removeGroupWithId:(NSString *)groupId
{
    NSMutableArray *groups = nil;
    if (self.groups) {
        groups = [NSMutableArray arrayWithArray:self.groups];
        for (NSDictionary *item in self.groups) {
            NSString *gid = [NSString stringWithFormat:@"%@",[item objectForKey:@"Gid"]];
            if ([gid isEqualToString:groupId]) {
                [groups removeObject:item];
            }
        }
    }
    self.groups = groups;
    
    if (self.groupsOfMine) {
        groups = [NSMutableArray arrayWithArray:self.groupsOfMine];
        for (NSDictionary *item in self.groupsOfMine) {
            NSString *gid = [NSString stringWithFormat:@"%@",[item objectForKey:@"Gid"]];
            if ([gid isEqualToString:groupId]) {
                [groups removeObject:item];
            }
        }
    }
    self.groupsOfMine = groups;
}

@end
