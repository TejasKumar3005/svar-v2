import 'package:flutter/material.dart';

/// A section widget with a title and content, styled as a card
class ReportSection extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? icon;
  final Color? headerColor;
  final Color? backgroundColor;

  const ReportSection({
    Key? key,
    required this.title,
    required this.child,
    this.icon,
    this.headerColor,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: headerColor ?? Theme.of(context).colorScheme.primaryContainer,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
            ),
            child: Row(
              children: [
                if (icon != null) ...[
                  icon!,
                  const SizedBox(width: 8.0),
                ],
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: headerColor != null 
                        ? Colors.white 
                        : Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: child,
          ),
        ],
      ),
    );
  }
}

/// A subsection widget with a title and content
class ReportSubSection extends StatelessWidget {
  final String title;
  final Widget child;
  final Color? titleColor;

  const ReportSubSection({
    Key? key,
    required this.title,
    required this.child,
    this.titleColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: titleColor ?? Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: child,
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}

/// A field widget with a label and value
class LabeledField extends StatelessWidget {
  final String label;
  final String value;
  final bool capitalize;

  const LabeledField({
    Key? key,
    required this.label,
    required this.value,
    this.capitalize = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Expanded(
            child: Text(
              capitalize ? value.toUpperCase() : value,
              style: const TextStyle(
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A bullet point widget with text
class BulletPoint extends StatelessWidget {
  final String text;
  final Color? bulletColor;

  const BulletPoint({
    Key? key,
    required this.text,
    this.bulletColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '•',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: bulletColor ?? Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A metric card widget for displaying a single value with a label
class MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final String? unit;
  final Color? backgroundColor;
  final Color? valueColor;

  const MetricCard({
    Key? key,
    required this.label,
    required this.value,
    this.unit,
    this.backgroundColor,
    this.valueColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: valueColor ?? Theme.of(context).colorScheme.primary,
                ),
              ),
              if (unit != null)
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Text(
                    unit!,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A status chip for showing status
class StatusChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final Color? activeColor;
  final Color? inactiveColor;

  const StatusChip({
    Key? key,
    required this.label,
    this.isActive = true,
    this.activeColor,
    this.inactiveColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = isActive
        ? (activeColor ?? Theme.of(context).colorScheme.primary.withOpacity(0.1))
        : (inactiveColor ?? Colors.grey.shade200);
    
    final Color borderColor = isActive
        ? (activeColor ?? Theme.of(context).colorScheme.primary)
        : (inactiveColor ?? Colors.grey.shade400);
    
    final Color textColor = isActive
        ? (activeColor ?? Theme.of(context).colorScheme.primary)
        : (inactiveColor ?? Colors.grey.shade700);

    return Container(
      margin: const EdgeInsets.only(right: 8.0, bottom: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }
}