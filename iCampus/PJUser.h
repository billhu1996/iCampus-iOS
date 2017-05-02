

#import <Foundation/Foundation.h>

@interface PJUser : NSObject
/**
 *  当前用户
 *
 */
+(PJUser *)currentUser;


/***************用户属性*****************/

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *last_login_date;

/**
 *  保存用户信息
 */
-(void)save;
/**
 *  删除当前用户
 */
+(void)logOut;
@end
