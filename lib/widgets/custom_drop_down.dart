import 'package:flutter/material.dart';
import '../core/app_export.dart';

class CustomDropDown extends StatelessWidget {
CustomDropDown({
Key? key,
this.alignment,
this.width,
this.focusNode,
this.icon,
this.autofocus = true,
this.textStyle,
this.items,
this.hintText,
this.hintStyle,
this.prefix,
this.prefixConstraints,
this.suffix,
this.suffixConstraints,
this.contentPadding,
this.borderDecoration,
this.fillColor,
this.filled = false,
this.validator,
this.onChanged,
}) : super(
key: key,
);

final Alignment? alignment;

final double? width;

final FocusNode? focusNode;

final Widget? icon;

final bool? autofocus;

final TextStyle? textStyle;

final List<SelectionPopupModel>? items;

final String? hintText;

final TextStyle? hintStyle;

final Widget? prefix;

final BoxConstraints? prefixConstraints;

final Widget? suffix;

final BoxConstraints? suffixConstraints;

final EdgeInsets? contentPadding;

final InputBorder? borderDecoration;

final Color? fillColor;

final bool? filled;

final FormFieldValidator<SelectionPopupModel>? validator;

final Function(SelectionPopupModel)? onChanged;

@override
Widget build(BuildContext context) {
return alignment != null
? Align(
alignment: alignment ?? Alignment.center,
child: dropDownWidget,
)
: dropDownWidget;
}

Widget get dropDownWidget => SizedBox(
width: width ?? double.maxFinite,
child: DropdownButtonFormField<SelectionPopupModel>(
focusNode: focusNode,
icon: icon,
autofocus: autofocus!,
style: textStyle,
items: items?.map((SelectionPopupModel item) {
return DropdownMenuItem<SelectionPopupModel>(
value: item,
child: Text(
item.title,
overflow: TextOverflow.ellipsis,
style: hintStyle,
),
);
}).toList(),
decoration: decoration,
validator: validator,
onChanged: (value) {
onChanged!(value!);
},
),
);
InputDecoration get decoration => InputDecoration(
hintText: hintText ?? "",
hintStyle: hintStyle,
prefixIcon: prefix,
prefixIconConstraints: prefixConstraints,
suffixIcon: suffix,
suffixIconConstraints: suffixConstraints,
isDense: true,
contentPadding: contentPadding,
fillColor: fillColor,
filled: filled,
border: borderDecoration ?? InputBorder.none,
enabledBorder: borderDecoration ?? InputBorder.none,
focusedBorder: borderDecoration ?? InputBorder.none,
);
}

/// Extension on [CustomDropDown] to facilitate inclusion of all types of border style etc
extension DropDownStyleHelper on CustomDropDown {
static OutlineInputBorder get outlineOrangeA200 => OutlineInputBorder(
borderRadius: BorderRadius.circular(5.h),
borderSide: BorderSide(
color: appTheme.orangeA200,
width: 1,
),
);
}

