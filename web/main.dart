import 'package:angular2/angular2.dart';
import 'package:angular2/bootstrap.dart';
import 'dock_spawn/dock_spawn.dart';
import 'dart:html';
import 'dart:js';
import "lib/ace.dart";

@Component(
    selector: 'my-app',
    template:
    '<div id="my_dock_manager" class="my-dock-manager">'
        '<div id="editor_window" caption="Editor"><div id="editor" style="width: 100%;height: 100%;">エディター</div></div>'
        '<div id="viewer_window" caption="Viewer"><div style="background-color:blue">ビューワー</div></div>'
        '<div id="console_window" caption="console"><div style="background-color:red">コンソール</div></div>'
        '</div>'
)
class AppComponent implements AfterViewInit {

  DockManager dockManager;
  AceEditor aceEditor;

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

    aceEditor = ace.edit("editor");
    aceEditor.on('change',() { onInput();} );

  }

  void onInput() {
    print("onInput!");
    aceEditor.getValue();
  }

  void onResized(Event event) {
    dockManager.resize(window.innerWidth, window.innerHeight);
  }
}

main() {
  bootstrap(AppComponent);
}

