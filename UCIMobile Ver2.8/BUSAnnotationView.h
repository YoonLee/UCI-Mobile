//
//  BUSAnnotationView.h
//  UCIMobile
//
//  Created by Yoon Lee on 8/8/10.
//  Copyright 2010 leeyc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>

@interface BUSAnnotationView : MKAnnotationView 
{

}

-(void)drawInContext:(CGContextRef)context;

@end
