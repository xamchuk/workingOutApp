//
//  DetailTableViewCell.swift
//  workingOutApp
//
//  Created by Rusłan Chamski on 19/01/2019.
//  Copyright © 2019 Rusłan Chamski. All rights reserved.
//

import UIKit

protocol DetailCellDelegate: AnyObject {
    func cellDidChanched(set: Sets, indexPath: IndexPath)
}

class DetailTableViewCell: UITableViewCell {

    var coreDataStack: CoreDataStack!
    var indexPath: IndexPath?
    var set: Sets? {
        didSet {
            guard let set = set else { return }
            repeatsNumberLabel.text = "\(set.repeats)"
            weightTextLabel.text = "\(set.weight)"

            pickerView.selectRow(Int(set.repeats - 1), inComponent: 1, animated: true)
            let weight = Double(set.weight) / 2.5
            pickerView.selectRow(Int(weight - 1), inComponent: 3, animated: true)
        }
    }
    let numberLabel = UILabel()
    var repeatsNumberLabel = UILabel() 
    let repeatsLabel = UILabel()
    let weightTextLabel = UILabel()
    let weightLabel = UILabel()
    let restImageView = UIImageView()
    let restLabel = UILabel()
    let pickerStackView = UIStackView()
    let pickerView = UIPickerView()
    let editImageView = UIImageView()
    var repsIntegers: [String] = []
    var weightDoubles: [String] = []
    var pickerData: [[String]] = [[]]
    var heightOfComponent: CGFloat = 30
    var widthOfComponentsTitles: CGFloat = 80
    var widhtOfComponentsNumbers: CGFloat = 40
    var bottomLine = UIView()
    var heightOfPicker = NSLayoutConstraint()

    weak var delegate: DetailCellDelegate?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    func makeVarsForPicker() {
        var reps: Int = 0
        var weight: Double = 0
        for _ in 0..<50 {
            reps += 1
            weight += 2.5
            repsIntegers.append("\(reps)")
            weightDoubles.append("\(weight)")
        }
        pickerData = [[" Reps"], repsIntegers, ["Weight"], weightDoubles]

        //  pickerView.selectRow(pickerData[3][10], inComponent: 3, animated: true)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DetailTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerData.count
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 1 {
            repeatsNumberLabel.text = pickerData[component][row]
        } else {
            weightTextLabel.text = pickerData[component][row]
        }
        set?.repeats = Int16(repeatsNumberLabel.text!)!
        set?.weight = Double(weightTextLabel.text!)!
        guard let set = set else { return }
        delegate?.cellDidChanched(set: set, indexPath: indexPath!)
        coreDataStack.saveContext()
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if component == 1 || component == 3 {
            let numbersView = UIView(frame: CGRect(x: 0, y: 0, width: widhtOfComponentsNumbers, height: heightOfComponent))
            let label = UILabel(frame: numbersView.frame)
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: heightOfComponent - 2)
            label.adjustsFontSizeToFitWidth = true
            label.textColor = .mainLight
            label.text = pickerData[component][row]
            numbersView.addSubview(label)
            return numbersView
        } else {
            let titlesView = UIView(frame: CGRect(x: 0, y: 0, width: widthOfComponentsTitles, height: heightOfComponent))
            let label = UILabel(frame: titlesView.frame)
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: heightOfComponent - 2)
            label.adjustsFontSizeToFitWidth = true
            label.textColor = .white
            label.text = pickerData[component][row]
            titlesView.addSubview(label)
            return titlesView
        }
    }

    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if component == 1 || component == 3 {
            return widthOfComponentsTitles + 2
        } else {
            return widhtOfComponentsNumbers + 2
        }
    }
}

extension DetailTableViewCell {

    fileprivate func setupUI() {

        addSubview(numberLabel)
        setupNumberOfSetLabel()
        addSubview(repeatsNumberLabel)
        setupNumberOfRepeatsLabel()
        addSubview(repeatsLabel)
        setupRepeatsLabel()
        addSubview(weightTextLabel)
        setupWeightTextField()
        addSubview(weightLabel)
        setupWeightLabel()
        addSubview(restImageView)
        setupRestImageView()
        addSubview(restLabel)
        setupRestLabel()
        addSubview(pickerStackView)
        setupPickerView()
        addSubview(editImageView)
        setupBotomImageView()
        addSubview(bottomLine)
        setupBottomLine()
        makeVarsForPicker()
    }

    fileprivate func setupNumberOfSetLabel() {
        numberLabel.textAlignment = .center
        numberLabel.backgroundColor = .clear
        numberLabel.layer.cornerRadius = 10
        numberLabel.layer.borderColor = UIColor.white.cgColor
        numberLabel.layer.borderWidth = 1
        numberLabel.font = UIFont.boldSystemFont(ofSize: 20)
        numberLabel.textColor = .white
        numberLabel.layer.masksToBounds = true
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            numberLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            numberLabel.centerXAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            numberLabel.widthAnchor.constraint(equalToConstant: 24)
            ])
        let height = numberLabel.heightAnchor.constraint(equalToConstant: 24)
        height.priority = .defaultLow
        height.isActive = true
    }

    fileprivate func setupNumberOfRepeatsLabel() {
        repeatsNumberLabel.font = UIFont.boldSystemFont(ofSize: 30)
        repeatsNumberLabel.textColor = .white
        repeatsNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            repeatsNumberLabel.centerYAnchor.constraint(equalTo: numberLabel.centerYAnchor),
            repeatsNumberLabel.leadingAnchor.constraint(equalTo: numberLabel.trailingAnchor, constant: 24)])
    }

    fileprivate func setupRepeatsLabel() {
        repeatsLabel.text = "repeats /"
        repeatsLabel.textColor = .white
        repeatsLabel.font = UIFont.systemFont(ofSize: 24)
        repeatsLabel.translatesAutoresizingMaskIntoConstraints = false
        restLabel.adjustsFontSizeToFitWidth = true
        NSLayoutConstraint.activate([
            repeatsLabel.centerYAnchor.constraint(equalTo: repeatsNumberLabel.centerYAnchor),
            repeatsLabel.leadingAnchor.constraint(equalTo: repeatsNumberLabel.trailingAnchor, constant: 8)])
    }

    fileprivate func setupWeightTextField() {
        weightTextLabel.textColor = .white
        weightTextLabel.font = UIFont.boldSystemFont(ofSize: 30)
        weightTextLabel.adjustsFontSizeToFitWidth = true
        weightTextLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weightTextLabel.centerYAnchor.constraint(equalTo: repeatsLabel.centerYAnchor),
            weightTextLabel.leadingAnchor.constraint(equalTo: repeatsLabel.trailingAnchor, constant: 12)])
    }

    fileprivate func setupWeightLabel() {
        weightLabel.text = "kilos"
        weightLabel.textColor = .white
        weightLabel.font = UIFont.systemFont(ofSize: 24)
        weightLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weightLabel.centerYAnchor.constraint(equalTo: weightTextLabel.centerYAnchor),
            weightLabel.leadingAnchor.constraint(equalTo: weightTextLabel.trailingAnchor, constant: 8),])
    }

    fileprivate func setupRestImageView() {
        restImageView.image = UIImage(named: "timer")
        restImageView.tintColor = .white
        restImageView.contentMode = .scaleAspectFill
        restImageView.layer.masksToBounds = false
        restImageView.layer.cornerRadius = 18
        restImageView.backgroundColor = .clear
        restImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            restImageView.centerXAnchor.constraint(equalTo: numberLabel.centerXAnchor),
            restImageView.topAnchor.constraint(equalTo: numberLabel.bottomAnchor, constant: 16),
            restImageView.widthAnchor.constraint(equalToConstant: 20),
            restImageView.heightAnchor.constraint(equalToConstant: 20)])
    }

    fileprivate func setupRestLabel() {
        restLabel.text = "Rest 1:00"
        restLabel.font = UIFont.systemFont(ofSize: 16)
        restLabel.textColor = .mainLight
        restLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            restLabel.centerYAnchor.constraint(equalTo: restImageView.centerYAnchor),
            restLabel.leadingAnchor.constraint(equalTo: restImageView.trailingAnchor, constant: 16)])
    }

    fileprivate func setupPickerView() {
        pickerStackView.anchor(top: restLabel.bottomAnchor, leading: numberLabel.trailingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: -6, left: 24, bottom: 0, right: 44))
        pickerView.delegate = self
        pickerView.tintColor = .mainDark
        pickerView.layer.cornerRadius = 20
        pickerView.contentMode = .center
        pickerStackView.addArrangedSubview(pickerView)
        pickerStackView.isHidden = true
    }

    fileprivate func setupBotomImageView() {
        editImageView.anchor(top: nil, leading: pickerView.trailingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 0, left: 8, bottom: 8, right: 0), size: CGSize(width: 16, height: 16))
        editImageView.image = UIImage(named: "edit")
        editImageView.contentMode = .scaleAspectFit
        editImageView.tintColor = .white
    }

    fileprivate func setupBottomLine() {
        bottomLine.alpha = 0.2
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomLine.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomLine.centerXAnchor.constraint(equalTo: centerXAnchor),
            bottomLine.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 2 / 3),
            bottomLine.heightAnchor.constraint(equalToConstant: 1)])
        bottomLine.layer.borderWidth = 0.5
        bottomLine.layer.borderColor = UIColor.white.cgColor
    }
}



