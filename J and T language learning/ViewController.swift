//
//  ViewController.swift
//  J and T language learning
//
//  Created by 太田和希 on 2020/12/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var Japanese: UILabel!
    @IBOutlet var hurigana: UILabel!
    @IBOutlet var Taiwanese: UILabel!
    @IBOutlet var bopomofo: UILabel!
    
    var number = 1 //文章の通し番号
    var tapCondition = 0 //0:？を表示,1:文章を表示
    var csvLines = [String]() //csvファイルを行ごとに分割
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //csvファイルの読み込み
        guard let path = Bundle.main.path(forResource:"sentence", ofType:"csv") else {
            print("csvファイルがないよ")
            return
        }
        
        //csvファイルを行ごとに分割
        //GoogleSpreadSheetで作成したcsvファイルは改行コードが一行ごとに入る仕様のようなので、削除し解決
        do {
            let csvString = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
            csvLines = csvString.components(separatedBy: .newlines)
            csvLines = csvLines.filter{!$0.isEmpty} //csvの空白要素を削除
        } catch let error as NSError {
            print("エラー: \(error)")
            return
        }
        
        //ボタンが押されるまで初期の表示になっていたため、表示する関数を置いて最初の文章を表示するように変更
        hyouzi(condition: tapCondition)
    }
    
    //ボタンが押されたらカウントアップする
    @IBAction func Next(_ sender: Any) {
        //countupをして次の文章に送る
        number = number + 1
        tapCondition = 0
        hyouzi(condition: tapCondition)
    }
    
    
    //ボタンが押されたらカウントダウンする
    @IBAction func Back(_ sender: Any) {
        //countdownして前の文章に戻す
        number = number - 1
        
        //通し番号１の状態で戻るボタンを押した時に？に戻る現象の応急処置
        if number < 1 && tapCondition == 1 {
            tapCondition = 1
        } else {
            tapCondition = 0
        }
        hyouzi(condition: tapCondition)
    }
    
    //透明ボタンを押した時のアクション
    @IBAction func hide_upper(_ sender: UIButton) {
        hyouzi(condition: tapCondition)
    }
    
    
    //透明ボタンを押した時のアクション
    @IBAction func hide_under(_ sender: UIButton){
        tapCondition = 1
        hyouzi(condition: tapCondition)
    }
    
    
    //文章を表示
    func hyouzi(condition: Int) {
        
        //範囲外の配列を受け付けないように設定
        if number < 1 {
            number = 1
        }
        //csvの行から要素に分割
        let sentenceDetail = csvLines[number].components(separatedBy: ",")
        
        Japanese.text = "\(sentenceDetail[1])"
        hurigana.text = "\(sentenceDetail[2])"
        
        if condition < 1 {
            //タップされていないときは？を出力
            Taiwanese.text = "?"
            bopomofo.text = ""
        } else {
            //タップされたら文章を出力
            Taiwanese.text = "\(sentenceDetail[3])"
            bopomofo.text = "\(sentenceDetail[4])"
        }
    }
    
}
