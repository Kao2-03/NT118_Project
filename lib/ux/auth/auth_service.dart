import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  get facebookAuthCredential => null;

  // Kiểm tra xem email có tồn tại trong Firebase Authentication không.
  Future<bool> checkEmailExists(String email) async {
    try {
      final List<String> signInMethods = await _auth.fetchSignInMethodsForEmail(email);
      return signInMethods.isNotEmpty;
    } catch (error) {
      print("Lỗi kiểm tra email: $error");
      return false;
    }
  }

  // Đăng nhập bằng email và mật khẩu.
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (error) {
      print("Lỗi đăng nhập bằng email và password: $error");
      throw error;
    }
  }

  // Đăng nhập bằng Google.
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        try {
          final UserCredential userCredential = await _auth.signInWithCredential(credential);
          return userCredential.user;
        } on FirebaseAuthException catch (error) {
          if (error.code == 'account-exists-with-different-credential') {
            // Xử lý lỗi khi tài khoản đã tồn tại với thông tin xác thực khác
            final email = error.email;
            final pendingCredential = error.credential;
            final signInMethods = await _auth.fetchSignInMethodsForEmail(email!);

            if (signInMethods.isNotEmpty) {
              // Chọn phương thức đăng nhập đã liên kết
              final signInMethod = signInMethods[0];
              UserCredential userCredential;

              if (signInMethod == 'password') {
                // Sử dụng mật khẩu mặc định hoặc yêu cầu người dùng nhập mật khẩu
                userCredential = await _auth.signInWithEmailAndPassword(email: email, password: 'YOUR_DEFAULT_PASSWORD');
              } else if (signInMethod == 'google.com') {
                userCredential = await _auth.signInWithCredential(GoogleAuthProvider.credential(
                  idToken: googleSignInAuthentication.idToken,
                  accessToken: googleSignInAuthentication.accessToken,
                ));
              } else if (signInMethod == 'facebook.com') {
                // Đăng nhập lại bằng Facebook
                userCredential = await _auth.signInWithCredential(facebookAuthCredential!);
              } else {
                throw FirebaseAuthException(
                  code: 'sign-in-method-not-supported',
                  message: 'Phương thức đăng nhập không được hỗ trợ: $signInMethod',
                );
              }

              // Liên kết phương thức Google với tài khoản hiện tại
              await userCredential.user?.linkWithCredential(pendingCredential!);
              return userCredential.user;
            } else {
              throw FirebaseAuthException(
                code: 'no-sign-in-method',
                message: 'Không tìm thấy phương thức đăng nhập.',
              );
            }
          } else {
            print("Lỗi đăng nhập bằng Google: $error");
            throw error;
          }
        }
      }
      return null;
    } catch (error) {
      print("Lỗi đăng nhập bằng Google: $error");
      throw error;
    }
  }

  // Đăng nhập bằng Facebook.
  Future<User?> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(result.accessToken!.token);
        try {
          final UserCredential userCredential = await _auth.signInWithCredential(facebookAuthCredential);
          return userCredential.user;
        } on FirebaseAuthException catch (error) {
          if (error.code == 'account-exists-with-different-credential') {
            // Xử lý lỗi khi tài khoản đã tồn tại với thông tin xác thực khác
            final email = error.email;
            final pendingCredential = error.credential;
            final signInMethods = await _auth.fetchSignInMethodsForEmail(email!);

            if (signInMethods.isNotEmpty) {
              // Chọn phương thức đăng nhập đã liên kết
              final signInMethod = signInMethods[0];
              UserCredential userCredential;

              if (signInMethod == 'password') {
                // Sử dụng mật khẩu mặc định hoặc yêu cầu người dùng nhập mật khẩu
                userCredential = await _auth.signInWithEmailAndPassword(email: email, password: 'YOUR_DEFAULT_PASSWORD');
              } else if (signInMethod == 'google.com') {
                // Đăng nhập lại bằng Google
                userCredential = await _auth.signInWithCredential(GoogleAuthProvider.credential(
                  idToken: null, // Bạn cần phải lấy lại Google ID token
                  accessToken: null, // Bạn cần phải lấy lại Google Access token
                ));
              } else if (signInMethod == 'facebook.com') {
                // Đăng nhập lại bằng Facebook
                userCredential = await _auth.signInWithCredential(facebookAuthCredential!);
              } else {
                throw FirebaseAuthException(
                  code: 'sign-in-method-not-supported',
                  message: 'Phương thức đăng nhập không được hỗ trợ: $signInMethod',
                );
              }

              // Liên kết phương thức Facebook với tài khoản hiện tại
              await userCredential.user?.linkWithCredential(pendingCredential!);
              return userCredential.user;
            } else {
              throw FirebaseAuthException(
                code: 'no-sign-in-method',
                message: 'Không tìm thấy phương thức đăng nhập.',
              );
            }
          } else {
            print("Lỗi đăng nhập bằng Facebook: $error");
            throw error;
          }
        }
      }
      return null;
    } catch (error) {
      print("Lỗi đăng nhập bằng Facebook: $error");
      throw error;
    }
  }

  // Đăng xuất.
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      print("Đăng xuất thành công");
    } catch (e) {
      print("Lỗi khi đăng xuất: $e");
      throw e;
    }
  }
}
