import 'package:do_an_mobile/utils/constants/colors.dart';
import 'package:do_an_mobile/utils/constants/sizes.dart';
import 'package:do_an_mobile/widgets/custom_text_field.dart';
import 'package:do_an_mobile/widgets/gradient_button.dart';
import 'package:flutter/material.dart';

class ProfileDetailEdit extends StatefulWidget{
  const ProfileDetailEdit ({ super.key });

  @override
  State<ProfileDetailEdit> createState() => EditDetailState();
}

class EditDetailState extends State<ProfileDetailEdit> {
  final _formKey = GlobalKey<FormState>();
  
  final _firstNameController = TextEditingController(text: "Tan");
  final _lastNameController = TextEditingController(text: "Dung");
  final _emailController = TextEditingController(text: "iamvotandung26@gmail.com");
  final _phoneController = TextEditingController(text: "+84 942 084 320");
  final _dobController = TextEditingController(text: "26 Sep 2004");
  String _selectedGender = 'Male';

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: TColors.primaryBackground,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.35,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: TColors.primaryGradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: -50,
                  bottom: -50,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: TColors.light.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  top: 48,
                  left: 16,
                  right: 26,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: TColors.dark,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Text("User Details",
                        style: TextStyle(
                          color: TColors.light,
                          fontSize: TSizes.fontSizeLg,
                          fontWeight: TSizes.fontWeightBold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.15,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration:  BoxDecoration(
                          gradient: LinearGradient(colors: TColors.primaryGradient),
                          color: TColors.primaryBackground,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: TColors.light,
                            width: 4,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.asset('assets/images/avatar/profile.jpg'),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: TColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: TColors.light,
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              color: TColors.light,
                              size: TSizes.iconLg,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: TColors.light,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                        // ignore: deprecated_member_use
                        color: TColors.dark.withOpacity(0.1),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Basic Infomation",
                            style: TextStyle(
                              fontSize: TSizes.fontSizeMd,
                              fontWeight: TSizes.fontWeightBold,
                              color: TColors.dark,
                            ),
                          ),
                          SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  controller: _firstNameController,
                                  label: 'First Name',
                                  prefixIcon: Icons.person,
                                  validator: (value) {
                                    // ignore: unnecessary_null_comparison
                                    if(value!.isEmpty || value == null){
                                      return 'First Name is required';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: CustomTextField(
                                  controller: _lastNameController,
                                  label: 'Last Name',
                                  prefixIcon: Icons.person,
                                  validator: (value) {
                                    // ignore: unnecessary_null_comparison
                                    if(value!.isEmpty || value == null){
                                      return 'Last Name is required';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          CustomTextField(
                            controller: _emailController,
                            label: 'Email',
                            prefixIcon: Icons.email,
                            validator: (value) {
                              // ignore: unnecessary_null_comparison
                              if(value!.isEmpty || value == null){
                                return 'Email is required';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          CustomTextField(
                            controller: _phoneController,
                            label: 'Phone',
                            prefixIcon: Icons.phone,
                            validator: (value) {
                              // ignore: unnecessary_null_comparison
                              if(value!.isEmpty || value == null){
                                return 'Phone is required';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 24),
                          Text(
                            "Additional Information",
                            style: TextStyle(
                              fontSize: TSizes.fontSizeMd,
                              fontWeight: TSizes.fontWeightBold,
                              color: TColors.dark,
                            ),
                          ),
                          SizedBox(height: 16),
                          CustomTextField(
                            controller: _dobController,
                            label: 'Date Of Birth',
                            prefixIcon: Icons.calendar_today,
                            validator: (value) {
                              // ignore: unnecessary_null_comparison
                              if(value!.isEmpty || value == null){
                                return 'Date of Birth is required';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Gender",
                                style: TextStyle(
                                  fontSize: TSizes.fontSizeSm,
                                  color: TColors.dark,
                                ),
                              ),
                              SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    // ignore: deprecated_member_use
                                    color: TColors.dark.withOpacity(0.1),
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    RadioListTile<String>(
                                      title: Text("Male"),
                                      value: "Male",
                                      groupValue: _selectedGender,
                                      activeColor: TColors.primary,
                                      onChanged: (String? value){
                                        setState(() {
                                          _selectedGender = value!;
                                        });
                                      },
                                    ),
                                    RadioListTile<String>(
                                      title: Text("Female"),
                                      value: "Female",
                                      groupValue: _selectedGender,
                                      activeColor: TColors.primary,
                                      onChanged: (String? value){
                                        setState(() {
                                          _selectedGender = value!;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24),
                          GradientButton(
                            text: "Save changes",
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}