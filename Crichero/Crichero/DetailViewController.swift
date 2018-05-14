//
//  DetailViewController.swift
//  Crichero
//
//  Created by ios dev 4 on 17/01/18.
//  Copyright © 2018 ios dev 4. All rights reserved.
//

import UIKit
import AVFoundation

class DetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    @IBOutlet weak var lblBowler2: UILabel!
    @IBOutlet weak var lblBowler: UILabel!
    @IBOutlet weak var lblBatsmen2: UILabel!
    @IBOutlet weak var lblBatsmen: UILabel!
    @IBOutlet weak var lblOvers: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var lblMain: UILabel!
    
    @IBOutlet weak var tblCommentary: UITableView!
    var tblData = [String]()

    
    var matchID = String()
    var mainTitle = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblCommentary.delegate = self; tblCommentary.dataSource = self;
        
 
        
        if #available(iOS 10.0, *) {
            Timer.scheduledTimer(withTimeInterval:12, repeats: true) { (Tim) in
                self.refresh()
            }
            
            Timer.scheduledTimer(withTimeInterval:100, repeats: true) { (Tim) in
        self.speechScore()
            }
        } else {
            // Fallback on earlier versions
        }
        

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        refresh()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func refresh()
    {
        lblMain.text = mainTitle
        getDataDict("http://cricketapi.herokuapp.com/livescore?matchId=\(matchID)") { (dict) in
            DispatchQueue.main.async {
                
                
                print(dict)
                
                let batDict = dict["batting"] as! [String:Any];let bowDict = dict["bowling"] as! [String:Any]
                let batsmen = batDict["batsman"] as! [[String:Any]];
                let bowler = bowDict["bowler"] as! [[String:Any]]
                let score = batDict["score"] as! [[String:Any]]
                self.lblBatsmen.text = "\(batsmen[0]["name"]as! String)  -  \(batsmen[0]["runs"]as! String) runs"
                if batsmen.count > 1{
                self.lblBatsmen2.text = "\( batsmen[1]["name"]as! String)  -  \(batsmen[1]["runs"]as! String) runs"
                }
                        if bowler.count > 1{
                self.lblBowler2.text = "\( bowler[1]["name"] as! String)  -  \(bowler[1]["overs"]as! String) Ovrs "
                }
                self.lblBowler.text = "\( bowler[0]["name"] as! String)  -  \(bowler[0]["overs"]as! String) Ovrs "
                self.lblScore.text = "   \(batDict["team"] as! String)  \( score[0]["runs"] as! String) / \(score[0]["wickets"]as! String) "
                self.lblOvers.text = "\( score[0]["overs"] as! String) Ovrs"
                //            print(batDict)
            }
        }
        
        getDataDict(" http://cricketapi.herokuapp.com/commentary?matchId=\(matchID)") { (dict) in
            DispatchQueue.main.async {
                print(dict)
                
                self.tblData = dict["commentary"]  as! [String];
                self.tblCommentary.reloadData()
      
            }
        }
        
       

    }
    
    
    
    // TABleview delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tblData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblCommentary.dequeueReusableCell(withIdentifier: "idCell")
        let commentaryLbl = cell?.viewWithTag(10)as! UILabel;
        commentaryLbl.text = tblData[indexPath.row]as? String
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100;
    }
    
    
    func speechScore()
    {
        
        let str  = "\(self.lblScore.text! .replacingOccurrences(of: "/", with: "for")) at \(self.lblOvers.text!) where \(self.lblBatsmen.text!) and \(self.lblBatsmen2.text!) on Crease"
        
        
        let utterance = AVSpeechUtterance(string:str )
        utterance.pitchMultiplier = 1.4
        //                utterance.rate = AVSpeechUtteranceMinimumSpeechRate * 1.5
        utterance.rate = 0.5
    utterance.voice  = AVSpeechSynthesisVoice(language: "en-US")
        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
        
    }
    
    func countryName(from countryCode: String) -> String {
        if let name = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: countryCode) {
            // Country name was found
            return name
        } else {
            // Country name cannot be found
            return countryCode
        }
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
