import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
    'acceptTerms': false
  };
  final _formKey = GlobalKey<FormState>();   //SHOULD WRAP THE METHOD WITH FORM

  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
      fit: BoxFit.cover, //fits the image to screen
      colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.25),
          BlendMode.dstATop), //background image details
      image: AssetImage('assets/background.jpg'),
    );
  }

  Widget _buildEmailTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'email', fillColor: Colors.black, filled: true),
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
          print('error in email');
          return 'Please enter a valid email';
        }
      },
      onSaved: (String value) {
        _formData['email'] = value;
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'password', fillColor: Colors.black, filled: true),
      obscureText: true,
      validator: (String value) {
        if (value.isEmpty || value.length < 5) {
          print('error in email');
          return 'Password invalid';
        }
      },
      onSaved: (String value) {
        _formData['password'] = value;
      },
    );
  }

  Widget _buildSwitchTile() {
    return SwitchListTile(
      value: _formData['acceptTerms'],
      onChanged: (bool value) {
        setState(() {
          _formData['acceptTerms'] = value;
        });
      },
      title: Text('Accept Terms'),
    );
  }

  void _submitForm(Function login) {
    if (!_formKey.currentState.validate() || !_formData['acceptTerms']) {
      print('case');
      return;
    }
    _formKey.currentState.save();
    login(_formData['email'], _formData['password']);
    Navigator.pushReplacementNamed(context, '/products');
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 768.0 ? 500.0 : deviceWidth * 0.95;
    //media Query for orientation
    return Scaffold(
      //Creates the page
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: _buildBackgroundImage(), //background image
        ),
        padding: EdgeInsets.all(10.0),
        child: Center(
          child: SingleChildScrollView(
            //  took auth fields to the center
            child: Container(
              width: targetWidth,
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    _buildEmailTextField(), //emailField
                    SizedBox(height: 10.0),
                    _buildPasswordTextField(), //passwordField
                    _buildSwitchTile(),
                    SizedBox(height: 10.0),
                    ScopedModelDescendant(builder:
                        (BuildContext context, Widget child, MainModel model) {
                      return RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        child: Text('Login'),
                        onPressed: () => _submitForm(model.login),
                      );
                    })
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
