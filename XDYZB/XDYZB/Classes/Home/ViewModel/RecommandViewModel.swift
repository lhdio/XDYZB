//
//  RecommandViewModel.swift
//  XDYZB
//
//  Created by takamashiro on 2016/9/28.
//  Copyright © 2016年 com.takamashiro. All rights reserved.
//

/*
 1> 请求0/1数组,并转成模型对象
 2> 对数据进行排序
 3> 显示的HeaderView中内容
 */

import UIKit

class RecommandViewModel  {
    // MARK:- 懒加载属性
    lazy var anchorGroups : [AnchorGroup] = [AnchorGroup]()
    fileprivate lazy var bigDataGroup : AnchorGroup = AnchorGroup()
    fileprivate lazy var prettyGroup : AnchorGroup = AnchorGroup()
}


//MARK:- 发送网络请求
extension RecommandViewModel {
    func requestData(_ finishCallback : @escaping () -> ()) {
        // 1.定义参数
        let parameters = ["limit" : "4", "offset" : "0", "time" : Date.getCurrentTime()]
        
        // 2.创建Group
        let dGroup = DispatchGroup()
        
        // 3.请求第一部分推荐数据
        dGroup.enter()
        NetworkTools.requestData(.GET, URLString: "http://capi.douyucdn.cn/api/v1/getbigDataRoom", parameters: ["time" : Date.getCurrentTime() as NSString]) { (result) in
            
            // 1.将result转成字典类型
            guard let resultDict = result as? [String : NSObject] else { return }
            
            // 2.根据data该key,获取数组
            guard let dataArray = resultDict["data"] as? [[String : NSObject]] else { return }
            
            // 3.遍历字典,并且转成模型对象
            // 3.1.设置组的属性
            self.bigDataGroup.tag_name = "热门"
            self.bigDataGroup.icon_name = "home_header_hot"
            
            // 3.2.获取主播数据
            for dict in dataArray {
                let anchor = AnchorModel(dict: dict)
                self.bigDataGroup.anchors.append(anchor)
            }
            
            // 3.3.离开组
            dGroup.leave()
        }
        
        // 4.请求第二部分颜值数据
        dGroup.enter()
        NetworkTools.requestData(.GET, URLString: "http://capi.douyucdn.cn/api/v1/getVerticalRoom", parameters: parameters as [String : NSString]?) { (result) in
            // 1.将result转成字典类型
            guard let resultDict = result as? [String : NSObject] else { return }
            
            // 2.根据data该key,获取数组
            guard let dataArray = resultDict["data"] as? [[String : NSObject]] else { return }
            
            // 3.遍历字典,并且转成模型对象
            // 3.1.设置组的属性
            self.prettyGroup.tag_name = "颜值"
            self.prettyGroup.icon_name = "home_header_phone"
            
            // 3.2.获取主播数据
            for dict in dataArray {
                let anchor = AnchorModel(dict: dict)
                self.prettyGroup.anchors.append(anchor)
            }
            
            // 3.3.离开组
            dGroup.leave()
        }
        
        // 5.请求2-12部分游戏数据
        dGroup.enter()
        // http://capi.douyucdn.cn/api/v1/getHotCate?limit=4&offset=0&time=1474252024
        NetworkTools.requestData(.GET, URLString: "http://capi.douyucdn.cn/api/v1/getHotCate", parameters: parameters as [String : NSString]?) { (result) in
            // 1.将result转成字典类型
            guard let resultDict = result as? [String : NSObject] else { return }
            
            // 2.根据data该key,获取数组
            guard let dataArray = resultDict["data"] as? [[String : NSObject]] else { return }
            
            // 3.遍历数组,获取字典,并且将字典转成模型对象
            for dict in dataArray {
                let group = AnchorGroup(dict: dict)
                self.anchorGroups.append(group)
            }
            
            // 4.离开组
            dGroup.leave()
        }
        
        
        // 6.所有的数据都请求到,之后进行排序
        dGroup.notify(queue: DispatchQueue.main) {
            self.anchorGroups.insert(self.prettyGroup, at: 0)
            self.anchorGroups.insert(self.bigDataGroup, at: 0)
            
            finishCallback()
        }
    }
}
