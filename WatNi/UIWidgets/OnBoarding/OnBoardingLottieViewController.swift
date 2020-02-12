//
//  OnBoardingLottieViewController.swift
//  WatNi
//
//  Created by 홍창남 on 2020/02/13.
//  Copyright © 2020 hcn1519. All rights reserved.
//

import UIKit
import Lottie

class OnBoardingLottieViewController: UIViewController {

    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var headLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!

    var jsonName: String = ""
    var head: String = ""
    var desc: String = ""
    var currentPage: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        let animation = Animation.named(jsonName)
        animationView.animation = animation
        pageControl.currentPage = currentPage
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animationView.play()
    }
}
