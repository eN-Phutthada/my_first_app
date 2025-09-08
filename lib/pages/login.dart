import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:my_first_app/config/config.dart';
import 'package:my_first_app/model/request/customer_login_post_req.dart';
import 'package:my_first_app/model/response/customer_login_post_res.dart';
import 'package:my_first_app/pages/register.dart';
// import 'package:my_first_app/pages/showtrip.dart';
import 'package:http/http.dart' as http;
import 'package:my_first_app/pages/showtrip.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String text = '';
  int number = 0;
  var phoneCtl = TextEditingController();
  var passwordCtl = TextEditingController();
  String url = '';

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then((config) {
      url = config['apiEndpoint'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login Page')),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => login(),
                child: Image.asset('assets/images/logo.png'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('หมายเลขโทรศัพท์', style: TextStyle(fontSize: 16)),
                    TextField(
                      controller: phoneCtl,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(border: OutlineInputBorder()),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text('รหัสผ่าน', style: TextStyle(fontSize: 16)),
                    ),
                    TextField(
                      obscureText: true,
                      controller: passwordCtl,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 1),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: register,
                          child: const Text('ลงทะเบียนใหม่'),
                        ),
                        FilledButton(
                          onPressed: () {
                            login();
                          },
                          child: const Text('เข้าสู่ระบบ'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(text, style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }

  void register() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage()),
    );
  }

  void login() {
    // var data = {"phone": "0817399999", "password": "1111"};
    CustomerLoginPostRequest customerLoginPostRequest =
        CustomerLoginPostRequest(
          phone: phoneCtl.text,
          password: passwordCtl.text,
        );

    http
        .post(
          Uri.parse("$url/customers/login"),
          headers: {"Content-Type": "application/json; charset=utf-8"},
          body: customerLoginPostRequestToJson(customerLoginPostRequest),
        )
        .then((value) {
          CustomerLoginPostResponse customerLoginPostResponse =
              customerLoginPostResponseFromJson(value.body);
          log(customerLoginPostResponse.customer.fullname);
          log(customerLoginPostResponse.customer.email);
          log(customerLoginPostResponse.customer.idx.toString());

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ShowTripPage(cid: customerLoginPostResponse.customer.idx),
            ),
          );
        })
        .catchError((error) {
          log('Error $error');
        });
  }
}
