import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:sobi/features/data/models/summary-goals_model.dart';
import 'package:sobi/features/domain/entities/sobi-goals.dart';
import 'package:sobi/features/presentation/style/typography.dart';
import 'package:go_router/go_router.dart';

import '../../provider/sobi-goals_provider.dart';
import '../../style/colors.dart';
import '../../style/typography.dart';

class SobiGoalsScreen extends StatefulWidget {
  const SobiGoalsScreen({super.key});

  @override
  State<SobiGoalsScreen> createState() => _SobiGoalsScreenState();
}

class _SobiGoalsScreenState extends State<SobiGoalsScreen> {
  final List<String> goals = [
    'Berhenti pacaran',
    'Berpakaian sesuai syariat',
    'Menghafal Alquran',
    'Tinggalkan teman toxic',
    'Lainnya',
  ];

  String? selectedGoal;
  DateTime? selectedDate;
  bool showDatePicker = false;
  bool isLocalLoading = false;
  bool _hasShownCompletedPopup = false; // <-- Tambahkan flag ini

  @override
  void initState() {
    super.initState();
    selectedGoal = null;
    selectedDate = null;
    initializeDateFormatting('id_ID', null);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<SobiGoalsProvider>(context, listen: false);
      provider.isLoading = true;
      provider.notifyListeners();
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      await provider.fetchTodayMission(date: today);
      provider.isLoading = false;
      provider.notifyListeners();

      // Cek status completed dan tampilkan pop up jika perlu
      if (provider.goalStatus == 'completed' && !_hasShownCompletedPopup) {
        _showCompletedPopup();
      }
    });
  }

  void _showDatePicker() async {
    setState(() {
      showDatePicker = true;
    });
    final now = DateTime.now();
    final picked = await showDialog<DateTime>(
      context: context,
      builder: (context) {
        DateTime tempDate = selectedDate ?? now;
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: SizedBox(
            width: 320,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
              child: StatefulBuilder(
                builder: (context, setStateDialog) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_left),
                            onPressed: () {
                              setStateDialog(() {
                                tempDate = DateTime(
                                  tempDate.year,
                                  tempDate.month - 1,
                                  tempDate.day,
                                );
                              });
                            },
                          ),
                          Text(
                            DateFormat('MMMM yyyy').format(tempDate),
                            style: AppTextStyles.heading_6_bold.copyWith(
                              color: AppColors.primary_90,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.chevron_right),
                            onPressed: () {
                              setStateDialog(() {
                                tempDate = DateTime(
                                  tempDate.year,
                                  tempDate.month + 1,
                                  tempDate.day,
                                );
                              });
                            },
                          ),
                        ],
                      ),
                      CalendarDatePicker(
                        initialDate: tempDate,
                        firstDate: DateTime(now.year, now.month, now.day),
                        lastDate: DateTime(now.year + 2),
                        onDateChanged: (date) {
                          setStateDialog(() {
                            tempDate = date;
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              // onPressed: () => Navigator.of(context).pop(),
                              onPressed: () => GoRouter.of(context).pop(),
                              style: TextButton.styleFrom(
                                backgroundColor: AppColors.default_10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Batal',
                                style: AppTextStyles.body_3_bold.copyWith(
                                  color: AppColors.primary_90,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextButton(
                              // onPressed: () => Navigator.of(context).pop(tempDate),
                              onPressed:
                                  () => GoRouter.of(context).pop(tempDate),
                              style: TextButton.styleFrom(
                                backgroundColor: AppColors.primary_50,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Pilih Tanggal',
                                style: AppTextStyles.body_3_bold.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
    setState(() {
      showDatePicker = false;
      if (picked != null) {
        selectedDate = picked;
      }
    });
  }

  void _showCompletedPopup() async {
    setState(() {
      _hasShownCompletedPopup = true;
    });
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Ilustrasi
                  Container(
                    width: 90,
                    height: 90,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFF3EFFF),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/illustration/hijrahmu_keren.png', // Ganti dengan ilustrasi sesuai desain
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Hijrahmu Keren',
                    style: AppTextStyles.heading_5_bold.copyWith(
                      color: AppColors.primary_90,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tak semua orang mampu bertahan,\ntapi kamu berhasil!!',
                    style: AppTextStyles.body_3_regular.copyWith(
                      color: AppColors.primary_90,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      // onPressed: () => Navigator.of(context).pop(),
                      onPressed: () => GoRouter.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary_50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        'Lanjutkan',
                        style: AppTextStyles.body_3_bold.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SobiGoalsProvider>(context);
    // Debug detail isi todayMissions
    for (var i = 0; i < provider.todayMissions.length; i++) {
      final m = provider.todayMissions[i];
      print(
        '[screen] todayMissions[$i]: userGoal=${m.userGoal}, dayIndex=${m.dayIndex}, missions=${m.missions}',
      );
      if (m.userGoal != null) {
        print(
          '[screen] todayMissions[$i].userGoal.status: ${m.userGoal.status}',
        );
      }
    }
    final goalStatus = provider.goalStatus;
    final goalEntity = provider.goalEntity;
    final todayMissions = provider.todayMissions;
    final error = provider.error;
    final isLoading = provider.isLoading;
    final hasActiveGoal = goalStatus == 'active';
    final isCompletedGoal = goalStatus == 'completed';
    final missionData = (todayMissions.isNotEmpty) ? todayMissions.first : null;

    // Ambil data dari mission jika ada
    // final missionData = (todayMissions.isNotEmpty) ? todayMissions.first : null;
    final mission =
        (missionData != null && missionData.missions.isNotEmpty)
            ? missionData.missions.first
            : null;

    final userGoal = missionData?.userGoal;
    final dayNumber = mission?.mission.dayNumber ?? 0;
    final focus = mission?.mission.focus ?? '';
    final category = userGoal?.goalCategory ?? selectedGoal;
    final startDate = userGoal?.startDate;
    final targetEndDate = userGoal?.targetEndDate;

    int daysLeft = 0;
    int totalDays = 0;
    if (startDate != null && targetEndDate != null && dayNumber > 0) {
      totalDays = targetEndDate.difference(startDate).inDays + 1;
      daysLeft = totalDays + 1 - dayNumber;
    }

    double progress =
        mission?.progress.completionPercentage != null
            ? (mission!.progress.completionPercentage! / 100)
            : 0.0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Sobi Goals',
          style: AppTextStyles.heading_5_bold.copyWith(
            color: AppColors.primary_90,
          ),
        ),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : error != null
              ? Center(child: Text(error))
              : hasActiveGoal && missionData != null
              ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Kiri: judul dan dropdown
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 8.0,
                                    bottom: 8.0,
                                  ),
                                  child: Text(
                                    'Fokus pada satu perubahan,\nistiqomah pada satu tujuan',
                                    style: AppTextStyles.body_3_bold.copyWith(
                                      color: AppColors.primary_90,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Dropdown (disabled)
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.default_10,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppColors.primary_30,
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: category,
                                      isExpanded: true,
                                      hint: Text(
                                        'Masukkan Target',
                                        style: AppTextStyles.body_3_regular
                                            .copyWith(
                                              color: AppColors.default_90,
                                            ),
                                      ),
                                      icon: const Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                      ),
                                      items: [
                                        DropdownMenuItem<String>(
                                          value: category,
                                          child: Text(
                                            category ?? '',
                                            style: AppTextStyles.body_3_regular
                                                .copyWith(
                                                  color: AppColors.primary_90,
                                                ),
                                          ),
                                        ),
                                      ],
                                      onChanged: null, // disable
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Kanan: Card ungu dengan sisa hari dan SVG
                          Container(
                            width: 90,
                            height: 125,
                            decoration: BoxDecoration(
                              color: AppColors.primary_50,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '$daysLeft hari tersisa',
                                  style: AppTextStyles.heading_6_bold.copyWith(
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                SvgPicture.asset(
                                  'assets/illustration/Fatimah-Senang.svg',
                                  width: 48,
                                  height: 48,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Progress section
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(color: AppColors.primary_10),
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sudah Sampai Mana?',
                            style: AppTextStyles.body_4_bold.copyWith(
                              color: AppColors.primary_90,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Bulatan slider bisa di slide dan overflow di-hide
                          ClipRect(
                            child: SizedBox(
                              height: 40,
                              width: double.infinity,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: List.generate(totalDays, (index) {
                                    // Cari previousDay dengan dayIndex == index+1
                                    final prevDay = provider.previousDays
                                        .firstWhere(
                                          (d) => d.dayIndex == index + 1,
                                          orElse:
                                              () => PreviousDayEntity(
                                                dayIndex: index + 1,
                                                isCompleted: false,
                                              ),
                                        );
                                    final isChecked = prevDay.isCompleted;
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0,
                                      ),
                                      child: CircleAvatar(
                                        radius: 16,
                                        backgroundColor: Colors.white,
                                        child:
                                            isChecked
                                                ? Icon(
                                                  Icons.check_circle,
                                                  color: AppColors.primary_30,
                                                  size: 28,
                                                )
                                                : Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color:
                                                          AppColors.primary_30,
                                                      width: 2,
                                                    ),
                                                  ),
                                                  width: 28,
                                                  height: 28,
                                                ),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Progress bar
                          Stack(
                            children: [
                              Container(
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.primary_30,
                                    width: 1,
                                  ),
                                ),
                              ),
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final barWidth =
                                      constraints.maxWidth * progress;
                                  return Stack(
                                    children: [
                                      Container(
                                        height: 24,
                                        width: barWidth,
                                        decoration: BoxDecoration(
                                          color: AppColors.primary_30,
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left:
                                            barWidth -
                                            30, // posisi bintang di ujung progress
                                        top: -6,
                                        child: Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 34, // perbesar bintang
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
                    const SizedBox(height: 18),
                    // Misi hari ini
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                      ), // ✅ padding kiri-kanan 24
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Misi Hari ini',
                            style: AppTextStyles.heading_6_bold.copyWith(
                              color: AppColors.primary_90,
                            ),
                          ),
                          Text(
                            'Fokus : $focus',
                            style: AppTextStyles.body_4_regular.copyWith(
                              color: AppColors.primary_90,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),
                    // Scrollable section hanya untuk daftar tugas
                    if (mission != null)
                      SizedBox(
                        height: 350,
                        child: Scrollbar(
                          child: ListView(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            children: [
                              ...mission.tasks.map((taskWithProgress) {
                                final task = taskWithProgress.task;
                                final progress = taskWithProgress.progress;
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: AppColors.primary_30,
                                      ),
                                    ),
                                    child: ListTile(
                                      leading: const Icon(
                                        Icons.checklist,
                                        color: AppColors.primary_30,
                                      ),
                                      title: Text(
                                        task.text,
                                        style: AppTextStyles.body_4_regular
                                            .copyWith(
                                              color: AppColors.primary_90,
                                            ),
                                      ),
                                      trailing: GestureDetector(
                                        onTap:
                                            progress.isCompleted
                                                ? null
                                                : () async {
                                                  debugPrint(
                                                    '[DEBUG] completeTask: userGoalId=${userGoal!.id}, taskId=${task.id}',
                                                  );
                                                  await provider.completeTask(
                                                    userGoal.id,
                                                    task.id,
                                                  );
                                                  await provider
                                                      .fetchTodayMission(
                                                        date: '',
                                                      );
                                                  setState(() {});
                                                },
                                        child: Icon(
                                          progress.isCompleted
                                              ? Icons.check_circle
                                              : Icons.radio_button_unchecked,
                                          color: AppColors.primary_30,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                              const SizedBox(
                                height: 32,
                              ), // agar bisa scroll sampai bawah
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),
                  ],
                ),
              )
              : isCompletedGoal
              ? FutureBuilder<SummaryGoalsEntity?>(
                future: provider.fetchSummaryData(goalEntity?.id ?? ''),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final summary = snapshot.data;
                  if (summary == null) {
                    return Center(
                      child: Text(
                        'Tidak ada data summary',
                        style: AppTextStyles.body_3_regular.copyWith(
                          color: AppColors.primary_90,
                        ),
                      ),
                    );
                  }
                  // Tampilkan summary section sesuai desain
                  return _SummarySection(
                    userGoalId: goalEntity?.id,
                    provider: provider,
                    summary: summary, // <-- tambahkan summary ke parameter
                  );
                },
              )
              : (goalStatus == null && todayMissions.isEmpty)
              ? Column(
                children: [
                  const SizedBox(height: 12),
                  // Atas: judul, dropdown, svg
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Kiri: judul dan dropdown
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 8.0,
                                  bottom: 8.0,
                                ),
                                child: Text(
                                  'Fokus pada satu perubahan,\nistiqomah pada satu tujuan',
                                  style: AppTextStyles.body_3_bold.copyWith(
                                    color: AppColors.primary_90,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Dropdown
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.default_10,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.primary_30,
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: selectedGoal,
                                    isExpanded: true,
                                    hint: Text(
                                      'Masukkan Target',
                                      style: AppTextStyles.body_3_regular
                                          .copyWith(
                                            color: AppColors.default_90,
                                          ),
                                    ),
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                    ),
                                    items:
                                        goals
                                            .map(
                                              (goal) =>
                                                  DropdownMenuItem<String>(
                                                    value: goal,
                                                    child: Text(
                                                      goal,
                                                      style: AppTextStyles
                                                          .body_3_regular
                                                          .copyWith(
                                                            color:
                                                                AppColors
                                                                    .primary_90,
                                                          ),
                                                    ),
                                                  ),
                                            )
                                            .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedGoal = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              // Tanggal atau tombol atur waktu
                              GestureDetector(
                                onTap: _showDatePicker,
                                child: Container(
                                  width: double.infinity,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: AppColors.default_10,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppColors.primary_30,
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      selectedDate == null
                                          ? 'Atur Waktu Pencapaian'
                                          : DateFormat(
                                            'd MMMM yyyy',
                                            'id_ID',
                                          ).format(selectedDate!),
                                      style: AppTextStyles.body_3_regular
                                          .copyWith(
                                            color: AppColors.primary_90,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Kanan: SVG
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 0,
                            left: 0,
                            right: 0,
                          ),
                          child: SvgPicture.asset(
                            'assets/illustration/Fatimah-semangat.svg',
                            width: 128,
                            height: 128,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Ilustrasi bawah
                  SvgPicture.asset(
                    'assets/illustration/Fatimah-Senang.svg',
                    width: 300,
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 32),
                  // Motivasi
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Waktu terbaik untuk taat adalah saat kamu memilih untuk memulainya.',
                      style: AppTextStyles.body_3_bold.copyWith(
                        color: AppColors.primary_90,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (selectedGoal != null && selectedDate != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              isLocalLoading
                                  ? null
                                  : () async {
                                    setState(() => isLocalLoading = true);
                                    final isoDate = DateFormat(
                                      'yyyy-MM-dd',
                                    ).format(selectedDate!);
                                    final storage = provider.datasource.storage;
                                    await storage.delete(key: 'goal_data');
                                    await storage.delete(key: 'goal_status');
                                    await storage.delete(key: 'summary_data');
                                    await provider.createGoal(
                                      selectedGoal!,
                                      isoDate,
                                    );
                                    await provider.fetchGoalStatusAndMission();
                                    await provider.fetchTodayMission(date: '');
                                    setState(() => isLocalLoading = false);
                                  },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary_90,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child:
                              provider.isLoading
                                  ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                  : Text(
                                    'Mulai',
                                    style: AppTextStyles.body_3_bold.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                        ),
                      ),
                    ),
                  const Spacer(),
                  const SizedBox(height: 24),
                ],
              )
              : const Center(child: Text('Tidak ada data goals')),
    );
  }
}

// Widget summary section
class _SummarySection extends StatefulWidget {
  final String? userGoalId;
  final SobiGoalsProvider provider;
  final SummaryGoalsEntity? summary; // <-- tambahkan parameter ini
  const _SummarySection({
    required this.userGoalId,
    required this.provider,
    this.summary,
  });

  @override
  State<_SummarySection> createState() => _SummarySectionState();
}

class _SummarySectionState extends State<_SummarySection> {
  bool isLoading = true;
  SummaryGoalsEntity? summary;

  final TextEditingController lessonController = TextEditingController();
  final TextEditingController hardestController = TextEditingController();
  final TextEditingController surviveController = TextEditingController();

  final List<String> changesList = [
    'Lebih tenang setelah jauh dari maksiat',
    'Punya rutinitas baru yang lebih bermanfaat',
    'Lingkaran pertemanan lebih positif dan mendukung hijrah',
    'Lebih peka terhadap dosa-dosa kecil yang dulu dianggap biasa',
    'Merasa dekat dengan Allah dan ingin terus memperbaiki diri',
  ];
  List<bool> changesChecked = List.generate(5, (_) => false);
  bool isBtnLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.summary != null) {
      // Jika summary sudah ada dari parent, gunakan langsung
      summary = widget.summary;
      _fillControllersFromSummary();
      isLoading = false;
    } else {
      _fetchSummary();
    }
  }

  Future<void> _fetchSummary() async {
    setState(() => isLoading = true);
    if (widget.userGoalId != null) {
      summary = await widget.provider.fetchSummaryData(widget.userGoalId!);
      _fillControllersFromSummary();
    }
    setState(() => isLoading = false);
  }

  void _fillControllersFromSummary() {
    if (summary != null) {
      final lines = (summary!.reflection).split('\n');
      lessonController.text = lines.isNotEmpty ? lines[0] : '';
      hardestController.text = lines.length > 1 ? lines[1] : '';
      surviveController.text = lines.length > 2 ? lines[2] : '';
      for (int i = 0; i < changesList.length; i++) {
        changesChecked[i] = summary!.selfChanges.contains(changesList[i]);
      }
    } else {
      lessonController.text = '';
      hardestController.text = '';
      surviveController.text = '';
      changesChecked = List.generate(5, (_) => false);
    }
  }

  Future<void> _submitSummary() async {
    setState(() => isBtnLoading = true);
    final selectedChanges = <String>[];
    for (int i = 0; i < changesList.length; i++) {
      if (changesChecked[i]) selectedChanges.add(changesList[i]);
    }
    final reflection = [
      lessonController.text,
      hardestController.text,
      surviveController.text,
    ];
    final userGoalId = summary?.userGoalId ?? widget.userGoalId;
    final storage = widget.provider.datasource.storage;
    await storage.delete(key: 'summary_data');
    await storage.delete(key: 'goal_data');
    await storage.delete(key: 'goal_status');
    debugPrint(
      '[DEBUG] Cleared summary_data, goal_data, goal_status from cache',
    );
    await widget.provider.postSummary(
      userGoalId: userGoalId!,
      reflection: reflection,
      selfChanges: selectedChanges,
    );
    await widget.provider.fetchGoalStatusAndMission();
    await widget.provider.fetchTodayMission(date: '');
    setState(() => isBtnLoading = false);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Jawaban berhasil disimpan')));
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    // Debug hasil summary dari provider
    debugPrint('[SCREEN] summary entity: $summary');
    debugPrint('[SCREEN] summary.totalDays: ${summary?.totalDays}');
    debugPrint('[SCREEN] summary.reflection: ${summary?.reflection}');
    debugPrint('[SCREEN] summary.selfChanges: ${summary?.selfChanges}');
    // Perbaiki logika: summary dianggap "tidak ada" hanya jika summary == null
    // Jika summary ada tapi field kosong, tetap tampilkan recap dan form
    if (summary == null) {
      return Center(
        child: Text(
          'Tidak ada data summary',
          style: AppTextStyles.body_3_regular.copyWith(
            color: AppColors.primary_90,
          ),
        ),
      );
    }
    // Jika summary ada, tampilkan recap dan form (meskipun field kosong)
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recap Perjalanan
              const SizedBox(height: 144),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 18,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recap Perjalanan',
                      style: AppTextStyles.heading_6_bold.copyWith(
                        color: AppColors.primary_90,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _SummaryCardRow(
                      label: 'Total hari diselesaikan',
                      value:
                          '${summary?.daysCompleted} / ${summary?.totalDays}',
                      shadow: true,
                    ),
                    _SummaryCardRow(
                      label: 'Jumlah kegiatan diselesaikan',
                      value:
                          '${summary?.tasksCompleted} / ${summary?.totalTasks}',
                      shadow: true,
                      borderColor: AppColors.primary_50,
                    ),
                    _SummaryCardRow(
                      label: 'Durasi waktu',
                      value: '${summary?.totalDays} hari',
                      shadow: true,
                    ),
                    const SizedBox(height: 24),
                    // Refleksi Diri
                    Text(
                      'Refleksi Diri',
                      style: AppTextStyles.heading_6_bold.copyWith(
                        color: AppColors.primary_90,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _SummaryTextField(
                      controller: lessonController,
                      label: '',
                      shadow: true,
                      hint:
                          'Meninggalkan yang dilarang itu berat, tapi ternyata hati jauh lebih tenang setelah taat.',
                    ),
                    _SummaryTextField(
                      controller: hardestController,
                      label: '',
                      shadow: true,
                      hint: 'Apa hal yang paling berat untuk kamu tinggalkan?',
                    ),
                    _SummaryTextField(
                      controller: surviveController,
                      label: '',
                      shadow: true,
                      hint: 'Apa hal yang membuat kamu bertahan?',
                    ),
                    const SizedBox(height: 24),
                    // Perubahan yang aku rasakan
                    Text(
                      'Perubahan yang aku rasakan',
                      style: AppTextStyles.heading_6_bold.copyWith(
                        color: AppColors.primary_90,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Column(
                      children: List.generate(changesList.length, (i) {
                        return _SummaryCheckboxCircle(
                          text: changesList[i],
                          checked: changesChecked[i],
                          onChanged: (val) {
                            setState(() {
                              changesChecked[i] = val;
                            });
                          },
                          shadow: true,
                        );
                      }),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 64,
                        ), // agar tombol tidak tertutup navbar
                        child: ElevatedButton(
                          onPressed: _submitSummary,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary_50,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 0,
                            shadowColor: AppColors.primary_50.withOpacity(0.3),
                          ),
                          child: Text(
                            'Simpan Jawaban',
                            style: AppTextStyles.body_3_bold.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Hero section sticky di atas
        Container(
          height: 140,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.primary_10,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary_50.withOpacity(0.5), // warna shadow
                blurRadius: 12, // seberapa lembut bayangannya
                spreadRadius: 2, // seberapa besar area bayangan
                offset: const Offset(
                  0,
                  4,
                ), // posisi bayangan (horizontal, vertical)
              ),
            ],
          ),
          child: Column(
            children: [
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform(
                      alignment: Alignment.center,
                      transform:
                          Matrix4.identity()
                            ..scale(-1.0, 1.0), // mirror horizontal
                      child: SvgPicture.asset(
                        'assets/illustration/Fatimah-semangat.svg',
                        width: 100,
                        height: 100,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'MasyaAllah! ${summary?.totalDays} Hari Hijrahmu Telah Selesai!',
                        style: AppTextStyles.heading_5_bold.copyWith(
                          color: const Color(0xFF2E2E2E),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Card row recap perjalanan dengan shadow ungu
class _SummaryCardRow extends StatelessWidget {
  final String label;
  final String value;
  final bool shadow;
  final Color borderColor;
  const _SummaryCardRow({
    required this.label,
    required this.value,
    this.shadow = false,
    this.borderColor = AppColors.primary_30,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.default_10,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow:
            shadow
                ? [
                  BoxShadow(
                    color: AppColors.primary_50.withOpacity(0.18),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
                : [],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.body_4_regular.copyWith(
              color: AppColors.primary_90,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.body_4_bold.copyWith(
              color: AppColors.primary_90,
            ),
          ),
        ],
      ),
    );
  }
}

// TextField refleksi diri dengan shadow ungu dan hint
class _SummaryTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool shadow;
  final String hint;
  const _SummaryTextField({
    required this.controller,
    required this.label,
    this.shadow = true,
    this.hint = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label.isNotEmpty)
            Text(
              label,
              style: AppTextStyles.body_4_regular.copyWith(
                color: AppColors.primary_90,
              ),
            ),
          if (label.isNotEmpty) const SizedBox(height: 4),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary_30),
              boxShadow:
                  shadow
                      ? [
                        BoxShadow(
                          color: AppColors.primary_50.withOpacity(0.18),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                      : [],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              controller: controller,
              maxLines: 2,
              maxLength: 1000,
              style: AppTextStyles.body_4_regular.copyWith(
                color: AppColors.primary_90,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                //hintstyle
                hintStyle: AppTextStyles.body_4_regular.copyWith(
                  color: AppColors.primary_90.withOpacity(0.35),
                  fontStyle: FontStyle.italic,
                ),
                counterText: '${controller.text.length}/1000',
                counterStyle: AppTextStyles.body_5_regular.copyWith(
                  color: AppColors.default_90,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                // Center the hint text
                alignLabelWithHint: true,
              ),
              textAlign: TextAlign.center,
              onChanged: (_) {
                (context as Element).markNeedsBuild();
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Checkbox lingkaran perubahan yang aku rasakan dengan shadow ungu
class _SummaryCheckboxCircle extends StatelessWidget {
  final String text;
  final bool checked;
  final ValueChanged<bool> onChanged;
  final bool shadow;
  const _SummaryCheckboxCircle({
    required this.text,
    required this.checked,
    required this.onChanged,
    this.shadow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ), // Tambahkan padding di luar card
      child: GestureDetector(
        onTap: () => onChanged(!checked),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ), // padding dalam card
          decoration: BoxDecoration(
            boxShadow:
                shadow
                    ? [
                      BoxShadow(
                        color: AppColors.primary_50.withOpacity(0.18),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                    : [],
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        checked ? AppColors.primary_50 : AppColors.primary_30,
                    width: 2,
                  ),
                  color: Colors.white,
                ),
                child: Center(
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          checked ? AppColors.primary_50 : Colors.transparent,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  text,
                  style: AppTextStyles.body_4_regular.copyWith(
                    color: AppColors.primary_90,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Radio item for summary selfChanges (for read-only display)
class _SummaryRadioItem extends StatelessWidget {
  final String text;
  final bool selected;
  const _SummaryRadioItem({required this.text, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? AppColors.primary_50 : AppColors.primary_30,
                width: 2,
              ),
              color: selected ? AppColors.primary_50 : Colors.white,
            ),
            child:
                selected
                    ? const Icon(Icons.check, color: Colors.white, size: 18)
                    : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.body_4_regular.copyWith(
                color: AppColors.primary_90,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// // Radio item for summary selfChanges (for read-only display)
// class _SummaryRadioItem extends StatelessWidget {
//   final String text;
//   final bool selected;
//   const _SummaryRadioItem({required this.text, required this.selected});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         children: [
//           Container(
//             width: 28,
//             height: 28,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               border: Border.all(
//                 color: selected ? AppColors.primary_50 : AppColors.primary_30,
//                 width: 2,
//               ),
//               color: selected ? AppColors.primary_50 : Colors.white,
//             ),
//             child:
//                 selected
//                     ? const Icon(Icons.check, color: Colors.white, size: 18)
//                     : null,
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Text(
//               text,
//               style: AppTextStyles.body_4_regular.copyWith(
//                 color: AppColors.primary_90,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//   }
// }
//   }
// }
//   }
// }
//   }
// }
//   }
// }
//   }
//
