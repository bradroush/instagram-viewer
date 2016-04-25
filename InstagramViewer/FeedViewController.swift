//
//  FeedViewController.swift
//  InstagramViewer
//
//  Created by Brad Roush on 4/24/16.
//  Copyright © 2016 Brad Roush. All rights reserved.
//

import UIKit
import SDWebImage

// Error Alert Copy
// This might be moved to another file where it can then be localized
let ErrorAlertTitle = "Oops"
let NetworkErrorMessage = "Please check your internet connection and try again"
let AccessTokenErrorMessage = "Looks like you will need to re-authenticate to continue"
let DefaultErrorMessage = "There was a problem getting your photos"

class FeedViewController: UICollectionViewController {
    
    // This will be used to determine the count of media objects to fetch from instagram
    let recentMediaCount = 20
    
    let reuseIdentifier = "Cell"
    var media = [MediaData]()
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        InstagramAPIClient.sharedClient.getCurrentUserRecentMedia(recentMediaCount) { [weak self] (possibleMedia, error) in
            // Make sure we go back to the main thread
            dispatch_async(dispatch_get_main_queue(), {
                if let mediaData = possibleMedia where mediaData.count > 0 {
                    // Set Media and reload collection view
                    self?.media = mediaData
                    self?.collectionView?.reloadData()
                } else if let error = error {
                    // Error Handleing
                    switch error {
                    case .MissingAccessToken:
                        self?.performSegueWithIdentifier("ShowLogin", sender: nil)
                    case .Network:
                        self?.showAlert(NetworkErrorMessage, handler: nil)
                    case .AccessTokenError:
                        self?.showAlert(AccessTokenErrorMessage, handler: { (action) in
                            self?.performSegueWithIdentifier("ShowLogin", sender: nil)
                        })
                    case .JsonSerialization, .JsonParsing, .Other:
                        self?.showAlert(DefaultErrorMessage, handler: nil)
                    }
                }
            })
        }
    }
    
    func showAlert(message: String, handler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: ErrorAlertTitle, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: handler))
        presentViewController(alert, animated: true, completion: nil)
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return media.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
        guard let feedCell = cell as? FeedCollectionViewCell else {
            return cell
        }
        
        let mediaData = media[indexPath.row]
        let url = NSURL(string: mediaData.thumbnailData.url)
        feedCell.image.sd_setImageWithURL(url, placeholderImage: UIImage(named: "Placeholder"))
        
        return feedCell
    }

}
