import 'package:splitit/models/group_members.dart';

class TransactionDetailsService {
  final List<GroupMembers> members;

  TransactionDetailsService({required this.members});

  String getMemberName(String memberId) {
    try {
      return members.firstWhere((m) => m.memberId == memberId).name;
    } catch (e) {
      return 'Unknown';
    }
  }
}
