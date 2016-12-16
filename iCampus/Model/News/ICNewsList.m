//
//  ICNewsList.m
//  iCampus-iOS-API
//
//  Created by Darren Liu on 13-11-6.
//  Copyright (c) 2013年 Darren Liu. All rights reserved.
//

#import "ICNewsList.h"
#import "ICNews.h"
#import "ICNewsChannel.h"
#import "../ICModelConfig.h"
#import "ICNetworkManager.h"

@interface ICNewsList ()

@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation ICNewsList

+ (ICNewsList *)newsListWithChannel:(ICNewsChannel *)channel
                          pageIndex:(NSUInteger)index {
    return [[self alloc] initWithChannel:channel
                               pageIndex:index];
}

+ (ICNewsList *)newsListWithKeyword:(NSString *)keyword {
    return [[self alloc] initWithKeyword:keyword];
}

- (id)init {
    self = [super init];
    if (self) {
        self.array = [NSMutableArray array];
    }
    return self;
}

- (id)initWithChannel:(ICNewsChannel *)channel
            pageIndex:(NSUInteger)index {
    self = [super init];
    if (self) {
        self.array = [NSMutableArray array];
        if (!channel) {
            return self;
        }
//        [[ICNetworkManager defaultManager] GET:"News List"
//                                    parameters:@{
//                                                 @"category": channel.listKey,
//                                                 @"page": @(index)
//                                                 }
//                                       success:^(NSArray *data) {
//                                           <#code#>
//                                       } failure:<#^(NSError *)failure#>];
        NSString *urlString = [NSString stringWithFormat:@"%@/api.php?table=newslist&url=%@&index=%lu", ICNewsAPIURLPrefix, channel.listKey, (unsigned long)index];
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
#       if !defined(IC_ERROR_ONLY_DEBUG) && defined(IC_NEWS_LIST_DATA_MODULE_DEBUG)
            NSLog(@"%@ %@ %@", ICNewsListTag, ICFetchingTag, urlString);
#       endif
        NSData *data = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:nil
                                                         error:nil];
        if (!data) {
#           ifdef IC_NEWS_LIST_DATA_MODULE_DEBUG
                NSLog(@"%@ %@ %@ %@", ICNewsListTag, ICFailedTag, ICNullTag, urlString);
#           endif
            return self;
        }
#       if !defined(IC_ERROR_ONLY_DEBUG) && defined(IC_NEWS_LIST_DATA_MODULE_DEBUG)
            NSLog(@"%@ %@ %@", ICNewsListTag, ICSucceededTag, urlString);
#       endif
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:kNilOptions
                                                               error:nil];
        json = json[@"d"];
        NSDateFormatter   *dateFormatter;
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:(NSString *)ICTimeZoneName]];
        for (NSMutableDictionary __strong *a in json) {
            a = a[@"attributes"];
            ICNews *news = [[ICNews alloc] init];
            news.index = [a[@"id"] intValue];
            news.date = [dateFormatter dateFromString:a[@"rt"]];
            news.title = a[@"n"];
            news.author = a[@"au"];
            news.preview = a[@"ab"];
            news.imageURL = [NSURL URLWithString:a[@"ic"]];
            news.detailKey = a[@"url"];
            news.detailKey = [news.detailKey stringByReplacingOccurrencesOfString:@"newsfeed.bistu.edu.cn"
                                                                       withString:@""];
            news.detailKey = [news.detailKey stringByReplacingOccurrencesOfString:@".xml"
                                                                       withString:@""];
            [self.array addObject:news];
        }
    }
    return self;
}

- (id)initWithKeyword:(NSString *)keyword {
    self = [super init];
    if (self) {
        NSString *urlString = [NSString stringWithFormat:@"%@/api.php?table=newssearch&search=%@", ICNewsAPIURLPrefix, keyword];
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
#       if !defined(IC_ERROR_ONLY_DEBUG) && defined(IC_NEWS_LIST_DATA_MODULE_DEBUG)
            NSLog(@"%@ %@ %@", ICNewsListTag, ICFetchingTag, urlString);
#       endif
        NSData *data = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:nil
                                                         error:nil];
        if (!data) {
#           ifdef IC_NEWS_LIST_DATA_MODULE_DEBUG
                NSLog(@"%@ %@ %@ %@", ICNewsListTag, ICFailedTag, ICNullTag, urlString);
#           endif
            return self;
        }
#       if !defined(IC_ERROR_ONLY_DEBUG) && defined(IC_NEWS_LIST_DATA_MODULE_DEBUG)
            NSLog(@"%@ %@ %@", ICNewsListTag, ICSucceededTag, urlString);
#       endif
        NSArray *json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:kNilOptions
                                                               error:nil];
        NSDateFormatter   *dateFormatter;
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:(NSString *)ICTimeZoneName]];
        self.array = [NSMutableArray array];
        for (NSDictionary __strong *a in json) {
            a = a[@"attributes"];
            ICNews *news = [[ICNews alloc] init];
            news.index = [a[@"id"] intValue];
            news.date = [dateFormatter dateFromString:a[@"rt"]];
            news.title = a[@"n"];
            [self addNews:news];
        }
    }
    return self;
}

- (void)addNews:(ICNews *)news {
    [self.array addObject:news];
}

- (void)addNewsFromNewsList:(ICNewsList *)newsList {
    [self.array addObjectsFromArray:newsList.array];
}

- (void)removeNews:(ICNews *)news {
    [self.array removeObject:news];
}

- (NSUInteger)count {
    return self.array.count;
}

- (ICNews *)firstNews {
    return self.array.firstObject;
}

- (ICNews *)lastNews {
    return self.array.lastObject;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(__unsafe_unretained id [])buffer
                                    count:(NSUInteger)len {
    return [self.array countByEnumeratingWithState:state
                                           objects:buffer
                                             count:len];
}

- (ICNews *)newsAtIndex:(NSUInteger)index {
    return (self.array)[index];
}

@end
