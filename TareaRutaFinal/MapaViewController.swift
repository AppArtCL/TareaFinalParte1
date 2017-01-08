//
//  MapaViewController.swift
//  TareaRutaFinal
//
//  Created by Cristian Diaz on 01-10-16.
//  Copyright © 2016 AppArt. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapaViewController: ViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Variables    
    var administradorUbicacion = CLLocationManager()
    var puntoInicial: CLLocation?       // Registra el punto de partida
    var ultimaUbicacion: CLLocation?    // Registra la ultima ubicacion centrada
    var ultimoPunto: MKMapItem?         // Registra el ultimo punto con PIN
    var nombreUltimoPunto = "Punto Inicial" // Registra el nombre del ultimo punto con PIN
    var listaPuntos: [MKMapItem] = []


    // MARK: - Conexiones
    @IBOutlet weak var mapa: MKMapView!
    
    // Abre ventana para capturar código
    @IBAction func capturarCodigoQR(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "IrAQR", sender: self)
        
    }
    
    // Muestra la ruta en el mapa
    @IBAction func mostrarRuta(_ sender: Any) {
        // Revisar si hay puntos para la ruta
        if listaPuntos.count < 2 {
            // Entrego mensaje que no se puede crear ruta con un punto
            let avisoPuntos = UIAlertController(title: "Importante", message: "Deben existir al menos dos puntos para crear una ruta. Usted sólo ha creado uno.", preferredStyle: UIAlertControllerStyle.alert)
            avisoPuntos.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(avisoPuntos, animated: true, completion: nil)
        } else {
            // Muestro la ruta con a lo menos dos puntos
            var iPuntos = 1
            while iPuntos < self.listaPuntos.count {
                let origenTemporal = listaPuntos[iPuntos-1]
                let destinoTemporal = listaPuntos[iPuntos]
                crearRuta(origen: origenTemporal, destino: destinoTemporal)
                iPuntos = iPuntos + 1
            }
        }
    }
    
    
    // Abre ventana para tomar fotografía
    @IBAction func tomaFotografia(_ sender: AnyObject) {
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
        }
    }
    
    // Agrega un chinche en la ubicación actual
    @IBAction func crearPunto(_ sender: AnyObject) {
        let ubicacionActual = self.mapa.userLocation
        let chinche = MKPointAnnotation()
        chinche.title = String("Pendiente")
        chinche.coordinate = ubicacionActual.coordinate
        
        // Mensaje para pedir el nombre del punto y luego ejecuto agregarPunto
        let aviso = UIAlertController(title: "Nuevo Punto de Interés", message: "Ingrese el nombre del punto.", preferredStyle: UIAlertControllerStyle.alert)
        aviso.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            alert -> Void in
            let campoNombre = aviso.textFields![0] as UITextField
            if (campoNombre.text! == "") || (campoNombre.text == nil) {
                self.agregarPunto(punto: chinche, nombre: "Sin Nombre")
                self.nombreUltimoPunto = "Sin Nombre"
            } else {
                self.agregarPunto(punto: chinche, nombre: campoNombre.text!)
                self.nombreUltimoPunto = campoNombre.text!
            }
        }))
        aviso.addTextField(configurationHandler: {(campoTexto: UITextField!) -> Void in
            campoTexto.placeholder = "Nombre del punto..."
        })
        self.present(aviso, animated: true, completion: nil)
    }
    
    // MARK: - Funciones
    
    // Agrego el punto al mapa
    func agregarPunto(punto: MKPointAnnotation, nombre: String) {
        punto.title = String(nombre)
        self.mapa.addAnnotation(punto)
        
        // Agrego al arreglo
        let puntoTemporal = MKMapItem(placemark: MKPlacemark(coordinate: punto.coordinate, addressDictionary: nil))
        self.listaPuntos.append(puntoTemporal)
        
        // Crea ruta
        let destino = MKMapItem(placemark: MKPlacemark(coordinate: punto.coordinate, addressDictionary: nil))
//        crearRuta(origen: self.ultimoPunto!, destino: destino)
        
        // Actualizo el ultimoPunto
        self.ultimoPunto = destino
    }
    
    // Hago la consulta al servidor y creo la ruta
    func crearRuta(origen: MKMapItem, destino: MKMapItem) {
        let solicitudRuta = MKDirectionsRequest()
        solicitudRuta.source = origen
        solicitudRuta.destination = destino
        solicitudRuta.transportType = .walking
        let detalleRuta = MKDirections(request: solicitudRuta)
        detalleRuta.calculate(completionHandler: {
            (respuestaRuta, error) -> Void in
            guard respuestaRuta != nil else {
                if let error = error {
                    print("")
                    print("")
                    print("Error: \(error)")
                }
                return
            }
            // Muestro la ruta en el mapa
            self.mostrarRuta(respuesta: respuestaRuta!)
        })
    }
    
    // Muestro la ruta obtenida en el mapa y la centro si es necesario
    func mostrarRuta(respuesta: MKDirectionsResponse) {
        self.mapa.add(respuesta.routes[0].polyline, level: MKOverlayLevel.aboveRoads)
    }
    
    // MARK: - Funciones de mapView
    
    // Opciones para dibujar la ruta
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 4.0
        return renderer
    }

    
    // MARK: - Funciones de locationManager
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let nuevaUbicacion = self.self.administradorUbicacion.location!
        let distancia = self.ultimaUbicacion!.distance(from: nuevaUbicacion)
        
        // Actualizar centro de mapa cada 30 metros
        if distancia > 30 {
            self.mapa.setCenter(nuevaUbicacion.coordinate, animated: true)
            self.ultimaUbicacion = nuevaUbicacion
        }
    }
    
    // Se activa por primera vez la lectura de GPS y se guarda el punto inicial
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == .authorizedAlways) || (status == .authorizedWhenInUse) {
            self.administradorUbicacion.startUpdatingLocation()
            self.puntoInicial = self.administradorUbicacion.location!
            self.ultimaUbicacion = self.puntoInicial!
            self.ultimoPunto = MKMapItem(placemark: MKPlacemark(coordinate: self.puntoInicial!.coordinate, addressDictionary: nil))
            
            // Guardar primer punto como inicial
            let chinche = MKPointAnnotation()
            chinche.title = "Punto Inicial"
            chinche.coordinate = puntoInicial!.coordinate
            self.mapa.addAnnotation(chinche)
            // Lo agrego a la lista
            let primero = MKMapItem(placemark: MKPlacemark(coordinate: self.puntoInicial!.coordinate, addressDictionary: nil))
            self.listaPuntos.append(primero)
            
            // Centrar el mapa y definir región
            self.mapa.setCenter(self.puntoInicial!.coordinate, animated: true)
            let zona = MKCoordinateSpan(latitudeDelta: 0.008, longitudeDelta: 0.008)
            let regionSeleccionada = MKCoordinateRegion(center: self.puntoInicial!.coordinate, span: zona)
            self.mapa.setRegion(regionSeleccionada, animated: true)
        } else {
            self.administradorUbicacion.stopUpdatingLocation()
            self.mapa.showsUserLocation = false
        }
    }

    // MARK: - Funciones de inicialización
    
    override func viewWillAppear(_ animated: Bool) {
        ultimaPantalla = "Mapa"
        
        print(ultimaPantalla)
        print("WillAppear Mapa")
         
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Inicializar variable
        //ultimaPantalla = "Mapa"
        
        // Inicializar el mapa
        self.mapa.delegate = self
        self.mapa.mapType = MKMapType.standard
        self.mapa.isZoomEnabled = true
        self.mapa.isRotateEnabled = false
        self.mapa.isScrollEnabled = true
        self.mapa.showsUserLocation = true
        
        // Conectar administrador
        self.administradorUbicacion.delegate = self
        self.administradorUbicacion.desiredAccuracy = kCLLocationAccuracyBest
        self.administradorUbicacion.requestAlwaysAuthorization()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
     
     @IBAction func unwindToMapa(segue: UIStoryboardSegue) {
        ultimaPantalla = "Mapa"
     }
     
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
