import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prefinal/models/Candidate.dart';
import 'package:prefinal/pages/Candidateresult.dart';
import 'package:prefinal/services/api.dart';

class CandidatePage extends StatefulWidget {
  static const routeName = '/CandidatePage';

  const CandidatePage({Key? key}) : super(key: key);

  @override
  _CandidatePageState createState() => _CandidatePageState();
}

class _CandidatePageState extends State<CandidatePage> {
  late Future<List<Candidate>> _futureCandidate;
var candidate;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Image.asset(
                        'assets/images/vote_hand.png',
                        width: 100.0,
                      ),
                      Text(
                        'EXIT POLL',
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      )
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                'เลือกตั้ง อบต.',
                style: TextStyle(fontSize: 30.0, color: Colors.white),
              ),
            ),
            Column(
              children: [
                Text(
                  'รายชื่อผู้สมัครรับเลือกตั้ง',
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
                Text(
                  'นายกองค์การบริหารส่วนตำบลเขาพระ',
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
                Text(
                  'อำเภอเมืองนครนายก จังหวัดนครนายก',
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              ],
            ),
            _listCandidate(context),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _handleClickFoodItem(candidate);
                      });
                    },
                    child: Text('ดูผล'),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget _listCandidate(BuildContext context) {
    return FutureBuilder<List<Candidate>>(
      // ข้อมูลจะมาจาก Future ที่ระบุให้กับ parameter นี้
      future: _futureCandidate,

      // ระบุ callback function ซึ่งใน callback นี้เราจะต้อง return widget ที่เหมาะสมออกไป
      // โดยดูจากสถานะของ Future (เช็คสถานะได้จากตัวแปร snapshot)
      builder: (context, snapshot) {
        // กรณีสถานะของ Future ยังไม่สมบูรณ์
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        // กรณีสถานะของ Future สมบูรณ์แล้ว แต่เกิด Error
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('ผิดพลาด: ${snapshot.error}'),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _futureCandidate = _loadListCandidate();
                    });
                  },
                  child: Text('RETRY'),
                ),
              ],
            ),
          );
        }

        // กรณีสถานะของ Future สมบูรณ์ และสำเร็จ
        if (snapshot.hasData) {
          var candidateList = snapshot.data;
          return ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(8.0),
            itemCount: candidateList!.length,
            itemBuilder: (BuildContext context, int index) {
              var candidate = candidateList[index];
              return Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                margin: EdgeInsets.all(8.0),
                elevation: 5.0,
                shadowColor: Colors.black.withOpacity(0.2),
                color: Colors.white.withOpacity(0.5),
                child: InkWell(
                  onTap: () => _showMaterialDialog('SUCCESS', 'บันทึกข้อมูลสำเร็จ'),
                  child: Row(
                    children: [
                      Container(
                        width: 40.0,
                        height: 40.0,
                        color: Colors.green,
                        child: Center(
                          child: Text(
                            '${candidate.candidateNumber}',
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          candidate.candidateName,
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Future<List<Candidate>> _loadListCandidate() async {
    List list = await Api().fetch('exit_poll');
    var listname = list.map((item) => Candidate.fromJson(item)).toList();
    return listname;
  }

  @override
  initState() {
    super.initState();
    _futureCandidate = _loadListCandidate();
  }

  _handleClickFoodItem(Candidate candidate) {
    Navigator.pushNamed(
      context,
      CandidateResult.routeName,
      arguments: candidate,
    );
  }

  void _showMaterialDialog(String title, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(msg, style: Theme
              .of(context)
              .textTheme
              .bodyText2),
          actions: [
            // ปุ่ม OK ใน dialog
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                // ปิด dialog
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}