#import <Foundation/Foundation.h>

@interface Track : NSObject<NSCoding>

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *artist;
@property (nonatomic, retain) NSString *iconURL;
@property (nonatomic, retain) NSString *key;

+ (NSArray *)parseTracks:(NSArray *)properties;

@end
