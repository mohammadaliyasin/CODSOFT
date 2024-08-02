import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Description extends StatelessWidget {
  const Description(
      {super.key, required this.title, required this.description});
  final String title, description;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.yellow,
        ),
        title: Text(
          title,
          style: const TextStyle(
              color: Colors.yellow, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
          
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Expanded(
            child: Container(
              width: double.infinity,
              height: 800,
              decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(8),border: Border.all(color: Colors.white,width: 2,)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text('Description',style: GoogleFonts.roboto(color: Colors.yellowAccent,fontWeight: FontWeight.bold,fontSize: 22),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      description,
                      style: GoogleFonts.roboto(
                          color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
          ),
        ),
      )),
    );
  }
}