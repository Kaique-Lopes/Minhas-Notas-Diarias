//
//  AnotacaoViewController.swift
//  Minhas Notas Diarias
//
//  Created by Kaique Lopes on 02/07/20.
//  Copyright © 2020 Kaique Lopes. All rights reserved.
//

import UIKit
import CoreData

class AnotacaoViewController: UIViewController {
    
    @IBOutlet weak var texto: UITextView!
    var context: NSManagedObjectContext!
    var anotacao: NSManagedObject!
 
        override func viewDidLoad() {
        super.viewDidLoad()
            
            self.becomeFirstResponder()
            
            if anotacao != nil {
                if let textoRecuperado = anotacao.value(forKey: "texto"){
                    self.texto.text = String(describing: textoRecuperado)
                }
                
            }else{
                self.texto.text = ""
            }
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            context = appDelegate.persistentContainer.viewContext
            

    }
    
    @IBAction func salvar(_ sender: Any) {
        if anotacao != nil {
            self.atualizarAnotacao()
        }else{
            self.salvarAnotacao()
        }
        
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func atualizarAnotacao(){
        anotacao.setValue(self.texto.text, forKey: "texto")
        anotacao.setValue(Date(), forKey: "data")
        do {
            try context.save()
            print("sucesso ao salvar")
        } catch {
            print("erro ao salvar")
        }
        
    }
    
    func salvarAnotacao(){
        let novaAnotacao = NSEntityDescription.insertNewObject(forEntityName: "Anotacao", into: context)
       
        // Configura Anotacao
        novaAnotacao.setValue(self.texto.text, forKey: "texto")
        novaAnotacao.setValue(Date(), forKey: "data")
        
        do {
            try context.save()
            print("sucesso ao salvar")
        } catch {
            print("erro ao salvar")
        }
    }
    
}
