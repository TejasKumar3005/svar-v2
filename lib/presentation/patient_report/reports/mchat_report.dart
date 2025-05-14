
import 'package:flutter/material.dart';

class MchatReport extends StatelessWidget {
  final Map<String, dynamic> data;

  const MchatReport({Key? key, required this.data}) : super(key: key);

  // Define questions and scoring rules
  static const List<Map<String, dynamic>> questions = [
    {"id": 1, "text": "If you point at something across the room, does your child look at it?", "example": "For example, if you point at a toy or an animal, does your child look at the toy or animal?", "failIf": "no"},
    {"id": 2, "text": "Have you ever wondered if your child might be deaf?", "example": "", "failIf": "yes"},
    {"id": 3, "text": "Does your child play pretend or make-believe?", "example": "For example, pretend to drink from an empty cup, pretend to talk on a phone, or pretend to feed a doll or stuffed animal?", "failIf": "no"},
    {"id": 4, "text": "Does your child like climbing on things?", "example": "For example, furniture, playground equipment, or stairs", "failIf": "no"},
    {"id": 5, "text": "Does your child make unusual finger movements near his or her eyes?", "example": "For example, does your child wiggle his or her fingers close to his or her eyes?", "failIf": "yes"},
    {"id": 6, "text": "Does your child point with one finger to ask for something or to get help?", "example": "For example, pointing to a snack or toy that is out of reach", "failIf": "no"},
    {"id": 7, "text": "Does your child point with one finger to show you something interesting?", "example": "For example, pointing to an airplane in the sky or a big truck in the road", "failIf": "no"},
    {"id": 8, "text": "Is your child interested in other children?", "example": "For example, does your child watch other children, smile at them, or go to them?", "failIf": "no"},
    {"id": 9, "text": "Does your child show you things by bringing them to you or holding them up for you to see – not to get help, but just to share?", "example": "For example, showing you a flower, a stuffed animal, or a toy truck", "failIf": "no"},
    {"id": 10, "text": "Does your child respond when you call his or her name?", "example": "For example, does he or she look up, talk or babble, or stop what he or she is doing when you call his or her name?", "failIf": "no"},
    {"id": 11, "text": "When you smile at your child, does he or she smile back at you?", "example": "", "failIf": "no"},
    {"id": 12, "text": "Does your child get upset by everyday noises?", "example": "For example, does your child scream or cry to noise such as a vacuum cleaner or loud music?", "failIf": "yes"},
    {"id": 13, "text": "Does your child walk?", "example": "", "failIf": "no"},
    {"id": 14, "text": "Does your child look you in the eye when you are talking to him or her, playing with him or her, or dressing him or her?", "example": "", "failIf": "no"},
    {"id": 15, "text": "Does your child try to copy what you do?", "example": "For example, wave bye-bye, clap, or make a funny noise when you do", "failIf": "no"},
    {"id": 16, "text": "If you turn your head to look at something, does your child look around to see what you are looking at?", "example": "", "failIf": "no"},
    {"id": 17, "text": "Does your child try to get you to watch him or her?", "example": "For example, does your child look at you for praise, or say \"look\" or \"watch me\"?", "failIf": "no"},
    {"id": 18, "text": "Does your child understand when you tell him or her to do something?", "example": "For example, if you don't point, can your child understand \"put the book on the chair\" or \"bring me the blanket\"?", "failIf": "no"},
    {"id": 19, "text": "If something new happens, does your child look at your face to see how you feel about it?", "example": "For example, if he or she hears a strange or funny noise, or sees a new toy, will he or she look at your face?", "failIf": "no"},
    {"id": 20, "text": "Does your child like movement activities?", "example": "For example, being swung or bounced on your knee", "failIf": "no"}
  ];

  // Helper function to calculate score and risk
  Map<String, dynamic> calculateMchatResult(Map<String, dynamic> answers) {
    int score = 0;
    List<int> failedItems = [];

    for (var q in questions) {
      final String answer = answers[q['text']] as String? ?? '';
      if (answer == q['failIf']) {
        score++;
        failedItems.add(q['id'] as int);
      }
    }

    String riskLevel = 'Low Risk';
    String riskColor = 'success';
    String recommendation = 'Screening negative. No further action required unless surveillance indicates risk for ASD.';

    if (score >= 8) {
      riskLevel = 'High Risk';
      riskColor = 'error';
      recommendation = 'Refer immediately for diagnostic evaluation and eligibility evaluation for early intervention.';
    } else if (score >= 3) {
      riskLevel = 'Medium Risk';
      riskColor = 'warning';
      recommendation = 'Administer the Follow-Up questions (M-CHAT-R/F) to get specific information about the responses. Refer if M-CHAT-R/F score is 2 or higher.';
    }

    return {
      'score': score,
      'riskLevel': riskLevel,
      'riskColor': riskColor,
      'recommendation': recommendation,
      'failedItems': failedItems
    };
  }

  Color getRiskColor(String riskColorString) {
    switch (riskColorString) {
      case 'error':
        return Colors.red;
      case 'warning':
        return Colors.orange;
      case 'success':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Extract answers from data
    final Map<String, dynamic> answers = data['answers'] ?? {};
    final bool hasAnswers = answers.isNotEmpty;

    // Calculate results if answers exist
    final Map<String, dynamic> result = hasAnswers
        ? calculateMchatResult(answers)
        : {
            'score': 0,
            'riskLevel': 'N/A',
            'riskColor': 'default',
            'recommendation': '',
            'failedItems': <int>[]
          };

    final int score = result['score'];
    final String riskLevel = result['riskLevel'];
    final String riskColorString = result['riskColor'];
    final String recommendation = result['recommendation'];
    final List<int> failedItems = result['failedItems'] as List<int>;
    final Color riskColor = getRiskColor(riskColorString);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                'M-CHAT-R™ Report (Modified Checklist for Autism in Toddlers, Revised)',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),

            // Summary Section
            Card(
              elevation: 1,
              margin: const EdgeInsets.only(bottom: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Screening Result',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (hasAnswers) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Total Score
                          RichText(
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: [
                                TextSpan(
                                  text: 'Total Score: ',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                TextSpan(
                                  text: '$score / ${questions.length}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Risk Level Chip
                          Row(
                            children: [
                              const Text(
                                'Risk Level: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: riskColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  riskLevel,
                                  style: TextStyle(
                                    color: riskColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '(items failed)',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Recommendation Alert
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: riskColor.withOpacity(0.1),
                          border: Border.all(color: riskColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Recommendation:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(recommendation),
                          ],
                        ),
                      ),
                    ] else ...[
                      Text(
                        'No answers recorded for scoring.',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Detailed Answers Section
            if (hasAnswers)
              Card(
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Detailed Responses',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Questions List
                      for (int i = 0; i < questions.length; i++) ...[
                        _buildQuestionItem(
                          context,
                          questions[i],
                          answers[questions[i]['text']] as String? ?? '',
                        ),
                        if (i < questions.length - 1)
                          const Divider(height: 1),
                      ],
                      // Legend
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '= Answer indicates risk (contributes to score)',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

            // No Data fallback
            if (!hasAnswers)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'No M-CHAT data available for this report.',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionItem(
    BuildContext context,
    Map<String, dynamic> question,
    String answer,
  ) {
    final bool isFail = answer == question['failIf'];
    final String example = question['example'] as String;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question text and example
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${question['id']}. ${question['text']}',
                  style: const TextStyle(fontSize: 14),
                ),
                if (example.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    example,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Answer with icon
          Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    answer.isEmpty
                        ? 'N/A'
                        : '${answer[0].toUpperCase()}${answer.substring(1)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: answer == 'yes' ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(width: 4),
                  if (answer.isNotEmpty)
                    Icon(
                      isFail
                          ? Icons.error_outline
                          : Icons.check_circle_outline,
                      color: isFail ? Colors.red : Colors.green,
                      size: 16,
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}