//
//  FlexibleGauge.h
//  FlexibleGauge
//
//  Created by ebru gungor on 23/11/2017.
//

#import <UIKit/UIKit.h>

#define ANIMATION_DURATION 1.0

IB_DESIGNABLE
@interface FlexibleGauge : UIView{CGFloat startTime;}
    
@property (assign, nonatomic) IBInspectable CGFloat newValue;
@property (assign, nonatomic) IBInspectable CGFloat value;

@property (strong, nonatomic) IB_DESIGNABLE UIColor *backgroundViewColor;
@property (strong, nonatomic) IBInspectable UIColor *emptyColor;
@property (strong, nonatomic) IBInspectable UIColor *filledColor;
@property (assign, nonatomic) IBInspectable CGFloat thickness;

@property (strong, nonatomic) IBInspectable NSString *outerText;
@property (strong, nonatomic) IBInspectable UIColor *outerTextColor;
@property (assign, nonatomic) IBInspectable CGSize outerImageSize;
@property (strong, nonatomic) IBInspectable UIImage *outerImage;

@property (strong, nonatomic) IBInspectable NSString *innerText;
@property (strong, nonatomic) IBInspectable UIColor *innerTextColor;
@property (assign, nonatomic) IBInspectable CGSize innerImageSize;
@property (strong, nonatomic) IBInspectable UIImage *innerImage;

@property (assign,nonatomic) IBInspectable CGFloat radiusMultiplier;

@property (assign, nonatomic) BOOL firstTimeToAppear;
@property (assign, nonatomic) BOOL animationIsBusy;

//It is not possible to make UIFont as IBInspectable
@property (strong, nonatomic) UIFont *innerTextFont;
@property (strong, nonatomic) UIFont *outerTextFont;
    
-(id)initWithProperties:(NSInteger)radiusMultiplier backgroundViewColor:(UIColor*)backgroundViewColor emptyColor:(UIColor*)emptyColor filledColor:(UIColor*)filledColor thickness:(CGFloat)thickness outerText:(NSString*)outerText outerTextFont:(UIFont*)outerTextFont outerTextColor:(UIColor*)outerTextColor outerImageSize:(CGSize)outerImageSize outerImage:(UIImage*)outerImage innerText:(NSString*)innerText innerTextFont:(UIFont*)innerTextFont innerTextColor:(UIColor*)innerTextColor innerImageSize:(CGSize)innerImageSize innerImage:(UIImage*)innerImage;
    
-(void)setProperties:(NSInteger)radiusMultiplier backgroundViewColor:(UIColor*)backgroundViewColor emptyColor:(UIColor*)emptyColor filledColor:(UIColor*)filledColor thickness:(CGFloat)thickness outerText:(NSString*)outerText outerTextFont:(UIFont*)outerTextFont outerTextColor:(UIColor*)outerTextColor outerImageSize:(CGSize)outerImageSize outerImage:(UIImage*)outerImage innerText:(NSString*)innerText innerTextFont:(UIFont*)innerTextFont innerTextColor:(UIColor*)innerTextColor innerImageSize:(CGSize)innerImageSize innerImage:(UIImage*)innerImage;
    
-(void)refreshGraph:(CGFloat)newValue withAnimation:(Boolean)withAnimation;
-(void)refreshGraph:(CGFloat)newValue innerText:(NSString *)innerText outerText:(NSString*)outerText;
    
-(void)animateGauge;
    
-(void)setDefaultProperties;
    
-(void)setOuterTextProperties:(NSString*)text textColor:(UIColor*)textColor font:(UIFont*)font;
-(void)setOuterTextValue:(NSString*)text;
-(void)setOuterImageProperties:(UIImage*)image imageSize:(CGSize)imageSize;
    
-(void)setInnerTextProperties:(NSString*)text textColor:(UIColor*)textColor font:(UIFont*)font;
-(void)setInnerTextValue:(NSString*)text;
-(void)setInnerImageProperties:(UIImage*)image imageSize:(CGSize)imageSize;

@end
