//
//  FoldingTableViewController.swift
//  Crichero
//
//  Created by ios dev 4 on 21/02/18.
//  Copyright © 2018 ios dev 4. All rights reserved.
//

import UIKit
import FoldingCell
class MainTableViewController: UITableViewController {
let CloseCellHeight: CGFloat = 179
let kOpenCellHeight: CGFloat = 488
let kRowsCount = 10
var cellHeights: [CGFloat] = []
    var tblMatchList = [[String:Any]]();
    var tblMatchDetails = [[String:Any]]();
    var matchID = String()
override func viewDidLoad() {
    super.viewDidLoad()
    setup()
}

private func setup() {
    cellHeights = Array(repeating: kCloseCellHeight, count: kRowsCount)
    tableView.estimatedRowHeight = kCloseCellHeight
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background"))
}
    
    override func viewWillAppear(_ animated: Bool) {
        getData("http://cricketapi.herokuapp.com/getMatches") { (dict) in
            
            print(dict);
            DispatchQueue.main.async {
                self.tblMatchList = dict as! [[String : Any]]
                self.tableView.reloadData()
            }
        }
        
    }

}

// MARK: - TableView
extension MainTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tblMatchList.count     }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as DemoCell = cell else {
            return
        }
        
        cell.backgroundColor = .clear
        
        if cellHeights[indexPath.row] == kCloseCellHeight {
            cell.selectedAnimation(false, animated: false, completion:nil)
        } else {
            cell.selectedAnimation(true, animated: false, completion: nil)
        }
//        cell.number = indexPath.row'
        if tblMatchList.count != 0{
            cell.closeNumberLabel.text =    (self.tblMatchList[indexPath.row]["type"] as? String)!
            cell.openNumberLabel.text =    (self.tblMatchList[indexPath.row]["mchdesc"] as? String)!
            cell.lblMatchDesc.text = "\( (self.tblMatchList[indexPath.row]["mchdesc"] as? String)!) \((self.tblMatchList[indexPath.row]["mnum"] as? String)!)"
            cell.lblMatchStatus.text = (self.tblMatchList[indexPath.row]["status"] as? String)!
            cell.lblMatchSource.text = (self.tblMatchList[indexPath.row]["srs"] as? String)!
            cell.lblMatchState.text = (self.tblMatchList[indexPath.row]["mchstate"] as? String)!
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as! FoldingCell
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
        let cell = tableView.cellForRow(at: indexPath) as! FoldingCell
        matchID =  (self.tblMatchList[indexPath.row]["id"] as? String)!

        if cell.isAnimating() {
            return
        }
       
        
        var duration = 0.0
        let cellIsCollapsed = cellHeights[indexPath.row] == kCloseCellHeight
        if cellIsCollapsed {
            cellHeights[indexPath.row] = kOpenCellHeight
            cell.selectedAnimation(true, animated: true, completion: nil)
            duration = 0.5
        } else {
            cellHeights[indexPath.row] = kCloseCellHeight
            cell.selectedAnimation(false, animated: true, completion: nil)
            duration = 0.8
        }
                   UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
        
        
        //Updating score
        
        guard case let cell1 as DemoCell = cell else {
            return
        }
        
        cell1.backgroundColor = .clear
        
        if cellHeights[indexPath.row] == kCloseCellHeight {
            cell1.selectedAnimation(false, animated: false, completion:nil)
        } else {
            cell1.selectedAnimation(true, animated: false, completion: nil)
        }
        
        
    getDataDict("http://cricketapi.herokuapp.com/livescore?matchId=\(matchID)") { (dict) in
        DispatchQueue.main.async {
            print(dict)
            if dict.count != 0{
            
            let batDict = dict["batting"] as! [String:Any];let bowDict = dict["bowling"] as! [String:Any]
            let batsmen = batDict["batsman"] as! [[String:Any]];
            let bowler = bowDict["bowler"] as! [[String:Any]]
            let score = batDict["score"] as! [[String:Any]]
            
            
            cell1.lblBatOne.text = "\(batsmen[0]["name"]as! String) "
            cell1.lblBatOneRuns.text =     "\(batsmen[0]["runs"]as! String) runs"
            
            if batsmen.count > 1{
                cell1.lblBatTwo.text = "\(batsmen[1]["name"]as! String) "
                cell1.lblBatTwoRuns.text =  "\(batsmen[1]["runs"]as! String) runs"
            }
            cell1.lblBowlOne.text = "\( bowler[0]["name"] as! String)   "
            cell1.lblBowlOneStats.text  = " \(bowler[0]["overs"]as! String) -  \(bowler[0]["wickets"]as! String ) - \(bowler[0]["runs"]as! String ) "
            if bowler.count > 1 {
                cell1.lblBowlTwo.text = "\( bowler[1]["name"] as! String)   "
                cell1.lblBowlTwoStats.text  =  " \(bowler[1]["overs"]as! String) -  \(bowler[1]["wickets"]as! String ) - \(bowler[1]["runs"]as! String ) "
            }
            
            cell1.lblScore.text = "   \(batDict["team"] as! String)  \( score[0]["runs"] as! String) / \(score[0]["wickets"]as! String) "
            cell1.lblOvers.text = "\( score[0]["overs"] as! String) Ovrs"
            print(batDict)
            }
        }
    }
    
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.isSelected == true { // check if cell has been previously selected
            tableView.deselectRow(at: indexPath, animated: true)
            return nil
        } else {
            return indexPath
        }
    }

    }


func matchdetails(_ matchID: String)
    {
        getDataDict("http://cricketapi.herokuapp.com/livescore?matchId=\(matchID)") { (dict) in
            DispatchQueue.main.async {
                
                print(dict)

            
                
//                let batDict = dict["batting"] as! [String:Any];let bowDict = dict["bowling"] as! [String:Any]
//                let batsmen = batDict["batsman"] as! [[String:Any]];
//                let bowler = bowDict["bowler"] as! [[String:Any]]
//                let score = batDict["score"] as! [[String:Any]]
//                self.lblBatsmen.text = "\(batsmen[0]["name"]as! String)  -  \(batsmen[0]["runs"]as! String) runs"
//                if batsmen.count > 1{
//                    self.lblBatsmen2.text = "\( batsmen[1]["name"]as! String)  -  \(batsmen[1]["runs"]as! String) runs"
//                }
//                if bowler.count > 1{
//                    self.lblBowler2.text = "\( bowler[1]["name"] as! String)  -  \(bowler[1]["overs"]as! String) Ovrs "
//                }
//                self.lblBowler.text = "\( bowler[0]["name"] as! String)  -  \(bowler[0]["overs"]as! String) Ovrs "
//                self.lblScore.text = "   \(batDict["team"] as! String)  \( score[0]["runs"] as! String) / \(score[0]["wickets"]as! String) "
//                self.lblOvers.text = "\( score[0]["overs"] as! String) Ovrs"
                //            print(batDict)
            }
        }
}
