//
//  listViewController.swift
//  FoodTracker
//
//  Created by 一戸悠河 on 2017/02/17.
//  Copyright © 2017年 Apple Inc. All rights reserved.
//

import UIKit
import CoreData
import Photos


class listViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //MARK: Properties
    var cafeArray: [NSDictionary] = []
    var cafeDic: NSDictionary! = [:]
    var myCafe = NSArray() as! [String]
    
    
    
    var selectedImageURL: String!
    var selectedName: String!
    var selectedDate: Date!
    var selectedRating: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        read()
        
    }

    //既に存在するデータの読み込み処理
    func read() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
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
        //配列は降順になっているから、昇順にする
        let sortDescription = NSSortDescriptor(key: "rating", ascending: false)
        let sortDescArray = [sortDescription]
        self.cafeArray = ((self.cafeArray as NSArray).sortedArray(using: sortDescArray) as NSArray) as! [NSDictionary]
    }
    
    //データの削除処理
    
    
    
    //MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cafeArray.count
    }
    
    //セルの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MealTableViewCell") as! MealTableViewCell
        
        //とってきてるのはディクショナリー型なのでディクショナリーで変換する
        var cafeDic = cafeArray[indexPath.row] as! NSDictionary
        cell.nameLabel.text = cafeDic["coffeeName"] as! String
        
        //画像
        var imgDic = cafeArray[indexPath.row] as! NSDictionary
        var AImage: UIImage!
        if imgDic["img"] as? String == nil {
            cell.photoImageView.image = UIImage(named: "defaultPhoto")
        } else {
            let url = URL(string: (imgDic["img"] as! NSString) as String)
            let fetchResult: PHFetchResult = PHAsset.fetchAssets(withALAssetURLs: [url!], options: nil)
            let asset: PHAsset = (fetchResult.firstObject! as PHAsset)
            let manager: PHImageManager = PHImageManager()
            manager.requestImage(for: asset,targetSize: CGSize(width: 5, height: 500),contentMode: .aspectFill,options: nil) { (image, info) -> Void in
                //                        self.cell.tableMyImg.image = image
                AImage = image
            }
            cell.photoImageView.image = AImage
        }
        
        //評価
        var ratingDic = cafeArray[indexPath.row] as! NSDictionary
        cell.ratingControl.rating = Int(cafeDic["rating"] as! NSNumber)
        
        
        return cell
    }
    
    
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
