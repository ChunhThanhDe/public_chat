import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:public_chat/constants/app_constants.dart';
import 'package:public_chat/features/chat/ui/public_chat_screen.dart';
import 'package:public_chat/features/login/bloc/login_cubit.dart';
import 'package:public_chat/features/login/ui/widgets/sign_in_button.dart';
import 'package:public_chat/repository/preferences_manager.dart';
import 'package:public_chat/service_locator/service_locator.dart';
import 'package:public_chat/utils/locale_support.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<LoginCubit>(
        create: (context) => LoginCubit(),
        child: const _LoginScreenBody(),
      );
}

class _LoginScreenBody extends StatefulWidget {
  const _LoginScreenBody();

  @override
  State<_LoginScreenBody> createState() => _LoginScreenBodyState();
}

class _LoginScreenBodyState extends State<_LoginScreenBody> {
  String? _userLanguage;

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final language = await PreferencesManager.instance.getLanguage();
    setState(() {
      _userLanguage = language;
    });
  }

  @override
  Widget build(BuildContext context) => BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            // open public chat screen
            // use Navigator temporary, will be changed later
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const PublicChatScreen(),
                ));
          }
        },
        builder: (context, state) {
          final loginErrorText = PreferencesManager.instance.getLanguage();

          final Widget content = state is LoginFailed
              ? Column(
                  children: [
                    Text(_userLanguage ?? AppTexts.loginErrorText),
                    buildSignInButton(
                      label: _userLanguage ?? context.locale.login,
                      onPressed: () =>
                          context.read<LoginCubit>().requestLogin(),
                    )
                  ],
                )
              : buildSignInButton(
                  label: _userLanguage ?? context.locale.login,
                  onPressed: () => context.read<LoginCubit>().requestLogin(),
                );

          return Scaffold(
            body: Center(child: content),
          );
        },
      );
}
