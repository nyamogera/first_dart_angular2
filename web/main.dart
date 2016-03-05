import 'package:angular2/angular2.dart';
import 'package:angular2/bootstrap.dart';
import 'dock_spawn/dock_spawn.dart';
import 'dart:html';

@Component(
    selector: 'my-app',
    template:
    '<div id="my_dock_manager" class="my-dock-manager">'
        '<div id="solution_window" caption="Solution Explorer"><div style="background-color:black">コンテンツ1</div></div>'
        '<div id="output_window" caption="Background"><div style="background-color:red">コンテンツ2</div></div>'
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

    PanelContainer solution = new PanelContainer(
        querySelector("#solution_window"), dockManager);
    PanelContainer output = new PanelContainer(
        querySelector("#output_window"), dockManager);

    DockNode documentNode = dockManager.context.model.documentManagerNode;

    DockNode solutionNode = dockManager.dockUp(documentNode, solution, 0.5);
    solutionNode.
    DockNode outputNode = dockManager.dockDown(documentNode, output, 0.5);
  }

  void onResized(Event event) {
    //int headerHeight = header.client.height;
    dockManager.resize(window.innerWidth, window.innerHeight);
//    dockManager.resize(600, 400);
  }
}

main() {
  bootstrap(AppComponent);
  print("hoge!!");
}

