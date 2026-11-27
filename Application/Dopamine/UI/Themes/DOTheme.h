//
//  DOTheme.h
//  Dopamine
//
//  Created by tomt000 on 14/02/2024.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DOTheme : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *icon;
@property (nonatomic, retain) NSString *key;
@property (nonatomic, retain) UIColor *actionMenuColor;
@property (nonatomic, retain) UIColor *windowColor;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, assign) float blur;
@property (nonatomic, assign) BOOL titleShadow;

- (id)initWithDictionary: (NSDictionary *)dictionary;

- (UIImage *)generateBootLogo;

// Renvoie le fond dark mode si le thème en a un ET que le style demandé est Dark,
// sinon le fond normal.
- (UIImage *)imageForUserInterfaceStyle:(UIUserInterfaceStyle)style;

@end


NS_ASSUME_NONNULL_END
