import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_first_app/model/request/customer_register_post_req.dart';
import 'package:my_first_app/pages/login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var fullnameCtl = TextEditingController();
  var phoneCtl = TextEditingController();
  var emailCtl = TextEditingController();
  var passwordCtl = TextEditingController();
  var confirmPasswordCtl = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ลงทะเบียนสมาชิกใหม่')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            TextField(
              controller: fullnameCtl,
              decoration: const InputDecoration(
                labelText: 'ชื่อ-นามสกุล',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: phoneCtl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'หมายเลขโทรศัพท์',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailCtl,
              decoration: const InputDecoration(
                labelText: 'อีเมล์',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passwordCtl,
              obscureText: obscurePassword,
              decoration: InputDecoration(
                labelText: 'รหัสผ่าน',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: confirmPasswordCtl,
              obscureText: obscureConfirmPassword,
              decoration: InputDecoration(
                labelText: 'ยืนยันรหัสผ่าน',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    obscureConfirmPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      obscureConfirmPassword = !obscureConfirmPassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(onPressed: register, child: const Text('สมัครสมาชิก')),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('หากมีบัญชีอยู่แล้ว?'),
                TextButton(
                  onPressed: loginPage,
                  child: const Text('เข้าสู่ระบบ'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void register() {
    String fullname = fullnameCtl.text.trim();
    String phone = phoneCtl.text.trim();
    String email = emailCtl.text.trim();
    String password = passwordCtl.text;
    String confirmPassword = confirmPasswordCtl.text;

    if (fullname.isEmpty ||
        phone.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      showMessage('กรุณากรอกข้อมูลให้ครบทุกช่อง');
      return;
    }

    if (password != confirmPassword) {
      showMessage('รหัสผ่านไม่ตรงกัน');
      return;
    }

    CustomerRegisterPostRequest
    customerRegisterPostRequest = CustomerRegisterPostRequest(
      fullname: fullname,
      phone: phone,
      email: email,
      image:
          "http://202.28.34.197:8888/contents/4a00cead-afb3-45db-a37a-c8bebe08fe0d.png",
      password: password,
    );

    http
        .post(
          Uri.parse("http://10.34.10.189:3000/customers"),
          headers: {"Content-Type": "application/json; charset=utf-8"},
          body: customerRegisterPostRequestToJson(customerRegisterPostRequest),
        )
        .then((response) {
          if (response.statusCode == 201 || response.statusCode == 200) {
            showMessage('สมัครสมาชิกสำเร็จ');
            Navigator.pop(context);
          } else {
            showMessage('เกิดข้อผิดพลาด: ${response.statusCode}');
          }
        })
        .catchError((error) {
          log('Error $error');
          showMessage('เกิดข้อผิดพลาดขณะสมัครสมาชิก');
        });
  }

  void loginPage() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage()));
  }
}
