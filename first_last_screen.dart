import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:q_and_a_mobile/blocs/blocs.dart';
import 'package:q_and_a_mobile/blocs/expert_onboarding/expert_onboarding.dart';
import 'package:q_and_a_mobile/models/que_register_expert.dart';
import 'package:q_and_a_mobile/screens/expert_onboarding/birthday_screen.dart';
import 'package:q_and_a_mobile/screens/onboarding/create_password.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

class FirstLastScreen extends StatefulWidget {
  final QueRegisterExpert user;
  // final isSavedStep - toggle on pressed to either pop or popandpushnamed

  FirstLastScreen({this.user});

  @override
  _FirstLastScreenState createState() => _FirstLastScreenState();
}

class _FirstLastScreenState extends State<FirstLastScreen> {
  static final GlobalKey<FormState> _createFullNameFormKey =
      GlobalKey<FormState>();

  String firstName;
  String lastName;
  DateTime birthday;

  @override
  void initState() {
    super.initState();
    setState(() {
      this.firstName = widget.user.firstName ?? "";
      this.lastName = widget.user.lastName ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    // sink linter rule is a bug in dart linter - https://github.com/felangel/bloc/issues/587
    final ExpertOnboardingBloc _expertOnboardingBloc =
        BlocProvider.of<ExpertOnboardingBloc>(context);

    return BlocBuilder(
        bloc: _expertOnboardingBloc,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              leading: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 16.0, 0.0, 0.0),
                child: IconButton(
                  icon: Icon(EvaIcons.arrowBack),
                  onPressed: () {
                    _createFullNameFormKey.currentState.save();
                    Navigator.pop(context);
                  },
                ),
              ),
              actions: <Widget>[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 16.0, 32.0, 0.0),
                    child: GestureDetector(
                      key: const Key('FirstLastNextButtonKey'),
                      child: Text(
                        "Next",
                        style: new TextStyle(
                          fontSize: 16.0,
                          color: Colors.tealAccent[400],
                        ),
                      ),
                      onTap: () async {
                        if (_createFullNameFormKey.currentState.validate()) {
                          _createFullNameFormKey.currentState.save();
                          _expertOnboardingBloc.add(UpdateFirstLastNameEvent(
                              firstName: firstName, lastName: lastName));

                          final result = await Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return BlocProvider.value(
                              value: _expertOnboardingBloc,
                              child: BirthdayScreen(
                                user: widget.user.copyWith(
                                  firstName: firstName,
                                  lastName: lastName,
                                  birthday: birthday,
                                ),
                              ),
                            );
                          }));

                          setState(() {
                            birthday = result;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(32.0),
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    "What's your name?",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28.0,
                        letterSpacing: -0.5,
                        color: Colors.grey[900]),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    "It will appear on your profile.",
                    style: TextStyle(fontSize: 16.0, color: Colors.grey[900]),
                  ),
                  SizedBox(
                    height: 32.0,
                  ),
                  // TODO - do we need keys for these forms?
                  Form(
                    key: _createFullNameFormKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          initialValue: firstName,
                          textCapitalization: TextCapitalization.none,
                          style: TextStyle(
                              fontSize: 16.0, color: Colors.grey[900]),
                          decoration: InputDecoration(
                            hintText: "First Name",
                            hintStyle: TextStyle(
                                fontSize: 16.0, color: Colors.grey[400]),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey[200],
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey[900],
                              ),
                            ),
                            errorStyle: TextStyle(
                              color: Colors.pinkAccent[400],
                              fontSize: 16.0,
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.pinkAccent[400],
                              ),
                            ),
                            focusedErrorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.pinkAccent[400],
                              ),
                            ),
                          ),
                          validator: (val) {
                            if (val.trim().isEmpty) {
                              return 'Enter your first name';
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) => firstName = value,
                          onSaved: (value) => firstName = value,
                        ),
                        SizedBox(
                          height: 32.0,
                        ),
                        TextFormField(
                            initialValue: lastName,
                            textCapitalization: TextCapitalization.none,
                            style: TextStyle(
                                fontSize: 16.0, color: Colors.grey[900]),
                            decoration: InputDecoration(
                              hintText: "Last Name",
                              hintStyle: TextStyle(
                                  fontSize: 16.0, color: Colors.grey[400]),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey[200],
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey[900],
                                ),
                              ),
                              errorStyle: TextStyle(
                                color: Colors.pinkAccent[400],
                                fontSize: 16.0,
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.pinkAccent[400],
                                ),
                              ),
                              focusedErrorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.pinkAccent[400],
                                ),
                              ),
                            ),
                            validator: (val) {
                              if (val.trim().isEmpty) {
                                return 'Enter your last name';
                              } else {
                                return null;
                              }
                            },
                            onChanged: (value) {
                              lastName = value;
                            },
                            onSaved: (value) {
                              lastName = value;
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
