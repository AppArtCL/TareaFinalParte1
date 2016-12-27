//
//  WebViewController.swift
//  TareaRutaFinal
//
//  Created by Cristian Diaz on 28-09-16.
//  Copyright © 2016 AppArt. All rights reserved.
//

import UIKit

class WebViewController: ViewController {

    var direccionWeb: String?
    
    @IBOutlet weak var visorWeb: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(direccionWeb!)
        // Cargar la dirección del codigo QR
        let urlDireccion = URL(string: direccionWeb!)
        let cargaPagina = URLRequest(url: urlDireccion!)
        visorWeb.loadRequest(cargaPagina)
        // Inhabilito el boton Volver y le agrego el volver al Home.
       
        
        //self.navigationItem.hidesBackButton = true
        //let botonVolver = UIBarButtonItem(title: "<Volver", style: .plain, target: self, action: #selector(WebViewController.volverAlHome))
        //self.navigationItem.setLeftBarButton(botonVolver, animated: true)
        
        let botonAbrir = UIBarButtonItem(title: "Abrir en browser", style: .plain, target: self, action: #selector(WebViewController.abrirEnSafari))
        self.navigationItem.setRightBarButton(botonAbrir, animated: true)
    }
    
//    func volverAlHome(sender: UIBarButtonItem) {
//        print(ultimaPantalla)
//        print("")
//        print("")
//        
//        if ultimaPantalla == "Home" {
//            self.performSegue(withIdentifier: "IrAlHome", sender: self)
//            
//            //self.performSegue(withIdentifier: "UnwindToHome", sender: self)
//        } else if ultimaPantalla == "Mapa" {
//            //self.performSegue(withIdentifier: "VolverAlMapa", sender: self)
//            
//            self.performSegue(withIdentifier: "UnwindToMapa", sender: self)
//        }
//    }
    
    func abrirEnSafari(){
        UIApplication.shared.open(URL(string: direccionWeb!)!, completionHandler: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation
     
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
