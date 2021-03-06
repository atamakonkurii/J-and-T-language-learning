//
//  ViewController.swift
//  J and T language learning
//
//  Created by 太田和希 on 2020/12/22.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet var Japanese: UILabel!
    @IBOutlet var hurigana: UILabel!
    @IBOutlet var Taiwanese: UILabel!
    @IBOutlet var bopomofo: UILabel!
    @IBOutlet weak var changeLangageButton: UIButton!
    
    
    var number = 1 //文章の通し番号
    var tapCondition = 0 //0:？を表示,1:文章を表示
    var chLangFlag = 0 //0:日本語 1:台湾中国語
    var csvLines = [String]() //csvファイルを行ごとに分割
    
    var audioPlayer: AVAudioPlayer!
    
    let japanImage = UIImage(named: "flag1")
    let taiwanImage = UIImage(named: "flag2")
    

    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        
        //csvファイルの読み込み
        guard let path = Bundle.main.path(forResource:"sentence/sentence", ofType:"csv") else {
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
        playSound(name: "sound/soundJapanese/\(number)_J.m4a")
    }
    
    //ボタンが押されたらカウントアップする
    @IBAction func Next(_ sender: Any) {
        //countupをして次の文章に送る
        number = number + 1
        
        //通し番号が配列の最大値の時の状態で進むボタンを押した時に？に戻る現象の応急処置
        if number > (csvLines.count - 1) && tapCondition == 1 {
            tapCondition = 1
        } else {
            tapCondition = 0
        }

        hyouzi(condition: tapCondition)
        playSoundUpper()
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
        playSoundUpper()
    }
    
    //透明ボタンを押した時のアクション
    @IBAction func hide_upper(_ sender: UIButton) {
        hyouzi(condition: tapCondition)
        playSoundUpper()
    }
    
    
    //透明ボタンを押した時のアクション
    @IBAction func hide_under(_ sender: UIButton){
        tapCondition = 1
        hyouzi(condition: tapCondition)
        playSoundLower()
    }
    
    
    @IBAction func changeLanguage(_ sender: UIButton) {
        
        if chLangFlag == 0 {
            
            //台湾語へ切り替え
            changeLangageButton.setImage(taiwanImage, for: .normal)
            chLangFlag = 1
            
        } else {
            
            //日本語へ切り替え
            changeLangageButton.setImage(japanImage, for: .normal)
            chLangFlag = 0
            
        }
        
        tapCondition = 0
        
        hyouzi(condition: tapCondition)
        playSoundUpper()
    }
    
    //文章を表示
    func hyouzi(condition: Int) {
        
        //範囲外の配列を受け付けないように設定
        if number < 1 {
            number = 1
        }else if number > (csvLines.count - 1){
            number = csvLines.count - 1
        }
        //csvの行から要素に分割
        
        let sentenceDetail = csvLines[number].components(separatedBy: ",")
        
        //chLangFlagの状態を見て上に表示する言語を切り替える
        if chLangFlag == 0{
            
            Japanese.text = "\(sentenceDetail[1])"
            hurigana.text = "\(sentenceDetail[2])"
            
            if condition < 1 {
                //タップされていないときは？を出力
                Taiwanese.text = "?"
                Taiwanese.textAlignment = NSTextAlignment.center
                bopomofo.text = ""
            } else {
                //タップされたら文章を出力
                Taiwanese.text = "\(sentenceDetail[3])"
                Taiwanese.textAlignment = NSTextAlignment.left
                bopomofo.text = "\(sentenceDetail[4])"
            }
            
        } else {
            
            Japanese.text = "\(sentenceDetail[3])"
            hurigana.text = "\(sentenceDetail[4])"
            
            if condition < 1 {
                //タップされていないときは？を出力
                Taiwanese.text = "?"
                Taiwanese.textAlignment = NSTextAlignment.center
                bopomofo.text = ""
            } else {
                //タップされたら文章を出力
                Taiwanese.text = "\(sentenceDetail[1])"
                Taiwanese.textAlignment = NSTextAlignment.left
                bopomofo.text = "\(sentenceDetail[2])"
            }
        }
        
        
    }
    
    //上側の文章を再生
    func playSoundUpper() {
        
        let soundNum: String = String(format: "%04d", number)
        
        if chLangFlag == 0 {
            playSound(name: "sound/soundChangeProgram/soundJapanese/wav_cut/J_\(soundNum).wav")
        } else {
            playSound(name: "sound/soundChangeProgram/soundTaiwanese/wav_cut/T_\(soundNum).wav")
        }
    }
    
    //下側の文章を再生
    func playSoundLower() {
        
        let soundNum: String = String(format: "%04d", number)
        
        if chLangFlag == 0 {
            playSound(name: "sound/soundChangeProgram/soundTaiwanese/wav_cut/T_\(soundNum).wav")
        } else {
            playSound(name: "sound/soundChangeProgram/soundJapanese/wav_cut/J_\(soundNum).wav")
        }
    }
    
}

extension ViewController: AVAudioPlayerDelegate {
    func playSound(name: String) {
        let soundPath = name.split(separator: ".").map { String($0) }
        if !isValidSoundPath(soundPath) {
            print("音源ファイル名が無効です。")
            return
        }

        guard let path = Bundle.main.path(forResource: soundPath[0], ofType: soundPath[1]) else {
            print("音源ファイルが見つかりません")
            return
        }

        do {
            // AVAudioPlayerのインスタンス化
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))

            // AVAudioPlayerのデリゲートをセット
            audioPlayer.delegate = self

            // 音声の再生
            audioPlayer.play()
        } catch {
        }
    }

    func isValidSoundPath(_ soundPath: [String]) -> Bool {
        // ここは目的とか状況によって柔軟に。
        // たとえば拡張子によって判定するとか
        return soundPath.count == 2
    }
}
