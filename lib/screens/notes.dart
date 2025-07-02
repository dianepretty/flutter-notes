import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Notes extends StatelessWidget {
  const Notes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:  FloatingActionButton(onPressed: (){},
        backgroundColor: Color(0xFF395BFE),
        child: Icon(Icons.add,color: Colors.white),


      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title:
        Center(child: Text("Notes", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),)),
        backgroundColor:Color(0xFF395BFE),

      ),
      body: 
      SafeArea(
        child: Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            children: [

              Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                color: Color(0xFFF0F3FA) ,
                child:   Row(
                  children: [
                    const Text(
                      "Hello",
                      style: TextStyle(fontSize: 16),
                    ),
                    const Spacer(), // Pushes the following widgets to the right
                    const Icon(Icons.edit, size: 30, color: Colors.amber), // First icon
                    const SizedBox(width: 10), // Space between icons
                    const Icon(Icons.delete, size: 30, color: Colors.red), // Second icon
                  ],
                ),
              ),



            ],
          ),
        
        ),
      )
    );
  }
}
