#import "ExtensionStateBridge.h"
@import SafariServices;

@implementation ExtensionStateBridge

+ (void)requestExtensionStateWithIdentifier:(NSString *)identifier
                                 completion:(SLABExtensionStateCompletion)completion {
    [SFSafariExtensionManager getStateOfSafariExtensionWithIdentifier:identifier completionHandler:^(SFSafariExtensionState * _Nullable state, NSError * _Nullable error) {
        BOOL enabled = (error == nil && state.isEnabled);
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(enabled, error);
        });
    }];
}

@end
