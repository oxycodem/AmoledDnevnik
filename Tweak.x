#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

%hook RCTView

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    %orig([UIColor blackColor]);
}

%end


%ctor {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        CFBooleanRef hasShown = CFPreferencesCopyAppValue(CFSTR("AmoledDnevnikHasShown"), CFSTR("ru.mes.dnevnik.fgis"));
        if (hasShown != kCFBooleanTrue) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"AmoledDnevnik"
                                                                           message:@"Tweak dev: @systemxplore / github.com/cryptexctl\nAntiJB-detect: @jailbreaker1337 / github.com/ghh-jb"
                                                                    preferredStyle:UIAlertControllerStyleAlert];

            UIWindow *keyWindow = nil;
            for (UIWindow *window in [UIApplication sharedApplication].windows) {
                if (window.isKeyWindow) {
                    keyWindow = window;
                    break;
                }
            }

            if (keyWindow && keyWindow.rootViewController) {
                UIViewController *rootVC = keyWindow.rootViewController;
                while (rootVC.presentedViewController) {
                    rootVC = rootVC.presentedViewController;
                }

                [rootVC presentViewController:alert animated:YES completion:nil];

                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    [alert dismissViewControllerAnimated:YES completion:nil];
                });

                CFPreferencesSetAppValue(CFSTR("AmoledDnevnikHasShown"), kCFBooleanTrue, CFSTR("ru.mes.dnevnik.fgis"));
                CFPreferencesAppSynchronize(CFSTR("ru.mes.dnevnik.fgis"));
            }
        }
    });
}
