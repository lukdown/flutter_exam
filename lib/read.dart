import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'personVo.dart';

class ReadPage extends StatelessWidget {
  const ReadPage({super.key});

  // 기본레이아웃
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("유영수"),
      ),
      body: Container(child: _ReadPage()),
    );
  }
}

// 상태변화를 감시하게 등록 시키는 클래스
class _ReadPage extends StatefulWidget {
  const _ReadPage({super.key});

  @override
  State<_ReadPage> createState() => _ReadPageState();
}

// 할일 정의 클래스(통신, 데이터적용)
class _ReadPageState extends State<_ReadPage> {
  // 변수
  late Future<PersonVo> personVoFuture;

  // 초기화 함수(1번만 실행됨)
  @override
  void initState() {
    super.initState();
  }

  // 화면그리기
  @override
  Widget build(BuildContext context) {
    // 추가코드   // 데이터 불러괴 메소드 호출
    print("initState(): 데이터 가져오기 전");
    personVoFuture = getPersonByNo();
    print("initState(): 데이터 가져오기 후");

    print("Build(): 그리기 작업");

    return FutureBuilder(
      future: personVoFuture, //Future<> 함수명, 으로 받은 데이타
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('데이터를 불러오는데 실패했습니다.'));
        } else if (!snapshot.hasData) {
          return Center(child: Text('데이터가 없습니다.'));
        } else {
          //데이터가 있으면
          // _nameController.text = snapshot.data!.name;
          return Container(
            padding: EdgeInsets.all(10),
            color: Color(0xffd6d6d6),
            child: Container(
              padding: EdgeInsets.all(10),
              color: Color(0xffffffff),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                          height: 40,
                          color: Color(0xffffffff),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${snapshot.data!.name}",
                            style: TextStyle(fontSize: 20),
                          )),
                      Container(
                          height: 40,
                          color: Color(0xffffffff),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "(${snapshot.data!.gender})",
                            style: TextStyle(fontSize: 20),
                          )),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                          width: 70,
                          height: 40,
                          color: Color(0xffffffff),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "핸드폰",
                            style: TextStyle(fontSize: 20),
                          )),
                      Container(
                          height: 40,
                          color: Color(0xffffffff),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${snapshot.data!.hp}",
                            style: TextStyle(fontSize: 20),
                          )),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                          width: 70,
                          height: 60,
                          color: Color(0xffffffff),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "회사",
                            style: TextStyle(fontSize: 20),
                          )),
                      Container(
                          height: 40,
                          color: Color(0xffffffff),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${snapshot.data!.company}",
                            style: TextStyle(fontSize: 20),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          );
        } // 데이터가있으면
      },
    );
  }

  // 3번(정우성) 데이터 가져오기 return    그림x
  Future<PersonVo> getPersonByNo() async {
    print("initState(): 데이터 가져오기 중");
    try {
      /*----요청처리-------------------*/
      //Dio 객체 생성 및 설정
      var dio = Dio();

      // 헤더설정:json으로 전송
      dio.options.headers['Content-Type'] = 'application/json';

      // 서버 요청
      final response = await dio.get(
        'http://15.164.245.216:9000/api/myclass',
      );

      /*----응답처리-------------------*/
      if (response.statusCode == 200) {
        //접속성공 200 이면
        print(response.data); // json->map 자동변경

        // print(response.data["apiData"]);
        return PersonVo.fromJson(response.data);
        //return PersonVo.fromJson(response.data["apiData"]);
      } else {
        //접속실패 404, 502등등 api서버 문제
        throw Exception('api 서버 문제');
      }
    } catch (e) {
      //예외 발생
      throw Exception('Failed to load person: $e');
    }
  }
}
