//
//  SceneDelegate.m
//  Dopamine
//
//  Created by Lars Fröder on 23.09.23.
//  Added url support by SaaS on 08.2026
//

#import "DOSceneDelegate.h"
#import "DONavigationController.h"
#import "DOMainViewController.h"
#import "DOEnvironmentManager.h"
#import "DOUIManager.h"

@interface DOSceneDelegate ()

@property (nonatomic, strong) NSSet<UIOpenURLContext *> *pendingURLContexts;

@end

@implementation DOSceneDelegate

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    UIWindow *window = [[UIWindow alloc] initWithWindowScene:(UIWindowScene *)scene];
    window.rootViewController = [[DONavigationController alloc] init];
    [window makeKeyAndVisible];
    self.window = window;

    if (connectionOptions.URLContexts.count > 0) {
        // App was launched cold via a dopamine:// URL. The scene isn't fully
        // active yet at this point (still mid system launch transition), so
        // acting on the UI now can silently be ignored. Store it and handle
        // it once sceneDidBecomeActive: fires instead.
        self.pendingURLContexts = connectionOptions.URLContexts;
    }
}

- (void)scene:(UIScene *)scene openURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts {
    for (UIOpenURLContext *context in URLContexts) {
        NSURL *url = context.URL;

        if ([[url.scheme lowercaseString] isEqualToString:@"dopamine"]) {
            NSLog(@"Dopamine URL received: %@", url);

            if ([[url.host lowercaseString] isEqualToString:@"jailbreak"]) {
                [self handleJailbreakURLRequest];
            }
        }
    }
}

- (void)handleJailbreakURLRequest
{
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    if (![navigationController isKindOfClass:[UINavigationController class]]) {
        return;
    }

    DOMainViewController *mainViewController = nil;
    for (UIViewController *viewController in navigationController.viewControllers) {
        if ([viewController isKindOfClass:[DOMainViewController class]]) {
            mainViewController = (DOMainViewController *)viewController;
            break;
        }
    }
    if (!mainViewController) {
        return;
    }

    BOOL isJailbroken = [[DOEnvironmentManager sharedManager] isJailbroken] || [[DOEnvironmentManager sharedManager] isJailbrokenWithOtherJailbreak];

    if (isJailbroken) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:DOLocalizedString(@"URLScheme_Already_Jailbroken_Title")
                                                                         message:DOLocalizedString(@"URLScheme_Already_Jailbroken_Message")
                                                                  preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [mainViewController presentViewController:alert animated:YES completion:nil];
        return;
    }

    void (^triggerJailbreak)(void) = ^{
        [mainViewController startJailbreakFromURLScheme];
    };

    if (navigationController.topViewController != mainViewController) {
        [navigationController popToViewController:mainViewController animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), triggerJailbreak);
    } else {
        triggerJailbreak();
    }
}

+ (void)relaunch
{
    UIWindowScene *windowScene = (UIWindowScene *)[[[UIApplication sharedApplication] connectedScenes] anyObject];
    DOSceneDelegate *instance = (DOSceneDelegate *)windowScene.delegate;

    UINavigationController *oldNavigationController = (UINavigationController *)instance.window.rootViewController;
    if ([oldNavigationController isKindOfClass:[UINavigationController class]]) {
        for (UIViewController *viewController in oldNavigationController.viewControllers) {
            if ([viewController isKindOfClass:[DOMainViewController class]]) {
                [(DOMainViewController *)viewController stopAllAudio];
                break;
            }
        }
    }

    [UIView animateWithDuration:0.3 animations:^{
        instance.window.alpha = 0;
    } completion:^(BOOL finished) {
        UIWindow *window = [[UIWindow alloc] initWithWindowScene:(UIWindowScene *)instance.window.windowScene];
        window.rootViewController = [[DONavigationController alloc] init];
        [window makeKeyAndVisible];
        instance.window = window;
        instance.window.alpha = 0;
        [UIView animateWithDuration:0.3 animations:^{
            instance.window.alpha = 1;
        }];
    }];
}

- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    if (self.pendingURLContexts.count > 0) {
        NSSet<UIOpenURLContext *> *contexts = self.pendingURLContexts;
        self.pendingURLContexts = nil;
        [self scene:scene openURLContexts:contexts];
    }
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}


@end
