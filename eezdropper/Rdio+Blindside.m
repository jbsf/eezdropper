#import <Rdio/Rdio.h>
#import "Blindside.h"

@implementation Rdio(Blindside)

+ (BSInitializer *)blindsideInitializer {
    SEL selector = @selector(initWithConsumerKey:andSecret:delegate:);
    return [BSInitializer 
            initializerWithClass:self 
                        selector:selector 
                    argumentKeys:@"rdioConsumerKey", @"rdioSecret", @"rdioDelegate", nil];

}

@end
