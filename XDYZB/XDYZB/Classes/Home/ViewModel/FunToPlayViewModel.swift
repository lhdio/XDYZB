 //
//  FunToPlayViewModel.swift
//  XDYZB
//
//  Created by takamashiro on 2016/10/11.
//  Copyright © 2016年 com.takamashiro. All rights reserved.
//

import UIKit


 class FunToPlayViewModel : BaseViewModel {
    // 用于上下拉刷新
    var currentPage = 0
    lazy var FunToPlays : [AnchorModel] = [AnchorModel]()
}

extension FunToPlayViewModel {
    func loadFunToPlayData(finishedCallback : @escaping () -> ()) {
      
        let parameters = ["limit" : 20 ,"offset" : 20 * currentPage]
        loadAnchorData(isGroupData: false, URLString: kGetFunToPlayData, parameters: parameters) {
            finishedCallback()
        }
      
    }
}
//下拉刷新
//前20
//http://capi.douyucdn.cn/api/v1/getColumnRoom/3?offset=0&limit=20

//更多刷新 更改offset，limit还是为20

extension FunToPlayViewModel {
    func getParameters(isMore:Bool)-> [String : NSString] {
        
        let key1 = "offset"
        let key2 = "limit"
        var keyValue1 = 0   //改变值
        let keyValue2 = 20
        
        if isMore {
            keyValue1 = keyValue1 + 20
        }else {
            keyValue1 = 0
        }
        
        return [key1:"\(keyValue1)" as NSString,key2:"\(keyValue2)" as NSString]
    }
}
