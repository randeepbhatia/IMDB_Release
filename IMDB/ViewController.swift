//
//  ViewController.swift
//  IMDB
//
//  Created by Bhatia, Randeep on 11/9/14.
//  Copyright (c) 2014 EA. All rights reserved.
//


import UIKit

class ViewController: UIViewController, IMDBAPIControllerDelegate {
    
    @IBOutlet var urlImage: UIImageView!
    @IBOutlet var imageShow: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var plotLabel: UILabel!
    
    lazy var apiController : IMDBAPIController = IMDBAPIController( delegate: self )

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.apiController.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func didFinishIMDBSearch(result: Array<Job>) {
        self.titleLabel.text = result[0].companyName;
        //println(result.count);
    }
    
    @IBAction func buttonPressed(sender: AnyObject) {
        //Search Imdb
        self.apiController.searchIMDB("")
        self.apiController.postRequest();
        self.formatImageFromPath("http://www.derekolsonphotography.com/wp-content/uploads/2011/10/iphone4s-photo-sharpness.jpg")
    }
    
    func formatImageFromPath(path: String){
        
        var posterUrl                               = NSURL(string: path)
        var posterImageData                         = NSData(contentsOfURL: posterUrl!)
        self.urlImage?.layer.cornerRadius    = 100.0
        self.urlImage!.clipsToBounds         = true
        self.urlImage!.image                 = UIImage(data: posterImageData!)
        
        if let imageToBlur = self.urlImage!.image? {
            self.blurBackgroundUsingImage(imageToBlur)
        }
    }
    
    func blurBackgroundUsingImage(image: UIImage){
        var frame       = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        var imageView   = UIImageView(frame: frame)
        
        imageView.image         = image
        imageView.contentMode   = .ScaleAspectFill
        
        var blurEffect          = UIBlurEffect(style: .Light)
        var blurEffectView      = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame    = frame
        
        var transparentWhiteView = UIView(frame: frame)
        transparentWhiteView.backgroundColor = UIColor(white: 1.0, alpha: 0.30)
        
        var viewsArray = [imageView, blurEffectView, transparentWhiteView]
        
        for index in 0..<viewsArray.count {
            if let oldView = self.view.viewWithTag(index + 1){
                var oldView = self.view.viewWithTag(index + 1)
                oldView?.removeFromSuperview()
            }
            var viewToInsert = viewsArray[index]
            self.view.insertSubview(viewToInsert, atIndex: index + 1)
            viewToInsert.tag = index + 1
        }
    }
}


/*8@IBOutlet weak var imageShow: UIImageView!
@IBOutlet weak var titleLabel: UILabel!
@IBOutlet weak var releaseLabel: UILabel!
@IBOutlet weak var ratingLabel: UILabel!
@IBOutlet weak var plotLabel: UILabel!

lazy var apiController : IMDBAPIController = IMDBAPIController( delegate: self )

override func viewDidLoad() {
super.viewDidLoad()
self.apiController.delegate = self
// Do any additional setup after loading the view, typically from a nib.
}

override func didReceiveMemoryWarning() {
super.didReceiveMemoryWarning()
// Dispose of any resources that can be recreated.
}

@IBAction func buttonPressed(sender: AnyObject) {
//    self.searchIMDB("Valentine");
self.imageShow.image =      UIImage(named: "images.jpeg");
}

func didFinishIMDBSearch(result: Dictionary<String, String>) {


/*  self.formatLabels(false)

if let foundTitle = result["Title"]{

self.parseTitleFromSubtitle(foundTitle)

}

if let foundTomato = result["tomatoMeter"] {

self.tomatoLabel!.text = foundTomato + "%"

}

if let foundReleased = result["Released"]{
self.releasedLabel!.text    = "Released: " + foundReleased
}

if let foundRating = result["Rated"]{
self.ratingsLabel!.text     = "Rated: " + foundRating

}

self.plotLabel!.text        = result["Plot"]

if let foundPosterUrl = result["Poster"]?
{
self.formatImageFromPath(foundPosterUrl)
}*/
}*/





