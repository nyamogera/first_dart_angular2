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
  external void on(String eventName, Function listener);
  external String getValue();
  external AceSession getSession();
  external void onChange();
}

@anonymous
@JS()
class ace {
  external static AceEditor edit(String id);
}