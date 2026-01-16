import 'package:bodh_flutter/core/utils/snack_bar_utils.dart';
import 'package:bodh_flutter/features/auth/presentation/pages/login_page.dart';
import 'package:bodh_flutter/features/auth/presentation/state/auth_state.dart';
import 'package:bodh_flutter/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:bodh_flutter/features/auth/presentation/widgets/gradient_widget.dart';
import 'package:bodh_flutter/features/batch/presentation/view_model/batch_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confirmPassController = TextEditingController();

  String selectedCountryCode = '+977';
  String? selectedCity;

  final countryCodes = [
    {'code': '+977', 'name': 'Nepal', 'flag': '🇳🇵'},
    {'code': '+91', 'name': 'India', 'flag': '🇮🇳'},
    {'code': '+1', 'name': 'USA', 'flag': '🇺🇸'},
    {'code': '+44', 'name': 'UK', 'flag': '🇬🇧'},
  ];

  Future<void> handleSignup() async {
    if (_formKey.currentState!.validate()) {
      ref.read(authViewModelProvider.notifier).register(
            fullName: nameController.text,
            email: emailController.text,
            username: nameController.text.trim().split('@').first,
            password: passController.text,
            phoneNumber: '$selectedCountryCode${phoneController.text}',
          );
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(batchViewmodelProvider.notifier).getAllBatches();
    });
  }

  @override
  Widget build(BuildContext context) {
    final batchState = ref.watch(batchViewmodelProvider);
    final authState = ref.watch(authViewModelProvider);

    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.error) {
        SnackbarUtils.showError(
          context,
          next.errorMessage ?? 'Registration failed',
        );
      } else if (next.status == AuthStatus.registered) {
        SnackbarUtils.showSuccess(
          context,
          next.successMessage ?? 'User registered successfully', // ✅ fixed
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            height: 270,
            decoration: const BoxDecoration(color: Color(0xFF5C8CF6)),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    "Create an account",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 30,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 25),

                            _inputField(
                              "Full Name",
                              nameController,
                              validator: (v) => v!.isEmpty ? "Required" : null,
                            ),
                            const SizedBox(height: 15),

                            Row(
                              children: [
                                SizedBox(
                                  width: 120,
                                  child: DropdownButtonFormField<String>(
                                    initialValue: selectedCountryCode,
                                    decoration: const InputDecoration(
                                      labelText: "Code",
                                    ),
                                    items: countryCodes.map((country) {
                                      return DropdownMenuItem<String>(
                                        value: country['code'],
                                        child: Row(
                                          children: [
                                            Text(
                                              country['flag']!,
                                              style: const TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              country['code']!,
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedCountryCode = value!;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _inputField(
                                    "Phone",
                                    phoneController,
                                    validator: (v) =>
                                        v!.isEmpty ? "Required" : null,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),

                            _inputField(
                              "Email",
                              emailController,
                              validator: (v) => v!.isEmpty ? "Required" : null,
                            ),
                            const SizedBox(height: 15),

                            _inputField(
                              "Password",
                              passController,
                              obscure: true,
                              validator: (v) => v!.isEmpty ? "Required" : null,
                            ),
                            const SizedBox(height: 15),

                            _inputField(
                              "Confirm Password",
                              confirmPassController,
                              obscure: true,
                              validator: (v) => v != passController.text
                                  ? "Passwords do not match"
                                  : null,
                            ),
                            const SizedBox(height: 10),
                            GradientButton(
                              text: 'Signup',
                              onPressed: handleSignup,
                              isLoading: authState.status == AuthStatus.loading,
                            ),
                            const SizedBox(height: 25),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Already have an account?",
                                  style: TextStyle(fontSize: 15),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const LoginPage(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    " Login",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputField(
    String hint,
    TextEditingController controller, {
    bool obscure = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: const BorderSide(color: Colors.lightBlueAccent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(35),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}





// import 'package:bodh_flutter/app/routes/app_routes.dart';
// import 'package:bodh_flutter/core/utils/snack_bar_utils.dart';
// import 'package:bodh_flutter/features/auth/presentation/pages/login_page.dart';
// import 'package:bodh_flutter/features/auth/presentation/state/auth_state.dart';
// import 'package:bodh_flutter/features/auth/presentation/view_model/auth_view_model.dart';
// import 'package:bodh_flutter/features/auth/presentation/widgets/gradient_widget.dart';
// import 'package:bodh_flutter/features/batch/domain/entities/batch_entity.dart';
// import 'package:bodh_flutter/features/batch/presentation/state/batch_state.dart';
// import 'package:bodh_flutter/features/batch/presentation/view_model/batch_viewmodel.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class SignUpScreen extends ConsumerStatefulWidget {
//   const SignUpScreen({super.key});

//   @override  
//   ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
// }




// class _SignUpScreenState extends ConsumerState<SignUpScreen> {
//   final _formKey = GlobalKey<FormState>();

//   final nameController = TextEditingController();
//   final phoneController = TextEditingController();
//   final emailController = TextEditingController();
//   final passController = TextEditingController();
//   final confirmPassController = TextEditingController();

  
//   // final bool _isLoading=false;

//   String selectedCountryCode = '+977';
//   String? selectedCity;

//   final countryCodes = [
//     {'code': '+977', 'name': 'Nepal', 'flag': '🇳🇵'},
//     {'code': '+91', 'name': 'India', 'flag': '🇮🇳'},
//     {'code': '+1', 'name': 'USA', 'flag': '🇺🇸'},
//     {'code': '+44', 'name': 'UK', 'flag': '🇬🇧'},
//   ];





//   Future<void> handleSignup() async{
//     if(_formKey.currentState!.validate()){
//       //yeta ko data lai view model ma pass garni
//       ref.read(authViewModelProvider.notifier)
//       .register(
//       fullName: nameController.text, 
//       email: emailController.text, 
//       username: nameController.text.trim().split('@').first, 
//       password: passController.text,
//       phoneNumber: '$selectedCountryCode${phoneController.text}',
//       batchId: selectedCity,
//       );

//     }
//   }









//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     Future.microtask((){
//       ref.read(batchViewmodelProvider.notifier).getAllBatches();
//     });
    
//   }

//   @override
//   Widget build(BuildContext context) {


//     //batch state conversion
//     final batchState= ref.watch(batchViewmodelProvider);
//     //auth state 
//     final authState = ref.watch(authViewModelProvider);


//     ref.listen<AuthState>(authViewModelProvider,(previous, next){ 
//       if(next.status == AuthStatus.error){
//         SnackbarUtils.showError(context, next.errorMessage ?? 'Registration failed',

//         );
//       }else if (next.status == AuthStatus.registered){
//         //navigate to dashboard
//         SnackbarUtils.showSuccess(
//           context, 
//           next.errorMessage ?? 'Registeration Successful');
//       }

//     });
   

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Stack(
//         children: [
//           Container(
//             height: 270,
//             decoration: const BoxDecoration(color: Color(0xFF5C8CF6)),
//           ),
//           SafeArea(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 30),

//                 // Back button
//                 IconButton(
//                   icon: const Icon(Icons.arrow_back, color: Colors.white),
//                   onPressed: () => Navigator.pop(context),
//                 ),

//                 const Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 25),
//                   child: Text(
//                     "Create an account",
//                     style: TextStyle(
//                       fontSize: 28,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 40),
//                 Expanded(
//                   child: Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 24,
//                       vertical: 30,
//                     ),
//                     decoration: const BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(50),
//                         topRight: Radius.circular(50),
//                       ),
//                     ),
//                     child: SingleChildScrollView(
//                       child: Form(
//                         key: _formKey,
//                         child: Column(
//                           children: [
//                             const Text(
//                               "Sign Up",
//                               style: TextStyle(
//                                 fontSize: 28,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black87,
//                               ),
//                             ),
//                             const SizedBox(height: 25),

//                             // Full Name
//                             _inputField(
//                               "Full Name",
//                               nameController,
//                               validator: (v) =>
//                                   v!.isEmpty ? "Required" : null,
//                             ),
//                             const SizedBox(height: 15),

//                             // Phone Number with Country Code Dropdown
//                             Row(
//                               children: [
//                                 SizedBox(
//                                   width: 120,
//                                   child: DropdownButtonFormField<String>(
//                                     initialValue: selectedCountryCode,
//                                     decoration: const InputDecoration(
//                                       labelText: "Code",
//                                     ),
//                                     items: countryCodes.map((country) {
//                                       return DropdownMenuItem<String>(
//                                         value: country['code'],
//                                         child: Row(
//                                           children: [
//                                             Text(country['flag']!,
//                                                 style: const TextStyle(
//                                                     fontSize: 18)),
//                                             const SizedBox(width: 6),
//                                             Text(country['code']!,
//                                                 style: const TextStyle(
//                                                     fontSize: 14)),
//                                           ],
//                                         ),
//                                       );
//                                     }).toList(),
//                                     onChanged: (value) {
//                                       setState(() {
//                                         selectedCountryCode = value!;
//                                       });
//                                     },
//                                   ),
//                                 ),
//                                 const SizedBox(width: 12),
//                                 Expanded(
//                                   child: _inputField(
//                                     "Phone",
//                                     phoneController,
//                                     validator: (v) =>
//                                         v!.isEmpty ? "Required" : null,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 15),

//                             // City Dropdown
//                             DropdownButtonFormField<String>(
//                               initialValue: selectedCity,
//                               decoration:  InputDecoration(
//                                 labelText: "Select City",
//                                 hintText: batchState.status == BatchStatus.loading
//                                 ? 'Loading Cities...'
//                                 : 'choose your City',
//                               ),
//                               items: batchState.batches.map((batch) {
//                                 return DropdownMenuItem<String>(
//                                   value: batch.batchId,
//                                   child: Text(batch.batchName),
//                                 );
//                               }).toList(),
//                               onChanged: (value) {
//                                 setState(() {
//                                   selectedCity = value;
//                                 });
//                               },
//                               validator: (v) =>
//                                   v == null ? "Please select a city" : null,
//                             ),
//                             const SizedBox(height: 15),

//                             // Email
//                             _inputField(
//                               "Email",
//                               emailController,
//                               validator: (v) =>
//                                   v!.isEmpty ? "Required" : null,
//                             ),
//                             const SizedBox(height: 15),

//                             // Password
//                             _inputField(
//                               "Password",
//                               passController,
//                               obscure: true,
//                               validator: (v) =>
//                                   v!.isEmpty ? "Required" : null,
//                             ),
//                             const SizedBox(height: 15),

//                             // Confirm Password
//                             _inputField(
//                               "Confirm Password",
//                               confirmPassController,
//                               obscure: true,
//                               validator: (v) => v != passController.text
//                                   ? "Passwords do not match"
//                                   : null,
//                             ),
//                             const SizedBox(height: 10),
//                             GradientButton(
//                               text: 'Signup',
//                               onPressed: handleSignup,
//                               isLoading: authState.status == AuthStatus.loading,
//                               ),

//                             // Sign Up Button
                         
//                             const SizedBox(height: 25),

//                             // Login Link
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 const Text(
//                                   "Already have an account?",
//                                   style: TextStyle(fontSize: 15),
//                                 ),
//                                 GestureDetector(
//                                   onTap: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) =>
//                                             const LoginPage(),
//                                       ),
//                                     );
//                                   },
//                                   child: const Text(
//                                     " Login",
//                                     style: TextStyle(
//                                       fontSize: 15,
//                                       color: Colors.blue,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _inputField(
//     String hint,
//     TextEditingController controller, {
//     bool obscure = false,
//     String? Function(String?)? validator,
//   }) {
//     return TextFormField(
//       controller: controller,
//       obscureText: obscure,
//       validator: validator,
//       decoration: InputDecoration(
//         hintText: hint,
//         filled: true,
//         fillColor: Colors.white,
//         contentPadding:
//             const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(35),
//           borderSide: const BorderSide(color: Colors.lightBlueAccent),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(35),
//           borderSide: const BorderSide(color: Colors.blue),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(35),
//           borderSide: const BorderSide(color: Colors.red),
//         ),
//         focusedErrorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(35),
//           borderSide: const BorderSide(color: Colors.red),
//         ),
//       ),
//     );
//   }
// }