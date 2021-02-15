//
//  ListarAnotacoesTableViewController.swift
//  Minhas Notas Diarias
//
//  Created by Kaique Lopes on 02/07/20.
//  Copyright © 2020 Kaique Lopes. All rights reserved.
//

import UIKit
import CoreData

class ListarAnotacoesTableViewController: UITableViewController {
    var context: NSManagedObjectContext!
    var anotacoes: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.recuperarAnotacoes()
    }
    

    func recuperarAnotacoes(){
        let requisicao = NSFetchRequest<NSFetchRequestResult>(entityName: "Anotacao")
        let ordenaNovo = NSSortDescriptor(key: "data", ascending: false)
        requisicao.sortDescriptors = [ordenaNovo]
        do {
         let anotacoesRecuperadas = try context.fetch(requisicao)
            self.anotacoes = anotacoesRecuperadas as! [NSManagedObject]
            self.tableView.reloadData()
        } catch{
            print("Erro ao recuperar os dados")
        }
    }
    
    
 
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
 
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.anotacoes.count
         
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        let indice = indexPath.row
        let anotacao = self.anotacoes[indice]
        performSegue(withIdentifier: "verAnotacao", sender: anotacao)
    }
     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "verAnotacao"{
            let viewDestino = segue.destination as! AnotacaoViewController
            viewDestino.anotacao = sender as? NSManagedObject
            
        }
        
    }
 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celula = tableView.dequeueReusableCell(withIdentifier: "celula", for: indexPath)
        let anotacao = self.anotacoes[indexPath.row]
        let textoRecuperado = anotacao.value(forKey: "texto")
        
        let dataRecuperada = anotacao.value(forKey: "data")
        let dataBrasil = DateFormatter()
        dataBrasil.dateFormat = "dd/MM/yyyy - HH:mm:ss"
        let novaData = dataBrasil.string(from: dataRecuperada as! Date)
 
            
            
        
        celula.textLabel?.text = textoRecuperado as? String
        celula.detailTextLabel?.text = novaData
        
 

        return celula
    }
 
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            let indice = indexPath.row
            let anotacao = self.anotacoes[indice]
            self.context.delete(anotacao)
            self.anotacoes.remove(at: indice)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            do {
                try context.save()
                print("Sucesso ao remover os itens")
            } catch {
                print("Erro ao remover os itens")
            }
        }
    }

}
