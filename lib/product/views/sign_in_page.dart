import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/core_variables.dart';
import '../view_models.dart/sign_in_model.dart';
import '../widgets/custom_elevated_button.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

final TextEditingController _characterEditController = TextEditingController();

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    FocusNode focusNode = FocusNode();
    final TextEditingController _textEditingController = TextEditingController();

    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/loginbackground.jpg'), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: const Text("Sign in"),
        ),
        body: GestureDetector(
          onTap: () {
            focusNode.unfocus();
          },
          child: context.watch<SignInModel>().busy
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Select a Character",
                          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        SizedBox(
                          height: 120,
                          child: StreamBuilder<QuerySnapshot>(
                            stream: Provider.of<SignInModel>(context).getCharacters(),
                            builder: (context, snapshot) {
                              return snapshot.hasData
                                  ? GridView.builder(
                                      padding: EdgeInsets.zero,
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,

                                      //shrinkWrap: true,
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                        mainAxisSpacing: 7,
                                        crossAxisSpacing: 7,
                                        mainAxisExtent: 120,
                                        crossAxisCount: 1,
                                      ),
                                      itemCount: snapshot.data?.size,

                                      //searchTerm.isEmpty ? snapshot.data!.docs.length : 3,

                                      itemBuilder: (context, index) {
                                        _characterEditController.addListener(() {
                                          if (mounted) {
                                            setState(() {});
                                          }
                                        });
                                        return Container(
                                          height: 200,
                                          width: 200,
                                          child: IngredientWidget(
                                            imageLink: snapshot.data?.docs[index]['imageLink'],
                                          ),
                                        );
                                      },
                                    )
                                  : const Center(child: CircularProgressIndicator());
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 18,
                          ),
                          child: TextField(
                            focusNode: focusNode,
                            controller: _textEditingController,
                            style: const TextStyle(color: Colors.white),
                            cursorColor: Colors.white,
                            autofocus: false,
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                color: Colors.white,
                              )),
                              hintText: 'Select an Username',
                              hintStyle: TextStyle(color: Color.fromARGB(255, 255, 253, 253)),
                              contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                            ),
                          ),
                        ),
                        CustomElevatedButton(
                            buttonColor: Color.fromARGB(156, 23, 78, 188),
                            buttonTextStyle: FontItems.boldTextInter20,
                            buttonTitle: "Sign In",
                            buttonMetod: () => Provider.of<SignInModel>(context, listen: false)
                                .signIn(_textEditingController.text, characterList[0], context)),
                        const SizedBox(
                          height: 50,
                        )
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

List<String> characterList = [' '];

class IngredientWidget extends StatefulWidget {
  const IngredientWidget({Key? key, required this.imageLink}) : super(key: key);

  final String imageLink;

  @override
  State<IngredientWidget> createState() => _IngredientWidgetState();
}

class _IngredientWidgetState extends State<IngredientWidget> {
  @override
  Widget build(BuildContext context) {
    //Color widgetColor = ColorItems.softGreyColor;

    return SizedBox(
      width: 200,
      child: ElevatedButton(
        onPressed: () {
          characterList.clear();

          characterList.add(widget.imageLink);
          _characterEditController.text = widget.imageLink;
          if (mounted) {
            setState(() {});
          }
        },
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11.0),
          )),
          backgroundColor: characterList[0] == widget.imageLink
              ? MaterialStateProperty.all<Color>(ColorItems.generalTurquaseColor)
              : MaterialStateProperty.all<Color>(Colors.transparent),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: characterList[0] == (widget.imageLink),
                      child: const Icon(
                        Icons.check,
                        size: 15,
                      ),
                    )
                  ],
                ),
              ),
              Image(image: NetworkImage(widget.imageLink))
            ],
          ),
        ),
      ),
    );
  }
}
