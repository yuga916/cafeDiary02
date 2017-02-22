//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by Jane Appleseed on 11/15/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit
import CoreData
import Photos

class MealTableViewController: UITableViewController {
    
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
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cafeArray.count
    }

    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        // Table view cells are reused and should be dequeued using a cell identifier.
//        let cellIdentifier = "MealTableViewCell"
//        
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell  else {
//            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
//        }
    
    //セルの内容
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
    //行が選択された時に発動
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)行目")
        var cafeRow = cafeArray[indexPath.row] as! NSDictionary
        
        
        
        //        セグエを通して画面遷移する
        //        →セグエを選択して、identifierに"showSecondView"を指定する
        performSegue(withIdentifier: "showSecondView", sender: nil)
        
    }
    
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

  

}
