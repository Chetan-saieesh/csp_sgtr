import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_provider.dart';
import '../services/supabase_service.dart';
import '../models/user_model.dart';
import '../models/report_model.dart';

class AuthorityDashboard extends StatefulWidget {
  const AuthorityDashboard({super.key});

  @override
  State<AuthorityDashboard> createState() => _AuthorityDashboardState();
}

class _AuthorityDashboardState extends State<AuthorityDashboard> {
  List<UserModel> _teachers = [];
  List<ReportModel> _reports = [];
  String? _selectedTeacherId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadTeachers();
    _loadReports();
  }

  Future<void> _loadTeachers() async {
    final user = Provider.of<AppProvider>(context, listen: false).currentUser;
    if (user != null) {
      setState(() => _isLoading = true);
      final teachers = await SupabaseService.getTeachersByAuthority(user.id);
      setState(() {
        _teachers = teachers;
        _isLoading = false;
      });
    }
  }

  Future<void> _loadReports() async {
    final user = Provider.of<AppProvider>(context, listen: false).currentUser;
    if (user != null) {
      setState(() => _isLoading = true);
      final reports = await SupabaseService.getReportsByAuthority(user.id);
      setState(() {
        _reports = reports;
        _isLoading = false;
      });
    }
  }

  Future<void> _filterReportsByTeacher(String? teacherId) async {
    setState(() {
      _selectedTeacherId = teacherId;
      _isLoading = true;
    });

    final user = Provider.of<AppProvider>(context, listen: false).currentUser;
    if (user != null) {
      List<ReportModel> reports;
      if (teacherId == null) {
        reports = await SupabaseService.getReportsByAuthority(user.id);
      } else {
        reports = await SupabaseService.getReportsByTeacher(teacherId);
      }
      setState(() {
        _reports = reports;
        _isLoading = false;
      });
    }
  }

  Future<void> _updateReportStatus(String reportId, String status) async {
    final success = await SupabaseService.updateReportStatus(reportId, status);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(status == 'viewed' ? 'రిపోర్ట్ వీక్షించబడింది' : 'స్థితి నవీకరించబడింది'),
          backgroundColor: Colors.green,
        ),
      );
      _loadReports();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppProvider>(context).currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('అథారిటీ డాష్బోర్డ్'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                user?.name ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _loadTeachers();
              _loadReports();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AppProvider>(context, listen: false).logout();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.grey.shade100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'టీచర్లు',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          title: const Text('అన్ని టీచర్లు'),
                          selected: _selectedTeacherId == null,
                          onTap: () => _filterReportsByTeacher(null),
                        ),
                        Expanded(
                          child: _teachers.isEmpty
                              ? const Center(
                                  child: Text('ఎటువంటి టీచర్ లేదు'),
                                )
                              : ListView.builder(
                                  itemCount: _teachers.length,
                                  itemBuilder: (context, index) {
                                    final teacher = _teachers[index];
                                    return ListTile(
                                      title: Text(teacher.name),
                                      subtitle: Text(teacher.email),
                                      selected: _selectedTeacherId == teacher.id,
                                      onTap: () =>
                                          _filterReportsByTeacher(teacher.id),
                                    );
                                  },
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'మొత్తం టీచర్లు: ${_teachers.length}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(
                  flex: 2,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'సమర్పించిన రిపోర్ట్లు',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Chip(
                              label: Text(
                                'మొత్తం: ${_reports.length}',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              backgroundColor: Colors.blue.shade100,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _reports.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.description_outlined,
                                      size: 64,
                                      color: Colors.grey.shade400,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'ఎటువంటి రిపోర్ట్ లేదు',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            color: Colors.grey.shade600,
                                          ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _reports.length,
                                itemBuilder: (context, index) {
                                  final report = _reports[index];
                                  return Card(
                                    margin: const EdgeInsets.only(bottom: 16),
                                    elevation: 4,
                                    child: ExpansionTile(
                                      leading: CircleAvatar(
                                        backgroundColor: report.status == 'viewed'
                                            ? Colors.green
                                            : Colors.orange,
                                        child: Icon(
                                          report.status == 'viewed'
                                              ? Icons.check
                                              : Icons.pending,
                                          color: Colors.white,
                                        ),
                                      ),
                                      title: Text(
                                        report.teacherName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${DateFormat('yyyy-MM-dd').format(report.fromDate)} - ${DateFormat('yyyy-MM-dd').format(report.toDate)}',
                                          ),
                                          Text(
                                            'సమర్పించిన తేదీ: ${DateFormat('yyyy-MM-dd HH:mm').format(report.submittedAt)}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      trailing: report.status != 'viewed'
                                          ? IconButton(
                                              icon: const Icon(Icons.check_circle),
                                              color: Colors.green,
                                              onPressed: () =>
                                                  _updateReportStatus(
                                                    report.id,
                                                    'viewed',
                                                  ),
                                            )
                                          : null,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              const Text(
                                                'గ్రోసరీ వివరాలు:',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const SizedBox(height: 16),
                                              Table(
                                                border: TableBorder.all(
                                                  color: Colors.grey.shade300,
                                                ),
                                                children: [
                                                  TableRow(
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey.shade200,
                                                    ),
                                                    children: const [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: Text(
                                                          'గ్రోసరీ పేరు',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: Text(
                                                          'మొత్తం పరిమాణం',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  ...report.groceryItems.map(
                                                    (item) {
                                                      return TableRow(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                              item.groceryName,
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                              '${item.totalQuantity} ${item.unit}',
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
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

