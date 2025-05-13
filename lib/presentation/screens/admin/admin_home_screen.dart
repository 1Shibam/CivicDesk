import 'package:cached_network_image/cached_network_image.dart';
import 'package:complaints/core/constants.dart';
import 'package:complaints/models/complaint_model.dart';
import 'package:complaints/presentation/widgets/complaint_detail_screen.dart';
import 'package:complaints/providers/all_complaints_provider.dart';
import 'package:complaints/providers/current_admin_provider.dart';
import 'package:complaints/routes/router_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AdminHomeScreen extends ConsumerStatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  ConsumerState<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends ConsumerState<AdminHomeScreen> {
  int _selectedIndex = 0;
  String _selectedFilter = 'All';
  final String emptyProfile = 'https://i.imgur.com/PcvwDlW.png';

  // Filter options
  final List<String> filterOptions = [
    'All',
    'Infrastructure',
    'Sanitation',
    'Security',
    'Other'
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _selectedFilter = 'All'; // Reset filter when changing tabs
    });
  }

  List<ComplaintModel> _getFilteredComplaints(
      List<ComplaintModel> allComplaints) {
    List<ComplaintModel> complaints;

    switch (_selectedIndex) {
      case 0: // Primary (Pending)
        complaints = allComplaints
            .where((complaint) =>
                complaint.status.toLowerCase() == 'pending' &&
                !complaint.isSpam)
            .toList();
        break;
      case 1: // Spam
        complaints =
            allComplaints.where((complaint) => complaint.isSpam).toList();
        break;
      case 2: // Approved
        complaints = allComplaints
            .where((complaint) =>
                complaint.status.toLowerCase() == 'approved' &&
                !complaint.isSpam)
            .toList();
        break;
      case 3: // Resolved
        complaints = allComplaints
            .where((complaint) =>
                complaint.status.toLowerCase() == 'resolved' &&
                !complaint.isSpam)
            .toList();
        break;
      default:
        complaints = allComplaints
            .where((complaint) =>
                complaint.status.toLowerCase() == 'pending' &&
                !complaint.isSpam)
            .toList();
    }

    if (_selectedFilter == 'All') {
      return complaints;
    } else {
      return complaints
          .where((complaint) => complaint.category == _selectedFilter)
          .toList();
    }
  }

  String _getScreenTitle() {
    switch (_selectedIndex) {
      case 0:
        return "Primary Complaints";
      case 1:
        return "Spam Reports";
      case 2:
        return "Approved Complaints";
      case 3:
        return "Resolved Complaints";
      default:
        return "Complaints";
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the allComplaintsProvider to get real-time complaints
    final complaintsAsync = ref.watch(allComplaintsProvider);

    return Scaffold(
      backgroundColor: AppColors.darkest,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: AppBar(
          elevation: 4,
          shadowColor: AppColors.darkest,
          title: Consumer(
            builder: (context, ref, child) {
              final adminProvider = ref.watch(currentAdminProvider);
              return adminProvider.when(
                data: (admin) {
                  return Text(admin.name, style: AppTextStyles.bold(20));
                },
                error: (error, stackTrace) {
                  return Text('No user', style: AppTextStyles.bold(20));
                },
                loading: () =>
                    const CircularProgressIndicator(color: AppColors.darkPink),
              );
            },
          ),
          backgroundColor: AppColors.darkBlueGrey,
          actions: [
            SizedBox(width: 12.w),
            Consumer(
              builder: (context, ref, child) {
                final currentUser = ref.watch(currentAdminProvider);
                return currentUser.when(
                  data: (admin) {
                    String url = admin.profileUrl.isEmpty
                        ? emptyProfile
                        : admin.profileUrl;
                    return GestureDetector(
                      onTap: () {
                        context.push(RouterNames.adminProfile);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: AppColors.darkPink, width: 2.w),
                        ),
                        child: CircleAvatar(
                          radius: 16.r,
                          backgroundImage: CachedNetworkImageProvider(url),
                        ),
                      ),
                    );
                  },
                  error: (error, stackTrace) => Text(
                    'Error',
                    style: AppTextStyles.bold(16),
                  ),
                  loading: () => const CircularProgressIndicator(
                      color: AppColors.darkPink),
                );
              },
            ),
            SizedBox(width: 12.w),
          ],
        ),
      ),
      body: complaintsAsync.when(
        data: (complaints) {
          final filteredComplaints = _getFilteredComplaints(complaints);

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Column(
              children: [
                SizedBox(
                  height: 16.h,
                ),
                // Filter section
                Container(
                  decoration: BoxDecoration(
                      color: AppColors.darkBlueGrey.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.r),
                          bottomLeft: Radius.circular(20.r))),
                  padding:
                      EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _getScreenTitle(),
                            style: AppTextStyles.bold(18),
                          ),
                          Text(
                            "${filteredComplaints.length} found",
                            style: AppTextStyles.regular(14,
                                color: AppColors.lightGrey),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: filterOptions.map((filter) {
                            final isSelected = _selectedFilter == filter;
                            return Padding(
                              padding: EdgeInsets.only(right: 8.w),
                              child: FilterChip(
                                label: Text(
                                  filter,
                                  style: AppTextStyles.medium(12,
                                      color: isSelected
                                          ? AppColors.textColor
                                          : AppColors.lightGrey),
                                ),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedFilter = filter;
                                  });
                                },
                                backgroundColor: AppColors.darkBlueGrey,
                                selectedColor: AppColors.darkPink,
                                checkmarkColor: AppColors.textColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.r),
                                  side: BorderSide(
                                    color: isSelected
                                        ? AppColors.darkPink
                                        : AppColors.lightGrey,
                                    width: 1.w,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                // Complaints list
                Expanded(
                  child: filteredComplaints.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64.sp,
                                color: AppColors.lightGrey,
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                "No complaints found",
                                style: AppTextStyles.medium(16,
                                    color: AppColors.lightGrey),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                "Try changing your filter",
                                style: AppTextStyles.regular(14,
                                    color: AppColors.lightGrey),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredComplaints.length,
                          itemBuilder: (context, index) {
                            final complaint = filteredComplaints[index];
                            return Container(
                              margin: EdgeInsets.only(bottom: 12.h),
                              child: _buildComplaintCard(complaint, context),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
        error: (error, stackTrace) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64.sp,
                  color: Colors.red,
                ),
                SizedBox(height: 16.h),
                Text(
                  "Error loading complaints",
                  style: AppTextStyles.medium(16, color: AppColors.lightGrey),
                ),
                SizedBox(height: 8.h),
                Text(
                  error.toString(),
                  style: AppTextStyles.regular(14, color: AppColors.lightGrey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.darkPink),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            color: AppColors.darkBlueGrey,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          selectedItemColor: AppColors.darkPink,
          unselectedItemColor: AppColors.lightGrey,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed, // Important for 4+ items
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Primary',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.warning),
              label: 'Spam',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.thumb_up),
              label: 'Approved',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.check_circle),
              label: 'Resolved',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComplaintCard(ComplaintModel complaint, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ComplaintDetailScreen(
              complaint: complaint,
              isAdmin: true,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Card(
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        color: _getCardColor(complaint),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      complaint.title,
                      style: AppTextStyles.bold(16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: _getStatusColor(complaint.status),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      complaint.status,
                      style: AppTextStyles.medium(12),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Icon(
                    _getCategoryIcon(complaint.category),
                    size: 16.sp,
                    color: AppColors.textColor.withValues(alpha: 0.8),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    complaint.category,
                    style: AppTextStyles.medium(14,
                        color: AppColors.textColor.withValues(alpha: 0.8)),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 16.sp,
                    color: AppColors.textColor.withValues(alpha: 0.8),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    complaint.userName,
                    style: AppTextStyles.regular(14,
                        color: AppColors.textColor.withValues(alpha: 0.8)),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16.sp,
                    color: AppColors.textColor.withValues(alpha: 0.8),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    _formatDate(complaint.submittedAt),
                    style: AppTextStyles.regular(14,
                        color: AppColors.textColor.withValues(alpha: 0.8)),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                complaint.description,
                style: AppTextStyles.regular(14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCardColor(ComplaintModel complaint) {
    switch (_selectedIndex) {
      case 1: // Spam
        return AppColors.darkBlueGrey;
      case 2: // Approved
        return Colors.green.shade800;
      case 3: // Resolved
        return Colors.teal.shade800;
      default: // Primary
        return AppColors.darkPinkAccent;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.amber.withValues(alpha: 0.8);
      case 'approved':
        return Colors.green.withValues(alpha: 0.8);
      case 'resolved':
        return Colors.teal.withValues(alpha: 0.8);
      case 'review':
        return Colors.orange.withValues(alpha: 0.8);
      default:
        return Colors.grey.withValues(alpha: 0.8);
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'infrastructure':
        return Icons.build;
      case 'sanitation':
        return Icons.cleaning_services;
      case 'security':
        return Icons.security;
      default:
        return Icons.help_outline;
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}
