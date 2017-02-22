//
//  imageCollectionViewController.swift
//  FoodTracker
//
//  Created by 一戸悠河 on 2017/02/16.
//  Copyright © 2017年 Apple Inc. All rights reserved.
//

import UIKit
import CoreData
import Photos

private let reuseIdentifier = "Cell"

var cafeArray: [NSDictionary] = []
var cafeDic: NSDictionary! = [:]
var myCafe = NSArray() as! [String]
var count = 0

class imageCollectionViewController: UICollectionViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        read()
    }
    
    //既に存在するデータの読み込み処理
    func read() {
        //AppDelegateを使う用意をする
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //エンティティを操作するためのオブジェクトを作成
        let viewContext = appDelegate.persistentContainer.viewContext
        
        //どのエンティティからdataを取得してくるか設定
        let query:NSFetchRequest<Diary> = Diary.fetchRequest()
        
        do{
            //データを一括取得
            var fetchResults = try viewContext.fetch(query)
            print(fetchResults.count)
            //            print(fetchResults)
            //データの取得
            //一旦配列を空っぽにする（初期化する）→そうしないとどんどん、TableViewに表示されてしまう。
            myCafe = NSArray() as! [String]
            //nilが入るかもしれないのでasに?をつける。
            for result: AnyObject in fetchResults {
                
                let coffeeName:String? = result.value(forKey: "coffeeName") as? String
                let date: Date? = result.value(forKey: "date") as? Date
                let studyTime: NSNumber = (result.value(forKey: "studyTime") as? NSNumber)!
                let img: String? = result.value(forKey: "img") as? String
                let rating: NSNumber? = result.value(forKey: "rating") as? NSNumber
                print("name:\(coffeeName) saveDate:\(date) studyTime:\(studyTime) image:\(img) rating:\(rating)")
                cafeDic = ["coffeeName":coffeeName, "date":date, "studyTime":studyTime, "img":img, "rating":rating]
                cafeArray.append(cafeDic)
                print(cafeArray)
                //                myCafe = NSArray() as! [String]
                //                myCafe.append(coffeeName!)
                //                print(myCafe)
            }
        } catch {
        }
        //TableViewの再描画
        //        myTableView.reloadData()
    }
    
    // MARK: - UICollectionViewDelegate Protocol
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:imageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! imageCollectionViewCell
        cell.image.image = UIImage(named: "sample_coffee.JPG")
        
        return cell
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        for data in 1 ... cafeArray.count {
//          var imgDic = data as! NSDictionary
//            if imgDic["img"] as! String == nil {
//                var count = imgDic["img"] as! String
//            }
//        }
        
        
//        return count
        return 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
