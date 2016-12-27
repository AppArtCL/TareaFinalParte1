//
//  ViewController.swift
//  TareaRutaFinal
//
//  Created by Cristian Diaz on 27-09-16.
//  Copyright © 2016 AppArt. All rights reserved.
//

import UIKit

var ultimaPantalla = "Home"
var ruta = ""
var descripcion = ""

class ViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        ultimaPantalla = "Home"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(ultimaPantalla)
        print("ViewController Home")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func unwindToHome(segue: UIStoryboardSegue) {

    }

}
