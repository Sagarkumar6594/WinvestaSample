//
//  FlexibleGauge.m
//  FlexibleGauge
//
//  Created by ebru gungor on 23/11/2017.
//

#import "FlexibleGauge.h"

@interface FlexibleGauge()
    
@property (assign, nonatomic) CGFloat startAngleCompleteArc;
@property (assign, nonatomic) CGFloat endAngleCompleteArc;

@property (assign, nonatomic) CGFloat startAngleHalfArc;
@property (assign, nonatomic) CGFloat endAngleHalfArc;
    
@end

@implementation FlexibleGauge

#pragma mark - Init Methods
    
-(id)init {
    self = [super init];
    if(self) {
        [self defaultValues];
        [self setNeedsDisplay];
    }
    return self;
}
    
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self defaultValues];
        [self setDefaultFont];
    }
    return self;
}
    
-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self defaultValues];
        [self setDefaultFont];
    }
    return self;
}
    
-(id)initWithProperties:(NSInteger)radiusMultiplier backgroundViewColor:(UIColor *)backgroundViewColor emptyColor:(UIColor *)emptyColor filledColor:(UIColor *)filledColor thickness:(CGFloat)thickness outerText:(NSString *)outerText outerTextFont:(UIFont *)outerTextFont outerTextColor:(UIColor *)outerTextColor outerImageSize:(CGSize)outerImageSize outerImage:(UIImage *)outerImage innerText:(NSString *)innerText innerTextFont:(UIFont *)innerTextFont innerTextColor:(UIColor *)innerTextColor innerImageSize:(CGSize)innerImageSize innerImage:(UIImage *)innerImage {
    self = [super init];
    if(self) {
        [self defaultValues];
        [self setProperties:radiusMultiplier
        backgroundViewColor:backgroundViewColor
                 emptyColor:emptyColor
                filledColor:filledColor
                  thickness:thickness
                  outerText:outerText
              outerTextFont:outerTextFont
             outerTextColor:outerTextColor
             outerImageSize:outerImageSize
                 outerImage:outerImage
                  innerText:innerText
              innerTextFont:innerTextFont
             innerTextColor:innerTextColor
             innerImageSize:innerImageSize
                 innerImage:innerImage];
    }
    return self;
}
    
#pragma mark - Public methods
    
-(void)setProperties:(NSInteger)radiusMultiplier backgroundViewColor:(UIColor *)backgroundViewColor emptyColor:(UIColor *)emptyColor filledColor:(UIColor *)filledColor thickness:(CGFloat)thickness outerText:(NSString *)outerText outerTextFont:(UIFont *)outerTextFont outerTextColor:(UIColor *)outerTextColor outerImageSize:(CGSize)outerImageSize outerImage:(UIImage *)outerImage innerText:(NSString *)innerText innerTextFont:(UIFont *)innerTextFont innerTextColor:(UIColor *)innerTextColor innerImageSize:(CGSize)innerImageSize innerImage:(UIImage *)innerImage {
    self.radiusMultiplier = radiusMultiplier;
    self.backgroundViewColor = backgroundViewColor;
    self.emptyColor = emptyColor;
    self.filledColor = filledColor;
    self.thickness = thickness;
    self.outerText = outerText;
    self.outerTextFont = outerTextFont;
    self.outerTextColor = outerTextColor;
    self.outerImageSize = outerImageSize;
    self.outerImage = outerImage;
    self.innerText = innerText;
    self.innerTextFont = innerTextFont;
    self.innerTextColor = innerTextColor;
    self.innerImageSize = innerImageSize;
    self.innerImage = innerImage;
}
    
-(void)refreshGraph:(CGFloat)newValue innerText:(NSString *)innerText outerText:(NSString *)outerText {
    self.newValue = newValue;
    self.innerText = innerText;
    self.outerText = outerText;
    self.firstTimeToAppear = YES;
    [self setNeedsDisplay];
}
    
-(void)refreshGraph:(CGFloat)newValue withAnimation:(Boolean)withAnimation {
    self.newValue = newValue;
    if(withAnimation == YES) {
        [self animateGauge];
    } else {
        [self setNeedsDisplay];
    }
}
    
#pragma mark - Private methods
    
-(void)setDefaultProperties {
    self.value = 0;
    self.newValue = 50;
    self.radiusMultiplier = 1;
    self.backgroundViewColor = [UIColor clearColor];
    self.emptyColor = [UIColor lightGrayColor];
    self.filledColor = [UIColor redColor];
    self.thickness = 20;
    [self setDefaultFont];
    //self.outerText = @"outer text";
    //self.outerImageSize = CGSizeMake(40, 40);
    //self.outerImage = [UIImage imageNamed:@"business"];
    //self.innerText = @"inner text";
    //self.innerImageSize = CGSizeMake(40, 40);
    //self.innerImage = [UIImage imageNamed:@"heart"];
}
    
-(void)setDefaultFont {
    self.innerTextFont = [UIFont fontWithName:@"Helvetica" size:11];
    self.outerTextFont = [UIFont fontWithName:@"Helvetica" size:11];
    self.innerTextColor = [UIColor darkGrayColor];
    self.outerTextColor = [UIColor darkGrayColor];
}
    
#pragma mark - Text property methods
    
-(void)setOuterTextProperties:(NSString *)text textColor:(UIColor *)textColor font:(UIFont*)font {
    self.outerText = text;
    self.outerTextColor = textColor;
    self.outerTextFont = font;
}
    
-(void)setOuterTextValue:(NSString *)text {
    self.outerText = text;
}
    
-(void)setOuterImageProperties:(UIImage *)image imageSize:(CGSize)imageSize {
    self.outerImage = image;
    self.outerImageSize = imageSize;
}
    
-(void)setInnerTextProperties:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font {
    self.innerText = text;
    self.innerTextColor = textColor;
    self.innerTextFont = font;
}
    
-(void)setInnerTextValue:(NSString *)text {
    self.innerText = text;
}
    
-(void)setInnerImageProperties:(UIImage *)image imageSize:(CGSize)imageSize {
    self.innerImage = image;
    self.innerImageSize = imageSize;
}
    
#pragma mark - Animating methods
-(void)animateGauge {
    if(self.animationIsBusy) {
        [self performSelector:@selector(makeAnimateGauge) withObject:nil afterDelay:0.4];
    } else {
        self.animationIsBusy = YES;
        [self makeAnimateGauge];
    }
}
    
-(void)makeAnimateGauge{
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(animateNumber:)];
    startTime = CACurrentMediaTime();
    [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    self.animationIsBusy = NO;
}
    
-(void)animateNumber:(CADisplayLink *)link {
    static float DURATION = ANIMATION_DURATION;
    float dt = ([link timestamp] - startTime) / DURATION;
    if (dt >= ANIMATION_DURATION){
        self.value = self.newValue;
        [link removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        self.animationIsBusy = NO;
        return;
    }
    
    float current = (self.newValue - self.value) * dt + self.value;
    self.value = current;
    [self setNeedsDisplay];
}
    
#pragma mark - Drawing methods
    
-(void)defaultValues {
    self.startAngleCompleteArc = 0.0;
    self.endAngleCompleteArc = 360.0;
    self.startAngleHalfArc = -90;
    self.endAngleHalfArc = -90;
    self.radiusMultiplier = 1;
}
    
-(void)drawRect:(CGRect)rect {
    //1. Set background of the view holder
    self.backgroundColor = self.backgroundViewColor;
    if(self.backgroundViewColor == nil) self.backgroundColor = [UIColor clearColor];
    
    //2. Draw inner and outer circles
    [self drawCircles:rect];
    //3. Outer assets
    [self drawOuterAssets:rect];
    //4. Inner assets
    [self drawInnerAssets:rect];
}
    
-(void)drawCircles:(CGRect)rect {
    //light color circle
    [self drawCircleInRect:rect
               centerWidth:CGPointMake(rect.size.width/2, rect.size.width/2)
              centerHeight:CGPointMake(rect.size.height/2, rect.size.height/2)
                     color:self.emptyColor
               radiusWidth:((self.bounds.size.width/2) - (self.thickness / self.radiusMultiplier))
              radiusHeight:((self.bounds.size.height/2) - (self.thickness / self.radiusMultiplier))];
    
    //value circle
    [self drawCircleInCircle:rect
                 centerWidth:CGPointMake(rect.size.width/2, rect.size.width/2)
                centerHeight:CGPointMake(rect.size.height/2, rect.size.height/2)
                       color:self.filledColor
                 radiusWidth:((self.bounds.size.width/2) - (self.thickness / self.radiusMultiplier))
                radiusHeight:((self.bounds.size.height/2) - (self.thickness / self.radiusMultiplier))
                  gaugeValue:self.value];
}
    
-(void)drawOuterAssets:(CGRect)rect {
    //outer value text
    if((self.outerText != nil) && ![self.outerText isEqualToString:@""]) {
        UILabel *label = [[UILabel alloc] init];
        label.text = self.outerText;
        label.font = self.outerTextFont;
        CGSize labelSize = label.attributedText.size;
        
        CGPoint textPoint = CGPointMake((rect.size.width/2)-(self.outerImageSize.width / 2) - labelSize.width - 5,  (self.thickness * self.radiusMultiplier) - (labelSize.height / 2));
        [self drawText:rect
                  text:self.outerText
             textColor:self.outerTextColor
             textPoint:textPoint
                  font:self.outerTextFont
                  size:labelSize
         textAlignment:NSTextAlignmentRight];
    }
    
    //outer image
    if(self.outerImage != nil) {
        CGPoint imagePoint = CGPointMake((rect.size.width/2)-(self.outerImageSize.width / 2), (self.thickness * self.radiusMultiplier) - (self.outerImageSize.height / 2));
        
        [self drawImage:imagePoint
                  image:self.outerImage
              imageSize:self.outerImageSize];
    }
}
    
-(void)drawInnerAssets:(CGRect)rect {
    //middle point
    CGPoint imagePoint = CGPointMake((rect.size.width/2)-(self.innerImageSize.width / 2), ((rect.size.height/2) - (self.innerImageSize.height / 2)));
    
    //inner text
    if((self.innerText != nil) && ![self.innerText isEqualToString:@""]) {
        imagePoint = CGPointMake(((rect.size.width/2)-(self.innerImageSize.width / 2)), ((rect.size.height/2) - (self.innerImageSize.height)));
        
        UILabel *label = [[UILabel alloc] init];
        label.text = self.innerText;
        label.font = self.innerTextFont;
        CGSize labelSize = label.attributedText.size;
        
        CGPoint textPoint = CGPointMake((rect.size.width / 2) - (labelSize.width / 2), (rect.size.height / 2) - (labelSize.height / 2));
        if(self.innerImage != nil){
            textPoint = CGPointMake((rect.size.width / 2) - (labelSize.width / 2), rect.size.height / 2);
        }
        
        [self drawText:rect
                  text:self.innerText
             textColor:self.innerTextColor
             textPoint: textPoint
                  font:self.innerTextFont
                  size:labelSize
         textAlignment:NSTextAlignmentCenter];
    }
    
    //inner image
    if(self.innerImage != nil) {
        [self drawImage:imagePoint
                  image:self.innerImage
              imageSize:self.innerImageSize];
    }
}
    
-(void)drawCircleInRect:(CGRect)rect centerWidth:(CGPoint)centerWidth centerHeight:(CGPoint)centerHeight color:(UIColor*)color radiusWidth:(CGFloat)radiusWidth radiusHeight:(CGFloat)radiusHeight {
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath setLineWidth:self.thickness];
    if(rect.size.width <= rect.size.height){
        [bezierPath addArcWithCenter:centerWidth radius:radiusWidth startAngle:self.startAngleCompleteArc endAngle:self.endAngleCompleteArc clockwise:YES];
    } else {
        [bezierPath addArcWithCenter:centerHeight radius:radiusHeight startAngle:self.startAngleCompleteArc endAngle:self.endAngleCompleteArc clockwise:YES];
    }
    [color setStroke];
    [bezierPath stroke];
}
    
-(void)drawCircleInCircle:(CGRect)rect centerWidth:(CGPoint)centerWidth centerHeight:(CGPoint)centerHeight color:(UIColor*)color radiusWidth:(CGFloat)radiusWidth radiusHeight:(CGFloat)radiusHeight gaugeValue:(CGFloat)gaugeValue{
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath setLineWidth:self.thickness];
    [bezierPath setLineCapStyle:kCGLineCapRound];
    if(rect.size.width <= rect.size.height) {
        [bezierPath addArcWithCenter:centerWidth radius:radiusWidth startAngle:[self setStartDegree:0.0] endAngle:[self setValueHalfArcPercentage:gaugeValue] clockwise:YES];
    } else {
        [bezierPath addArcWithCenter:centerHeight radius:radiusHeight startAngle:[self setStartDegree:0.0] endAngle:[self setValueHalfArcPercentage:gaugeValue] clockwise:YES];
    }
    [color setStroke];
    [bezierPath stroke];
}
    
-(CGFloat)radiansFromDegrees:(CGFloat)degrees{
    return (CGFloat)((degrees) / 180.0 * M_PI);
}
    
-(CGFloat)setStartDegree:(CGFloat)halfArcStartDegree {
    self.startAngleHalfArc = halfArcStartDegree - 90;
    return [self radiansFromDegrees:self.startAngleHalfArc];
}
    
-(CGFloat)setEndDegree:(CGFloat)halfArcEndDegree {
    self.endAngleHalfArc = halfArcEndDegree - 90;
    return [self radiansFromDegrees:self.endAngleHalfArc];
}
    
-(CGFloat)setValueHalfArcPercentage:(CGFloat)value{
    return [self setEndDegree:((value*360)/100)];
}
    
#pragma mark - Drawing Gauge Accessories
    
-(void)drawText:(CGRect)rect text:(NSString*)text textColor:(UIColor*)textColor textPoint:(CGPoint)textPoint font:(UIFont*)font size:(CGSize)size textAlignment:(NSTextAlignment)textAlignment {
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setAlignment:textAlignment];
    NSDictionary *stringAttrs = @{ NSFontAttributeName:font, NSForegroundColorAttributeName:textColor , NSParagraphStyleAttributeName:style};
    
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:text attributes:stringAttrs];
    
    CGRect frame = CGRectMake(textPoint.x, textPoint.y, size.width, size.height);
    
    [attrStr drawInRect:frame];
}
    //if width is bigger than height then it only uses pointWidth or vice versa
-(void)drawImage:(CGPoint)point image:(UIImage*)image imageSize:(CGSize)imageSize{
    [image drawInRect:CGRectMake(point.x, point.y, imageSize.width, imageSize.height)];
    
}

@end
