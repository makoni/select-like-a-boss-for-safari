#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^SLABExtensionStateCompletion)(BOOL enabled, NSError * _Nullable error);

@interface ExtensionStateBridge : NSObject

+ (void)requestExtensionStateWithIdentifier:(NSString *)identifier
                                 completion:(SLABExtensionStateCompletion)completion;

@end

NS_ASSUME_NONNULL_END
