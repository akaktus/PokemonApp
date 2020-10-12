//
//  PokemonInformationViewController.swift
//  PokemonApp
//
//  Created by Artem Kutasevych on 10/3/20.
//

import UIKit

class PokemonInformationViewController: UIViewController {
    
    var viewModel: PokemonInformationViewModel?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var pokemonName: UILabel!
    @IBOutlet weak var pokemonType: UILabel!
    @IBOutlet weak var tableViewStats: UITableView!
    @IBOutlet weak var pageControl: UIPageControl!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewStats.delegate = self
        tableViewStats.dataSource = self
        tableViewStats.separatorStyle = .none
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        imagesCollectionView.alwaysBounceHorizontal = true
        imagesCollectionView.showsHorizontalScrollIndicator = false
        
        title = "\(viewModel?.model.name ?? "")"
        let backButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(backButtonTapped))
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        pokemonName.text = viewModel?.model.name
        pokemonType.text = pokemonText
        pageControl.currentPage = 0
        pageControl.numberOfPages = viewModel?.model.pictureUrls.stringURLs.count ?? 0
        tableViewStats.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private var pokemonText: String {
        var text = ""
        if let types = viewModel?.model.types {
            for type in types {
                if !text.isEmpty {
                    text += ", "
                }
                text += type.type.name
            }
        }
        return text
    }
    
    
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
}

extension PokemonInformationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.model.stats.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell()
        cell.textLabel?.text = "\(viewModel?.model.stats[indexPath.row].stat.name ?? ""): \(viewModel?.model.stats[indexPath.row].base_stat ?? 0) "
        cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension PokemonInformationViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel?.model.pictureUrls.stringURLs.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as? ImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure()
        cell.activityIndicator.startAnimating()
        viewModel?.getPictureFrom(urlString: viewModel?.model.pictureUrls.stringURLs[indexPath.section] ?? "", completion: { image in
            DispatchQueue.main.async {
                cell.activityIndicator.stopAnimating()
                cell.image.image = image
            }
        })
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.section
    }
}

extension PokemonInformationViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 200)
    }
}
