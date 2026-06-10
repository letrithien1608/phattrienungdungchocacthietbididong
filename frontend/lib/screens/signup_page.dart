import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../api_client.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isValidName = false;

  void _checkName(String value) {
    setState(() {
      _isValidName = value.trim().isNotEmpty;
    });
  }

  void _handleSignup() async {
    final res = await ApiClient.signup(_nameController.text, _emailController.text, _passwordController.text);
    if (!mounted) return;
    if (res['success']) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đăng ký thành công!')));
      Provider.of<AppState>(context, listen: false).setUser(_nameController.text, _emailController.text, res['data']['token']);
      Navigator.pushReplacementNamed(context, '/main');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message'])));
    }
  }

  void _handleGoogleLogin() async {
    try {
      await GoogleSignIn.instance.signOut();
      final GoogleSignInAccount? googleUser = await GoogleSignIn.instance.authenticate();
      if (googleUser == null) return;
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      if (googleAuth.idToken != null) {
        final res = await ApiClient.socialLogin('google', googleAuth.idToken!, '');
        if (!mounted) return;
        if (res['success']) {
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đăng nhập Google thành công!')));
           Provider.of<AppState>(context, listen: false).setUser(
             googleUser.displayName ?? 'Google User',
             googleUser.email, res['data']['token'],
             googleUser.photoUrl,
           );
           Navigator.pushReplacementNamed(context, '/main');
        } else {
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message'])));
        }
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lỗi: Cấu hình thiếu Web Client ID. Không thể lấy idToken.')));
      }
    } catch (e) {
      if (e.toString().contains('sign_in_canceled') || e.toString().contains('Canceled') || e.toString().contains('canceled')) {
        return; // Người dùng ấn cancel thì bỏ qua
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
    }
  }

  void _handleFacebookLogin() async {
    try {
      await FacebookAuth.instance.logOut();
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final res = await ApiClient.socialLogin('facebook', result.accessToken!.tokenString, '');
        if (!mounted) return;
        if (res['success']) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đăng nhập Facebook thành công!')));
          final userData = await FacebookAuth.instance.getUserData();
          Provider.of<AppState>(context, listen: false).setUser(
            userData['name'] ?? 'Facebook User',
            userData['email'] ?? '', res['data']['token'],
            userData['picture']?['data']?['url'],
          );
          Navigator.pushReplacementNamed(context, '/main');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message'])));
        }
      } else if (result.status == LoginStatus.cancelled) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã hủy đăng ký Facebook')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: ${result.message}')));
      }
    } catch (e) {
      if (e.toString().contains('CANCELLED') || e.toString().contains('cancelled') || e.toString().contains('canceled')) {
        return;
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      'Sign up',
                      style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    const SizedBox(height: 50),
                    _buildTextField(
                      controller: _nameController,
                      label: 'Name',
                      onChanged: _checkName,
                      trailing: _isValidName ? const Icon(Icons.check, color: Colors.green) : null,
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      controller: _emailController,
                      label: 'Email',
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      controller: _passwordController,
                      label: 'Password',
                      obscureText: true,
                    ),
                    const SizedBox(height: 15),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/login'),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Already have an account?', style: TextStyle(color: Colors.black54)),
                            SizedBox(width: 5),
                            Icon(Icons.arrow_right_alt, color: Color(0xFFDB3022)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _handleSignup,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDB3022),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                          elevation: 3,
                        ),
                        child: const Text('SIGN UP', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const Spacer(),
                    const Center(child: Text('Or sign up with social account', style: TextStyle(color: Colors.black54))),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSocialButton('assets/icons/google.svg', _handleGoogleLogin),
                        const SizedBox(width: 15),
                        _buildSocialButton('assets/icons/facebook.svg', _handleFacebookLogin),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String label, bool obscureText = false, Widget? trailing, void Function(String)? onChanged}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black54),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          suffixIcon: trailing,
        ),
      ),
    );
  }

  Widget _buildSocialButton(String assetPath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
        ),
        child: Center(
          child: SvgPicture.asset(assetPath, width: 24, height: 24),
        ),
      ),
    );
  }
}
