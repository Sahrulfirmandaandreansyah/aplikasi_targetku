import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isSignIn = true;

  void _toggleAuthMode() {
    setState(() {
      _isSignIn = !_isSignIn;
    });
  }

  void _signIn() {
    // TODO: Implement real sign-in logic
    context.go('/');
  }

  void _signUp() {
    // TODO: Implement real sign-up logic
    setState(() {
      _isSignIn = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sign up successful! Please sign in.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _isSignIn ? 'Selamat Datang!' : 'Buat Akun Baru',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _isSignIn ? 'Masuk untuk melanjutkan' : 'Isi form di bawah untuk mendaftar',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 48),
              _buildTextField(label: 'Email', icon: Icons.email),
              const SizedBox(height: 16),
              _buildTextField(label: 'Password', icon: Icons.lock, obscureText: true),
              if (!_isSignIn) ...[
                const SizedBox(height: 16),
                _buildTextField(label: 'Confirm Password', icon: Icons.lock, obscureText: true),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isSignIn ? _signIn : _signUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  _isSignIn ? 'Sign In' : 'Sign Up',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('OR'),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 24),
              _buildLoginButton(
                context,
                icon: Icons.g_mobiledata,
                text: 'Masuk dengan Google',
                onPressed: () {
                  // TODO: Implement Google Login
                },
              ),
              const SizedBox(height: 16),
              _buildLoginButton(
                context,
                icon: Icons.phone,
                text: 'Masuk dengan Nomor HP',
                onPressed: () {
                  // TODO: Implement Phone Login
                },
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: _toggleAuthMode,
                child: Text(
                  _isSignIn ? 'Belum punya akun? Sign Up' : 'Sudah punya akun? Sign In',
                  style: GoogleFonts.poppins(
                    color: Colors.indigo,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, required IconData icon, bool obscureText = false}) {
    return TextFormField(
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context, {required IconData icon, required String text, required VoidCallback onPressed}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        side: BorderSide(color: Colors.grey.shade300),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}