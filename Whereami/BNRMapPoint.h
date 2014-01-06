//
//  BNRMapPoint.h
//  Whereami
//
//  Created by Tim Brandt on 1/5/14.
//  Copyright (c) 2014 Tim Brandt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface BNRMapPoint : NSObject
{
}
// A new designated initilizer for instances of BNRMapPoint
- (id)initWithCoordinate:(CLLocationCoordinate2D)c title:(NSString *)t;

// This is a required property from MKAnotation
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

// This is an optional property from MKAnotation
@property (nonatomic, copy) NSString *title;

@end
