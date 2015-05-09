//
//  LXPIGDefine.h
//  LXPig
//
//  Created by leexiang on 15/4/11.
//
//

#ifndef LXPig_LXPIGDefine_h
#define LXPig_LXPIGDefine_h


#pragma mark -http server & api url-
#define SERVER_URL @"http://203.93.210.77:9504/zcdl/api"
#define SERVICE_USER    @"userservice.do"
#define SERVICE_MEMBER @"memberservice.do"
#define SERVICE_PRODUCT @"productservice.do"
#define SERVICE_ENTERPRISE @"enterpriseservice.do"
#define SERVICE_CODESERVICE @"codeservice.do"
#define SERVICE_VISIT @"visitservice.do"
#define SERVICE_COMMENT @"commentservice.do"
#define SERVICE_CART    @"cartservice.do"
#define SERVICE_SHIPADDRESS @"shipaddressservice.do"
#define SERVICE_AREAR @"arearservice.do"
#define SERVICE_ORDER @"orderservice.do"
#define SERVICE_MESSAGE @"messageservice.do"
#define SERVICE_PAPER @"paperservice.do"
#define SERVICE_PROBLEM @"problemservice.do"
#define SERVICE_SERVICE @"serservice.do"



#pragma mark -ui value-
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#define NavigationBarColor [UIColor colorWithRed:0xcf/255.f green:0 blue:0x0d/255.f alpha:1]
#define TextGrayColor   [UIColor colorWithRed:0x61/255.f green:0x61/255.f blue:0x61/255.f alpha:1]

#define IOS_SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#pragma mark -image name-
#define BackButtomImageName @"common_back"

#pragma mark -notification name-
#define NTF_SETORDERADDRESS @"NTF_SETORDERADDRESS"
#define NTF_ADD_ORDER @"NTF_CHANGE_ORDER_INFO"
#define NTF_REMOVE_ORDER        @"NTF_REMOVE_ORDER"
#endif
