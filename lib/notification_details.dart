import 'package:flutter/material.dart';
import 'package:push_image_notification/models/notification.dart';

class NotificationDetailsScreen extends StatelessWidget {
  final NotificationModel notificationModel;

  const NotificationDetailsScreen(this.notificationModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          notificationModel.title,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: notificationModel.imageUrl != null,
                child: Image.network(
                  notificationModel.imageUrl != null
                      ? notificationModel.imageUrl!
                      : '',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                notificationModel.details,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
