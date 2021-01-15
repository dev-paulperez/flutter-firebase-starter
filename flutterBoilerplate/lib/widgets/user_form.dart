import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/bloc/users/users_bloc.dart';
import 'package:flutterBoilerplate/bloc/users/users_event.dart';
import 'package:flutterBoilerplate/constants/strings.dart';
import 'package:flutterBoilerplate/widgets/common/responsive_button.dart';
import 'package:flutterBoilerplate/widgets/common/responsive_checkbox.dart';
import 'package:flutterBoilerplate/widgets/common/slider.dart';
import 'package:flutterBoilerplate/widgets/common/text_field_builder.dart';

class UserForm extends StatelessWidget {
  final UsersBloc bloc;

  const UserForm(this.bloc);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            TextFieldBuilder(
              labelText: AppString.name,
              stream: bloc.firstName,
              onChanged: bloc.onFirstNameChanged,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            TextFieldBuilder(
              labelText: AppString.lastName,
              stream: bloc.lastName,
              onChanged: bloc.onLastNameChanged,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            TextFieldBuilder(
              labelText: AppString.email,
              stream: bloc.email,
              onChanged: bloc.onEmailChanged,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            TextFieldBuilder(
              prefix: '+598 ',
              labelText: AppString.phone,
              stream: bloc.phone,
              onChanged: bloc.onPhoneChanged,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            TextFieldBuilder(
              labelText: AppString.address,
              stream: bloc.address,
              onChanged: bloc.onAddressChanged,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            ResponsiveSlider(
              stream: bloc.age,
              onChanged: bloc.onAgeChanged,
              max: 100,
              min: 1,
              label: AppString.age,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            ResponsiveCheckbox(
              label: AppString.admin,
              stream: bloc.isAdmin,
              onChanged: bloc.onIsAdmingChanged,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.06),
            ResponsiveButton(
              width: MediaQuery.of(context).size.width * 0.9,
              activeColorButton: Colors.white,
              disabledColorButton: Colors.grey[400],
              activeColorText: Colors.teal,
              disabledColorText: Colors.white,
              stream: bloc.activateButton,
              action: () => bloc.add(const CreateUser()),
              title: AppString.create,
            )
          ],
        ),
      );
}
