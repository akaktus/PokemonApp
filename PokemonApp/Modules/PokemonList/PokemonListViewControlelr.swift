//
//  ListViewController.swift
//  PokemonApp
//
//  Created by Artem Kutasevych on 10/3/20.
//

import UIKit

class ListViewController: UIViewController {
    var viewModel: PokemonListViewModelProtocol?
    private var spinner = UIActivityIndicatorView(style: .gray)

    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNotifications()
        searchBar.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        title = "Pokemons"
        showActivityIndicator()
        hideKeyboardWhenTappedAround()
    }
    
    private func showActivityIndicator() {
        spinner.center = view.center
        spinner.hidesWhenStopped = true
        view.addSubview(spinner)
        spinner.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }

    private func hideActivityIndicator() {
        spinner.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    private func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
        
        if let nav = self.navigationController {
            nav.view.endEditing(true)
        }
    }
    
    private func registerNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
          notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification){
        guard let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        collectionView.contentInset.bottom = view.convert(keyboardFrame.cgRectValue, from: nil).size.height
    }

    @objc private func keyboardWillHide(notification: NSNotification){
        collectionView.contentInset.bottom = 0
    }
}

extension ListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
       
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel?.filteredModel.count ?? 0 / 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pokemonCell", for: indexPath) as? PokemonListCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.delegate = viewModel as? CancelableTask
        let item = viewModel?.filteredModel[indexPath.item]
        cell.configure(with: item)
        cell.activityIndicator.startAnimating()
        viewModel?.showOfficialImage(id: item?.id ?? 1, completion: { image in
            DispatchQueue.main.async {
                cell.activityIndicator.stopAnimating()
                cell.imageView.image = image
            }
        })
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        showActivityIndicator()
        viewModel?.pokemonDidSelect(name: viewModel?.filteredModel[indexPath.item].name ?? "")
    }
}

extension ListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/3 - 10, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
    }
}

extension ListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.searchElements(searchText: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}


extension ListViewController: PokemonListViewModelDelegate {
    
    func updateUI() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.hideActivityIndicator()
        }
    }
    
    func showPokemonInformation(pokemon: Pokemon) {
        if let networkAPI = viewModel?.networkAPI {
        let viewModel = PokemonInformationViewModel(model: pokemon, networkAPI: networkAPI)
        let storyboard = UIStoryboard(name: "PokemonInformationViewController", bundle: nil)
        DispatchQueue.main.async {
            if let viewController = storyboard.instantiateInitialViewController() as? PokemonInformationViewController {
                viewController.viewModel = viewModel
                self.hideActivityIndicator()
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    }
}
