//
//  ViewController.m
//  缓存
//
//  Created by zxc-02 on 16/10/19.
//  Copyright © 2016年 zxc-02. All rights reserved.
//

#import "ViewController.h"
#import "YGBanner.h"
#import "HttpRequest.h"
#import "AFNetworking.h"
#import "BannerModel.h"
#import "BannerDB.h"
#import "BannModel.h"
//轮播图
#define kBannerURL @"http://api.liwushuo.com/v2/banners?gender=1&generation=1"

#define kSvcURL @"http://api.liwushuo.com/v2/secondary_banners?gender=1&generation=1"

@interface ViewController ()
@property (nonatomic, strong) YGBanner *banner;
@property (nonatomic, strong) NSMutableArray *tmpArr;

@property (nonatomic, strong) YGBanner *ban;
@property (nonatomic, strong) NSMutableArray *tmpBanArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tmpArr = [[NSMutableArray alloc] init];
    
    // 获取本地轮播数据
//    NSArray *ygBModels = [self bannerModels:[[BannerDB shared] findAll]];
   
    NSArray *ygBModels = [BannerModel searchAll];
   
    _banner = [[YGBanner alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,230) imageHandle:^(NSInteger index)
    {
        NSLog(@"第%ld张",index);
    }];
    
    [self.view addSubview:_banner];
    
    if (ygBModels.count > 0) {
        [_banner reloadYGBanner:[self bannerModels:ygBModels]];
        
        [BannerModel deleteForproperty:@{@"title":@"感恩节礼物场"}];
        NSArray *arr = [BannerModel searchLinesWhithPropertyA:@"imageurl" PropertyB:@"title"];
        NSLog(@"arryy=%@  imageurl=%@ title=%@",arr,[arr valueForKey:@"imageurl"],[arr valueForKey:@"title"]);
        
    } else {
        [self getBannerListURL:kBannerURL key:@"banners"];
    }
    
    
    
    self.tmpBanArr = [[NSMutableArray alloc] init];
    NSArray *banModels = [BannModel searchAll];
    
    _ban = [[YGBanner alloc] initWithFrame:CGRectMake(0, 350, [UIScreen mainScreen].bounds.size.width,230) imageHandle:^(NSInteger index)
               {
                   NSLog(@"第%ld张",index);
               }];
    
    [self.view addSubview:_ban];
    
    if (banModels.count > 0) {
        [_ban reloadYGBanner:[self bannerModels:banModels]];
    } else {
        [self getBannerListURL:kSvcURL key:@"secondary_banners"];
    }

}

- (void)getBannerListURL:(NSString *)urlStr key:(NSString *)key
{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 获取网络轮播图片
    [HttpRequest GET:urlStr params:nil completion:^(id jsonObj) {
        
        for (id obj in jsonObj[@"data"][key]) {
           NSString *imageurl = obj[@"image_url"];
            if ([key isEqualToString:@"banners"]) {
                BannerModel *model = [BannerModel getUserInfoFromDBkey:imageurl obj:obj];
                [self.tmpArr addObject:model];

            } else {
                BannModel *modell = [BannModel getUserInfoFromDBkey:imageurl obj:obj];
                [self.tmpBanArr addObject:modell];
            }
            
            
           //KVC
//            NSDictionary *dic = obj[@"target"];
//            BannerModel *model = [[BannerModel alloc] init];
//            [model setValuesForKeysWithDictionary:obj];

            //JSONModel
//             BannerModel *model = [[BannerModel alloc]initWithDictionary:obj error:nil];
           
            
            
           
        }

        // 更新轮播模型
        [_banner reloadYGBanner:[self bannerModels:self.tmpArr]];
        [_ban reloadYGBanner:[self bannerModels:self.tmpBanArr]];
        // 移除轮播数据
//        [[BannerDB shared] deleteAll];
        
        if (self.tmpArr.count > 0) {
            //  插入数据到数据库
//            [[BannerDB shared] insertModels:self.tmpArr];
        }
       
    } faild:^(NSError *error) {
        NSLog(@"首页轮播图加载失败");
        
    }];
}

#pragma mark -  转化为轮播模型
- (NSArray *)bannerModels:(NSArray *)models
{
    NSMutableArray *banners = [[NSMutableArray alloc] init];
    
    for (BannerModel *model in models) {
        
        YGBannerModel *ygBM = [[YGBannerModel alloc] init];
        ygBM.title = model.title;
        ygBM.imgUrl = model.imageurl;
        
        [banners addObject:ygBM];
    }
    
    return banners;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
