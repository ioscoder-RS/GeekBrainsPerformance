//
//  ProgressAnimator.swift
//  GeekbrainsUI
//
//  Created by raskin-sa on 18/02/2020.
//  Copyright © 2020 raskin-sa. All rights reserved.
//

import UIKit

/// Used for ViewControllers that need to present an activity indicator when loading data.
public protocol ActivityIndicatorPresenter {

    /// The activity indicator
    var activityIndicator: UIActivityIndicatorView { get }

    /// Show the activity indicator in the view
    func showActivityIndicator()

    /// Hide the activity indicator in the view
    func hideActivityIndicator()
}// protocol ActivityIndicatorPresenter

public extension ActivityIndicatorPresenter where Self: UIViewController {

    func showActivityIndicator() {
        DispatchQueue.main.async {

            self.activityIndicator.style = UIActivityIndicatorView.Style.large
            self.activityIndicator.frame = CGRect(x: 0, y: 0, width: 80, height: 80) //or whatever size you would like
            self.activityIndicator.center = CGPoint(x: self.view.bounds.size.width / 2, y: self.view.bounds.height / 2)
            self.view.addSubview(self.activityIndicator)
            self.activityIndicator.startAnimating()
        }
    }

    func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
        }
    }
}//public extension ActivityIndicatorPresenter
