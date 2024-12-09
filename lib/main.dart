

import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spiringintern/HistoryPage.dart';

import 'models/searchInfo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FreightRateSearch(),
    );
  }
}

class FreightRateSearch extends StatefulWidget {

  @override
  State<FreightRateSearch> createState() => _FreightRateSearchState();
}

class _FreightRateSearchState extends State<FreightRateSearch> {
  bool isSourceChecked=false;

  bool isDestinationChecked=false;
 final TextEditingController dateController=TextEditingController();
   final TextEditingController sourceCtr=TextEditingController();
  final TextEditingController descCtr=TextEditingController();
 final TextEditingController commodityController=TextEditingController();
 final TextEditingController noOfBoxes=TextEditingController();
 final TextEditingController weight=TextEditingController();
  final Dio dio = Dio();
  List<searchInfo> source = [];
  bool lcl=false;
  bool fcl=false;
  String src="";
  String desc="";
  List<searchInfo> destination = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE6EAF8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Search the best Freight Rates",
          style: GoogleFonts.roboto(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 30),
            child: OutlinedButton(
              onPressed: () {

                Navigator.push(context, MaterialPageRoute(builder: (context)=>Historypage()));

              },
              child: Text('History'),
              style: ButtonStyle(
                side: MaterialStateProperty.all(
                  BorderSide(color: Color(0xFF0139FF)),
                ),
                foregroundColor: MaterialStateProperty.all(Color(0xFF0139FF)),
              ),
            ),
          ),

        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Origin and Destination
            Row(


            children: [
            Expanded(
            child: Autocomplete<searchInfo>(
                optionsBuilder: (textEditingValue) async {
          if (textEditingValue.text.isEmpty) {
          return [];
          } else {
          source = await getPlaceDetails(textEditingValue.text);
          return source;
          }
          },
            displayStringForOption: (searchInfo option) => option.properties?.name ?? "",
            fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {




              return TextField(

                controller: textEditingController,
                focusNode: focusNode,

                onSubmitted: (value) => onFieldSubmitted(),


                decoration: InputDecoration(
                  prefixIcon: Image.asset("assets/location.png"),
                  hintText: "Origin",
                  border: OutlineInputBorder(

                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF666666)),
                  ),
                ),
              );
            },
            onSelected: (searchInfo selection) {
                  setState(() {
                    src=selection.properties!.name!;
                  });

              print('Selected: ${selection.properties!.name}');
            },
          ),
        ),
        SizedBox(width: 20,),
        Expanded(
          child: Autocomplete<searchInfo>(
            optionsBuilder: (textEditingValue) async {
              if (textEditingValue.text.isEmpty) {
                return [];
              } else {
                destination = await getPlaceDetails(textEditingValue.text);
                return destination;
              }
            },
            displayStringForOption: (searchInfo option) => option.properties?.name ?? "",
            fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
              return TextField(
                controller: textEditingController,
                focusNode: focusNode,
                onSubmitted: (value) => onFieldSubmitted(),
                decoration: InputDecoration(
                  prefixIcon: Image.asset("assets/location.png"),
                  hintText: "Destination",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF666666)),
                  ),
                ),
              );
            },
            onSelected: (searchInfo selection) {
              setState(() {
                desc=selection.properties!.name!;
              });
              print('Selected: ${selection.properties!.name}');
            },
          ),
        ),

        ],
      ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Checkbox(
                      side: BorderSide(
                        color: Color(0xFF666666)
                      ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)
                        ),

                        activeColor: Color(0xFf155EEF),
                        value: isSourceChecked, onChanged: (value) {
                      setState(() {
                        isSourceChecked=!isSourceChecked;
                      });

                    }),
                    Text("Include nearby origin ports",style: GoogleFonts.publicSans(
                      color: Color(0xFF666666)
                    ),),
                    Spacer(),
                    Checkbox(
                        side: BorderSide(
                            color: Color(0xFF666666)
                        ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)
                ),
                        activeColor: Color(0xFf155EEF),value: isDestinationChecked, onChanged: (value) {
                      setState(() {
                        isDestinationChecked=!isDestinationChecked;
                      });
                    }),
                    Text("Include nearby destination ports",style: GoogleFonts.publicSans(
                       color:  Color(0xFF666666)
                    ),),
                  ],
                ),
                SizedBox(height: 20),
                // Commodity
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: commodityController,
                        decoration: InputDecoration(
                          hintText: "Commodity",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 20,),
                    Expanded(
                      child: TextField(
                        controller: dateController,
                        decoration: InputDecoration(
                          hintText: "Cut off date",
                          
                          suffixIcon: InkWell(
                              onTap: () async{
                                final date=await  returnDate();
                                setState(() {
                                  dateController.text=date;

                                });
                              },
                              child:  Image.asset("assets/calendar.png"),),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),

                  ],
                ),
                SizedBox(height: 20),
                // Shipment Type
                Text("Shipment Type:",style: GoogleFonts.publicSans(),),
                Row(
                  children: [
                    Row(
                      children: [
                        Checkbox(
                            side: BorderSide(
                                color: Color(0xFF666666)
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)
                            ),
                            activeColor:Color(0xFF155EEF) ,

                            value: fcl, onChanged: (val){

                          setState(() {
                            fcl=val!;
                          });
                            })
                        // Radio(value: fcl, groupValue: true, onChanged: (value) {
                        //   setState(() {
                        //
                        //     fcl=!fcl;
                        //   });
                        // }),
                        , Text("FCL",style: GoogleFonts.publicSans(),),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                            side: BorderSide(
                                color: Color(0xFF666666)
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)
                            ),

                            activeColor:Color(0xFF155EEF) ,

                            value: lcl, onChanged: (val){

                          setState(() {
                            lcl=val!;
                          });
                        }),
                        Text("LCL",style: GoogleFonts.publicSans(),),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                // Container Size


                // No of Boxes and Weight
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField<String>(
                        items: [
                          DropdownMenuItem(child: Text("40' Standard",style: GoogleFonts.publicSans(),), value: "40 Standard"),
                          DropdownMenuItem(child: Text("20' Standard",style: GoogleFonts.publicSans(),), value: "20 Standard",),
                        ],
                        onChanged: (value) {},
                        decoration: InputDecoration(

                          hintText: "Container Size",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: noOfBoxes,
                        decoration: InputDecoration(
                          hintText: "No of Boxes",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: weight,
                        decoration: InputDecoration(
                          hintText: "Weight (Kg)",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Image.asset("assets/info.png"),
                    SizedBox(width: 5,),
                    Expanded(
                      child: Text("To obtain accurate rate for spot rate with guaranteed space and booking, please ensure your container count and weight per container is accurate.",style: GoogleFonts.publicSans(
                        
                        
                        color: Color(0xFF666666)
                      ),),
                    )
                  ],
                ),

                SizedBox(height: 20),
                // Container Internal Dimensions
                Text(
                  "Container Internal Dimensions:",
                  style: GoogleFonts.publicSans(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text("Length: 39.46ft\n\nWidth: 7.70\n\nftHeight: 7.84ft",style: GoogleFonts.publicSans(),),
                    SizedBox(width: 20),
                    Image.asset("assets/container.png",width: 255,height: 100,fit: BoxFit.cover,)
                    
                    
                  ],
                ),

                Spacer(),
                // Search Button
               
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    width: 120,
                    height: 33,
                    child: OutlinedButton(
                         style: ButtonStyle(
                           foregroundColor: MaterialStateProperty.all(
                             Color(0xFF0139FF)
                           ),
                           side: MaterialStateProperty.all(
                             BorderSide(
                               color:  Color(0xFF0139FF)
                             )
                           )
                         ),

                        onPressed: (){
                           Fluttertoast.showToast(msg: "SUBMITTED SUCCESSFULLY");
                           
                           print("${src}$desc${commodityController.text}${dateController.text}${fcl}$lcl${weight.text}${noOfBoxes.text}");
                           
                        }, child: Row(

                      children: [
                        Image.asset("assets/normalSearch.png"),
                        SizedBox(width: 3,),
                        Text("search",textAlign: TextAlign.center,)
                      ],
                    )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<List<searchInfo>> getPlaceDetails(String place) async {
    final response = await dio.get("https://photon.komoot.io/api/?q=$place&limit=5");
    final jsonRes = response.data;
    return (jsonRes["features"] as List).map((e) => searchInfo.fromJson(e)).toList();
  }
  Future<String> returnDate() async
  {
    final date=await showDatePickerDialog(
      context: context,
      minDate: DateTime(1995, 1, 1),
      maxDate: DateTime(2050, 12, 31),
    );

    return (date==null)?"":(date.toIso8601String().split("T")[0]);
  }
}

