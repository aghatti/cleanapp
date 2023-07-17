
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tasks_repository/tasks_repository.dart';
import 'common_widgets/customappbar.dart';
import 'utils/utils.dart';
import 'package:user_repository/user_repository.dart';

class TaskPage extends StatefulWidget {
  TaskPage({super.key, required this.task, required this.par});

  Task task = Task.empty;
  String par = '';

  @override
  State<TaskPage> createState() => _TaskPageState();
}



class _TaskPageState extends State<TaskPage> {
  UserRepository _userRepo = UserRepository();
  User _usr = User.empty;
  Color statusBg = Color(0xFFEBE8FB);
  Color statusColor = Color(0xFF0B1F33);
  IconData statusIcon = Icons.drafts_outlined;

  final List<PhotoItem> _items = [
    PhotoItem(
        "assets/photos/photo1.png",
        "photo1"),
    PhotoItem(
        "assets/photos/photo2.png",
        "photo2"),
  ];

  @override
  void initState() {
    _userRepo.getUser().then(
            (User usr) => setState(() {
          _usr = usr;
        })
    );
    if(!widget.task.isEmpty()) {
      switch(widget.task.tStatus) {
        case 'не выполнено':
          statusBg = Color(0xFFEBE8FB);
          statusColor = Color(0xFF0B1F33);
          statusIcon = Icons.check_box_outline_blank;
          break;
        case 'начато':
          statusBg = Color(0xFF85C3FF);
          statusColor = Colors.white;
          statusIcon = Icons.update_outlined;
          break;
        case 'завершено':
          statusBg = Color(0xFF9FA6AD);
          statusColor = Colors.white;
          statusIcon = Icons.check_box_outlined;
          break;
        case 'отменено':
          statusBg = Color(0xFFDC0000);
          statusColor = Colors.white;
          statusIcon = Icons.cancel_outlined;
          break;
        case 'ожидание':
          statusBg = Color(0xFFFF8585);
          statusColor = Colors.white;
          statusIcon = Icons.pending_outlined;
          break;

      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(autoLeading: true, context: context),
      body:
    //Expanded(child:
    Column(
    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      // OLD CARD
      Visibility(
        visible: false,
        child:
      Card(
        clipBehavior: Clip.antiAlias,
        shadowColor: Colors.black,
        elevation: 0,
        child: Column(
            children: [
              Container(
                color: this.statusBg,
                constraints: BoxConstraints(minHeight: 100),
                child:
                    Padding(
                      padding: EdgeInsets.all(16),
                      child:
              Row(
                children: [
                  SizedBox(height: 10),
                  //Text(Utils.getTimeFromDate(task.tDate), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  Text(Utils.getTimeFromDate(widget.task.tDate),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: this.statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child:
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child:
                  Text(widget.task.tName,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: this.statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ),
                  ),
                  Icon(statusIcon,
                  color: statusColor),
                ],
              ),
                    ),
              ),
            ]
        ),
      ),),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 0),
        child:Container(
          color: this.statusBg,
          constraints: BoxConstraints(minHeight: 80),
          child: Padding(
            padding: EdgeInsets.all(16),
            child:
            Row(
                children: [
                  Text(Utils.getTimeFromDate(widget.task.tDate),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: this.statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  //SizedBox(width: 16),
          Expanded(
            child:
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child:
                  Text(widget.task.tName,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: this.statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            ),),
                  Icon(statusIcon,
                      color: statusColor),
                ]
            ),),),
      ),
      SizedBox(height: 15),

      Expanded(
            child:
          CustomScrollView(
            shrinkWrap: true,
              slivers: [
              SliverFillRemaining(
              hasScrollBody: false,
              child:
                  Column(
    children: [
      Visibility(
        visible: widget.task.tStatus=='завершено',
        child:
      Padding(
        padding: EdgeInsets.all(16),
        child:
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.access_time_outlined, color: Color(0xFF85C3FF),),
            SizedBox(width: 16),
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Text(AppLocalizations.of(context)!.leadTime, style: TextStyle(fontWeight: FontWeight.bold),),
              Text(Utils.getTimeFromDate(widget.task.tDate) + ' - ' + Utils.getTimeFromDate(widget.task.tDate.add(Duration(minutes: 15)))),
            ]),
          ],
        ),
      ),
      ),
      Visibility(
          visible: widget.task.tStatus=='завершено',
          child:
          Divider(thickness: 1, height: 1, color: Color(0xFFC2E1FF), indent: 16, endIndent: 16,),
      ),
      Padding(
        padding: EdgeInsets.all(16),
        child:
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.location_pin, size: 28, color: Color(0xFF85C3FF),),
            SizedBox(width: 16),
            Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.of(context)!.location, style: TextStyle(fontWeight: FontWeight.bold),),
              Text(widget.task.tAddress + '\n' + widget.task.tZone),
              ],),
          ],
        ),
      ),
      Divider(thickness: 1, height: 1, color: Color(0xFFC2E1FF), indent: 16, endIndent: 16,),
      Padding(
        padding: EdgeInsets.all(16),
        child:
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.person_outline, size: 28, color: Color(0xFF85C3FF),),
            SizedBox(width: 16),
          Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.performer, style: TextStyle(fontWeight: FontWeight.bold),),
            Text(_usr!.uName.toString() + ' ' + _usr!.uSurname.toString()),
            ],),
          ],
        ),
      ),
      Divider(thickness: 1, height: 1, color: Color(0xFFC2E1FF), indent: 16, endIndent: 16,),
          Padding(
              padding: EdgeInsets.all(16),
              child:
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.description, size: 28, color: Color(0xFF85C3FF),),
          SizedBox(width: 16),

          Flexible(child:
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text(AppLocalizations.of(context)!.description, style: TextStyle(fontWeight: FontWeight.bold),),
          Text(widget.task.tDesc),
            ],),
          ),
        ],
      ),
          ),
      Divider(thickness: 1, height: 1, color: Color(0xFFC2E1FF), indent: 16, endIndent: 16,),
      Padding(
        padding: EdgeInsets.all(16),
        child:
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.view_cozy_rounded, size: 28, color: Color(0xFF85C3FF),),
            SizedBox(width: 16),

            Flexible(child:
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(AppLocalizations.of(context)!.photos, style: TextStyle(fontWeight: FontWeight.bold),),
                SizedBox(height: 8),
                // TODO show miniatures
                Wrap(
                  children: [
                    Padding(padding: EdgeInsets.all(5),
                    child:
                    Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(),
                        child: FittedBox(
                          child: Image.asset('assets/photos/photo2.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),),
                    Padding(padding: EdgeInsets.all(5),
                      child:
                      Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(),
                          child: FittedBox(
                            child: Image.asset('assets/photos/photo1.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),),
                    Padding(padding: EdgeInsets.all(5),
                      child:
                      Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(),
                          child: FittedBox(
                            child: Image.asset('assets/photos/photo1.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),),
                    Padding(padding: EdgeInsets.all(5),
                      child:
                      Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(),
                          child: FittedBox(
                            child: Image.asset('assets/photos/photo1.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),),
                  ],
                ),

                //Text(widget.task.tDesc),
              ],),
            ),
            Visibility(
              visible: widget.task.tStatus=='начато',
              child:
            IconButton.filled(
              icon: const Icon(Icons.add_a_photo),
              style: IconButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Color(0xFF7E7BF4),
              ),
              //color: Colors.white,
              onPressed: () {},
            ),
            ),
          ],
        ),
      ),
/*      ListTile(
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(Icons.description, color: Color(0xFF85C3FF),),
            ],
          ),
        title: Text(task.tDesc)
      ),*/
      SizedBox(height: 10),
          ]),
        ),
      //),
      ],
    ),
          ),
      /*Flexible(
        child: Container(
          width: double.infinity,
          //color: Colors.orange,
        ),
      ),*/
      //const CurrentTaskCard(),
      Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child:
        Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
      if(widget.task.tStatus=='завершено') ...[]
      else if(widget.par=='entertaskbyqr' && widget.task.tStatus=='не выполнено') ... [
        FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: Color(0xFF7ACB82),
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: Size(100, 56),
          //elevation: 5.0,
        ),
        onPressed: () {
        },
        //child: Text(AppLocalizations.of(context)!.reportProblem),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context)!.beginTask,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Colors.white, fontWeight: FontWeight.bold
              ),
              //style: TextStyle(color: Color(0xFF7B7B7B))
            ),
          ],
        ),
      ),
        SizedBox(height: 10),
        OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: Color(0xFF85C3FF),
          side: BorderSide(width: 2.0, color: Color(0xFF85C3FF)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: Size(100, 56),
          //elevation: 5.0,
        ),
        onPressed: () {
        },
        //child: Text(AppLocalizations.of(context)!.reportProblem),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                AppLocalizations.of(context)!.cancelTask,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Color(0xFF7B7B7B), fontWeight: FontWeight.bold
                ),
            ),
          ],
        ),
      ),
      ]
      else if(widget.par=='entertask' && widget.task.tStatus=='не выполнено') ... [
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Color(0xFF7ACB82),
            foregroundColor: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            minimumSize: Size(100, 56),
            //elevation: 5.0,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/qrscan');
          },
          //child: Text(AppLocalizations.of(context)!.reportProblem),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.beginTaskQR,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                //style: TextStyle(color: Color(0xFF7B7B7B))
              ),
              SizedBox(
                width: 10,
              ),
              Icon( // <-- Icon
                Icons.qr_code_scanner,
                size: 24.0,
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: Color(0xFF85C3FF),
            side: BorderSide(width: 2.0, color: Color(0xFF85C3FF)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            minimumSize: Size(100, 56),
            //elevation: 5.0,
          ),
          onPressed: () {
          },
          //child: Text(AppLocalizations.of(context)!.reportProblem),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  AppLocalizations.of(context)!.beginTaskNoQR,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Color(0xFF7B7B7B), fontWeight: FontWeight.bold
                  ),
              ),
            ],
          ),
        ),
      ]
      else if(widget.task.tStatus=='отменено' ||  widget.task.tStatus=='ожидание') ... [
        OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: Color(0xFF85C3FF),
              side: BorderSide(width: 2.0, color: Color(0xFF85C3FF)),
              minimumSize: Size(100, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              //elevation: 5.0,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/report_problem');
            },
            //child: Text(AppLocalizations.of(context)!.reportProblem),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    AppLocalizations.of(context)!.reportProblem,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Color(0xFF7B7B7B), fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Icon( // <-- Icon
                  Icons.error_outline,
                  size: 24.0,
                ),
              ],
            ),
          ),
      ]
      else if(widget.task.tStatus=='начато') ... [
        FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Color(0xFF7E7BF4),
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: Size(100, 56),
                ),
                onPressed: () {
                },
                //child: Text(AppLocalizations.of(context)!.reportProblem),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.confirmCompletion,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold
                      ),
                      //style: TextStyle(color: Color(0xFF7B7B7B))
                    ),
                  ],
                ),
              ),
        SizedBox(height: 10),
        OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Color(0xFF85C3FF),
                  side: BorderSide(width: 2.0, color: Color(0xFF85C3FF)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: Size(100, 56),
                  //elevation: 5.0,
                ),
                onPressed: () {
                },
                //child: Text(AppLocalizations.of(context)!.reportProblem),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        AppLocalizations.of(context)!.cancelTask,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Color(0xFF7B7B7B), fontWeight: FontWeight.bold
                        ),
                    ),
                  ],
                ),
              ),
      ]
      else ... [],
    ]),),
        ]),

    );
  }
}

class PhotoItem {
  final String image;
  final String name;
  PhotoItem(this.image, this.name);
}