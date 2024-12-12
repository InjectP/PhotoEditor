

import Foundation
import FirebaseAuth

final class AuthErrorHand {
    func AuthErrorHandler(_ error: NSError) -> String {
        var message = "Неизвестная ошибка. Попробуйте снова..."
        
        if let errorCode = AuthErrorCode(rawValue: error.code) {
            switch errorCode {
            case .emailAlreadyInUse:
                message = "Этот email уже зарегистрирован. Пожалуйста, войдите в систему."
            case .invalidEmail:
                message = "Неверный формат email. Пожалуйста, проверьте введенный адрес."
            case .weakPassword:
                message = "Пароль слишком короткий. Используйте не менее 6 символов."
            case .networkError:
                message = "Проблема с сетью. Проверьте подключение к интернету."
            case .userDisabled:
                message = "Этот аккаунт отключен. Обратитесь в службу поддержки."
            case .operationNotAllowed:
                message = "Регистрация с использованием email временно недоступна."
            case .invalidCredential:
                message = "Неверные или устаревшие учетные данные."
            case .userNotFound:
                message = "Пользователь не найден"
            default:
                message = "Неизвестная ошибка: \(error.localizedDescription)"
            }
        }
        
        return message

    }
}
