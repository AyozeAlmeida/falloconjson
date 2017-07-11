import UIKit
import SQLite


class SeleccionBalizaVC: UIViewController {
    
    @IBOutlet weak var buscador: UISearchBar!
    

    @IBOutlet weak var CollectionBaliza: UICollectionView!
    
    fileprivate let seleccionBalizaPresenter = SeleccionBalizaPresenter(seleccionBalizaService: SeleccionBalizaService(), escaneado: Escaneado(), firmado : Firmado())
    
    var listaBalizas :
        [BalizaData] = []
    var listaBalizasFiltro : [BalizaData] = []
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // self.inicializarVista()
        self.CollectionBaliza.dataSource = self
        
        
        // self.buscador.delegate = self
        self.seleccionBalizaPresenter.attachView(self)
        self.seleccionBalizaPresenter.obtenerBalizas()
        self.seleccionBalizaPresenter.iniciarEscaneo()
       // self.seleccionBalizaPresenter.escaneo()
    }
    
    
    func inicializarVista() {
        self.buscador.placeholder = NSLocalizedString("Buscar baliza", comment: "Buscar balizas") + "..."
    }
    
}

extension SeleccionBalizaVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listaBalizas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let baliza: BalizaData = self.listaBalizas[indexPath.row]
        
        let celdaBaliza = collectionView.dequeueReusableCell (withReuseIdentifier: "SeleccionBalizaCell", for: indexPath)
            as! SeleccionBalizaCell
        
        celdaBaliza.backgroundColor = UIColor.red
        
        celdaBaliza.uuidLabel.text = baliza.uuid
        
        return celdaBaliza
    }
}


extension SeleccionBalizaVC: SeleccionBalizaView {
    
    
    func setBalizas(balizas: [BalizaData]) {
        self.listaBalizas = balizas
        // self.seleccionBalizaPresenter.filtrarBalizas(listaBalizas: self.listaBalizas, texto: buscador.text!)
    }
    
}
