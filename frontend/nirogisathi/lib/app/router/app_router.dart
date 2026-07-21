import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/enums/app_state.dart';
import 'package:go_router/go_router.dart';

import '../../core/enums/user_role.dart';

import '../../app/di/injection.dart';
import '../../features/Splash/presentation/provider/splash_provider.dart';

import '../../features/Splash/presentation/pages/splash_screen.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/auth_selection_page.dart';
import '../../features/auth/presentation/pages/signup_name_page.dart';
import '../../features/auth/presentation/pages/signup_otp_page.dart';
import '../../features/auth/presentation/pages/signup_details_page.dart';
import '../../features/auth/presentation/pages/signup_password_page.dart';
import '../../features/auth/presentation/pages/terms_page.dart';
import '../../features/auth/presentation/pages/privacy_policy_page.dart';
import '../../features/auth/presentation/pages/forgot_mpin_page.dart';
import '../../features/auth/presentation/pages/otp_screen.dart';
import 'package:nirogisathi/features/auth/presentation/controller/auth_controller.dart';
import '../../features/auth/presentation/pages/role_selection_page.dart';
import '../../features/location/presentation/pages/location_screen.dart';
import '../../features/location/presentation/pages/add_location_screen.dart';

import '../../features/home/presentation/pages/user_home.dart';
import '../../features/home/presentation/pages/assistant_home.dart';
import '../../features/home/presentation/pages/doctor_home.dart';
import '../../features/admin/presentation/pages/admin_dashboard.dart';
import '../../features/home/presentation/pages/subscription_pack_page.dart';
import '../../features/home/presentation/pages/standard_subscription_page.dart';
import '../../features/home/presentation/pages/premium_subscription_page.dart';
import '../../features/home/presentation/pages/plan_your_day_page.dart';

// Profile Feature Pages
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/profile/presentation/pages/my_subscription_page.dart';
import '../../features/profile/presentation/pages/my_insurance_page.dart';
import '../../features/profile/presentation/pages/add_insurance_page.dart';
import '../../features/profile/presentation/pages/faq_page.dart';
import '../../features/profile/presentation/pages/contact_us_page.dart';
import '../../features/profile/presentation/pages/my_ratings_page.dart';

// Transactions Feature Pages
import '../../features/transactions/presentation/pages/transactions_screen.dart';

// Health Locker Feature Pages
import '../../features/health_locker/presentation/pages/health_locker_screen.dart';
import '../../features/health_locker/presentation/pages/prescriptions_screen.dart';
import '../../features/health_locker/presentation/pages/lab_reports_screen.dart';
import '../../features/health_locker/presentation/pages/diagnostics_screen.dart';
import '../../features/health_locker/presentation/pages/medicines_screen.dart';
import '../../features/health_locker/presentation/pages/prescription_detail_screen.dart';
import '../../features/health_locker/presentation/pages/add_prescription_screen.dart';
import '../../features/health_locker/presentation/pages/lab_report_detail_screen.dart';
import '../../features/health_locker/presentation/pages/add_lab_report_screen.dart';
import '../../features/health_locker/presentation/pages/diagnostic_detail_screen.dart';
import '../../features/health_locker/presentation/pages/add_diagnostic_screen.dart';
import '../../features/health_locker/presentation/pages/medicine_detail_screen.dart';
import '../../features/health_locker/presentation/pages/add_medicine_screen.dart';

// Orders Feature Pages
import '../../features/orders/presentation/screens/my_orders_screen.dart';

// Notifications & Cart ✅
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/cart/presentation/screens/my_cart_screen.dart';
import '../../features/cart/presentation/screens/payment_gateway_screen.dart';

// My Health Team
import '../../features/my_health_team/presentation/pages/my_health_team_page.dart';
import '../../features/my_health_team/presentation/pages/hospitals_page.dart';
import '../../features/my_health_team/presentation/pages/add_preferred_hospital_page.dart';
import '../../features/my_health_team/presentation/pages/hospital_detail_page.dart';
import '../../features/my_health_team/presentation/pages/doctors_page.dart';
import '../../features/my_health_team/presentation/pages/add_preferred_doctor_page.dart';
import '../../features/my_health_team/presentation/pages/all_doctors_page.dart';
import '../../features/my_health_team/presentation/pages/doctor_category_page.dart';
import '../../features/my_health_team/presentation/pages/doctor_detail_page.dart';
import '../../features/my_health_team/domain/entities/hospital.dart';
import '../../features/my_health_team/domain/entities/doctor.dart';

import 'router_refresh_notifier.dart';

SplashProvider get _splashProvider => getIt<SplashProvider>();

final GoRouter router = GoRouter(
  initialLocation: '/splash',
  refreshListenable: RouterRefreshNotifier([getIt<SplashProvider>()]),
  redirect: (context, state) {
    final appState = _splashProvider.state;
    final location = state.matchedLocation;

    if (appState is AppLoading) {
      return location == '/splash' ? null : '/splash';
    }

    if (appState is Unauthenticated) {
      if (location == '/auth' || 
          location == '/login' || 
          location.startsWith('/signup') ||
          location == '/terms' ||
          location == '/privacy' ||
          location == '/forgot-mpin') {
        return null;
      }
      return '/auth';
    }

    if (appState is MpinRequired) {
      if (location == '/login' || location == '/auth' || location == '/forgot-mpin') return null;
      return '/login';
    }

    if (appState is RoleSelectionRequired) {
      if (location == '/role-selection') return null;
      return '/role-selection';
    }

    if (appState is LocationPermissionRequired) {
      if (location == '/location-permission') return null;
      return '/location-permission';
    }

    if (appState is AuthenticatedWithRole) {
      final role = appState.role;
      // ✅ Fix: Redirect authenticated users away from login/auth/splash pages to their home
      if (location == '/login' || 
          location == '/auth' || 
          location == '/verify-otp' || 
          location.startsWith('/signup') ||
          location == '/splash') {
        
        switch (role) {
          case UserRole.user: return '/user-home';
          case UserRole.healthAssistant: return '/assistant-home';
          case UserRole.doctor: return '/doctor-home';
          case UserRole.admin: return '/admin-dashboard';
        }
      }

      if (location == '/role-selection') {
        switch (role) {
          case UserRole.user: return '/user-home';
          case UserRole.healthAssistant: return '/assistant-home';
          case UserRole.doctor: return '/doctor-home';
          case UserRole.admin: return '/admin-dashboard';
        }
      }
      return null;
    }

    return null;
  },
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/auth', builder: (context, state) => const AuthSelectionPage()),
    
    GoRoute(
      path: '/login', 
      builder: (context, state) {
        String? initialMobile;
        if (_splashProvider.state is MpinRequired) {
          initialMobile = (_splashProvider.state as MpinRequired).mobile;
        }
        return LoginPage(initialMobile: initialMobile);
      },
    ),

    GoRoute(path: '/signup-name', builder: (context, state) => const SignupNamePage()),
    
    GoRoute(
      path: '/signup-details',
      builder: (context, state) {
        final name = state.extra as String;
        return SignupDetailsPage(name: name);
      },
    ),
    
    GoRoute(
      path: '/signup-otp',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return SignupOtpPage(
          name: data['name'],
          mobile: data['mobile'],
          email: data['email'],
        );
      },
    ),
    
    GoRoute(
      path: '/signup-password',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        return SignupPasswordPage(
          name: data['name'],
          mobile: data['mobile'],
          email: data['email'],
          otp: data['otp'],
        );
      },
    ),

    GoRoute(path: '/terms', builder: (context, state) => const TermsPage()),
    GoRoute(path: '/privacy', builder: (context, state) => const PrivacyPolicyPage()),
    GoRoute(path: '/forgot-mpin', builder: (context, state) => const ForgotMpinPage()),
    GoRoute(
      path: '/verify-otp',
      builder: (context, state) {
        final mobile = state.extra as String;
        return ChangeNotifierProvider.value(
          value: getIt<AuthController>(),
          child: OtpScreen(mobile: mobile),
        );
      },
    ),
    
    GoRoute(
      path: '/role-selection', 
      builder: (context, state) {
        String name = "User";
        if (_splashProvider.state is RoleSelectionRequired) {
          name = (_splashProvider.state as RoleSelectionRequired).userName;
        }
        return RoleSelectionPage(userName: name);
      },
    ),

    GoRoute(path: '/location-permission', builder: (context, state) => const LocationScreen()),
    GoRoute(path: '/add-location', builder: (context, state) => const AddLocationScreen()),

    GoRoute(path: '/user-home', builder: (context, state) => const UserHome()),
    GoRoute(path: '/assistant-home', builder: (context, state) => const AssistantHome()),
    GoRoute(path: '/doctor-home', builder: (context, state) => const DoctorHome()),
    GoRoute(path: '/admin-dashboard', builder: (context, state) => const AdminDashboard()),

    // Home Sub-pages
    GoRoute(path: '/plan-your-day', builder: (context, state) => const PlanYourDayPage()),

    // Profile Sub-pages
    GoRoute(path: '/edit-profile', builder: (context, state) => const EditProfilePage()),
    GoRoute(path: '/past-transactions', builder: (context, state) => const TransactionsScreen()),
    GoRoute(path: '/orders', builder: (context, state) => const MyOrdersScreen()),
    GoRoute(path: '/subscription', builder: (context, state) => const MySubscriptionPage()),
    GoRoute(path: '/subscription-pack', builder: (context, state) => const SubscriptionPackPage()),
    GoRoute(path: '/standard-subscription', builder: (context, state) => const StandardSubscriptionPage()),
    GoRoute(path: '/premium-subscription', builder: (context, state) => const PremiumSubscriptionPage()),
    GoRoute(path: '/insurance', builder: (context, state) => const MyInsurancePage()),
    GoRoute(path: '/add-insurance', builder: (context, state) => const AddInsurancePage()),
    GoRoute(path: '/faq', builder: (context, state) => const FaqPage()),
    GoRoute(path: '/contact', builder: (context, state) => const ContactUsPage()),
    GoRoute(path: '/ratings', builder: (context, state) => const MyRatingsPage()),

    // ✅ New Features Routes
    GoRoute(path: '/notifications', builder: (context, state) => const NotificationsPage()),
    GoRoute(path: '/cart', builder: (context, state) => const MyCartScreen()),
    GoRoute(
      path: '/payment', 
      builder: (context, state) {
        final amount = state.extra as double;
        return PaymentGatewayScreen(totalAmount: amount);
      },
    ),

    GoRoute(path: '/my-health-team', builder: (context, state) => const MyHealthTeamPage()),
    GoRoute(path: '/hospitals', builder: (context, state) => const HospitalsPage()),
    GoRoute(path: '/doctor-categories', builder: (context, state) => const DoctorCategoryPage()),
    GoRoute(path: '/doctors', builder: (context, state) => const DoctorsPage()),
    GoRoute(path: '/add-preferred-hospital', builder: (context, state) => const AddPreferredHospitalPage()),
    GoRoute(path: '/add-preferred-doctor', builder: (context, state) => const AddPreferredDoctorPage()),
    GoRoute(
      path: '/all-doctors',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>? ?? {};
        return AllDoctorsPage(
          title: data['title'] ?? 'Doctors',
          category: data['category'],
        );
      },
    ),
    GoRoute(
      path: '/doctor-detail',
      builder: (context, state) {
        final doctor = state.extra as Doctor;
        return DoctorDetailPage(doctor: doctor);
      },
    ),
    GoRoute(
      path: '/hospital-detail',
      builder: (context, state) {
        final hospital = state.extra as Hospital;
        return HospitalDetailPage(hospital: hospital);
      },
    ),

    // Health Locker Routes
    GoRoute(path: '/health-locker', builder: (context, state) => const HealthLockerScreen()),
    
    GoRoute(path: '/health-locker/prescriptions', builder: (context, state) => const PrescriptionsScreen()),
    GoRoute(path: '/health-locker/prescription-detail', builder: (context, state) => const PrescriptionDetailScreen()),
    GoRoute(path: '/health-locker/add-prescription', builder: (context, state) => const AddPrescriptionScreen()),
    
    GoRoute(path: '/health-locker/lab-reports', builder: (context, state) => const LabReportsScreen()),
    GoRoute(path: '/health-locker/lab-report-detail', builder: (context, state) => const LabReportDetailScreen()),
    GoRoute(path: '/health-locker/add-lab-report', builder: (context, state) => const AddLabReportScreen()),
    
    GoRoute(path: '/health-locker/diagnostics', builder: (context, state) => const DiagnosticsScreen()),
    GoRoute(path: '/health-locker/diagnostic-detail', builder: (context, state) => const DiagnosticDetailScreen()),
    GoRoute(path: '/health-locker/add-diagnostic', builder: (context, state) => const AddDiagnosticScreen()),

    GoRoute(path: '/health-locker/medicines', builder: (context, state) => const MedicinesScreen()),
    GoRoute(path: '/health-locker/medicine-detail', builder: (context, state) => const MedicineDetailScreen()),
    GoRoute(path: '/health-locker/add-medicine', builder: (context, state) => const AddMedicineScreen()),
  ],
);
