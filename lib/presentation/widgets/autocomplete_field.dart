import 'package:flutter/material.dart';

/// Campo de texto com autocomplete baseado no histórico.
///
/// Usa [RawAutocomplete] com um [TextEditingController] externo (controlado pelo
/// formulário), permitindo pré-preencher na edição e ler o valor no salvar.
class AutocompleteField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final List<String> options;
  final TextInputType? keyboardType;

  const AutocompleteField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.options,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return RawAutocomplete<String>(
      textEditingController: controller,
      focusNode: FocusNode(),
      optionsBuilder: (value) {
        final q = value.text.trim().toLowerCase();
        if (q.isEmpty) return const Iterable<String>.empty();
        return options.where((o) => o.toLowerCase().contains(q) && o.toLowerCase() != q);
      },
      fieldViewBuilder: (context, textController, focusNode, onSubmit) {
        return TextField(
          controller: textController,
          focusNode: focusNode,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon),
          ),
        );
      },
      optionsViewBuilder: (context, onSelected, opts) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(12),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 220, maxWidth: 400),
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: opts
                    .map((o) => ListTile(
                          dense: true,
                          title: Text(o),
                          onTap: () => onSelected(o),
                        ))
                    .toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}
