import 'package:flutter/material.dart';
import 'dart:async';

import 'package:uae_pass/uae_pass.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _uaePassPlugin = UaePass();
  String? _authToken;
  String? accessToken;
  String? _error;
  String? profileDetails;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    _uaePassPlugin.setUpSandbox();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('UAE Pass example app'),
        ),
        body: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    _authToken = null;
                    accessToken = null;
                    _error = null;
                    setState(() {});

                    try {
                      accessToken = await _uaePassPlugin.signIn();
                      debugPrint("my access token11 $accessToken");
                      _authToken = await _uaePassPlugin
                          .getAccessToken(accessToken ?? "");
                      debugPrint("my auth token $_authToken");
                    } catch (e) {
                      _error = e.toString();
                    }
                    setState(() {});
                  },
                  child: const Text('Sign in'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    _authToken = null;
                    accessToken = null;
                    profileDetails = null;
                    _error = null;
                    try {
                      await _uaePassPlugin.signOut();
                    } catch (e) {
                      _error = "SignOut Fail, Error :: $e";
                    }

                    setState(() {});
                  },
                  child: const Text('Sign out'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      if (_authToken == null) {
                        _error = "ERROR :: Do SignIn first";
                        setState(() {});
                        return;
                      }

                      profileDetails =
                          await _uaePassPlugin.getProfile(_authToken ?? "");
                    } catch (e) {
                      _error = "ERROR :: $e";
                    }
                    setState(() {});
                  },
                  child: const Text('get Profile'),
                ),
                const SizedBox(height: 50),
                if (_error != null)
                  Text(
                    "$_error",
                  ),
                const SizedBox(height: 20),
                if (accessToken != null)
                  Text(
                    " access token :: $accessToken",
                    style: const TextStyle(color: Colors.red),
                  ),
                if (_authToken != null)
                  Text(
                    " auth token :: $_authToken",
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 20),
                if (profileDetails != null)
                  Text(
                    "$profileDetails",
                  ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
