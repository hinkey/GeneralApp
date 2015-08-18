#import <Foundation/Foundation.h>
#import "Constants.h"

@interface AppUserInfo : NSObject

// 登录名 (邮箱或者手机号)
@property (nonatomic, assign) NSString *name;

// 注册名 (邮箱或者手机号)，用于注册使用
@property (nonatomic, assign) NSString *registerName;

// 登录密码
@property (nonatomic, assign) NSString *password;

// Token
@property (nonatomic, strong) NSString *token;

// 用户ID
@property (nonatomic, strong) NSString *userId;

// 所有用户组(http服务器上的分组)
@property (nonatomic, strong) NSArray *groups;

// 我创建的用户组
@property (nonatomic, strong) NSArray *groupsOfMine;

// 昵称
@property (nonatomic, strong) NSString *nick;

// 性别
@property (nonatomic, strong) NSString *sex;

// 生日
@property (nonatomic, strong) NSString *birth;

// 邮箱
@property (nonatomic, strong) NSString *email;

// 手机号码
@property (nonatomic, strong) NSString *mobile;

// 当前登录状态
@property (nonatomic, assign) BOOL isLogin;

// 是否需要自动登录
@property (nonatomic, assign) BOOL needsAutoLogin;

// 验证码时间
@property (nonatomic, readonly) NSInteger codeTime;

// 网关列表
@property (nonatomic, strong) NSArray *gatewayArray;

// 所有子设备数据
@property (nonatomic, strong) NSDictionary *subDeviceData;

// 当前网关 ID
@property (nonatomic, strong) NSString *gatewayId;

// 不接收消息的网关 ID
@property (nonatomic, strong) NSArray *gatewayArrayOfInvalidate;

// 选中的网关分组号（被记录到本地）
@property (nonatomic, assign) NSInteger selectedIndex;

// 所有网关组分组筛选，按照组号排序 (每一个item中，plot为当前组的策略，device为当前组的设备, name为名称)
@property (nonatomic, strong) NSArray *groupInfoArray;

+ (AppUserInfo *)userInfo;

// For verify code
- (NSInteger)getCodeTimeWithName:(NSString *)name;

// 记录下获取验证码的时间
- (void)recordCodeTime;

// 清理获取验证码的时间
- (void)clearCodeTime;

// 添加一个设备（网关）
- (BOOL)addDeviceId:(NSDictionary *)dict;

// 删除一个设备
- (void)removeDeviceId:(NSString *)deviceId;

// 禁用一个设备（网关）
- (void)disableDevice:(NSString *)deviceId;

// 获取我添加的网关
- (NSArray *)getGatewayOfMine;

// 从网关列表中移除指定组的网关Id
- (void)removeGatewaysWith:(NSDictionary *)group;

// 从缓存中移除指定组
- (void)removeGroupWithId:(NSString *)groupId;

@end
