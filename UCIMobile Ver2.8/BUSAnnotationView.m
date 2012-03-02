//
//  BUSAnnotationView.m
//  UCIMobile
//
//  Created by Yoon Lee on 8/8/10.
//  Copyright 2010 leeyc. All rights reserved.
//

#import "BUSAnnotationView.h"


@implementation BUSAnnotationView
#define R(Red) (Red/255.0)
#define G(Green) (Green/255.0)
#define B(Blue) (Blue/255.0)

- (id) initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
	
	if (self != nil) 
	{
		CGRect frame = self.frame;
		frame.size = CGSizeMake(90.0f, 90.0f);
		self.frame = frame;
		self.backgroundColor = [UIColor clearColor];
		//self.backgroundColor = [UIColor lightGrayColor];
	}
	
	return self;
}

- (void)setAnnotation:(id <MKAnnotation>)annotation
{
    [super setAnnotation:annotation];
	
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect 
{
	[self drawInContext:UIGraphicsGetCurrentContext()];
}

-(void)drawInContext:(CGContextRef)context 
{
	CGContextSetRGBStrokeColor(context, R(51), G(102), B(153), .75);
	// And draw with a blue fill color
	CGContextSetRGBFillColor(context, R(51), G(153), B(204), 0.1);
	// Draw them with a 2.0 stroke width so they are a bit more visible.
	CGContextSetLineWidth(context, 2.0);
	
	//location
	//circle of shape
	//CGRectMake (X, Y, width, height)
	CGContextAddEllipseInRect(context, CGRectMake((self.frame.size.width/13), (self.frame.size.height/13), 75.0, 75.0));
	
	CGContextDrawPath(context, kCGPathFillStroke);
	
	CABasicAnimation* pulseAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	pulseAnimation.toValue = [NSNumber numberWithFloat: 0.0];
	pulseAnimation.duration = 1.5;
	pulseAnimation.repeatCount = HUGE_VALF;
	pulseAnimation.autoreverses = YES;
	pulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	[self.layer addAnimation:pulseAnimation forKey:@"pulseAnimation"];
	
	CALayer *imageLayer = [[CALayer alloc] init];
	imageLayer.contents = (id)[[UIImage imageNamed:@"BUS_LIVE.png"] CGImage];
	imageLayer.bounds = CGRectMake(55, 55, 45.0, 45.0);
	imageLayer.position = CGPointMake(45.0f, 45.0f);
	[self.layer addSublayer:imageLayer];
	[imageLayer release];
	
	//	CABasicAnimation* resizeAnimation = [CABasicAnimation animationWithKeyPath:@"bounds.size"];
	//	resizeAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(0.0f, 0.0f)];
	//	resizeAnimation.fillMode = kCAFillModeBoth;
	//	resizeAnimation.duration = 1.0;
	//	resizeAnimation.repeatCount = HUGE_VALF;
	//	resizeAnimation.autoreverses = YES;
	//	resizeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	//	[self.layer addAnimation:resizeAnimation forKey:@"resizeAnimation"];
}

@end

