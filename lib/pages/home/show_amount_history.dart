import 'package:due_management/config.dart';
import 'package:due_management/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ShowAmountHistory extends StatefulWidget {
  @override
  _ShowAmountHistoryState createState() => _ShowAmountHistoryState();
}

class _ShowAmountHistoryState extends State<ShowAmountHistory> {
  final int pageSize = 10;
  List<dynamic> data = [];
  bool isLoading = true;
  String userId = "";
  int currentPage = 1;
  bool hasNextPage = true;
  bool isFetchingAllData = false;
  int? amount;
  bool isFetchingAmount = true;
  String? amountError;

  ScrollController _scrollController = ScrollController();

  Future<Map<String, dynamic>> fetchAmountHistory(int page) async {
    print("fetch history");

    try {
      final response = await http.get(Uri.parse(
          'http://192.168.1.104:5000/users/$userId/showAmountHistory?page=$page&pagesize=$pageSize'));
      final responseData = json.decode(response.body);
      return responseData;
    } catch (error) {
      print("Error fetching amount history: $error");
      return {"data": [], "nextPage": null};
    }
  }

  @override
  void initState() {
    super.initState();
    loadInitialData();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> loadInitialData() async {
    int? storedUserId = await UserPreferences.getUserId();
    setState(() {
      isLoading = true;
      userId = storedUserId.toString();
    });

    final initialData = await fetchAmountHistory(currentPage);
    // print(initialData);
    setState(() {
      data = initialData['data'];
      // print(data);
      isLoading = false;
      isFetchingAmount = true;
      amount = null; // Reset amount when fetching new data
      amountError = null;
      fetchAmount(userId);
    });
  }

  Future<void> fetchAmount(String userId) async {
    try {
      final response = await http.get(Uri.parse(
          '${Config.baseUrl}users/$userId/totalAmount')); // Replace with the URL of your total amount API
      final responseData = json.decode(response.body);
      setState(() {
        amount = responseData; // Assuming response contains the total amount
        isFetchingAmount = false;
      });
    } catch (error) {
      print("Error fetching amount: $error");
      setState(() {
        amountError = error.toString();
        isFetchingAmount = false;
      });
    }
  }

  Future<void> handleLoadMore() async {
    if (isFetchingAllData) {
      return;
    }

    final nextPage = currentPage + 1;
    final newData = await fetchAmountHistory(nextPage);

    if (newData['data'].length > 0) {
      setState(() {
        data.addAll(newData['data']);
        currentPage = nextPage;
        hasNextPage = newData['nextPage'] != null;
      });
    } else {
      setState(() {
        isFetchingAllData = true;
      });
    }
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      handleLoadMore();
    }
  }

  Widget renderFooter() {
    return isFetchingAllData && isLoading
        ? Center(child: CircularProgressIndicator())
        : SizedBox();
  }

  Widget renderEmptyList() {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Text('No data available');
  }

  Widget renderItem(dynamic item) {
    print(item['createdAt']);
    final createdAtString = item['createdAt'];
    // Parse 'createdAt' to an integer

    final createdAt = DateTime.parse(createdAtString);
    final formattedDate = createdAt.toLocal();
    final formattedDateString = formattedDate.toString();
    final isLabelAddAmount = item['labelAddAmount'];
    print(isLabelAddAmount);
    final isVerifyPay = item['verifyPay'];
    final isReceivedPayment = item['receivedPayment'];

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Colors.grey))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 5), // Add margin at the bottom
            child: Text('Date: $formattedDateString',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          Text('Amount: ${item['amount']}',
              style: TextStyle(fontSize: 14, color: Colors.black)),
          Text(isLabelAddAmount ? 'Added Amount' : 'Paid Amount',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          isVerifyPay && isReceivedPayment
              ? Text('Confirmed Payment',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
              : !isLabelAddAmount
                  ? Text('Awaiting Payment Confirmation',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                  : Text('Waiting for Full Payment',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Amount History'),
      ),
      body: Column(
        children: [
          Text('Amount due is : ${amount ?? 'Fetching amount...'}'),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                if (scrollNotification is ScrollEndNotification) {
                  final metrics = scrollNotification.metrics;
                  if (metrics.atEdge && metrics.pixels != 0 && hasNextPage) {
                    handleLoadMore();
                  }
                }
                return true;
              },
              child: ListView.builder(
                controller: _scrollController,
                itemCount: data.length + 1,
                itemBuilder: (context, index) {
                  if (index < data.length) {
                    return renderItem(data[index]);
                  } else {
                    return renderFooter();
                  }
                },
                shrinkWrap: true,
              ),
            ),
          ),
          if (data.isEmpty && !isLoading) renderEmptyList(),
        ],
      ),
    );
  }
}
