//
//  RutasViewController.swift
//  TareaRutaFinal
//
//  Created by Cristian Diaz on 28-09-16.
//  Copyright © 2016 AppArt. All rights reserved.
//

import UIKit

class RutasViewController: ViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - Variables
    var nombreNuevaRuta = ""
    
    // MARK: - Conexiones
    @IBOutlet weak var nombreRuta: UITextField!
    @IBOutlet weak var descripcionRuta: UITextField!
    @IBOutlet weak var imagenRuta: UIImageView!
    @IBOutlet weak var botonTomarFotografia: UIButton!
    @IBOutlet weak var botonAbrirBibliotecaImagenes: UIButton!
    
    // MARK: - Funciones
    @IBAction func tomarFotografia(_ sender: AnyObject) {
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
            self.botonTomarFotografia.isEnabled = false
        }
    }
    
    @IBAction func abrirBibliotecaImagenes(_ sender: AnyObject) {
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
            self.botonAbrirBibliotecaImagenes.isEnabled = false
        }
    }
    
    
    @IBAction func abrirMapas(_ sender: AnyObject) {
        var todoOK = true
        var mensaje = ""
        if nombreRuta.text == "" {
            todoOK = false
            mensaje = "Falta Nombre"
        } else {
            ruta = nombreRuta.text!
            self.nombreNuevaRuta = ruta
        }
        if descripcionRuta.text == "" {
            todoOK = false
            if mensaje == "" {
                mensaje = "Falta Descripción"
            } else {
                mensaje = mensaje + ", Descripción"
            }
        } else {
            descripcion = descripcionRuta.text!
        }
        if imagenRuta.image == nil {
            todoOK = false
            if mensaje == "" {
                mensaje = "Falta Fotografía"
            } else {
                mensaje = mensaje + ", Fotografía"
            }
        } else {
            //hay foto (Por ahora no hacemos nada)
        }
        if todoOK {
            performSegue(withIdentifier: "MuestraMapa", sender: self)
        } else {
            // poner mensaje
            mensaje = mensaje + " de la ruta. Complete todos los datos antes de guardar."
            let aviso = UIAlertController(title: "Importante", message: mensaje, preferredStyle: UIAlertControllerStyle.alert)
            aviso.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(aviso, animated: true, completion: nil)
        }
    }
    
    //Termino de seleccionar o tomar la foto y la muestro
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject: Any]!) {
        imagenRuta.image = image
        self.dismiss(animated: true, completion: nil);

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.descripcionRuta.resignFirstResponder()
        self.nombreRuta.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Configuro para que desaparezcan al apretar el Enter
        self.descripcionRuta.delegate = self
        self.nombreRuta.delegate = self    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "MuestraMapa" {
            segue.destination.title = self.nombreNuevaRuta
        }
        
    }
}
