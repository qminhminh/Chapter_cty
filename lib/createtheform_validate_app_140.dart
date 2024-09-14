import 'package:flutter/material.dart';

class FromCalidatetionApp extends StatelessWidget {
  const FromCalidatetionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Validation'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: FormValidationWidget(),
      ),
    );
  }
}

class FormValidationWidget extends StatefulWidget {
  const FormValidationWidget({super.key});

  @override
  _FormValidationWidgetState createState() => _FormValidationWidgetState();
}

class _FormValidationWidgetState extends State<FormValidationWidget> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _controller,
            decoration: const InputDecoration(labelText: 'Enter your notes'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Processing Data')),
                );
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
