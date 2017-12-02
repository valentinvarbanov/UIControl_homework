//
//  ViewController.swift
//  UIControl_homework
//
//  Created by Valentin Varbanov on 1.12.17.
//  Copyright © 2017 Valentin Varbanov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var gauge: Gauge!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func increase(_ sender: Any) {
        gauge.value = 70
    }
    
    @IBAction func decrease(_ sender: Any) {
        gauge.value = 10
    }
}

