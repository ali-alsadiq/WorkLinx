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
    private weak var targetRequestViewController: RequestViewController?
    private weak var targetScheduleViewController: ScheduleViewController?
    
    init(buttons: [UIButton], targetViewController: RequestViewController) {
        self.buttons = buttons
        self.targetRequestViewController = targetViewController
        setupButtons()
    }
    
    init(buttons: [UIButton], targetViewController: ScheduleViewController) {
        self.buttons = buttons
        self.targetScheduleViewController = targetViewController
        setupButtons()
    }
    
    private func setupButtons() {
        for button in buttons {
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        }
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        selectButton(sender)
        
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
        switch index {
        case 0:
            targetRequestViewController?.allRequestsButtonTapped()
            targetScheduleViewController?.allShiftsButtonTapped()
        case 1:
            targetRequestViewController?.timeOffButtonTapped()
            targetScheduleViewController?.shiftsButtonTapped()
        case 2:
            targetRequestViewController?.reimbursementButtonTapped()
            targetScheduleViewController?.openShiftsButtonTapped()
        default:
            break
        }
    }
}
