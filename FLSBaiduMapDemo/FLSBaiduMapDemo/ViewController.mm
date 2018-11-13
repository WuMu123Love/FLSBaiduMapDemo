//
//  ViewController.m
//  FLSBaiduMapDemo
//
//  Created by 天立泰 on 2018/9/6.
//  Copyright © 2018年 天立泰. All rights reserved.
//

#import "ViewController.h"
#import "BaiduMapHeader.h"
#import "cityModel.h"
#import "SearchViewController.h"
@interface ViewController ()<BMKMapViewDelegate,BMKLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource,BMKGeoCodeSearchDelegate>{
    BMKGeoCodeSearch *_geoCodeSearch;
    BMKReverseGeoCodeSearchOption *_reverseGeoCodeOption;
}
@property (nonatomic, strong) BMKMapView *mapView; //当前界面的mapView
@property (nonatomic, strong) BMKLocationViewDisplayParam *param; //定位图层自定义样式参数
@property (nonatomic, strong) BMKLocationManager *locationManager; //定位对象
@property (nonatomic, strong) BMKUserLocation *userLocation; //当前位置对象

@property(nonatomic,strong)UIButton * locatePinBtn;
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray *cityDataArr;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    //当mapView即将被显示的时候调用，恢复之前存储的mapView状态
    [_mapView viewWillAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:NO];
    //当mapView即将被隐藏的时候调用，存储当前mapView的状态
    [_mapView viewWillDisappear];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(clickSearch)];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self createMapView];
    [self startUpdating];
    [self createLocationBtn];
    [self.view addSubview:self.tableView];
}
- (void)clickSearch{
    __weak typeof(self) ws = self;
    __block BMKMapView * map = _mapView;
    SearchViewController * vc = [[SearchViewController alloc] init];
    [vc setBackLocationBlick:^(CLLocationCoordinate2D location) {
        NSLog(@"您的选择位置:经度：%f,纬度：%f",location.longitude,location.latitude);
        dispatch_async(dispatch_get_main_queue(), ^{
            CLLocation * llocation = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
            ws.userLocation.location = llocation;
//            ws.userLocation.updating = YES;

            //        //实现该方法，否则定位图标不出现
            [map updateLocationData:ws.userLocation];
            //        //设置当前地图的中心点，改变该值时，地图的比例尺级别不会发生变化
            map.centerCoordinate = ws.userLocation.location.coordinate;
        });
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)createLocationBtn{
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 100, 30, 30)];
    [btn setBackgroundImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
- (void)click{
    __weak typeof(self) ws = self;
    __block BMKMapView * map = _mapView;
    [self.locationManager requestLocationWithReGeocode:YES withNetworkState:NO completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
        
        ws.userLocation.location = location.location;
        //实现该方法，否则定位图标不出现
        [map updateLocationData:ws.userLocation];
        //设置当前地图的中心点，改变该值时，地图的比例尺级别不会发生变化
        map.centerCoordinate = ws.userLocation.location.coordinate;
    }];
}
- (void)startUpdating{
    //开启定位服务
    [self click];
    //设置显示定位图层
    _mapView.showsUserLocation = YES;
    //设置定位模式为普通模式
    _mapView.userTrackingMode = BMKUserTrackingModeNone;
    //设置定位图标(屏幕坐标)X轴偏移量为0
    _param.locationViewOffsetX = 0;
    //设置定位图标(屏幕坐标)Y轴偏移量为0
    _param.locationViewOffsetY = 0;
    //设置定位图层locationView在上层(也可设置为在下层)
    _param.locationViewHierarchy = LOCATION_VIEW_HIERARCHY_BOTTOM;
    //设置显示精度圈
    _param.isAccuracyCircleShow = NO;
    //更新定位图层个性化样式
    [_mapView updateLocationViewWithParam:_param];
    /*🌺**/
    [_mapView bringSubviewToFront:self.locatePinBtn];
}
- (void)createMapView {
    //将mapView添加到当前视图中
    [self.view addSubview:self.mapView];
    //设置mapView的代理
    _mapView.delegate = self;
    //设置地图比例尺级别
    _mapView.zoomLevel = 15;
    //配置定位图层个性化样式，初始化BMKLocationViewDisplayParam的实例
    BMKLocationViewDisplayParam *param = [[BMKLocationViewDisplayParam alloc] init];
    self.param = param;
}
- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 64, KScreenWidth, (KScreenHeight - 64)/2)];
        _mapView.delegate = self;
        self.locatePinBtn =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//        self.locatePinBtn.backgroundColor = [UIColor yellowColor];
        [self.locatePinBtn setBackgroundImage:[UIImage imageNamed:@"serach_Map"] forState:UIControlStateNormal];
        
        self.locatePinBtn.center = CGPointMake(KScreenWidth/2, (KScreenHeight - 64)/4 - 15);
        
        [_mapView addSubview:self.locatePinBtn];
        
    }
    return _mapView;
}
- (BMKLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[BMKLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
        _locationManager.pausesLocationUpdatesAutomatically = NO;
        _locationManager.allowsBackgroundLocationUpdates = NO;
        _locationManager.locationTimeout = 10;
    }
    return _locationManager;
}
- (BMKUserLocation *)userLocation {
    if (!_userLocation) {
        _userLocation = [[BMKUserLocation alloc] init];
    }
    return _userLocation;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, (KScreenHeight-64)/2, KScreenWidth, (KScreenHeight-64)/2) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 80;
        _tableView.tableFooterView = [UIView new];
#ifdef __IPHONE_11_0
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
        }
#endif
    }
    return _tableView;
}
- (NSMutableArray *)cityDataArr{
    if (!_cityDataArr) {
        _cityDataArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _cityDataArr;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    //    //屏幕坐标转地图经纬度
        CLLocationCoordinate2D coordinate=[_mapView convertPoint:self.locatePinBtn.center toCoordinateFromView:_mapView];
  NSLog(@"您的当前位置:经度：%f,纬度：%f",coordinate.longitude,coordinate.latitude);
    if (_geoCodeSearch==nil) {
        //初始化地理编码类
        _geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
        _geoCodeSearch.delegate = self;

    }
    if (_reverseGeoCodeOption==nil) {

        //初始化反地理编码类
        _reverseGeoCodeOption= [[BMKReverseGeoCodeSearchOption alloc] init];
    }
    //需要逆地理编码的坐标位置
    _reverseGeoCodeOption.location = coordinate;
    [_geoCodeSearch reverseGeoCode:_reverseGeoCodeOption];
}

#pragma mark BMKGeoCodeSearchDelegate
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error{
    //获取周边用户信息
    if (error==BMK_SEARCH_NO_ERROR) {
        [self.cityDataArr removeAllObjects];
        for(BMKPoiInfo *poiInfo in result.poiList)
        {
            cityModel *model=[[cityModel alloc]init];
            model.name=poiInfo.name;
            model.address=poiInfo.address;
            [self.cityDataArr addObject:model];
        }
        [self.tableView reloadData];
    }else{
        
        NSLog(@"BMKSearchErrorCode: %u",error);
    }
    
}


#pragma mark tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cityDataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    cityModel * model = self.cityDataArr[indexPath.row];
    static NSString * cellID = @"cduhcihwhc9i";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    cell.textLabel.text=model.name;
    cell.detailTextLabel.text=model.address;
    return cell;
}


@end
