//
//  ColorPickerView.swift
//  Pods
//
//  Created by Andrea Antonioni on 23/01/2017.
//
//

import UIKit

open class ColorPickerView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    open var colors: [UIColor] = [#colorLiteral(red: 1, green: 0.5411764706, blue: 0.5019607843, alpha: 1), #colorLiteral(red: 1, green: 0.09019607843, blue: 0.2666666667, alpha: 1), #colorLiteral(red: 0.8352941176, green: 0, blue: 0, alpha: 1),
                                  #colorLiteral(red: 0.9176470588, green: 0.5019607843, blue: 0.9882352941, alpha: 1), #colorLiteral(red: 0.8352941176, green: 0, blue: 0.9764705882, alpha: 1), #colorLiteral(red: 0.6666666667, green: 0, blue: 1, alpha: 1),
                                  #colorLiteral(red: 0.7019607843, green: 0.5333333333, blue: 1, alpha: 1), #colorLiteral(red: 0.3960784314, green: 0.1215686275, blue: 1, alpha: 1), #colorLiteral(red: 0.3843137255, green: 0, blue: 0.9176470588, alpha: 1),
                                  #colorLiteral(red: 0.5490196078, green: 0.6196078431, blue: 1, alpha: 1), #colorLiteral(red: 0, green: 0.6901960784, blue: 1, alpha: 1), #colorLiteral(red: 0, green: 0.568627451, blue: 0.9176470588, alpha: 1),
                                  #colorLiteral(red: 0.5176470588, green: 1, blue: 1, alpha: 1), #colorLiteral(red: 0, green: 0.8980392157, blue: 1, alpha: 1), #colorLiteral(red: 0, green: 0.7215686275, blue: 0.831372549, alpha: 1),
                                  #colorLiteral(red: 0.7254901961, green: 0.9647058824, blue: 0.7921568627, alpha: 1), #colorLiteral(red: 0, green: 0.9019607843, blue: 0.462745098, alpha: 1), #colorLiteral(red: 0, green: 0.7843137255, blue: 0.3254901961, alpha: 1),
                                  #colorLiteral(red: 1, green: 1, blue: 0.5529411765, alpha: 1), #colorLiteral(red: 1, green: 0.9176470588, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.8392156863, blue: 0, alpha: 1),
                                  #colorLiteral(red: 1, green: 0.8196078431, blue: 0.5019607843, alpha: 1), #colorLiteral(red: 1, green: 0.568627451, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.4274509804, blue: 0, alpha: 1),
                                  #colorLiteral(red: 1, green: 0.6196078431, blue: 0.5019607843, alpha: 1), #colorLiteral(red: 1, green: 0.2392156863, blue: 0, alpha: 1), #colorLiteral(red: 0.8666666667, green: 0.1725490196, blue: 0, alpha: 1),
                                  #colorLiteral(red: 0.737254902, green: 0.6666666667, blue: 0.6431372549, alpha: 1), #colorLiteral(red: 0.4745098039, green: 0.3333333333, blue: 0.2823529412, alpha: 1), #colorLiteral(red: 0.3058823529, green: 0.2039215686, blue: 0.1803921569, alpha: 1),
                                  #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1), #colorLiteral(red: 0.3803921569, green: 0.3803921569, blue: 0.3803921569, alpha: 1), #colorLiteral(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1)]
    
    fileprivate lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ColorPickerCell.self, forCellWithReuseIdentifier: ColorPickerCell.cellIdentifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsMultipleSelection = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    open var layoutDelegate: ColorPickerViewDelegateFlowLayout?
    open var delegate: ColorPickerViewDelegate?
    
    open var preselectedIndex: Int? {
        didSet {
            guard let index = preselectedIndex else { return }
            guard index > 0, colors.indices.contains(index) else {
                print("ERROR ColorPickerView - preselectedItem out of colors range")
                return
            }
            indexOfSelectedColor = preselectedIndex
        }
    }
    
    fileprivate var indexOfSelectedColor: Int?
    
    // MARK: - View management
    
    open override func layoutSubviews() {
        self.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addConstraint(NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: collectionView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: collectionView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0))
        
    }
    
    // MARK: - UICollectionViewDataSource
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorPickerCell.cellIdentifier, for: indexPath) as! ColorPickerCell
        
        cell.backgroundColor = colors[indexPath.item]
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let colorPickerCell = cell as! ColorPickerCell
        guard indexPath.item == indexOfSelectedColor else {
            colorPickerCell.checkbox.setCheckState(.unchecked, animated: false)
            return
        }
        
        if colors[indexPath.item].isWhiteText {
            colorPickerCell.checkbox.tintColor = .white
        } else {
            colorPickerCell.checkbox.tintColor = .black
        }
        colorPickerCell.checkbox.setCheckState(.checked, animated: false)
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Check if user taps on the already selected color
//        guard indexPath.item != indexOfSelectedColor else { return }
        indexOfSelectedColor = indexPath.item
        
        let colorCell = collectionView.cellForItem(at: indexPath) as! ColorPickerCell
        if colors[indexPath.item].isWhiteText {
            colorCell.checkbox.tintColor = .white
        } else {
            colorCell.checkbox.tintColor = .black
        }
//        colorCell.checkbox.switchCheckState(animated: true)
        colorCell.checkbox.setCheckState((colorCell.checkbox.checkState == .checked) ? .unchecked : .checked, animated: true)
        
        delegate?.colorPickerView(self, didSelectItemAt: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        // Check if the old color cell is showed. If true, it deselects it
        guard let oldColorCell = collectionView.cellForItem(at: indexPath) as? ColorPickerCell else {
            return
        }
        oldColorCell.checkbox.setCheckState(.unchecked, animated: true)
        
        delegate?.colorPickerView?(self, didDeselectItemAt: indexPath)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let layoutDelegate = layoutDelegate, let sizeForItemAt = layoutDelegate.colorPickerView?(self, sizeForItemAt: indexPath) {
            return sizeForItemAt
        }
        return CGSize(width: 48, height: 48)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if let layoutDelegate = layoutDelegate, let minimumLineSpacingForSectionAt = layoutDelegate.colorPickerView?(self, minimumLineSpacingForSectionAt: section) {
            return minimumLineSpacingForSectionAt
        }
        return 0
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if let layoutDelegate = layoutDelegate, let minimumInteritemSpacingForSectionAt = layoutDelegate.colorPickerView?(self, minimumInteritemSpacingForSectionAt: section) {
            return minimumInteritemSpacingForSectionAt
        }
        return 0
    }
    
}
