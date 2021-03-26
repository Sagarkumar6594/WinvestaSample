# FlexibleGauge

With this animated gauge you will be able to create flexible gauges with or without images in or out of the gauge circle.


![example](https://s8.postimg.org/yowsqjqbp/ezgif.com-video-to-gif.gif)


![example2](https://s8.postimg.org/dynynn4kl/Screen_Shot_2017-11-23_at_08.55.33.png)

# Build Requirements

## iOS

9.3+

# Adding To Project

You can add MultipleGaugeAnimated as a cocoapod with 'pod MultipleGaugeAnimated' or you can add it as a resource

# Usage

##  You may add via interface designer

### 1. Add the resource class

![adding via designer](https://s8.postimg.org/yjjup8rcl/ezgif.com-crop.gif)

### 2. Enter mandatory requirements

'New value' vs 'Value' --> If you are willing to see an animation, then you should animate the gauge from Value to New value, lets say  your starting value of the gauge is 50, then you should assign 'Value' as 0 to start animation from 0, and assign 'New value' as 50 so that it will animate to 50 from 0.
You may also assign the values of the gauge via the code, you just need to connect it to the view as an outlet and call:

-(void)refreshGraph:(CGFloat)newValue withAnimation:(Boolean)withAnimation;

//call the method above from the view class that your outlet is connected as:
[self.gauge refreshGraph:50 withAnimation:YES];

## You may add via code

### Example:

@property (weak, nonatomic) IBOutlet UIView *gaugeView;
@property(strong, nonatomic) Gauge *gauge;

self.gauge = [[Gauge alloc] initWithFrame:self.gaugeView.bounds];
[self.gauge setDefaultProperties];
[self.gauge setOuterTextProperties:@"outer 2" textColor:[UIColor darkGrayColor] font:[UIFont fontWithName:@"HelveticaNeue" size:11]];
[self.gauge setOuterImageProperties:[UIImage imageNamed:@"business"] imageSize:CGSizeMake(15, 15)];
self.gauge setNeedsDisplay];
[self.gaugeView addSubview:self.gauge];

//To animate
[self.gauge animateGauge];


### Check example project for different type of gauges.


