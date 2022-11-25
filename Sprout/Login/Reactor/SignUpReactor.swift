//
//  SignUpReactor.swift
//  Sprout
//
//  Created by Blanc on 2022/11/10.
//  Copyright © 2022 Blanc. All rights reserved.
//

import Foundation
import UIKit
//import ReactorKit
//
//class SignUpReactor: Reactor {
//
//    let initialState = State()
//
//    enum Action {
//        case emailEdited(_ email: String)
//        case pwdEdited(_ password: String)
//        case pwdCheckEdited(_ passwordCheck: String)
//        case nicknameEdited(_ nickname: String)
//        case uploadProfileImage(_ photoData: PostPhotoModel)
//        case completedSignUp
//    }
//
//    enum Mutation {
//        case isEmailAlert(_ email: String)
//        case isNickNameAlert(_ nickName: String)
//        case isCorrectRegex(_ password: String)
//        case comparedToPassword(_ passwordCheck: String)
//        case uploadProfileImage(_ photoData: PostPhotoModel)
//        case completedSignUp
//    }
//
//    struct State {
//        var emailAlertText: String = ""
//        var nicknameAlertText: String = ""
//        var doneEnable: Bool = false
//        var completedSignUp: Bool = false
//    }
//
//    var isEmailAlert: Bool = false
//    var isNickNameAlert: Bool = false
//
//    private var userInform = User()
//
//}
//
//extension SignUpReactor {
//    func mutate(action: Action) -> Observable<Mutation> {
//        switch action {
//        case let .emailEdited(email):
//            return Observable.just(Mutation.isEmailAlert(email))
//
//        case let .pwdEdited(password):
//            return Observable.just(Mutation.isCorrectRegex(password))
//
//        case let .pwdCheckEdited(passwordCheck):
//            return Observable.just(Mutation.comparedToPassword(passwordCheck))
//
//        case let .nicknameEdited(nickname):
//            return Observable.just(Mutation.isNickNameAlert(nickname))
//
//        case let .uploadProfileImage(photoData):
//            return Observable.just(Mutation.uploadProfileImage(photoData))
//
//        case .completedSignUp:
//
//            return FirebaseManager.shared.auth.rx.createUser(withEmail: userInform.email, password: userInform.password)
//                .flatMap { [weak self] (result) -> Observable<String> in
//                    //프로필 이미지 업로드
//                    if let data = self?.userInform.profileImage {
//                        return FirebaseManager.shared.storageRef.child("profile_images").child(NSUUID().uuidString)
//                            .rx.uploadProfileImage(photoData: data.photoData)
//                    } else {
//                        let guestData = UIImage(named: "User_Guest")?.jpegData(compressionQuality: 1.0) ?? Data()
//                        return FirebaseManager.shared.storageRef.child("profile_images").child(NSUUID().uuidString)
//                            .rx.uploadProfileImage(photoData: guestData)
//                    }
//
//                }.flatMap { [weak self] imageUrl -> Observable<Bool> in
//                    //데이터베이스 유저정보 업로드
//                    guard let userInform = self?.userInform else { return Observable.empty() }
//                    return FirebaseManager.shared.realTimeDBRef.rx.uploadUserInfo(uid: NSUUID().uuidString,
//                                                                          nickname: userInform.nickname,
//                                                                          profileImageUrl: imageUrl)
//                }.filter { $0 }
//                .map { _ in Mutation.completedSignUp }
//        }
//    }
//
//    func reduce(state: State, mutation: Mutation) -> State {
//        var returnState = state
//        switch mutation {
//
//        case let .isEmailAlert(email):
//            returnState.emailAlertText = "이메일 형식이 맞지 않습니다."
//            isEmailAlert = !email.isEmpty
//            userInform.email = email
//
//        case let .isNickNameAlert(nickName):
//            returnState.nicknameAlertText = "닉네임이 중복됩니다."
//            isNickNameAlert = !nickName.isEmpty
//            userInform.nickname = nickName
//
//        case let .isCorrectRegex(password):
//            userInform.password = password
//
//        case let .comparedToPassword(passwordCheck):
//            if passwordCheck == userInform.password && !userInform.password.isEmpty && !passwordCheck.isEmpty {
//                returnState.doneEnable = true
//                userInform.password = passwordCheck
//            } else {
//                returnState.doneEnable = false
//            }
//        case let .uploadProfileImage(photoData):
//            userInform.profileImage = photoData
//
//        case .completedSignUp:
//            returnState.completedSignUp = true
//
//        }
//
//        return returnState
//    }
//}

struct User {
    var email: String
    var password: String
    var rePassword: String
    var nickname: String
    var profileImage: Photo?
    var userType: UserType

    init() {
        email = ""
        password = ""
        rePassword = ""
        nickname = ""
        userType = .None
    }
}

enum UserType: String {
    case None
    case Mentor
    case Mentee
    case Both
}
