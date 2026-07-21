import '../../../../core/network/api_client.dart';
import '../models/transaction_model.dart';

abstract class TransactionRemoteDataSource {
  Future<List<TransactionModel>> getTransactions({String? type, int page = 1});
}

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final ApiClient apiClient;

  TransactionRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<TransactionModel>> getTransactions({String? type, int page = 1}) async {
    await Future.delayed(const Duration(seconds: 1));
    
    final dummyData = [
      // === APPOINTMENTS ===
      {
        "id": "TXN001",
        "title": "appointment for Gestic Problem",
        "description": "General Checkup",
        "amount": 500.0,
        "date": "2024-11-01T14:20:00Z",
        "status": "pending",
        "type": "debit",
        "category": "appointment",
        "doctorName": "Dr. Ankur Jain",
        "phoneNumber": "+91 90249 74391",
        "location": "Jaipur, Rajasthan, India",
        "placedTime": "14:20",
        "statusTime": "not confirmed"
      },
      {
        "id": "TXN004",
        "title": "Appointment with fever",
        "description": "Fever treatment",
        "amount": 800.0,
        "date": "2024-11-05T14:20:00Z",
        "status": "confirmed",
        "type": "debit",
        "category": "appointment",
        "doctorName": "Arvind Kumar Sharma",
        "phoneNumber": "+91 90249 74391",
        "location": "Jaipur, Rajasthan, India",
        "placedTime": "14:20",
        "statusTime": "Confirmed on 14:35"
      },
      {
        "id": "TXN005",
        "title": "Fill out Daily Check-Up Form.",
        "description": "Missed checkup",
        "amount": 0.0,
        "date": "2024-11-08T14:20:00Z",
        "status": "missed",
        "type": "debit",
        "category": "appointment",
        "doctorName": "Arvind Kumar Sharma",
        "phoneNumber": "+91 90249 74391",
        "location": "Jaipur, Rajasthan, India",
        "placedTime": "14:20",
        "statusTime": "Missed on 14:20"
      },

      // === PAYMENTS ===
      {
        "id": "TXN002",
        "title": "Wallet Top-up",
        "description": "Added credits to health wallet",
        "amount": 2000.0,
        "date": "2024-10-28T14:20:00Z",
        "status": "success",
        "type": "credit",
        "category": "payment",
        "doctorName": "Health Wallet",
        "phoneNumber": "Internal Transaction",
        "location": "Digital Payment",
        "placedTime": "14:20",
        "statusTime": "Success"
      },
      {
        "id": "TXN006",
        "title": "Monthly Subscription",
        "description": "Standard Health Plan",
        "amount": 240.0,
        "date": "2024-11-01T08:00:00Z",
        "status": "success",
        "type": "debit",
        "category": "payment",
        "doctorName": "Nirogi Sathi",
        "phoneNumber": "Auto-debit",
        "location": "Subscription",
        "placedTime": "08:00",
        "statusTime": "Success"
      },
      {
        "id": "TXN007",
        "title": "Pharmacy Order #1024",
        "description": "Prescription Medicines",
        "amount": 1250.0,
        "date": "2024-11-03T18:45:00Z",
        "status": "success",
        "type": "debit",
        "category": "payment",
        "doctorName": "Apollo Pharmacy",
        "phoneNumber": "+91 98765 43210",
        "location": "Delivery Address, India",
        "placedTime": "18:45",
        "statusTime": "Success"
      },

      // === OTHERS (VISITS) ===
      {
        "id": "TXN003",
        "title": "Assistant Home Visit",
        "description": "Vitals check by Anjali Ray",
        "amount": 300.0,
        "date": "2024-11-02T09:15:00Z",
        "status": "confirmed",
        "type": "debit",
        "category": "visit",
        "doctorName": "Anjali Ray (Assistant)",
        "phoneNumber": "+91 88888 77777",
        "location": "At Home",
        "placedTime": "09:15",
        "statusTime": "Visited on 09:45"
      },
      {
        "id": "TXN008",
        "title": "Yoga Trainer Session",
        "description": "Morning Wellness Session",
        "amount": 450.0,
        "date": "2024-11-04T07:00:00Z",
        "status": "confirmed",
        "type": "debit",
        "category": "visit",
        "doctorName": "Karan Singh",
        "phoneNumber": "+91 77777 66666",
        "location": "Yoga Studio",
        "placedTime": "07:00",
        "statusTime": "Completed"
      },
      {
        "id": "TXN009",
        "title": "Physiotherapy Session",
        "description": "Home Rehabilitation",
        "amount": 600.0,
        "date": "2024-11-07T11:00:00Z",
        "status": "missed",
        "type": "debit",
        "category": "visit",
        "doctorName": "Dr. Sameer",
        "phoneNumber": "+91 66666 55555",
        "location": "At Home",
        "placedTime": "11:00",
        "statusTime": "Missed"
      }
    ];

    return dummyData.map((json) => TransactionModel.fromJson(json)).toList();
  }
}
