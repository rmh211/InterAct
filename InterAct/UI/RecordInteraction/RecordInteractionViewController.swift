//
//  RecordInteractionViewController.swift
//  InterAct
//
//  Created by Robert Huber on 9/29/22.
//

import UIKit

class RecordInteractionViewController: UIViewController, Noteable{
    @IBOutlet weak var saveInteractionButton: UIButton! {
        didSet {
            saveInteractionButton.layer.cornerRadius = 5
            saveInteractionButton.layer.backgroundColor = UIColor.systemBlue.cgColor
            saveInteractionButton.tintColor = .white
        }
    }
    @IBOutlet weak var addNotesButton: UIButton! {
        didSet {
            addNotesButton.layer.cornerRadius = 5
            addNotesButton.layer.backgroundColor = UIColor.systemBlue.cgColor
            addNotesButton.tintColor = .white
        }
    }
    @IBOutlet weak var profileImageView: UIImageView! {
        didSet {
            profileImageView.contentMode = .scaleAspectFill
            profileImageView.makeRound()
            profileImageView.isUserInteractionEnabled = true
        }
    }
    @IBOutlet weak var personNameLabel: UILabel! {
        didSet {
            personNameLabel.font = .systemFont(ofSize: 25, weight: .medium)
        }
    }
    @IBOutlet weak var datePickerLabel: UILabel! {
        didSet {
            datePickerLabel.text = "Select Interaction Date: "
        }
    }
    @IBOutlet weak var interactionDatePicker: UIDatePicker! {
        didSet {
            interactionDatePicker.datePickerMode = .date
        }
    }
    @IBOutlet weak var qualitySliderLabel: UILabel! {
        didSet  {
            qualitySliderLabel.text = "Select the Quality of the Interaction"
        }
    }
    @IBOutlet weak var interactionQualitySegementedControl: UISegmentedControl! {
        didSet {
            interactionQualitySegementedControl.setTitle("In Passing", forSegmentAt: 0)
            interactionQualitySegementedControl.setTitle("Scheduled Meeting", forSegmentAt: 1)
        }
    }
    var imagePicker: UIImagePickerController!
    var notes: String? {
        didSet {
            viewModel?.notes = notes
        }
    }
    var viewModel: RecordInteractionViewModel? {
        didSet {
            viewModel?.viewDelegate = self
            title = viewModel?.title
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.initializeProfile()
        initializeTapGestureRecognizer()
    }
    override func viewDidAppear(_ animated: Bool) {
  
    }
    @objc func changePersonImage() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            selectImageFrom(.library)
            return
        }
        selectImageFrom(.camera)
    }
    @IBAction func addNotesButtonTapped(_ sender: Any) {
        viewModel?.addNotes()
    }
    func initializeTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(changePersonImage))
        profileImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    @IBAction func saveInteractionTapped(_ sender: Any) {
        guard let image = profileImageView.image else { return }
        viewModel?.saveInteraction(on: interactionDatePicker.date, qualityOf: interactionQualitySegementedControl.selectedSegmentIndex, image: image)
    }
}
extension RecordInteractionViewController: RecordInteractionViewModelDelegate {
    func recordInteractionViewModel(_ recordInteractionViewModel: RecordInteractionViewModel, willInitializeProfile person: Person) {
        profileImageView.image = UIImage(data: person.image)
        personNameLabel.text = person.name
    }
}
extension RecordInteractionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func selectImageFrom(_ source: ImageSource) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        switch source {
        case .camera:
            imagePicker.sourceType = .camera
        case .library:
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Error picking picture")
            return
        }
        profileImageView.image = selectedImage
    }
}
