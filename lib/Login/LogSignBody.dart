import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nine_workout/Login/LoginWays.dart';
import 'package:nine_workout/Login/custombutton.dart';
import 'package:nine_workout/Login/customtextfield.dart';
import 'package:nine_workout/Needes/Profile.dart';
import 'package:nine_workout/Pages/NavigationBar.dart'; // لضمان معرفة MainScreen
import 'package:nine_workout/Useless/consts.dart';

class Logsignbody extends StatelessWidget 
{
  // Controllers الخاصة بالحقلين المشتركة
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  // Controller لحقل اسم المستخدم (يُستخدم فقط إذا كان showUsernameField true)
  final TextEditingController usernameController = TextEditingController();

  final bool _isLoading = false;


  // معرف الطريق للصفحة التي سيتم الانتقال إليها (مثلاً صفحة التسجيل أو صفحة الدخول)
  final String returnPageRoute;
  // دالة العملية التي تأخذ BuildContext، البريد الإلكتروني، كلمة المرور، واسم المستخدم (يمكن أن يكون null)
  final Future<void> Function(BuildContext, String, String, String?) doSign;

  final String title;
  final String anotheroptiontext;
  final String anotheroptionpage;
  final String ButtonTitle;
  final Color doSignColor;

  // متغير اختياري لتحديد عرض قسم "Forget Password?"
  final bool showForgetPassword;
  
  // متغير اختياري لتحديد عرض حقل اسم المستخدم (يُعرض في صفحة التسجيل)
  final bool showUsernameField;
  

  Logsignbody
  ({
    super.key,
    required this.returnPageRoute,
    required this.doSign,
    required this.title,
    required this.anotheroptiontext,
    required this.anotheroptionpage,
    required this.ButtonTitle,
    this.showForgetPassword = true,
    this.showUsernameField = false, 
    required this.doSignColor,
  });

  @override
  Widget build(BuildContext context) 
  {
    return WillPopScope
    (
      onWillPop: () async 
      {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold
      (
        backgroundColor: Colors.black,
        appBar: AppBar
        (
          toolbarHeight: 80,
          backgroundColor: Colors.black,
          leadingWidth: 85,

          leading: Container
          (
            padding: const EdgeInsets.only(left: 0),

            child: TextButton
            (
              onPressed: ()
               {
                Navigator.pushReplacement
                (
                  context,
                  MaterialPageRoute(builder: (context) => const MainScreen()),
                );
              },
              style: TextButton.styleFrom
              (
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),

              child: const Text
              (
                'Skip',
                softWrap: false,
                style: TextStyle
                (
                  color: Colors.grey,
                  fontSize: 16,
                  height: 1.0,
                ),
              ),
            ),
          ),
        ),
        body: Padding
        (
          padding: const EdgeInsets.all(20),

          child: ListView
          (
            children: 
            [
              // العنوان العام
              Row
              (
                mainAxisAlignment: MainAxisAlignment.center,
                children: 
                [
                  Text
                  (
                    'Nine Workout',
                    style: TextStyle
                    (
                      fontFamily: 'Pacifico',
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 55),
              // عنوان العملية (Login أو Sign Up)
              Row
              (
                children: 
                [
                  Text
                  (
                    title,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // إذا كان showUsernameField true، نعرض حقل اسم المستخدم
              if (showUsernameField)
                Column
                (
                  children: 
                  [
                    CustomTextField
                    (
                      iconfield: Icon
                      (
                        CupertinoIcons.person_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                      hinttext: 'Username',
                      bordercolor: Colors.white,
                      controller: usernameController,
                      obscureText: false,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              // حقل البريد الإلكتروني
              CustomTextField
              (
                iconfield: Icon(CupertinoIcons.mail, color: Colors.white, size: 20),
                hinttext: 'Email',
                bordercolor: Colors.white,
                controller: emailController,
                obscureText: false,
              ),
              const SizedBox(height: 20),
              // حقل كلمة المرور
              CustomTextField
              (
                iconfield: Icon(CupertinoIcons.padlock, color: Colors.white, size: 19),
                hinttext: 'Password',
                bordercolor: Colors.white,
                controller: passwordController,
                obscureText: true,
              ),
              
              // عرض قسم "Forget Password?" فقط إذا كان showForgetPassword true
              if (showForgetPassword)
                Align
                (
                  alignment: Alignment.centerRight,

                  child: Padding
                  (
                    padding: const EdgeInsets.only(right: 2.0),

                    child: TextButton
                    (
                      style: TextButton.styleFrom
                      (
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),

                      onPressed: ()
                      {
                        Navigator.push
                        (
                          context,
                          MaterialPageRoute(builder: (context) => const Profile()),
                        );
                      },

                      child: IntrinsicWidth
                      (
                        child: Column
                        (
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,

                          children: 
                          [

                            SizedBox(height: 10),

                            Text(
                              'Forget Password?',
                              style: TextStyle
                              (
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),

                            Container
                            (
                              height: 1,
                              color: Colors.grey,
                            ),

                            SizedBox(height: 35),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              // الزر الذي ينفذ العملية (Login/Sign Up)
              Custombutton
              (

                backgroundcolor: doSignColor,
                titlecolor: Colors.black,
                title: ButtonTitle,

                onPressed: () => doSign
                (
                  context,
                  emailController.text.trim(),
                  passwordController.text,
                  showUsernameField ? usernameController.text.trim() : null,
                ),
              ),

              const SizedBox(height: 8),

              // السطر الخاص بنقل المستخدم بين الصفحات (مثلاً: "Already have an account?")
              Row
              (

                mainAxisAlignment: MainAxisAlignment.center,

                children: 
                [
                  Text
                  (
                    anotheroptiontext,
                    style: TextStyle(color: Colors.white),
                  ),
                  GestureDetector
                  (
                    onTap: () 
                    {
                      Navigator.pushReplacementNamed(context, returnPageRoute);
                    },

                    child: Text
                    (
                      anotheroptionpage,
                      style: TextStyle(color: myColor),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // الفاصل بين الخيارات الاجتماعية
              Row
              (

                mainAxisAlignment: MainAxisAlignment.center,

                children: 
                [
                  Expanded
                  (
                    child: Divider
                    (
                      color: Colors.grey,
                      thickness: 1,
                      endIndent: 0,
                      indent: 30,
                    ),
                  ),

                  Padding
                  (
                  
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  
                    child: Text
                    (
                      'or',
                      style: TextStyle
                      (
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  
                  Expanded
                  (
                    child: Divider
                    (
                      color: Colors.grey,
                      thickness: 1,
                      indent: 0,
                      endIndent: 30,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              // خيارات الدخول عبر وسائل التواصل الاجتماعي
              
              Row
              (
                
                mainAxisAlignment: MainAxisAlignment.center,
                
                children: 
                [
                  LoginWays
                  (
                    image: 'assets/IconImage/apple15.png',
                    destinationPage: Profile(),
                  ),
                  const SizedBox(width: 20),
                  LoginWays
                  (
                    image: 'assets/IconImage/facebook (1).png',
                    destinationPage: Profile(),
                  ),
                  const SizedBox(width: 20),
                  LoginWays
                  (
                    image: 'assets/IconImage/search (2).png',
                    destinationPage: Profile(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
