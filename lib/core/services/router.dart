import 'package:cursach_app/core/common/views/page_under_construction.dart';
import 'package:cursach_app/core/extensions/context_extension.dart';
import 'package:cursach_app/core/services/injection_container.dart';
import 'package:cursach_app/src/auth/data/models/local_user_model.dart';
import 'package:cursach_app/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:cursach_app/src/auth/presentation/views/sign_in_screen.dart';
import 'package:cursach_app/src/auth/presentation/views/sign_up_screen.dart';
import 'package:cursach_app/src/dashboard/presentation/views/dashboard.dart';
import 'package:cursach_app/src/on_boarding/data/datasources/on_boarding_local_data_source.dart';
import 'package:cursach_app/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:cursach_app/src/on_boarding/presentation/views/on_boarding_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart' as fui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'router.main.dart';
