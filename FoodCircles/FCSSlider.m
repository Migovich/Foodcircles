#import "FCSSlider.h"

#import "FCSStyles.h"

@implementation FCSSlider

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        UIImage *sliderKnob = [UIImage imageNamed:@"slider_Knob.png"];
        [self setThumbImage:sliderKnob forState:UIControlStateNormal];
        [self setMinimumTrackImage:[[UIImage imageNamed:@"Track-Min.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 0)] forState:UIControlStateNormal];
        [self setMaximumTrackImage:[[UIImage imageNamed:@"Track-Max.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0,0,0,15)] forState:UIControlStateNormal];
    }
    return self;
}

@end
