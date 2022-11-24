import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Form(
            child: Column(
              children: [
                Text("อีเมล", style:TextStyle(fontSize: 20)),
                TextFormField(),
                SizedBox(height:15),
                Text("รหัสผ่าน", style:TextStyle(fontSize: 20)),
                TextFormField(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (){},
                    child: Text("ลงทะเบียน")
                  ),
                )
              ]
            ),
          ),
        ),
    );
  }
}