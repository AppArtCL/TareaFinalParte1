//
//  FotoViewController.swift
//  TareaRutaFinal
//
//  Created by Cristian Diaz on 27-12-16.
//  Copyright © 2016 AppArt. All rights reserved.
//

import UIKit

class FotoViewController: ViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  
    // MARK: - Conexiones
    @IBOutlet weak var imagenPunto: UIImageView!
    @IBOutlet weak var botonAbrirBiblioImagenes: UIButton!
    @IBOutlet weak var botonTomarFotoPunto: UIButton!
    
    // MARK: - Funciones
    
    @IBAction func tomarFotoPunto(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let aviso = UIAlertController(title: "Importante", message: "No hay cámara disponible para tomar fotografía. Debe usar en dispositivo o usar una fotografía guardada.", preferredStyle: UIAlertControllerStyle.alert)
            aviso.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(aviso, animated: true, completion: nil)
            self.botonTomarFotoPunto.isEnabled = false
        }
    }
    
    @IBAction func abrirBiblioImagenes(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let aviso = UIAlertController(title: "Importante", message: "No hay biblioteca de imagenes disponible.", preferredStyle: UIAlertControllerStyle.alert)
            aviso.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(aviso, animated: true, completion: nil)
            self.botonAbrirBiblioImagenes.isEnabled = false
        }
    }
   
    
    //Termino de seleccionar o tomar la foto y la muestro
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject: Any]!) {
        imagenPunto.image = image
        self.dismiss(animated: true, completion: nil);
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
