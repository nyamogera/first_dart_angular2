# オレオレエディターを作るためにDock Spawnを使いたかったから、DartでAngular2を使ってみた。

最近、Angular2を使い始めてすごく使いやすいなぁと思っていて、みんな作るのが大好きなオレオレエディターを作っていた。
作っていくと欲望は強くなり、動的に配置を変えたくて、JavaScriptのライブラリーはないのかな？ と探していたら、「[Dock Spawn](http://www.dockspawn.com/)」というものを見つけた。
Dart製[^1]とのことなので、せっかくなのでDartでAngular2を使って、オレオレエディターの基礎となる部分を作ってみたのでログに残す。

DartにもAngular2にも詳しくないので、おかしなことしているところがあるかも。

[^1]: ある程度作ってから気がついたけれど、[Dock Spawn](http://www.dockspawn.com/)はDart製だけど、[JavaScript用にも書き出されてる]()からこんなことしなくても使えそう。TypeScript+Angular2でのDock Spawnの使い方も近々共有したいなー。

# MacにDartをインストール
- [Installing Dart on Mac](https://www.dartlang.org/downloads/mac.html)

```
$ brew tap dart-lang/dart
$ brew install dart
```

# Angular2のDartのコード

- [Angular 2 for Dart 5 MIN QUICKSTART](https://angular.io/docs/dart/latest/quickstart.html)

上のチュートリアルを進めて、いろいろファイル作る。完成後、こういう構成になっているはず。

```
.
├── build
├── packages
└── web
    ├── main.dart
    ├── index.html
    └── packages
```

# Dock SpawnをAngular2で使う
[Dock Spawn 公式サイト](http://www.dockspawn.com/)のDownLoadボタンからzipをダウンロードする

- 「lib」フォルダを ⇢ 「dock_spawn」へリネームし、「web/dock_spawn」として配置する。
- 「web/resources」フォルダ以下のファイルを「web/resources」以下に配置する。

```
.
├── build
├── packages
└── web
    ├── dock_spawn ← lib
    ├── packages
    └── resources ← web/resources
        ├── css
        ├── font
        └── images
```

## Dock Spawnを組み込む

### CSSを読み込む

`index.html`にDock Spawnにcss読み込みコード追加。

```
<link rel="stylesheet" href="resources/css/dock-manager.css">
```

### ソースにDock Spawn用コード追加

ここから`main.dart`に追加した内容。

Dock Spawnのimportを行う。

```
import 'dock_spawn/dock_spawn.dart';
```

コンポーネントのtemplateのHTMLに必要なdivを配置。Dartは文字列を改行して時にちゃんと結合してくれるみたい。
```
@Component(
    selector: 'my-app',
    template:
    '<div id="my_dock_manager" class="my-dock-manager">'
        '<div id="editor_window" caption="Editor"><div style="background-color:yellow">エディター</div></div>'
        '<div id="viewer_window" caption="Viewer"><div style="background-color:blue">ビューワー</div></div>'
        '<div id="console_window" caption="console"><div style="background-color:red">コンソール</div></div>'
        '</div>'
)
```

Angular2のライフサイクルのビューの初期化の`ngAfterViewInit()`メソッド内で初期化を行った。

Dockの配置は[Dock Spawn]( http://www.dockspawn.com/ ) に記載されているコードを参考にしたが、エラーが発生したのでいろいろ調整した。
いわゆる`document.getElementById()`メソッド的なものは、`dart:html`をimportして、`querySelector()`メソッド(旧`query()`)で使用できるみたい。
( https://www.dartlang.org/docs/tutorials/connect-dart-html/ ) 

- main.dart

```
class AppComponent implements AfterViewInit {

  DockManager dockManager;

  AppComponent() {
    print("constractor!!");
  }

  void ngAfterViewInit() {
    print("ngOnAfterViewInit!!");
    dockManager = new DockManager(querySelector("#my_dock_manager"));
    dockManager.initialize();

    window.onResize.listen(onResized);
    onResized(null);

    PanelContainer editor = new PanelContainer(
        querySelector("#editor_window"), dockManager);
    PanelContainer viwer = new PanelContainer(
        querySelector("#viewer_window"), dockManager);
    PanelContainer console = new PanelContainer(
        querySelector("#console_window"), dockManager);

    DockNode documentNode = dockManager.context.model.documentManagerNode;

    DockNode consoleNode = dockManager.dockDown(documentNode, console, 0.2);
    DockNode viwerNode = dockManager.dockRight(documentNode, viwer, 0.5);
    DockNode editorNode = dockManager.dockFill(documentNode, editor);
  }

  void onResized(Event event) {
    dockManager.resize(window.innerWidth, window.innerHeight);
  }
}
```

- main.dart (全体のコード)

```
import 'package:angular2/angular2.dart';
import 'package:angular2/bootstrap.dart';
import 'dock_spawn/dock_spawn.dart';
import 'dart:html';

@Component(
    selector: 'my-app',
    template:
    '<div id="my_dock_manager" class="my-dock-manager">'
        '<div id="editor_window" caption="Editor"><div style="background-color:yellow">エディター</div></div>'
        '<div id="viewer_window" caption="Viewer"><div style="background-color:blue">ビューワー</div></div>'
        '<div id="console_window" caption="console"><div style="background-color:red">コンソール</div></div>'
        '</div>'
)
class AppComponent implements AfterViewInit {

  DockManager dockManager;

  AppComponent() {
    print("constractor!!");
  }

  void ngAfterViewInit() {
    print("ngOnAfterViewInit!!");
    dockManager = new DockManager(querySelector("#my_dock_manager"));
    dockManager.initialize();

    window.onResize.listen(onResized);
    onResized(null);

    PanelContainer editor = new PanelContainer(
        querySelector("#editor_window"), dockManager);
    PanelContainer viwer = new PanelContainer(
        querySelector("#viewer_window"), dockManager);
    PanelContainer console = new PanelContainer(
        querySelector("#console_window"), dockManager);

    DockNode documentNode = dockManager.context.model.documentManagerNode;

    DockNode consoleNode = dockManager.dockDown(documentNode, console, 0.2);
    DockNode viwerNode = dockManager.dockRight(documentNode, viwer, 0.5);
    DockNode editorNode = dockManager.dockFill(documentNode, editor);
  }

  void onResized(Event event) {
    dockManager.resize(window.innerWidth, window.innerHeight);
  }
}

main() {
  bootstrap(AppComponent);
}

```

Dock Spawn関連のコードはマスターした！（してない）

# JavaScriptのライブラリを使うために、Dartからjsを使う。
、一旦ひととおりDock Spawnが動いたのでちょっと満足した。

エディター部分には「[Ace(cloud9)](https://ace.c9.io/#nav=about)」を使うので、AceのライブラリをCDNで入れておく。

- index.html

```
    <script src="https://cdnjs.cloudflare.com/ajax/libs/ace/1.2.3/ace.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/ace/1.2.3/mode-markdown.js"></script>
```

Dartからjsを使うには、`pubspec.yaml`に`js`パッケージを追加と、定義ファイルを作るみたい。

```
dependencies:
  js: ^0.6.0
```

記述後、`pub get`コマンドでインストールするはず。

```
$ pub get
```
※ と思ってしてみたら、ありとあらゆるフォルダに`package`フォルダへのリンクができて、違和感があったのですでに作成されていたもの以外は削除。別のコマンドがあるのかな？この作業よろしくない気がする・・・。

```
Resolving dependencies... (3.7s) 
+ js 0.6.0
Downloading js 0.6.0...
Changed 1 dependency!
```

定義ファイルを作るときは、[chart.js](https://github.com/google/chartjs.dart/blob/master/lib/chartjs.dart)を参考にしてねと書かれていたので参考にした。
ひとまずすぐに必要そうなもののみ作成した。

- 定義ファイル 「lib/ace.dart」

```
import "package:js/js.dart";

@anonymous
@JS()
class AceSession {
  external void on(String eventName, Function listener);
  external void setMode(String theme);

}

@anonymous
@JS()
class AceEditor {
  external String getValue();
  external AceSession getSession();
}

@anonymous
@JS()
class ace {
  external static AceEditor edit(String id);
}
```

- main.dart

Aceからアクセスできるように`id`に任意の名前をつける。`width`、`height`にサイズを指定する。
```
'<div id="editor_window" caption="Editor"><div id="editor" style="width: 100%;height: 100%;">エディター</div></div>'
```


```
aceEditor = ace.edit("editor");
aceEditor.on('change',() { print("onInput!");} );
```

ここでエラーが出てしまう。
```
aceEditor.on('change',() { print("onInput!");} );
```