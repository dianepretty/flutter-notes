import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handel_login (){
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;

    if ( email.isEmpty || password.isEmpty) {
      _showSnackBar('Please fill in all fields.');
      return;
    }
    if (!email.contains('@') || !email.contains('.')) {
      _showSnackBar('Please enter a valid email address.');
      return;
    }
    if (password.length < 6) {
      _showSnackBar('Password must be at least 6 characters long.');
      return;
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: TextStyle(fontSize: 18),)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: SafeArea(child:
        Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text("Login", style: TextStyle( fontWeight: FontWeight.bold, fontSize: 30, color: Color(0xFF395BFE)),),
                ),
                const  SizedBox(height: 24),


                SizedBox(
                    width: 400,
                    height: 50,
                    child: TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: "Email",
                          hintText: "user@gmail.com",
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                          )
                      ),
                    )),
                const  SizedBox(height: 24),
                SizedBox(
                    width: 400,
                    height: 50,
                    child: TextField(
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: _passwordController,
                      decoration: InputDecoration(
                          labelText: "Password",
                          hintText: "enter password",
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                          )
                      ),
                    )),
                const  SizedBox(height: 24),
                SizedBox(
                  width: 400,
                  height: 50,
                  child: ElevatedButton(onPressed: _handel_login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF395BFE),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
                      ),
                    ),
                    child: const Text("Log In", style: TextStyle(fontSize: 20)),

                  ),
                ),

                // SnackBar(content: Text("You have successfully signed up"))


              ],
            )) ,

        ));
  }
}
