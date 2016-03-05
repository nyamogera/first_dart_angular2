import 'package:angular2/angular2.dart';
import 'package:angular2/bootstrap.dart';
import 'dock_spawn/dock_spawn.dart';

@Component(
    selector: 'my-app',
    template: '<h1>My First Angular 2 App</h1>'
    '<div id="my_dock_manager" class="my-dock-manager">'
        '<div id="solution_window" style="background-color:black"></div>'
        '<div id="output_window" style="background-color:red"></div>'
    '</div>'
)
class AppComponent {

  DockManager dockManager;
  ngOnAfterViewInit() {
    dockManager = new DockManager(document.query("#my_dock_manager"));
    dockManager.initialize();

    //window.on.resize.add(onResized);
    //onResized(null);

    PanelContainer solution = new PanelContainer(document.query("#solution_window"), dockManager);
    PanelContainer output = new PanelContainer(document.query("#output_window"), dockManager);

    DockNode documentNode = dockManager.context.model.documentManagerNode;

    DockNode solutionNode = dockManager.dockLeft(documentNode, solution, 0.20);
    DockNode outputNode = dockManager.dockRight(documentNode, output, 0.4);
  }

}

main() {
  bootstrap(AppComponent);
}

