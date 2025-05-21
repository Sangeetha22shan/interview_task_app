import 'package:flutter/material.dart';

import 'home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _mobileController;
  late TextEditingController _otpController;
  bool _isOTPEnabled = false;
  bool _isLoginEnabled = false;
  bool _isSendOTPEnabled = false;
  @override
  void initState() {
    super.initState();
    _mobileController = TextEditingController();
    _otpController = TextEditingController();
  }

  void dispose() {
    _mobileController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _onMobileChanged(String value) {
    final isValid = RegExp(r'^[6-9]\d{9}$').hasMatch(value);
    setState(() {
      _isSendOTPEnabled = isValid;
      if (!isValid) {
        _isOTPEnabled = false;
        _otpController.clear();
        _isLoginEnabled = false;
      }
    });
  }

  void _onOtpChanged(String value) {
    setState(() {
      _isLoginEnabled = _isOTPEnabled && value.length == 6;
    });
  }

  void _onSendOtp() {
    setState(() {
      _isOTPEnabled = true;
      _otpController.clear();
      _isLoginEnabled = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('OTP sent to your mobile number')),
    );
  }

  void _onLogin() {
    if (_otpController.text == "123456") {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Login Successful!')));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid OTP')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Page')),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            constraints: const BoxConstraints(maxWidth: 400),
            child: Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _mobileController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      decoration: const InputDecoration(
                        labelText: 'Mobile Number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                      ),
                      onChanged: _onMobileChanged,
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        onPressed: _isSendOTPEnabled ? _onSendOtp : null,
                        child: const Text('Send OTP'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      enabled: _isOTPEnabled,
                      decoration: InputDecoration(
                        labelText: 'OTP',
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        hintText:
                            _isOTPEnabled
                                ? 'Enter OTP'
                                : 'Enter valid mobile number and send OTP',
                      ),
                      onChanged: _onOtpChanged,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: 100,
                      child: ElevatedButton(
                        onPressed: _isLoginEnabled ? _onLogin : null,
                        child: const Text('Login'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
