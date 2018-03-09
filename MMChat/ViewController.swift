//
//  ViewController.swift
//  MMChat
//
//  Created by Magdalena Witkowska on 09.03.2018.
//  Copyright © 2018 Magdalena Witkowska. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var bubble1View: BubbleView!
    @IBOutlet weak var bubble2View: BubbleView!
    @IBOutlet weak var bubble3View: BubbleView!
    @IBOutlet weak var bubble4View: BubbleView!
    @IBOutlet weak var bubble5View: BubbleView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let raspberryRed = UIColor.init(red: 250/255, green: 64/255, blue: 107/255, alpha: 1.0)
        let lightGray = UIColor.init(red: 239/255, green: 237/255, blue: 237/255, alpha: 1.0)

    
        bubble1View.configureBubbleView(text: "Magdalena Witkowska", backgroundColor: raspberryRed, textColor: UIColor.white, bubbleAlignment: .Left)
        
        bubble2View.configureBubbleView(text: "dwafzrds ewdsfbaeszbdf edaBYSdvawDA SwesrdwyFwrf raeszdfbaerygbf", backgroundColor: lightGray, textColor: UIColor.black, bubbleAlignment: .Right)
        
        bubble3View.configureBubbleView(text: "Lorem ipsum", backgroundColor: raspberryRed, textColor: UIColor.white, bubbleAlignment: .Left)
        
        bubble4View.configureBubbleView(text: "Boo", backgroundColor: lightGray, textColor: UIColor.black, bubbleAlignment: .Right)
        bubble5View.configureBubbleView(text: "dwdawfawef", backgroundColor: raspberryRed, textColor: UIColor.white, bubbleAlignment: .Left)
        
        
    }


}

