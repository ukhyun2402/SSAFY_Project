import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:main/globals.dart' as g;
import 'package:main/model/Member.dart';
import 'package:main/service/MemberService.dart';
import 'package:main/util/CheckValidate.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final emailKey = GlobalKey<FormFieldState>();
  final _passwordKey = GlobalKey<FormFieldState>();
  final _nameKey = GlobalKey<FormFieldState>();
  final _phonelKey = GlobalKey<FormFieldState>();

  var email = "";
  bool isVisible = true;

  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode nameFocus = FocusNode();
  FocusNode phoneFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('회원가입')),
      body: SingleChildScrollView(
        child: Form(
            key: formKey,
            child: Column(
              children: [
                _showEmailInput(),
                _showPasswordInput(),
                _showNameInput(),
                _showPhoneInput(),
                _showOkBtn()
              ],
            )),
      ),
    );
  }

  Widget _showEmailInput() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Stack(alignment: Alignment.centerRight, children: [
                  TextFormField(
                    key: emailKey,
                    keyboardType: TextInputType.emailAddress,
                    focusNode: emailFocus,
                    decoration: _textFormDecoration('이메일', '이메일을 입력하세요'),
                    onChanged: (value) {
                      emailKey.currentState?.validate();
                      email = value;

                      MemberService().idCheck(value).then((response) {
                        if (response) {
                          setState(() {
                            isVisible = true;
                          });
                        } else {
                          isVisible = false;
                        }
                      });
                    },
                    validator: (value) =>
                        CheckValidate().validateEmail(emailFocus, value!),
                  ),
                  Visibility(
                    child: Container(
                      child: Text(
                        "중복되는 아이디입니다",
                        style: TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    ),
                    visible: !isVisible,
                  )
                ])),
          ],
        ));
  }

  Widget _showPasswordInput() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextFormField(
                  key: _passwordKey,
                  focusNode: passwordFocus,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  onChanged: (value) {
                    _passwordKey.currentState?.validate();
                  },
                  decoration: _textFormDecoration(
                      '비밀번호', '특수문자, 대소문자, 숫자 포함 8자 이상 15자 이내로 입력하세요'),
                  validator: (value) =>
                      CheckValidate().validatePassword(passwordFocus, value!),
                )),
          ],
        ));
  }

  Widget _showNameInput() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextFormField(
                  key: _nameKey,
                  onChanged: (value) {
                    _nameKey.currentState?.validate();
                  },
                  focusNode: nameFocus,
                  keyboardType: TextInputType.text,
                  // obscureText: true,
                  decoration: _textFormDecoration('이름', '이름을 입력해 주세요'),
                  validator: (value) =>
                      CheckValidate().validateName(nameFocus, value!),
                )),
          ],
        ));
  }

  Widget _showPhoneInput() {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextFormField(
                  key: _phonelKey,
                  focusNode: phoneFocus,
                  keyboardType: TextInputType.text,
                  // obscureText: true,
                  onChanged: (_) {
                    _phonelKey.currentState?.validate();
                  },
                  decoration: _textFormDecoration('전화번호', '- 포함하여 입력해주세요'),
                  validator: (value) =>
                      CheckValidate().validatePhone(phoneFocus, value!),
                )),
          ],
        ));
  }

  InputDecoration _textFormDecoration(hintText, helperText) {
    return new InputDecoration(
      contentPadding: EdgeInsets.fromLTRB(0, 16, 0, 0),
      hintText: hintText,
      helperText: helperText,
    );
  }

  Widget _showOkBtn() {
    return Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: ElevatedButton(
          // height: 50,
          child: Text('회원가입'),
          onPressed: () {
            formKey.currentState?.validate();
            if (!isVisible) {
              emailFocus.requestFocus();
            } else {
              MemberService()
                  .signUp(
                Member(
                    email: email,
                    name: _nameKey.currentState?.value,
                    password: _passwordKey.currentState?.value,
                    phoneNumber: _phonelKey.currentState?.value),
              )
                  .then((value) {
                if (value) {
                  Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false);
                }
              });
            }
          },
        ));
  }
}
