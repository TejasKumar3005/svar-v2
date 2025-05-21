import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:svar_new/core/app_export.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:svar_new/widgets/custom_button.dart';

class ForgotPasswordDialog extends StatefulWidget {
  @override
  _ForgotPasswordDialogState createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
   void showErrorSnackBar(String message) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'password sent!',
        message: message,
        contentType: ContentType.success,
      ),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  Future<void> _sendResetEmail() async {
    if (_emailController.text.isNotEmpty) {
      try {
        await _auth.sendPasswordResetEmail(email: _emailController.text.trim());
     showErrorSnackBar('Password reset email sent');
       
        Navigator.of(context).pop(); // Close the dialog after successful email sent
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } else {
      showErrorSnackBar('Please enter an email address');
     
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      
      title: Text("Forgot Password",style: TextStyle(color: Colors.black),textAlign: TextAlign.center,),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.95,
            child:   TextFormField(
                  cursorColor: appTheme.orangeA200,
                controller: _emailController,
                decoration: InputDecoration(
                  fillColor: const Color.fromARGB(255, 241, 240, 240),
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    
                  borderSide: BorderSide(color: const Color.fromARGB(255, 135, 135, 135),width: 2),
                  ),
                  hintText: "Email",
                focusedBorder:  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    
                  borderSide: BorderSide(color: const Color.fromARGB(255, 135, 135, 135),width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    
                    borderSide: BorderSide(color: const Color.fromARGB(255, 187, 186, 186),width: 2),
                  ),
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog without action
          },
          child: CustomButton(type: ButtonType.Cancel, onPressed: () {
            Navigator.of(context).pop(); // Close the dialog without action
          }),
        ),
      CustomButton(
          type: ButtonType.ResetPassword,
        onPressed: _sendResetEmail,
      
      ),
      ],
    );
  }

  Widget Field(double height, String name, TextEditingController controller,
      BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      height: height,
      decoration: BoxDecoration(
          color: appTheme.whiteA70001,
          borderRadius: BorderRadius.circular(height / 2)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 60.h,
            padding: EdgeInsets.symmetric(vertical: 6.v),
            decoration: BoxDecoration(
                color: appTheme.whiteA70001,
                border: Border.all(
                  color: appTheme.orangeA200,
                  width: 4.h,
                  strokeAlign: strokeAlignOutside,
                ),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(height / 2),
                    bottomLeft: Radius.circular(height / 2))),
            child: Center(
              child: Icon(
                name == "email" ? Icons.email : Icons.lock,
                color: appTheme.orangeA200,
                size: 30.h,
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: appTheme.whiteA70001,
                  border: Border.all(
                    color: appTheme.orangeA200,
                    width: 4.h,
                    strokeAlign: strokeAlignOutside,
                  ),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(height / 2),
                      bottomRight: Radius.circular(height / 2))),
              child: Center(
                child: TextFormField(
                  
                  controller: controller,
                  style: TextStyle(color: Colors.black, fontSize: 22.h),
                  decoration: InputDecoration(
                      hintText: name.tr,
                    
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 22.h),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 6.h)),
                  validator: (value) {
                    if (value == null || value == "") {
                      return "Please enter $name";
                    }
                   
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

}
