import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';

class MyTextField extends StatefulWidget {
  final String value;
  final TextInputType keyboardType;
  final bool isInteger;
  final int? minLines;
  final int? maxLines;
  final TextAlign? textAlign;
  final Function(String) onChange;
  final String? hintText;
  final InputBorder? border;
  final EdgeInsetsGeometry? padding;
  final Color? bgColor;

  const MyTextField({
    super.key,
    required this.onChange,
    required this.value,
    this.keyboardType = TextInputType.text,
    this.isInteger = false,
    this.maxLines = 1,
    this.minLines = 1,
    this.textAlign,
    this.hintText,
    this.border,
    this.padding,
    this.bgColor,
  });

  @override
  createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.value == "0" ? "" : widget.value,
    );
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );
  }

  @override
  void didUpdateWidget(MyTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _controller.text) {
      final currentSelection = _controller.selection;
      _controller.text = widget.value == "0" ? "" : widget.value;
      if (currentSelection.isValid &&
          currentSelection.baseOffset <= _controller.text.length) {
        _controller.selection = currentSelection;
      } else {
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<TextInputFormatter> inputFormatters = [];

    if (widget.isInteger) {
      inputFormatters.add(
        FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*$')),
      );
    }

    return TextField(
      controller: _controller,
      textAlign: widget.textAlign ?? TextAlign.start,
      keyboardType: widget.keyboardType,
      inputFormatters: inputFormatters.isEmpty ? null : inputFormatters,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      style: TextStyle(
        color: Colors.black,
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText ?? 'Input...',
        hintStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: const Color(0xFFCECECE),
        ),
        contentPadding: widget.padding ?? EdgeInsets.zero,
        border: widget.border ?? InputBorder.none,
        enabledBorder: widget.border ?? InputBorder.none,
        focusedBorder: widget.border ?? InputBorder.none,
        filled: widget.bgColor != null,
        fillColor: widget.bgColor ?? Colors.transparent,
      ),
      onChanged: (v) => widget.onChange.call(v),
    );
  }
}
