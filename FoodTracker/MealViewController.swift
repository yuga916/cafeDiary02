//
//  MealViewController.swift
//  FoodTracker
//
//  Created by Jane Appleseed on 10/17/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit
import CoreData
import Photos
import os.log

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var studyTime: UITextField!
    
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    /*
         This value is either passed by `MealTableViewController` in `prepare(for:sender:)`
         or constructed as part of adding a new meal.
     */
    var meal: Meal?
    
    
    var myTextField = NSArray() as! [String]
    var strURL: String = ""
    var textView: UITextView!
    var num:Int = 0
    var selectedRating: Int!
//    受け取り用の変数
    var scSelectedDate = NSDate()
    
    
    //テスト
    var myTitle = NSArray() as! [String]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        
        //完了ボタンの生成
        //init toolbar
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 30))
        //create left side empty space so that done button set on right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: Selector(("doneButtonAction")))
        //array of BarButtonItems
        var arr = [UIBarButtonItem]()
        arr.append(flexSpace)
        arr.append(doneBtn)
        toolbar.setItems(arr, animated: false)
        toolbar.sizeToFit()
        //setting toolbar as inputAccessoryView
        self.studyTime.inputAccessoryView = toolbar
        
        //ratingの初期値設定
        ratingControl.rating = 0
        ratingControl.layer.cornerRadius = 5
//        ratingControl.rating = selectedRating
        read()
    }
    
    //numpadのdoneが押されたら
    func doneButtonAction(){
        self.view.endEditing(true)
    }
    
    
    //MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    
    //キーボードが立ち上がるとき
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        print(textField.tag)
        switch textField.tag {
        case 1:
            //cafe名記入欄の表示
            return true
        case 2:
            self.studyTime.keyboardType = UIKeyboardType.decimalPad
            return true
        default:
            return true
        }
    }
    
    //編集後の操作
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
     
//        StringなのでNumberに変更して格納
//        var studyTime:NSNumber = self.studyTime.text as! NSNumber
        print(textField.tag)
        //studyTime入力の時は、StringをIntに変換して格納
        if textField.tag == 2 {
        
            var str = self.studyTime.text
            print(self.studyTime.text)
            num = Int(str!)!
            print(num)
            
        }
        
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled
        dismiss(animated: true, completion: nil)
    }
    
    //カメラロールで選択された後の処理
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
        
        
        
        let assetURL:AnyObject = info[UIImagePickerControllerReferenceURL]! as AnyObject
        
        strURL = assetURL.description
        if strURL != "" {
            let url = URL(string: strURL as String!)
            let fetchResult: PHFetchResult = PHAsset.fetchAssets(withALAssetURLs: [url!], options: nil)
            let asset: PHAsset = (fetchResult.firstObject! as PHAsset)
            let manager: PHImageManager = PHImageManager()
            manager.requestImage(for: asset,targetSize: CGSize(width: 500, height: 500),contentMode: .aspectFit,options: nil) { (image, info) -> Void in
                self.photoImageView.image = image
                //閉じる処理
                picker.dismiss(animated: true, completion: nil)

            }
        }
    }
    

    
    
    //MARK: バリデーション（空白の確認）
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }


    //MARK: Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
    
            return
    }
    
    //MARK: 画像を選択したとき
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        // Hide the keyboard.
        nameTextField.resignFirstResponder()
        studyTime.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    


//    //データの保存
//    func tapSave(_ sender: UIBarButtonItem) {
//        //　AppDelegateを使う用意をしておく
//        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
//        
//        //エンティティを操作するためのオブジェクトを作成
//        //DB接続をするのと同じ
//        let viewContext = appDelegate.persistentContainer.viewContext
//        
//        //ToDoエンティティオブジェクトを作成
//        let ToDo = NSEntityDescription.entity(forEntityName: "Diary", in: viewContext)
//        
//        //ToDoエンティティにレコード（行)を挿入するためのオブジェクトを作成
//        let newRecord = NSManagedObject(entity: ToDo!, insertInto: viewContext)
//        
//        //値のセット
//        newRecord.setValue(nameTextField.text ?? String(), forKey: "coffeeName")
//        newRecord.setValue(scSelectedDate, forKey: "date")
//        newRecord.setValue(num, forKey: "studyTime")
//        newRecord.setValue(strURL, forKey: "img")
//        newRecord.setValue(ratingControl.rating, forKey: "rating")
//        
//        
//        
//        
//        
//        //例外処理
//        do{
//            //レコード（行）の即時保存
//            try viewContext.save()
//            
//            //前の画面に戻る
//            navigationController?.popViewController(animated: true)
//        } catch {
//        }
//        
//        
//    }
    
    //データの保存
   func tapSave(_ sender: UIBarButtonItem) {
    //AppDelegateを使う用意をする
    let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //エンティティを操作するためのオブジェクトを作成
    let viewContext = appDelegate.persistentContainer.viewContext
    
    //どのエンティティからdataを取得してくるか設定
    let query:NSFetchRequest<Diary> = Diary.fetchRequest()
    
    do{
        //データを一件取得
        //            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "date")
        query.predicate = NSPredicate(format:"date = %@", scSelectedDate)
        let fetchResults = try! viewContext.fetch(query)
        
        print(fetchResults.count)
        
        if fetchResults.count == 0 {
            //ToDoエンティティオブジェクトを作成
            let ToDo = NSEntityDescription.entity(forEntityName: "Diary", in: viewContext)
            
            //ToDoエンティティにレコード（行)を挿入するためのオブジェクトを作成
            let newRecord = NSManagedObject(entity: ToDo!, insertInto: viewContext)
            
            //値のセット
            newRecord.setValue(nameTextField.text ?? String(), forKey: "coffeeName")
            newRecord.setValue(scSelectedDate, forKey: "date")
            newRecord.setValue(num, forKey: "studyTime")
            newRecord.setValue(strURL, forKey: "img")
            newRecord.setValue(ratingControl.rating, forKey: "rating")
            //例外処理
            do{
                //レコード（行）の即時保存
                try viewContext.save()
                
                //前の画面に戻る
                navigationController?.popViewController(animated: true)
            } catch {
            }
        
            
        } else {
        
        
            
        //nilが入るかもしれないのでasに?をつける。
        for result: AnyObject in fetchResults {
            
                    result.setValue(nameTextField.text ?? String(), forKey: "coffeeName")
                    result.setValue(scSelectedDate, forKey: "date")
                    result.setValue(num, forKey: "studyTime")
                    result.setValue(strURL, forKey: "img")
                    result.setValue(ratingControl.rating, forKey: "rating")
            
            
        }
                do{
                    //レコード（行）の即時保存
                    try viewContext.save()
                    
                    //前の画面に戻る
                    navigationController?.popViewController(animated: true)
    } catch {
    }
    
    //TableViewの再描画
    //        myTableView.reloadData()
    }
    }
    }

    //移動画面からの戻り口
    @IBAction func returnMenu(_ segue:UIStoryboardSegue){
        
        //スタート地点に戻ってくる場合は"segue.source"と書き換えなければならない。
        let secondVC = segue.source as! MealViewController
        
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
            //データを一括取得
            //            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "date")
            query.predicate = NSPredicate(format:"date = %@", scSelectedDate)
            let fetchResults = try viewContext.fetch(query)
            
            
            print(fetchResults.count)
            //            print(fetchResults)
            //データの取得
            //一旦配列を空っぽにする（初期化する）→そうしないとどんどん、TableViewに表示されてしまう。
            
            //nilが入るかもしれないのでasに?をつける。
            for result: AnyObject in fetchResults {
                
                let coffeeName:String? = result.value(forKey: "coffeeName") as? String
                let date: Date? = result.value(forKey: "date") as? Date
                let studyTimenum: NSNumber = (result.value(forKey: "studyTime") as? NSNumber)!
                let img: String? = result.value(forKey: "img") as? String
                let rating: NSNumber? = result.value(forKey: "rating") as? NSNumber
                print("name:\(coffeeName) saveDate:\(date) studyTime:\(studyTime) image:\(img) rating:\(rating)")
                //                myCafe = NSArray() as! [String]
                //                myCafe.append(coffeeName!)
                //                print(myCafe)
                //下画面の変更
                nameTextField.text = "\(coffeeName!)"
                studyTime.text = "\(studyTimenum)"
                num = studyTimenum as! Int
                ratingControl.rating = rating as! Int
                var AImage: UIImage!
                if img == nil {
                    photoImageView.image = UIImage(named: "defaultPhoto")
                } else {
                    let url = URL(string: (img! as String))
                    let fetchResult: PHFetchResult = PHAsset.fetchAssets(withALAssetURLs: [url!], options: nil)
                    let asset: PHAsset = (fetchResult.firstObject! as PHAsset)
                    let manager: PHImageManager = PHImageManager()
                    manager.requestImage(for: asset,targetSize: CGSize(width: 5, height: 500),contentMode: .aspectFill,options: nil) { (image, info) -> Void in
                        //                        self.cell.tableMyImg.image = image
                        AImage = image
                        self.strURL = img!
                    }
                    photoImageView.image = AImage
                }
            }
        } catch {
        }
        //TableViewの再描画
//        myTableView.reloadData()
    }
}
