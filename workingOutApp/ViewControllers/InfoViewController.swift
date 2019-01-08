//
//  InfoViewController.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 07/01/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit
import WebKit

class InfoViewController: UIViewController, WKUIDelegate {

    var portraitHeihtAnchor: NSLayoutConstraint?
    var landscapeHeihtAnchor: NSLayoutConstraint?
    var continerView: UIView?
    var webView: WKWebView!
    var item: Item?

    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.text = "Name"
        return label
    }()

    let groupLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "Group"
        return label
    }()

    let descriotionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "this is long description this is long description this is long description this is long description this is long description this is long description this is long description this is long description this is long description this is long description this is long description"
        return label
    }()

    let stackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.distribution = .fillProportionally
        stackview.spacing = 8
        return stackview
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        view.backgroundColor = .white
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = true

        setUpContainerView()
        setupWebView()
        setupStackView()
    }
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            portraitHeihtAnchor?.isActive = false
            landscapeHeihtAnchor = continerView?.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.9)
            landscapeHeihtAnchor?.isActive = true
            stackView.layoutIfNeeded()
            stackView.setNeedsLayout()
            stackView.setNeedsDisplay()
        }
        if UIDevice.current.orientation.isPortrait {
            landscapeHeihtAnchor?.isActive = false
            portraitHeihtAnchor?.isActive = true
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        tabBarController?.tabBar.isHidden = false
    }

    fileprivate func setUpContainerView() {
        continerView = UIView()
        continerView?.backgroundColor = .red
        view.addSubview(continerView!)
        continerView?.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, size: CGSize(width: 0, height: 0))
        portraitHeihtAnchor = continerView?.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35)
        portraitHeihtAnchor?.isActive = true
    }

    fileprivate func setupWebView() {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.preferences.javaScriptEnabled = true
        webConfiguration.allowsInlineMediaPlayback = true
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        continerView?.addSubview(webView)
        webView.backgroundColor = .black
        webView.anchor(top: continerView?.topAnchor, leading: continerView?.leadingAnchor, bottom: continerView?.bottomAnchor, trailing: continerView?.trailingAnchor)
        guard let itemInfo = item else { return }
        guard let videoString = itemInfo.videoString else { return }
        navigationItem.title = itemInfo.name
        nameLabel.text = itemInfo.name


        configureWebView(videoString: videoString)
    }

    fileprivate func setupStackView() {
        [nameLabel, groupLabel, descriotionLabel].forEach { stackView.addArrangedSubview($0) }
        let someView = UIView()
        view.addSubview(someView)
        someView.backgroundColor = .yellow
        someView.anchor(top: continerView?.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 0), size: CGSize(width: 0, height: 0))
        someView.addSubview(stackView)
        stackView.anchor(top: someView.topAnchor, leading: webView.leadingAnchor, bottom: nil, trailing: someView.trailingAnchor)
    }

    fileprivate func configureWebView(videoString: String) {
        guard let url = URL(string: "https://www.youtube.com/embed/\(videoString)?enablejsapi=0&rel=0&playsinline=1&autoplay=1") else { return }
        webView.load(URLRequest(url: url))
    }
}

