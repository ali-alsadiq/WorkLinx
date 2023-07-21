//
//  ButtonGroup.swift
//  WorkLinx
//
//  Created by Ali Alsadiq on 2023-07-21.
//

import Foundation
import UIKit

class ButtonGroup {
    private var buttons: [UIButton]
    private weak var targetViewController: RequestViewController? // Keep a weak reference to the target view controller
    
    init(buttons: [UIButton], targetViewController: RequestViewController) {
        self.buttons = buttons
        self.targetViewController = targetViewController // Assign the target view controller
        
        // Add target to each button to handle tap events
        for button in buttons {
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        }
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        selectButton(sender)
        
        // Run the function associated with the selected button (if any)
        if let index = buttons.firstIndex(of: sender) {
            runFunctionForButton(at: index)
        }
    }
    
    private func selectButton(_ button: UIButton) {
        for btn in buttons {
            btn.isSelected = btn == button
            btn.backgroundColor = btn.isSelected ? .systemBlue : .lightGray
            btn.setTitleColor(btn.isSelected ? .white : .black, for: .normal)
        }
    }
    
    private func runFunctionForButton(at index: Int) {
        // Implement your custom function for each button index here
        switch index {
        case 0:
            // Handle button at index 0
            targetViewController?.timeOffButtonTapped() // Call the corresponding function in the target view controller
        case 1:
            // Handle button at index 1
            targetViewController?.shiftsButtonTapped() // Call the corresponding function in the target view controller
        case 2:
            // Handle button at index 2
            targetViewController?.openShiftsButtonTapped() // Call the corresponding function in the target view controller
        default:
            break
        }
    }
}
