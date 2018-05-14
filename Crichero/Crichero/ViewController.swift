//
//  ViewController.swift
//  Crichero
//
//  Created by ios dev 4 on 17/01/18.
//  Copyright © 2018 ios dev 4. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    var tbldata = [[String:Any]]()
    @IBOutlet weak var tblMatchList: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tblMatchList.delegate = self;
        tblMatchList.dataSource = self;
        
        // color code
//        4A3C7B

   
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData("http://cricketapi.herokuapp.com/getMatches") { (dict) in
            
            print(dict);
            DispatchQueue.main.async {
                self.tbldata = dict as! [[String : Any]]
                self.tblMatchList.reloadData()
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // TABleview delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tbldata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tblMatchList.dequeueReusableCell(withIdentifier: "idCell")
        let srsLbl = cell?.viewWithTag(10)as! UILabel; let type = cell?.viewWithTag(11) as! UILabel; let mnum = cell?.viewWithTag(12)as! UILabel; let status = cell?.viewWithTag(13)as! UILabel; let mchdesc = cell?.viewWithTag(14)as! UILabel;
        srsLbl.text = tbldata[indexPath.row]["srs"] as? String
//        type.text = tbldata[indexPath.row]["type"] as? String
        mnum.text = tbldata[indexPath.row]["mnum"] as? String
        status.text = tbldata[indexPath.row]["status"] as? String
        mchdesc.text = tbldata[indexPath.row]["mchdesc"] as? String
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "idDetailView" )as! DetailViewController
        vc.matchID = (tbldata[indexPath.row]["id"] as? String)!
        vc.mainTitle = (tbldata[indexPath.row]["mchdesc"] as? String)!
        self.navigationController?.pushViewController(vc, animated: true)
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150;
    }
    

}
// MARK : GET DATA
func getData(_ appendString:String,_ completion: @escaping (_ result: NSArray) -> Void) {
    //        completionHandler: ((NSDictionary!) -> Void)?) {
    
    
    let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string: "\(appendString.replacingOccurrences(of: " ", with: ""))")!)
    
    request.httpMethod = "GET"
    
    request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
    
    
    
    let session = URLSession(configuration: URLSessionConfiguration.default)
    
    session.dataTask(with: request as URLRequest) {(data, response, error) in
        
        
        
        var jsonResult = NSArray()
        
        do {
            
            if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSArray {
                
                print("The FiNAl Response is \(json)"); jsonResult = json
                
            } else {
                
                let jsonStr:String = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
                
                
                
                print("Error could not parse JSON: \(jsonStr)")
                
            }
            
        } catch let parseError {
            
            print(parseError)
            
            let jsonStr:String = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
            
            print("Error could not parse JSON: '\(jsonStr)'")
            
        }
        
        // then on complete I call the completionHandler...
        
        //completionHandler?(jsonResult);
        
        completion(jsonResult)
        
        }.resume()
    
}
func getDataDict(_ appendString:String,_ completion: @escaping (_ result: NSDictionary) -> Void) {
    //        completionHandler: ((NSDictionary!) -> Void)?) {
    
    
    let request: NSMutableURLRequest = NSMutableURLRequest(url:URL(string: "\(appendString.replacingOccurrences(of: " ", with: ""))")!)
    
    request.httpMethod = "GET"
    
    request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
    
    
    
    let session = URLSession(configuration: URLSessionConfiguration.default)
    
    session.dataTask(with: request as URLRequest) {(data, response, error) in
        
        
        
        var jsonResult = NSDictionary()
        
        do {
            
            if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                
                print("The FiNAl Response is \(json)"); jsonResult = json
                
            } else {
                
                let jsonStr:String = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
                
                
                
                print("Error could not parse JSON: \(jsonStr)")
                
            }
            
        } catch let parseError {
            
            print(parseError)
            
            let jsonStr:String = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
            
            print("Error could not parse JSON: '\(jsonStr)'")
            
        }
        
        // then on complete I call the completionHandler...
        
        //completionHandler?(jsonResult);
        
        completion(jsonResult)
        
        }.resume()
    
}




    


