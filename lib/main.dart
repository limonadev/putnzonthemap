import 'dart:async';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

void main() {
  FirebaseAuth.fromApp(FirebaseApp.instance).signInAnonymously();
  runApp(App());
}

class App extends StatefulWidget {
  createState() => _AppState();
}

class _AppState extends State<App> {
  final database = FirebaseDatabase();
  Map<String, _Level> _levels = {};

  initState() {
    super.initState();

    database.reference().child('levels').onValue.listen((event) {
      var ss = event.snapshot;
      var list = ss.value;

      list.forEach((key, value) {
        var l = _levels[key] ?? _Level();
        l.update(key, value);
        _levels[key] = l;
      });

      if (mounted) setState(() {});
    });
  }

  build(context) {
    List<_Level> sorted = _levels.values.toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    const c = Color(0xff04287b);
    return MaterialApp(
      theme: ThemeData(primaryColor: c),
      home: Scaffold(
          appBar: AppBar(title: Text('#putnzonthemap')),
          backgroundColor: c,
          body: Stack(children: [
            SizedBox.expand(child: _Flag()),
            ListView(children: sorted.map((l) => _LevelItem(l)).toList())
          ])),
    );
  }
}

class _Flag extends StatelessWidget {
  build(context) {
    var sz = MediaQuery.of(context).size;
    var flag =
        'assets/images/nz_flag${sz.width > sz.height ? "_landscape" : ""}.png';

    return Image.asset(flag, fit: BoxFit.fill);
  }
}

class _NzSticker extends StatefulWidget {
  _NzSticker({this.level});
  final _Level level;
  createState() => _NzStickerState();
}

class _NzStickerState extends State<_NzSticker>
    with SingleTickerProviderStateMixin {
  build(context) {
    var l = widget.level;
    var ratio = MediaQuery.of(context).devicePixelRatio;
    var scale = l.nzScale * (l.done ? 1 : 5) / ratio;

    return AnimatedSize(
      curve: Curves.elasticOut,
      duration: Duration(milliseconds: 1000),
      vsync: this,
      child: Opacity(
        opacity: l.done ? 1 : 0,
        child: Container(
            width: 400 * scale,
            height: 436 * scale,
            child: Image.asset('assets/images/sticker.png', fit: BoxFit.fill)),
      ),
    );
  }
}

class _LevelPage extends StatefulWidget {
  _LevelPage(this.level);
  final _Level level;
  createState() => _LevelPageState();
}

class _LevelPageState extends State<_LevelPage> {
  var _sc = StreamController<_Level>.broadcast();
  var _controller = PhotoViewController();
  var _level;

  initState() {
    super.initState();
    _level = widget.level;
    _level.notifier = _sc;
    _sc.stream.listen((l) {
      _level = l;
      if (mounted) setState(() {});
    });
  }

  dispose() {
    _controller.dispose();
    _sc?.close();
    _level.notifier = null;
    super.dispose();
  }

  build(context) {
    var l = _level;
    var mq = MediaQuery.of(context);
    var ratio = mq.devicePixelRatio;
    var sz = Size(l.size.width / ratio, l.size.height / ratio);
    var pos = Positioned(
      top: l.nzTop / ratio,
      left: l.nzLeft / ratio,
      child: GestureDetector(
        onTap: () => setState(() => l.done = true),
        child: _NzSticker(level: l),
      ),
    );
    var pv = PhotoView.customChild(
      basePosition: Alignment.topLeft,
      childSize: sz,
      controller: _controller,
      initialScale: l.scale,
      child: Stack(children: [Image.asset(l.image, scale: ratio), pos]),
    );

    return Scaffold(
      appBar: AppBar(title: Text(l.name)),
      backgroundColor: Colors.white,
      body: ClipRect(child: pv),
    );
  }
}

class _LevelItem extends StatefulWidget {
  _LevelItem(this.level);
  final _Level level;
  _LevelItemState createState() => _LevelItemState();
}

class _LevelItemState extends State<_LevelItem> {
  build(context) {
    var l = widget.level;
    var tile = ListTile(
        title: Text(l.name),
        trailing:
            l.done ? Icon(Icons.check_circle, color: Colors.green) : null);
    var iw = InkWell(
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => _LevelPage(l))),
      child: tile,
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Material(
          borderRadius: BorderRadius.circular(8),
          color: l.done ? Colors.white30 : Colors.white,
          child: iw),
    );
  }
}

class _Level {
  bool done = false;
  double nzLeft, nzScale, nzTop, scale;
  String name, image;
  Size size;
  StreamController<_Level> notifier;

  void update(String name, dynamic map) {
    this.name = name;
    image = map['image'];
    nzLeft = map['nzLeft'] * 1.0;
    nzScale = map['nzScale'] * 1.0;
    nzTop = map['nzTop'] * 1.0;
    scale = map['scale'] * 1.0;
    size = Size(map['width'] * 1.0, map['height'] * 1.0);

    notifier?.add(this);
  }
}
