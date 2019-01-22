//
//  LYADsModel.m
//  LLFullScreenAd
//
//  Created by liyu on 2018/11/8.
//

#import "LYADsModel.h"

@implementation LYADsModel

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.path forKey:@"path"];
    [aCoder encodeObject:self.pageURL forKey:@"pageURL"];
    [aCoder encodeInteger:self.status forKey:@"status"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.path = [aDecoder decodeObjectForKey:@"path"];
        self.pageURL = [aDecoder decodeObjectForKey:@"pageURL"];
        self.status = [[aDecoder decodeObjectForKey:@"status"] integerValue];
    }
    return self;
}

@end
