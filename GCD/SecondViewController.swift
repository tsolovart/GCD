//
//  SecondViewController.swift
//  GCD
//
//  Created by Zaoksky on 07.09.2021.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // [7] Для загрузки изображения из интернета. Адрес image
    fileprivate var imageURL: URL?
    fileprivate var image: UIImage? {
        
        // [7] Получение значения image
        get {
            return imageView.image
        }
        // [7] Установка нового значения для св-ва. Изображение загрузилось
        set {
            activityIndicator.startAnimating()
            activityIndicator.isHidden = true
            imageView.image = newValue
            imageView.sizeToFit()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchImage()
        delay(3) {
            self.loginAlert()
        }
    }
    
    // [9] Задержка кода. @escaping - так как closure не замкнут, а может передаваться
    fileprivate func delay(_ delay: Int, closure: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
            closure()
        }
    }
    
    // [9]
    fileprivate func loginAlert() {
        let ac = UIAlertController(title: "Are you registered?", message: "Enter your username and password", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        ac.addAction(okAction)
        ac.addAction(cancelAction)
        
        ac.addTextField { (usernameTF) in
            usernameTF.placeholder = "username"
        }
        
        ac.addTextField { (userPasswordTF) in
            userPasswordTF.placeholder = "password"
            // [9] Не видеть вводимый пароль
            userPasswordTF.isSecureTextEntry = true
        }
        
        self.present(ac, animated: true, completion: nil)
    }
    
    // [7] Метод получения изображения
    fileprivate func fetchImage() {
        imageURL = URL(string: "https://s1.1zoom.ru/big3/309/Switzerland_Mountains_Winter_Fiesch_Alps_Snow_542199_4195x2800.jpg")
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        // [8] Процесс загрузки в другой поток.
        let queue = DispatchQueue.global(qos: .utility)
        // [8] Добавляем процесс ассинхронно, чтобы не ждать, когда выполнится задача
        queue.async {
            // [7] Если адрес существует, то получаем данные ввиде Data
            guard let url = self.imageURL, let imageData = try? Data(contentsOf: url) else { return }
            // [8] Возврат в главный поток
            DispatchQueue.main.async {
                // [7] устанавливаем новое значение для изображения
                self.image = UIImage(data: imageData)
            }
        }
    }
    
}
