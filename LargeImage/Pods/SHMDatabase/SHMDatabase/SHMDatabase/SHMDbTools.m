//
//  SHMDbTools.m
//  SHMDatabase
//
//  Created by teason23 on 2018/10/25.
//  Copyright © 2018年 teason23. All rights reserved.
//

#import "SHMDbTools.h"
#import <objc/runtime.h>

@implementation SHMDbTools

@end

@implementation NSObject (SHMDbTools_Reflection)

- (NSString *)className {
    return NSStringFromClass([self class]);
}

- (NSString *)superClassName {
    return NSStringFromClass([self superclass]);
}

+ (NSString *)className {
    return NSStringFromClass([self class]);
}

+ (NSString *)superClassName {
    return NSStringFromClass([self superclass]);
}

- (NSDictionary *)propertyDictionary {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    unsigned int outCount;
    Class        cls = [self class];
    while (1) {
        objc_property_t *props = class_copyPropertyList(cls, &outCount);
        for (int i = 0; i < outCount; i++) {
            objc_property_t prop = props[i];
            NSString *      propName =
            [[NSString alloc] initWithCString:property_getName(prop)
                                     encoding:NSUTF8StringEncoding];
            id propValue = [self valueForKey:propName];
            [dict setObject:propValue ?: [NSNull null] forKey:propName];
        }
        free(props);
        cls = [cls superclass];
        if ([NSStringFromClass(cls)
             isEqualToString:NSStringFromClass([NSObject class])]) {
            break;
        }
    }
    return dict;
}

- (NSArray *)propertyKeys {
    return [[self class] propertyKeys];
}

+ (NSArray *)propertyKeys {
    unsigned int     propertyCount = 0;
    objc_property_t *properties    = class_copyPropertyList(self, &propertyCount);
    NSMutableArray *propertyNames  = [NSMutableArray array];
    for (unsigned int i = 0; i < propertyCount; ++i) {
        objc_property_t property = properties[i];
        const char *    name     = property_getName(property);
        [propertyNames addObject:[NSString stringWithUTF8String:name]];
    }
    free(properties);
    return propertyNames;
}

- (NSArray *)propertiesInfo {
    return [[self class] propertiesInfo];
}

+ (NSArray *)propertiesInfo {
    NSMutableArray *propertieArray = [NSMutableArray array];
    unsigned int     propertyCount;
    objc_property_t *properties =
    class_copyPropertyList([self class], &propertyCount);
    for (int i = 0; i < propertyCount; i++) {
        [propertieArray addObject:({
            
            NSDictionary *dictionary =
            [self dictionaryWithProperty:properties[i]];
            
            dictionary;
        })];
    }
    
    free(properties);
    return propertieArray;
}

+ (NSDictionary *)propertiesInfoDict {
    NSMutableDictionary *propertieDic = [NSMutableDictionary dictionary];
    unsigned int     propertyCount;
    objc_property_t *properties =
    class_copyPropertyList([self class], &propertyCount);
    for (int i = 0; i < propertyCount; i++) {
        NSDictionary *tmpDic = [self dictionaryWithProperty:properties[i]];
        [propertieDic setObject:tmpDic forKey:tmpDic[@"name"]];
    }
    free(properties);
    return propertieDic;
}

+ (NSString *)iosTypeWithPropName:(NSString *)name {
    return [self propertiesInfoDict][name][@"type"];
}

+ (NSArray *)propertiesWithCodeFormat {
    NSMutableArray *array = [NSMutableArray array];
    
    NSArray *properties = [[self class] propertiesInfo];
    
    for (NSDictionary *item in properties) {
        NSMutableString *format = ({
            
            NSMutableString *formatString =
            [NSMutableString stringWithFormat:@"@property "];
            // attribute
            NSArray *attribute = [item objectForKey:@"attribute"];
            attribute          = [attribute
                                  sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                                      return [obj1 compare:obj2 options:NSNumericSearch];
                                  }];
            if (attribute && attribute.count > 0) {
                NSString *attributeStr = [NSString
                                          stringWithFormat:@"(%@)",
                                          [attribute componentsJoinedByString:@", "]];
                
                [formatString appendString:attributeStr];
            }
            
            // type
            NSString *type = [item objectForKey:@"type"];
            if (type) {
                [formatString appendString:@" "];
                [formatString appendString:type];
            }
            
            // name
            NSString *name = [item objectForKey:@"name"];
            if (name) {
                [formatString appendString:@" "];
                [formatString appendString:name];
                [formatString appendString:@";"];
            }
            
            formatString;
        });
        
        [array addObject:format];
    }
    
    return array;
}

- (NSArray *)methodList {
    u_int           count;
    NSMutableArray *methodList = [NSMutableArray array];
    Method *methods            = class_copyMethodList([self class], &count);
    for (int i = 0; i < count; i++) {
        SEL       name    = method_getName(methods[i]);
        NSString *strName = [NSString stringWithCString:sel_getName(name)
                                               encoding:NSUTF8StringEncoding];
        [methodList addObject:strName];
    }
    free(methods);
    return methodList;
}

- (NSArray *)methodListInfo {
    u_int           count;
    NSMutableArray *methodList = [NSMutableArray array];
    Method *methods            = class_copyMethodList([self class], &count);
    for (int i = 0; i < count; i++) {
        NSMutableDictionary *info = [NSMutableDictionary dictionary];
        
        Method method = methods[i];
        SEL name = method_getName(method);
        int argumentsCount = method_getNumberOfArguments(method);
        const char *encoding = method_getTypeEncoding(method);
        const char *returnType = method_copyReturnType(method);
        
        NSMutableArray *arguments = [NSMutableArray array];
        for (int index = 0; index < argumentsCount; index++) {
            char *arg = method_copyArgumentType(method, index);
            [arguments addObject:[[self class] decodeType:arg]];
        }
        
        NSString *returnTypeString = [[self class] decodeType:returnType];
        NSString *encodeString     = [[self class] decodeType:encoding];
        NSString *nameString       = [NSString stringWithCString:sel_getName(name)
                                                        encoding:NSUTF8StringEncoding];
        
        [info setObject:arguments forKey:@"arguments"];
        [info setObject:[NSString stringWithFormat:@"%d", argumentsCount]
                 forKey:@"argumentsCount"];
        [info setObject:returnTypeString forKey:@"returnType"];
        [info setObject:encodeString forKey:@"encode"];
        [info setObject:nameString forKey:@"name"];
        [methodList addObject:info];
    }
    free(methods);
    return methodList;
}

+ (NSArray *)methodList {
    u_int           count;
    NSMutableArray *methodList = [NSMutableArray array];
    Method *methods            = class_copyMethodList([self class], &count);
    for (int i = 0; i < count; i++) {
        SEL       name    = method_getName(methods[i]);
        NSString *strName = [NSString stringWithCString:sel_getName(name)
                                               encoding:NSUTF8StringEncoding];
        [methodList addObject:strName];
    }
    free(methods);
    
    return methodList;
}

+ (NSArray *)registedClassList {
    NSMutableArray *result = [NSMutableArray array];
    
    unsigned int count;
    Class *      classes = objc_copyClassList(&count);
    for (int i = 0; i < count; i++) {
        [result addObject:NSStringFromClass(classes[i])];
    }
    free(classes);
    [result sortedArrayUsingSelector:@selector(compare:)];
    
    return result;
}

- (NSDictionary *)protocolList {
    return [[self class] protocolList];
}

+ (NSDictionary *)protocolList {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    unsigned int count;
    Protocol *__unsafe_unretained *protocols =
    class_copyProtocolList([self class], &count);
    for (int i = 0; i < count; i++) {
        Protocol *protocol = protocols[i];
        
        NSString *protocolName =
        [NSString stringWithCString:protocol_getName(protocol)
                           encoding:NSUTF8StringEncoding];
        
        NSMutableArray *superProtocolArray = ({
            
            NSMutableArray *array = [NSMutableArray array];
            
            unsigned int superProtocolCount;
            Protocol *__unsafe_unretained *superProtocols =
            protocol_copyProtocolList(protocol, &superProtocolCount);
            for (int ii = 0; ii < superProtocolCount; ii++) {
                Protocol *superProtocol = superProtocols[ii];
                
                NSString *superProtocolName =
                [NSString stringWithCString:protocol_getName(superProtocol)
                                   encoding:NSUTF8StringEncoding];
                
                [array addObject:superProtocolName];
            }
            free(superProtocols);
            
            array;
        });
        
        [dictionary setObject:superProtocolArray forKey:protocolName];
    }
    free(protocols);
    
    return dictionary;
}

+ (NSArray *)instanceVariable {
    unsigned int    outCount;
    Ivar *          ivars  = class_copyIvarList([self class], &outCount);
    NSMutableArray *result = [NSMutableArray array];
    for (int i = 0; i < outCount; i++) {
        NSString *type = [[self class] decodeType:ivar_getTypeEncoding(ivars[i])];
        NSString *name = [NSString stringWithCString:ivar_getName(ivars[i])
                                            encoding:NSUTF8StringEncoding];
        NSString *ivarDescription =
        [NSString stringWithFormat:@"%@ %@", type, name];
        [result addObject:ivarDescription];
    }
    free(ivars);
    return result.count ? [result copy] : nil;
}

- (BOOL)hasPropertyForKey:(NSString *)key {
    objc_property_t property = class_getProperty([self class], [key UTF8String]);
    return (BOOL)property;
}

- (BOOL)hasIvarForKey:(NSString *)key {
    Ivar ivar = class_getInstanceVariable([self class], [key UTF8String]);
    return (BOOL)ivar;
}

+ (NSDictionary *)dictionaryWithProperty:(objc_property_t)property {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    NSString *propertyName =
    [NSString stringWithCString:property_getName(property)
                       encoding:NSUTF8StringEncoding];
    [result setObject:propertyName forKey:@"name"];
    
    NSMutableDictionary *attributeDictionary = ({
        
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        
        unsigned int               attributeCount;
        objc_property_attribute_t *attrs =
        property_copyAttributeList(property, &attributeCount);
        
        for (int i = 0; i < attributeCount; i++) {
            NSString *name = [NSString stringWithCString:attrs[i].name
                                                encoding:NSUTF8StringEncoding];
            NSString *value = [NSString stringWithCString:attrs[i].value
                                                 encoding:NSUTF8StringEncoding];
            [dictionary setObject:value forKey:name];
        }
        
        free(attrs);
        
        dictionary;
    });
    
    NSMutableArray *attributeArray = [NSMutableArray array];
    
    /***
     https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html#//apple_ref/doc/uid/TP40008048-CH101-SW6
     */
    
    // R
    if ([attributeDictionary objectForKey:@"R"]) {
        [attributeArray addObject:@"readonly"];
    }
    // C
    if ([attributeDictionary objectForKey:@"C"]) {
        [attributeArray addObject:@"copy"];
    }
    //&
    if ([attributeDictionary objectForKey:@"&"]) {
        [attributeArray addObject:@"strong"];
    }
    // N
    if ([attributeDictionary objectForKey:@"N"]) {
        [attributeArray addObject:@"nonatomic"];
    }
    else {
        [attributeArray addObject:@"atomic"];
    }
    // G<name>
    if ([attributeDictionary objectForKey:@"G"]) {
        [attributeArray
         addObject:[NSString
                    stringWithFormat:@"getter=%@", [attributeDictionary objectForKey:@"G"]]];
    }
    // S<name>
    if ([attributeDictionary objectForKey:@"S"]) {
        [attributeArray
         addObject:[NSString
                    stringWithFormat:@"setter=%@", [attributeDictionary objectForKey:@"G"]]];
    }
    // D
    if ([attributeDictionary objectForKey:@"D"]) {
        [result setObject:[NSNumber numberWithBool:YES] forKey:@"isDynamic"];
    }
    else {
        [result setObject:[NSNumber numberWithBool:NO] forKey:@"isDynamic"];
    }
    // W
    if ([attributeDictionary objectForKey:@"W"]) {
        [attributeArray addObject:@"weak"];
    }
    // P
    if ([attributeDictionary objectForKey:@"P"]) {
        // TODO:P | The property is eligible for garbage collection.
    }
    // T
    if ([attributeDictionary objectForKey:@"T"]) {
        /*
         https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
         */
        
        NSDictionary *typeDic = @{
                                  @"c" : @"char",
                                  @"i" : @"int",
                                  @"s" : @"short",
                                  @"l" : @"long",
                                  @"q" : @"long long",
                                  @"C" : @"unsigned char",
                                  @"I" : @"unsigned int",
                                  @"S" : @"unsigned short",
                                  @"L" : @"unsigned long",
                                  @"Q" : @"unsigned long long",
                                  @"f" : @"float",
                                  @"d" : @"double",
                                  @"B" : @"BOOL",
                                  @"v" : @"void",
                                  @"*" : @"char *",
                                  @"@" : @"id",
                                  @"#" : @"Class",
                                  @":" : @"SEL",
                                  };
        NSString *key = [attributeDictionary objectForKey:@"T"];
        id type_str = [typeDic objectForKey:key];
        if (type_str == nil) {
            if ([[key substringToIndex:1] isEqualToString:@"@"] &&
                [key rangeOfString:@"?"].location == NSNotFound) {
                type_str = [[key substringWithRange:NSMakeRange(2, key.length - 3)]
                            stringByAppendingString:@"*"];
            }
            else if ([[key substringToIndex:1] isEqualToString:@"^"]) {
                id str = [typeDic objectForKey:[key substringFromIndex:1]];
                
                if (str) {
                    type_str = [NSString stringWithFormat:@"%@ *", str];
                }
            }
            else {
                type_str = @"unknow";
            }
        }
        
        [result setObject:type_str forKey:@"type"];
    }
    
    [result setObject:attributeArray forKey:@"attribute"];
    
    return result;
}

+ (NSString *)decodeType:(const char *)cString {
    if (!strcmp(cString, @encode(char)))
        return @"char";
    if (!strcmp(cString, @encode(int)))
        return @"int";
    if (!strcmp(cString, @encode(short)))
        return @"short";
    if (!strcmp(cString, @encode(long long)))
        return @"long long";
    if (!strcmp(cString, @encode(long)))
        return @"long";
    if (!strcmp(cString, @encode(unsigned char)))
        return @"unsigned char";
    if (!strcmp(cString, @encode(unsigned int)))
        return @"unsigned int";
    if (!strcmp(cString, @encode(unsigned short)))
        return @"unsigned short";
    if (!strcmp(cString, @encode(unsigned long long)))
        return @"unsigned long long";
    if (!strcmp(cString, @encode(unsigned long)))
        return @"unsigned long";
    if (!strcmp(cString, @encode(float)))
        return @"float";
    if (!strcmp(cString, @encode(double)))
        return @"double";
    if (!strcmp(cString, @encode(bool)))
        return @"bool";
    if (!strcmp(cString, @encode(_Bool)))
        return @"_Bool";
    if (!strcmp(cString, @encode(void)))
        return @"void";
    if (!strcmp(cString, @encode(char *)))
        return @"char *";
    if (!strcmp(cString, @encode(id)))
        return @"id";
    if (!strcmp(cString, @encode(Class)))
        return @"class";
    if (!strcmp(cString, @encode(SEL)))
        return @"SEL";
    if (!strcmp(cString, @encode(BOOL)))
        return @"BOOL";
    
    NSString *result =
    [NSString stringWithCString:cString encoding:NSUTF8StringEncoding];
    if ([[result substringToIndex:1] isEqualToString:@"@"] &&
        [result rangeOfString:@"?"].location == NSNotFound) {
        result = [[result substringWithRange:NSMakeRange(2, result.length - 3)]
                  stringByAppendingString:@"*"];
    }
    else {
        if ([[result substringToIndex:1] isEqualToString:@"^"]) {
            result = [NSString
                      stringWithFormat:@"%@ *",
                      [NSString decodeType:[[result substringFromIndex:1]
                                            cStringUsingEncoding:
                                            NSUTF8StringEncoding]]];
        }
    }
    return result;
}

@end


@implementation NSDate (SHMDbTools_Tick)

+ (long long)shmdb_getNowTick {
    return [[NSDate date] shmdb_getTick];
}

- (long long)shmdb_getTick {
    NSTimeInterval timeInterval2 = [self timeIntervalSince1970];
    long long time               = (long long)((double)timeInterval2 * kUnitConversion);
    //    NSLog(@"shmdb_tick :%lld",time) ;
    return time;
}

+ (long long)shmdb_getTickWithDateStr:(NSString *)dateStr
                            format:(NSString *)format {
    return [[self shmdb_getDateWithStr:dateStr format:format] shmdb_getTick];
}

+ (NSComparisonResult)shmdb_compareTick:(long long)tick1 and:(long long)tick2 {
    NSDate *date1 = [NSDate shmdb_getDateWithTick:tick1];
    NSDate *date2 = [NSDate shmdb_getDateWithTick:tick2];
    return [date1 compare:date2];
}

+ (NSString *)shmdb_getStrWithTick:(long long)tick {
    return [self shmdb_getStrWithTick:tick format:kTIME_STR_FORMAT_1];
}

+ (NSString *)shmdb_getStrWithTick:(long long)tick format:(NSString *)format {
    NSTimeInterval timeInterval = (double)tick / kUnitConversion;
    NSDate *       theDate      = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [theDate shmdb_getStrWithFormat:format];
}

- (NSString *)shmdb_getStr {
    return [self shmdb_getStrWithFormat:kTIME_STR_FORMAT_1];
}

- (NSString *)shmdb_getStrWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterFullStyle];
    [formatter setTimeStyle:NSDateFormatterFullStyle];
    [formatter setDateFormat:format];
    [formatter setLocale:[NSLocale currentLocale]];
    NSString *string = [formatter stringFromDate:self];
    return string;
}

- (NSString *)shmdb_timeInfo {
    NSDate *curDate     = [NSDate date];
    NSTimeInterval time = -[self timeIntervalSinceDate:curDate];
    NSTimeInterval retTime = 1.0;
    if (time == 0) {
        return @"";
    }
    else if (time < 60 * 10) {
        return @"刚刚";
    }
    else if (time < 60 * 60) {
        retTime = time / 60;
        retTime = retTime <= 0.0 ? 1.0 : retTime;
        return [NSString stringWithFormat:@"%d分钟前", (int)retTime];
    }
    else if (time < 3600 * 24) {
        retTime = time / 3600;
        retTime = retTime <= 0.0 ? 1.0 : retTime;
        return [NSString stringWithFormat:@"%d小时前", (int)retTime];
    }
    else if (time < (3600 * 24) * 7) {
        retTime = time / (3600 * 24);
        return [NSString stringWithFormat:@"%d天前", (int)retTime];
    }
    else if (time < (3600 * 24) * 365) {
        return [self shmdb_getMMDD];
    }
    else {
        return [self shmdb_getStrWithFormat:kTIME_STR_FORMAT_5];
    }
    return @"";
}

- (NSString *)shmdb_getMMDD {
    return [self shmdb_getStrWithFormat:kTIME_STR_FORMAT_8];
}

+ (NSDate *)shmdb_getDateWithTick:(long long)tick {
    NSTimeInterval timeInterval = (double)tick / kUnitConversion;
    return [NSDate dateWithTimeIntervalSince1970:timeInterval];
}

+ (NSDate *)shmdb_getDateWithStr:(NSString *)dateStr {
    return [self shmdb_getDateWithStr:dateStr format:kTIME_STR_FORMAT_1];
}

+ (NSDate *)shmdb_getDateWithStr:(NSString *)dateStr format:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]] ;
    dateFormatter.dateFormat = format;
    return [dateFormatter dateFromString:dateStr];
}

@end
