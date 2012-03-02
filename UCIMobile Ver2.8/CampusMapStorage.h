//
//  CampusMapStorage.h
//  UCIMobileAccessCoreData
//
//  Created by Yoon Lee on 3/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>

@interface CampusMapStorage :  NSManagedObject<MKAnnotation> {
}

@property (nonatomic, retain) NSString * extendBname;
@property (nonatomic, retain) NSString * abreviateBname;
@property (nonatomic, retain) NSDecimalNumber * x_coordinate;
@property (nonatomic, retain) NSDecimalNumber * y_coordinate;
@property (nonatomic, retain) NSNumber * numBuilding;
@property (nonatomic, retain) NSString * phoneContact;
@property (nonatomic, retain) NSString * operationHours;

@end



