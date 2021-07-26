import 'package:cab_driver/brand_colors.dart';
import 'package:cab_driver/dataprovider.dart';
import 'package:cab_driver/screens/historypage.dart';
import 'package:cab_driver/widgets/BrandDivider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EarningsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: BrandColors.colorPrimary,
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 70),
            child: Column(
              children: [
                Text(
                  'Total Earnings',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  '\$${Provider.of<AppData>(context).earnings}',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontFamily: 'Brand-Bold'),
                ),
              ],
            ),
          ),
        ),
        FlatButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => HistoryPage()));
          },
          padding: EdgeInsets.all(0),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 18),
            child: Row(
              children: [
                Image.asset(
                  'images/taxi.png',
                  width: 70,
                ),
                SizedBox(
                  width: 16,
                ),
                Text(
                  'Trips',
                  style: TextStyle(fontSize: 16),
                ),
                Expanded(
                  child: Container(
                    child: Text(
                      '3',
                      textAlign: TextAlign.end,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        BrandDivider(),
      ],
    );
  }
}
