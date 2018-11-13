//
//  SearchViewController.m
//  FLSBaiduMapDemo
//
//  Created by 天立泰 on 2018/9/7.
//  Copyright © 2018年 天立泰. All rights reserved.
//

#import "SearchViewController.h"
#import "cityModel.h"

@interface SearchViewController ()<UITextFieldDelegate,BMKSuggestionSearchDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITextField * searchText;
@property(nonatomic,strong)BMKSuggestionSearch * sugSearch;
@property(nonatomic,strong)NSMutableArray * cityDataArray;
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,assign)CLLocationCoordinate2D secLocation;


@end

@implementation SearchViewController
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
//不使用时将delegate设置为 nil
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.sugSearch.delegate = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.searchText];
    [self.view addSubview:self.tableView];
}
- (UITextField *)searchText{
    if (!_searchText) {
        _searchText = [[UITextField alloc] initWithFrame:CGRectMake(30, 80,KScreenWidth-60, 50)];
        _searchText.borderStyle = UITextBorderStyleLine;
        _searchText.backgroundColor = [UIColor redColor];
        _searchText.delegate = self;
    }
    return _searchText;
}
- (BMKSuggestionSearch *)sugSearch{
    if (!_sugSearch) {
        _sugSearch = [[BMKSuggestionSearch alloc] init];
        _sugSearch.delegate = self;
    }
    return _sugSearch;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"%@",textField.text);
    BMKSuggestionSearchOption* option = [[BMKSuggestionSearchOption alloc] init];
    option.cityname = @"北京";
    option.keyword  = textField.text;
    BOOL flag = [self.sugSearch suggestionSearch:option];
    if(flag){
        NSLog(@"Sug检索发送成功");
    }else{
        NSLog(@"Sug检索发送失败");
    }
}

/**
 *返回suggestion搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetSuggestionResult:(BMKSuggestionSearch *)searcher result:(BMKSuggestionSearchResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        [self.cityDataArray removeAllObjects];
        NSArray * array = result.suggestionList;
        for (BMKSuggestionInfo * info in array) {
            cityModel * model = [[cityModel alloc] init];
            model.name = [NSString stringWithFormat:@"%@",info.key];
            model.address = [NSString stringWithFormat:@"%@%@",info.city,info.district];
            model.location = info.location;
            [self.cityDataArray addObject:model];
        }
        [self.tableView reloadData];
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 200, KScreenWidth, KScreenHeight - 200) style:UITableViewStylePlain];
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
- (NSMutableArray *)cityDataArray{
    if (!_cityDataArray) {
        _cityDataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _cityDataArray;
}
#pragma mark tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cityDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    cityModel * model = self.cityDataArray[indexPath.row];
    static NSString * cellID = @"cduhcihwciudhichiwdi";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    cell.textLabel.text=model.name;
    cell.detailTextLabel.text=model.address;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    cityModel * model = self.cityDataArray[indexPath.row];
    if (self.backLocationBlick) {
        self.backLocationBlick(model.location);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
