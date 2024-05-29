import 'package:flutter/material.dart';
import 'user_details_page.dart';
import 'sign_up_page.dart';

class PatientLoginScreen extends StatefulWidget {
  @override
  _PatientLoginScreenState createState() => _PatientLoginScreenState();
}

class _PatientLoginScreenState extends State<PatientLoginScreen> {
  final Map<String, Map<String, dynamic>> users = {
    'user1': {
      'password': '123',
      'name': 'Sam',
      'age': '30',
      'gender': 'Male',
      'maritalStatus': 'Single',
      'occupation': 'Engineer',
      'alcohol': false,
      'smoke': false,
    },
    'user2': {
      'password': 'password2',
      'name': 'Jane Smith',
      'age': '25',
      'gender': 'Female',
      'maritalStatus': 'Married',
      'occupation': 'Doctor',
      'alcohol': true,
      'smoke': false,
    },
    // Add more default usernames and details here
  };

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String _errorMessage = '';
  String _loggedInUser = '';

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + mediaQuery.size.height * 0.03125), // Original height + 2 inch
        child: AppBar(
          title: Text('Patient Login'),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.indigo[900]!,
                  Colors.indigo[500]!,
                  Colors.indigo[100]!,
                  Colors.white,
                ],
              ),
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.white, // Middle section should be plain white
        child: Padding(
          padding: EdgeInsets.all(mediaQuery.size.height * 0.025),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: mediaQuery.size.width * 0.8,
                child: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    prefixIcon: Icon(Icons.person),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(mediaQuery.size.height * 0.015625), // 12.0
                    ),
                  ),
                ),
              ),
              SizedBox(height: mediaQuery.size.height * 0.025),
              Container(
                width: mediaQuery.size.width * 0.8,
                child: TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(mediaQuery.size.height * 0.015625), // 12.0
                    ),
                  ),
                  obscureText: true,
                ),
              ),
              SizedBox(height: mediaQuery.size.height * 0.025),
              Container(
                width: mediaQuery.size.width * 0.8,
                child: ElevatedButton(
                  onPressed: _login,
                  child: Text('Login'),
                ),
              ),
              SizedBox(height: mediaQuery.size.height * 0.0125),
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
              SizedBox(height: mediaQuery.size.height * 0.025),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: _forgotPassword,
                    child: Text('Forgot Password?'),
                    style: TextButton.styleFrom(foregroundColor: Colors.indigo[700]),
                  ),
                  Text('|', style: TextStyle(color: Colors.black)),
                  TextButton(
                    onPressed: _signUp,
                    child: Text('Sign Up'),
                    style: TextButton.styleFrom(foregroundColor: Colors.indigo[700]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: mediaQuery.size.height * 0.1,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.indigo[100]!,
              Colors.indigo[500]!,
              Colors.indigo[900]!,
            ],
          ),
        ),
      ),
    );
  }

  void _login() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (users.containsKey(username) && users[username]!['password'] == password) {
      setState(() {
        _loggedInUser = username;
      });

      // Navigate to next page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserDetailsPage(
            username: username,
            name: users[username]!['name']!,
            age: users[username]!['age']!,
            gender: users[username]!['gender']!,
            maritalStatus: users[username]!['maritalStatus']!,
            alcohol: users[username]!['alcohol']!,
            smoke: users[username]!['smoke']!,
          ),
        ),
      );
    } else {
      setState(() {
        _errorMessage = 'Wrong username or password.';
      });
    }
  }

  void _forgotPassword() {
    // Implement forgot password functionality
    print('Forgot Password');
  }

  void _signUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpPage()),
    );
  }
}
