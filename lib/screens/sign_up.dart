import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

   void _submit (){
     final String firstName = _firstNameController.text.trim();
     final String lastName = _lastNameController.text.trim();
     final String email = _emailController.text.trim();
     final String password = _passwordController.text;

     if (firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty) {
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
            child: Text("Sign Up", style: TextStyle( fontWeight: FontWeight.bold, fontSize: 30, color: Color(0xFF395BFE)),),
          ),
         const SizedBox(
            height: 24),
        SizedBox(
        width: 400,
        height: 50,
        child: TextField(
          controller: _firstNameController,
            decoration: InputDecoration(
              labelText: "First Name",
              hintText: "John",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),

                ),

            ),
            keyboardType: TextInputType.text,
          )),
          const  SizedBox(height: 24),
      SizedBox(
        width: 400,
        height: 50,
          child: TextField(
            controller: _lastNameController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                labelText: "Last Name",
                hintText: "Doe",
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
                controller: _passwordController,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
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
           child: ElevatedButton(onPressed: _submit,
             style: ElevatedButton.styleFrom(
                 backgroundColor: Color(0xFF395BFE),
                 foregroundColor: Colors.white,
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
               ),
             ),
             child: const Text("Sign Up", style: TextStyle(fontSize: 20)),

           ),
         ),

          // SnackBar(content: Text("You have successfully signed up"))


        ],
      )) ,

    ));
  }
}
