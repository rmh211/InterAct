//
//  AddPersonViewController.swift
//  InterAct
//
//  Created by Robert Huber on 9/29/22.
//

import UIKit

class AddPersonViewController: UIViewController, Noteable {
    @IBOutlet weak var additionalInfoButton: UIButton! {
        didSet{
            additionalInfoButton.setTitle("", for: .normal)
        }
    }
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addPersonButton: UIButton! {
        didSet {
            addPersonButton.layer.cornerRadius = 5
            addPersonButton.tintColor = .white
            addPersonButton.layer.backgroundColor = UIColor.systemBlue.cgColor
        }
    }
    @IBOutlet weak var profileImageView: UIImageView! {
        didSet {
            profileImageView.image = UIImage(systemName: "person")
            profileImageView.isUserInteractionEnabled = true
            profileImageView.contentMode = .scaleAspectFill
            profileImageView.makeRound()
        }
    }
    
    var imagePicker: UIImagePickerController!
    var notes: String? {
        didSet {
            viewModel?.notes = notes
        }
    }
    
    var viewModel: AddPersonViewModel? {
        didSet {
            viewModel?.viewDelegate = self
            title = viewModel?.title
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTapGestureRecognizer()
    }
    @objc func changePersonImage() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            selectImageFrom(.library)
            return
        }
        selectImageFrom(.camera)
    }
    @IBAction func addPersonButtonTapped(_ sender: Any) {
        guard let image = profileImageView.image else { return }
        viewModel?.savePerson(withName: nameTextField.text, image: image)
    }
    func initializeTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(changePersonImage))
        profileImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    @IBAction func additionalInfoButtonTapped(_ sender: Any) {
        viewModel?.didRequestNotes(titled: "Add Personal Details")
    }
}
extension AddPersonViewController: AddPersonViewModelDelegate {
    
}
extension AddPersonViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
enum ImageSource {
    case camera
    case library
}
