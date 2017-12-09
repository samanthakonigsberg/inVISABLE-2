//
//  PickerViewController.swift
//  inVISABLE
//
//  Created by Samantha Konigsberg on 6/15/17.
//  Copyright © 2017 Samantha Konigsberg. All rights reserved.
//

import UIKit

class PickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var picker: UIPickerView!
    
    var array: [String]
    
    var selectedChoice: String?
    
    var selectedArray: [String]
    
    @IBOutlet weak var choicesTextView: UITextView!
    
    init(dataArray: [String]){
        array = dataArray
        selectedArray = []
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.array = []
        selectedArray = []
        super.init(coder: aDecoder)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        choicesTextView.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return array.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return array[row]

    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedChoice = array[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.black
        pickerLabel.text = array[row]
        pickerLabel.font = pickerLabel.font.withSize(15) ; pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        if let selectedChoice = selectedChoice {
            selectedArray.append(selectedChoice)
        } else {
            selectedArray.append(array[0])
        }
        
        choicesTextView.text = makeArrayString(array: selectedArray)
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        if array == illnesses{
            CurrentUser.shared.illnesses = selectedArray as NSArray
        } else if array == interests {
            CurrentUser.shared.interests = selectedArray as NSArray
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func makeArrayString(array: [String]) -> String {
        var returnString = ""
        for i in 0..<array.count{
            returnString += "\(i+1). \(array[i])\n"
        }
        return returnString
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
