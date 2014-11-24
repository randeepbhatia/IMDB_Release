//
//  IMDBApiController.swift
//  IMDB
//
//  Created by Bhatia, Randeep on 11/15/14.
//  Copyright (c) 2014 EA. All rights reserved.
//


import UIKit
import Alamofire
import JSONJoy


struct Job {
    var companyName: String?
    var imageUrl: String?
    var jobDescription: String?
    var jobId: String?
    var jobTitle: String?
    var latitude: Double?
    var longitude: Double?
    var postingDate: Int?
    init(_ decoder: JSONDecoder) {
        companyName = decoder["companyName"].string
        imageUrl = decoder["imageUrl"].string
        jobDescription = decoder["jobDescription"].string
        jobId = decoder["jobId"].string
        jobTitle = decoder["jobTitle"].string
        latitude = decoder["latitude"].double
        longitude = decoder["longitude"].double
        postingDate = decoder["postingDate"].integer
    }
}

struct Jobs : JSONJoy {
    var jobs: Array<Job>?
    init() {
        var jobsArray = Array<Job>()
    }
    init(_ decoder: JSONDecoder) {
        //we check if the array is valid then alloc our array and loop through it, creating the new address objects.
        if let jobArray = decoder["response"].array {
            jobs = Array<Job>()
            for addrDecoder in jobArray {
                jobs?.append(Job(addrDecoder))
            }
        }
    }
}

protocol IMDBAPIControllerDelegate
{
    func didFinishIMDBSearch(result: Array<Job>)
}

class IMDBAPIController
{
    var delegate : IMDBAPIControllerDelegate?
    
    /*var net: Net!
    
    var imgUploadTask: UploadTask?*/
    
    init(delegate : IMDBAPIControllerDelegate?){
        self.delegate = delegate
    }
    
    func searchIMDB(forContent: String) {
        if let apiDelegate = self.delegate?{
            var result: Dictionary<String,String>?
            Alamofire.request(.GET, "https://www.punjit.com/punjit/rest/jobs")
                .responseJSON { (_, _, JSON, _) in
                    var jobs = Jobs(JSONDecoder(JSON!))
                    apiDelegate.didFinishIMDBSearch(jobs.jobs!);
            }
        }
    }
    
    func postRequest() {
        if let apiDelegate = self.delegate?{
            let image = UIImage(named: "Iphone6.jpg")
            let imageData = UIImageJPEGRepresentation(image, 0.0)

            var parameters = [
                "jobTitle": "Hero"
            ]
            parameters["latitude"] = "3.4"
            parameters["longitude"] = "2.3"
            parameters["company"] = "Ea4"
            parameters["description"] = "hello hi how r u"
            
            // CREATE AND SEND REQUEST ----------
            
            let urlRequest = urlRequestWithComponents("http://192.168.1.253:8080/punjit/rest/job/upload", parameters: parameters, imageData: imageData, imageName: "Iphone6.jpg")
            
            Alamofire.upload(urlRequest.0, urlRequest.1)
                .progress { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
                    println("\(totalBytesWritten) / \(totalBytesExpectedToWrite)")
                }
                .responseJSON { (request, response, JSON, error) in
                    println("REQUEST \(request)")
                    println("RESPONSE \(response)")
                    println("JSON \(JSON)")
                    println("ERROR \(error)")
            }
        }
    }
    
    // this function creates the required URLRequestConvertible and NSData we need to use Alamofire.upload
    private func urlRequestWithComponents(urlString:String, parameters:Dictionary<String, String>, imageData:NSData, imageName: String) -> (URLRequestConvertible, NSData) {
        
        // create url request to send
        var mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        mutableURLRequest.HTTPMethod = Alamofire.Method.POST.rawValue
        let boundaryConstant = "myRandomBoundary12345";
        let contentType = "multipart/form-data;boundary="+boundaryConstant
        mutableURLRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        // create upload data to send
        let uploadData = NSMutableData()
        
        // add image
        uploadData.appendData("\r\n--\(boundaryConstant)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        uploadData.appendData("Content-Disposition: form-data; name=\"job_image\"; filename=\(imageName)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        uploadData.appendData("Content-Type: image/png\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        uploadData.appendData(imageData)
        
        // add parameters
        for (key, value) in parameters {
            uploadData.appendData("\r\n--\(boundaryConstant)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
            uploadData.appendData("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n\(value)".dataUsingEncoding(NSUTF8StringEncoding)!)
        }
        uploadData.appendData("\r\n--\(boundaryConstant)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        // return URLRequestConvertible and NSData
        return (Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0, uploadData)
    }
}

/*import UIKit
import Alamofire
import JSONJoy





/*struct Job {
    var companyName: String?
    var imageUrl: String?
    var jobDescription: String?
    var jobId: String?
    var jobTitle: String?
    var latitude: Double?
    var longitude: Double?
    var postingDate: Int?
    init(_ decoder: JSONDecoder) {
        companyName = decoder["companyName"].string
        imageUrl = decoder["imageUrl"].string
        jobDescription = decoder["jobDescription"].string
        jobId = decoder["jobId"].string
        jobTitle = decoder["jobTitle"].string
        latitude = decoder["latitude"].double
        longitude = decoder["longitude"].double
        postingDate = decoder["postingDate"].integer
    }
}

struct Jobs : JSONJoy {
    var jobs: Array<Job>?
    init() {
        var jobsArray = Array<Job>()
    }
    init(_ decoder: JSONDecoder) {
        //we check if the array is valid then alloc our array and loop through it, creating the new address objects.
        if let jobArray = decoder["response"].array {
            jobs = Array<Job>()
            for addrDecoder in jobArray {
                jobs?.append(Job(addrDecoder))
            }
        }
    }
}*/

protocol IMDBAPIControllerDelegate
{
    func didFinishIMDBSearch(result: Dictionary<String,String>)
}

class IMDBAPIController {
    var delegate : IMDBAPIController?
    init(delegate: IMDBAPIController?){
        self.delegate = delegate;
    }
    
    func searchIMDB(forContent: String) {
        var spacelessString = forContent.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        
        if let foundString = spacelessString? {
            var urlPath = NSURL(string: "http://www.omdbapi.com/?t=\(foundString)&tomatoes=true")
            
            var session = NSURLSession.sharedSession()
            
            var task = session.dataTaskWithURL(urlPath!){
                data, response, error -> Void in
                
                if (( error ) != nil){
                    println(error.localizedDescription)
                }
                
                var jsonError : NSError?
                
                var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers,error: &jsonError) as Dictionary<String, String>
                
                if ((jsonError?) != nil){
                    println(jsonError!.localizedDescription)
                }
                
                if let apiDelegate = self.delegate?{
                    
                    dispatch_async(dispatch_get_main_queue()){
                        
                        apiDelegate.didFinishIMDBSearch(jsonResult)
                        
                    }
                }
            }
            
            task.resume()
        }
        
        
        
        /*if let apiDelegate = self.delegate? {
            Alamofire.request(.GET, "https://www.punjit.com/punjit/rest/jobs")
                .responseJSON { (_, _, JSON, _) in
                    println(JSON);
                    var jobs = Jobs(JSONDecoder(JSON!))
                    apiDelegate.didFinishIMDBSearch(jobs);
                    println(jobs.jobs?[0].jobTitle);
            }
        }*/
        
        //---------------------------------------------------------------------------------------------------
        
        /*  var spacelessString = forContent.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding);
        var urlPath:NSURL?
        urlPath = NSURL(string: "https://www.punjit.com/punjit/rest/jobs")
        var session = NSURLSession.sharedSession();
        if(urlPath != nil) {
        var task = session.dataTaskWithURL(urlPath!) {
        data, response, error -> Void in
        if((error) != nil) {
        println(error.localizedDescription);
        }
        let jsonResult = JSON(data: data);
        println(jsonResult["response"][0]["jobTitle"].stringValue);
        dispatch_async(dispatch_get_main_queue()) {
        self.titleLabel.text =      jsonResult["response"][0]["jobTitle"].stringValue
        self.releaseLabel.text =    jsonResult["response"][0]["companyName"].stringValue
        self.ratingLabel.text =     jsonResult["response"][0]["jobId"].stringValue
        self.plotLabel.text =       jsonResult["response"][0]["imageUrl"].stringValue
        }
        }
        task.resume();
        }*/
    }
}*/
