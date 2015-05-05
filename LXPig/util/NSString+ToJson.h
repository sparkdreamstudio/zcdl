//
//  NSString+ToJson.h
//  LXPig
//
//  Created by leexiang on 15/5/1.
//
//

#import <Foundation/Foundation.h>

@interface NSString (ToJson)
+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary;

+(NSString *) jsonStringWithArray:(NSArray *)array;

+(NSString *) jsonStringWithString:(NSString *) string;

+(NSString *) jsonStringWithObject:(id) object;

+(void) jsonTest;
@end
