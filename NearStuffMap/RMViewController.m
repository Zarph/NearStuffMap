//
//  RMViewController.m
//  NearStuffMap
//
//  Created by Marco S. Graciano on 4/22/13.
//  Copyright (c) 2013 Marco Graciano. All rights reserved.
//

#import "RMViewController.h"
#import "RMMapViewAnnotation.h"
#import "RMMasterSDK.h"

@interface CustomPin : MKPinAnnotationView
{
}
- (id)initWithAnnotation:(id <MKAnnotation>) annotation andPinColor:(MKPinAnnotationColor *)pinColor;
- (id)initWithAnnotation:(id <MKAnnotation>) annotation andImage:(UIImage *)photo;

@end

@implementation CustomPin

- (id)initWithAnnotation:(id <MKAnnotation>)annotation andImage:(UIImage *)photo
{
    
    self = [super initWithAnnotation:annotation reuseIdentifier:@"CustomId"];
    
    if (self)
    {
        
        self.image = photo;
        
        self.frame = CGRectMake(0, 0, 50, 50);
    }
    return self;
    
}

- (id)initWithAnnotation:(id <MKAnnotation>)annotation andPinColor:(MKPinAnnotationColor *)pinColor
{
    
    self = [super initWithAnnotation:annotation reuseIdentifier:@"CustomId"];
    
    if (self)
    {
        
        [self setPinColor:pinColor];
        
    }
    return self;
    
}

@end

@interface RMViewController ()

@end

@implementation RMViewController
@synthesize mapView = _mapView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.mapView setShowsUserLocation:YES];
    self.mapView.delegate = self;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMapView:nil];
    [super viewDidUnload];
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    self.mapView.centerCoordinate = userLocation.coordinate;
    
    latitude = userLocation.coordinate.latitude;
    longitude = userLocation.coordinate.longitude;
    
    [self loadAnnotations];
    
    [self zoomToUserLocation:self.mapView.userLocation];
}

- (void)zoomToUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance (userLocation.location.coordinate, 50, 50);
    [self.mapView setRegion:region animated:NO];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(RMMapViewAnnotation *)annotation{
    
    if([annotation isKindOfClass:[RMMapViewAnnotation class]]) {
        MKAnnotationView *view = [self.mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomId"];
        if(nil == view) {
            
            
            if ([annotation.socialNetwork isEqualToString:@"Foursquare"])
            {                
                view = [[CustomPin alloc] initWithAnnotation:annotation andPinColor:MKPinAnnotationColorGreen];
            }
            else if ([annotation.socialNetwork isEqualToString:@"Instagram"])
            {
                view = [[CustomPin alloc] initWithAnnotation:annotation andImage:annotation.photo];
            }
            
           
            
        }
        
        [view setCanShowCallout:YES];

        
        return view;
    }
    
    return nil;
}

-(void)loadAnnotations{
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f", latitude],@"latitude", [NSString stringWithFormat:@"%f", longitude], @"longitude", nil];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"700", @"radius", @"15", @"limit", nil];

    [[RMMasterSDK FoursquareSDK] getUserlessExploreVenuesWithLatitudeLongitude:dict OrNear:nil AndParameters:params AndWithDelegate:self];
    
    NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f", latitude],@"lat", [NSString stringWithFormat:@"%f", longitude], @"lng", @"1000", @"distance", nil];
    
    [[RMMasterSDK InstagramSDK] getWAMediaSearchWithParams:dict2 AndWithDelegate:self];
    
}

-(void)loadNearbyExploreWithData:(NSDictionary *)array{

    NSLog(@"ArrayCount: %i",[[[/*[[*/[[array  objectForKey:@"response"] objectForKey:@"groups"] objectAtIndex:0] objectForKey:@"items"] count] /*objectForKey:@"venue"] objectForKey:@"location"] */);
    
    for (int i = 0; i < [[[[[array  objectForKey:@"response"] objectForKey:@"groups"] objectAtIndex:0] objectForKey:@"items"] count] ; i++)
    {
        RMMapViewAnnotation *annotation = [[RMMapViewAnnotation alloc] init];
        
        CLLocationCoordinate2D location;
       
        location.latitude = [[[[[[[[[array  objectForKey:@"response"] objectForKey:@"groups"] objectAtIndex:0] objectForKey:@"items"] objectAtIndex:i] objectForKey:@"venue"] objectForKey:@"location"] objectForKey:@"lat"] floatValue];
       location.longitude = [[[[[[[[[array  objectForKey:@"response"] objectForKey:@"groups"] objectAtIndex:0] objectForKey:@"items"] objectAtIndex:i] objectForKey:@"venue"] objectForKey:@"location"] objectForKey:@"lng"] floatValue];
        
        
        
        NSLog(@"LAT : %f LON: %f", location.latitude, location.longitude);
            
        annotation.coordinate = location;
        annotation.title = [[[[[[[array  objectForKey:@"response"] objectForKey:@"groups"] objectAtIndex:0] objectForKey:@"items"] objectAtIndex:i] objectForKey:@"venue"] objectForKey:@"name"];
            
        annotation.socialNetwork = @"Foursquare";
        
        [self.mapView addAnnotation:annotation];
        
    }
    
}

-(void)loadNerbyImagesWithData:(NSDictionary *)data{
    
    NSLog(@"ARRAY: %@", [[[[data objectForKey:@"data"] objectAtIndex:0] objectForKey:@"location"] objectForKey:@"latitude"]);
    NSLog(@"ARRAY: %@", [[[[data objectForKey:@"data"] objectAtIndex:0] objectForKey:@"location"] objectForKey:@"longitude"]);
    NSLog(@"ARRAY: %@", [[[[[data objectForKey:@"data"] objectAtIndex:0] objectForKey:@"images"] objectForKey:@"thumbnail"] objectForKey:@"url"]);
    
    
    for (int i = 0; i < [[data objectForKey:@"data"] count]; i++){
        
        RMMapViewAnnotation *annotation = [[RMMapViewAnnotation alloc] init];
        
        CLLocationCoordinate2D location;
        
        location.latitude = [[[[[data objectForKey:@"data"] objectAtIndex:i] objectForKey:@"location"] objectForKey:@"latitude"] floatValue];
        location.longitude = [[[[[data objectForKey:@"data"] objectAtIndex:i] objectForKey:@"location"] objectForKey:@"longitude"] floatValue];
        
        
        
        NSLog(@"LAT : %f LON: %f", location.latitude, location.longitude);
        
        annotation.coordinate = location;
        
       // UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[[[[data objectForKey:@"data"] objectAtIndex:i] objectForKey:@"images"] objectForKey:@"thumbnail"] objectForKey:@"url"]]]];
        
          NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[[[[[data objectForKey:@"data"] objectAtIndex:i] objectForKey:@"images"] objectForKey:@"thumbnail"] objectForKey:@"url"]]];
        
        AFImageRequestOperation *operation;
        operation = [AFImageRequestOperation imageRequestOperationWithRequest:request
                                                         imageProcessingBlock:nil
                                                                      success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                          
                                                                        annotation.photo = image;

                                                                      }
                                                                      failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                          NSLog(@"%@", [error localizedDescription]);
                                                                      }];
        [operation start];

       
        
        annotation.socialNetwork = @"Instagram";
        
        [self.mapView addAnnotation:annotation];
        
    }
}


@end
