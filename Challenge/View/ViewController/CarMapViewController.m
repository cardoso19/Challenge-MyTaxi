//
//  CarMapViewController.m
//  Challenge
//
//  Created by Matheus Cardoso kuhn on 06/04/19.
//  Copyright © 2019 MDT. All rights reserved.
//

#import "CarMapViewController.h"
#import "CarMapViewModel.h"
#if TEST
#import "ChallengeTests-Swift.h"
#else
#import "Challenge-Swift.h"
#endif

@interface CarMapViewController ()
#pragma mark - IBOutlets
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *carListContainerView;
@property (weak, nonatomic) IBOutlet UIButton *buttonUserLocation;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintContainerViewHeight;
@property (nonatomic) CarListViewModel *viewModelList;
@property (nonatomic) CarMapViewModel *viewModelMap;
@end

@implementation CarMapViewController

#pragma mark - Variables
__weak CarListViewController *containerController;

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViewModels];
    [containerController setWithViewModel:_viewModelList];
    [self configGestureRecognizer];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier  isEqual: @"containerSegue"]) {
        containerController = segue.destinationViewController;
    }
}

- (void)configViewModels {
    _viewModelList = [[CarListViewModel alloc] init];
    _viewModelMap = [[CarMapViewModel alloc] init];
    __weak CarMapViewController *weakSelf = self;
    [_viewModelMap setFirstLocationUpdateClosure:^(CLLocation * _Nonnull userLocation) {
        [weakSelf setRegionWith:userLocation];
    }];
}

- (void)configGestureRecognizer {
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(actionPanGesture:)];
    panGesture.maximumNumberOfTouches = 1;
    panGesture.minimumNumberOfTouches = 1;
    [_carListContainerView addGestureRecognizer:panGesture];
}

#pragma mark - IBActions
- (IBAction)actionZoomUserLocation:(UIButton *)sender {
    [UIView animateWithDuration:0.5 animations:^{
        [self setRegionWith:self.viewModelMap.getLastUserLocation];
    }];
}

- (void)actionPanGesture:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:_carListContainerView];
    CGFloat currentConstraintValue = _constraintContainerViewHeight.constant;
    if(sender.state == UIGestureRecognizerStateEnded) {
        CGFloat newConstraintValue = [self.viewModelMap getListHeight:currentConstraintValue translationY:translation.y];
        [self.constraintContainerViewHeight setConstant:newConstraintValue];
        [UIView animateWithDuration:0.25 animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self.viewModelMap setIsPainGestureActivated:false];
        }];
    } else {
        CGFloat newConstraintValue = [_viewModelMap calculateHeight:currentConstraintValue translationY:translation.y];
        [self.constraintContainerViewHeight setConstant:newConstraintValue];
        [_viewModelMap setIsPainGestureActivated:true];
    }
    
    [sender setTranslation:CGPointZero inView:_carListContainerView];
}

#pragma mark - Map
- (void)setRegionWith:(CLLocation *)location {
    [self.mapView setRegion: MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.01, 0.01))];
}

- (void)createCarAnnotations {
    [_mapView addAnnotations:[_viewModelMap createCarAnnotationsWith:_viewModelList.cars]];
}

#pragma mark - MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if([annotation isKindOfClass:[CarAnnotation class]]) {
        CarAnnotation *carAnnotation = (CarAnnotation *)annotation;
        CarAnnotationView *view = [[CarAnnotationView alloc] initWithFrame:[_viewModelMap getAnnovationViewRect] icon:[_viewModelList getIconWithCar:carAnnotation.car] heading:[_viewModelMap getAnnotationViewRotationAngleWith:carAnnotation]];
        return view;
    }
    return NULL;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    if(![_viewModelMap getIsPainGestureActivated]) {
        __weak CarMapViewController *weakSelf = self;
        NSArray<CLLocation *> *locations = [_viewModelMap convertBoundsOnCoordinatesOf:mapView];
        [_viewModelList requestCarsWithBottomCoordinate:locations[0].coordinate topCoordinate:locations[1].coordinate userLocation:[_viewModelMap getLastUserLocation] completion:^(NSError * _Nullable error) {
            if (error != NULL) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:NULL];
                [alertController addAction:actionOk];
                [weakSelf presentViewController:alertController animated:true completion:NULL];
            } else {
                [mapView removeAnnotations:[weakSelf.viewModelMap getAllAnnotations]];
                [containerController.tableViewCars reloadData];
                [weakSelf createCarAnnotations];
            }
        }];
    }
}

@end
