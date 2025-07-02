import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

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
           child: ElevatedButton(onPressed: (){},
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
