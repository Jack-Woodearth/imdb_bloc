// import 'dart:async';
// import 'dart:io';

// import 'dart:isolate';

// void main(List<String> args) {
//   // myCreateIsolate();
// }

// ///
// ///The CommonWorkerIsolate class is a singleton that provides an interface for running functions in an isolate. It has a init method that creates an isolate and sets up communication channels between the isolate and the main isolate.

// ///The requestTask method sends a message to the isolate containing a function and data to be processed. It also generates a unique request ID and adds a completer to the _completesMap map, using the request ID as the key.

// ///The isolate has a _workerIsolateCallback function that listens for messages from the main isolate. When it receives a message, it calls the _handleMasterMessage function, which runs the function contained in the message and returns the result to the main isolate using the request ID.

// ///The main isolate listens for responses from the isolate using the _handleWorkerResponse function. When it receives a response, it looks up the corresponding completer in the _completesMap map and completes it with the result from the isolate. The completer is then removed from the map.

// ///The IsolateRequest and IsolateResponse classes are used to package the function, data, and request ID into a message that can be sent between isolates. The IsolateRequest class has a sendPort, a requestId, a function, and data fields. The IsolateResponse class has a requestId and a result field.
// ///
// class CommonWorkerIsolate {
//   static final CommonWorkerIsolate _singleton = CommonWorkerIsolate._internal();
//   factory CommonWorkerIsolate() {
//     return _singleton;
//   }
//   CommonWorkerIsolate._internal();
//   static bool _initialized = false;
//   static bool get initialized => _initialized;
//   static Future<void> init() async {
//     await _singleton._createIsolate();
//     _initialized = true;
//   }

//   late final SendPort _taskSendPort;
//   final ReceivePort _receivePort = ReceivePort();
//   final ReceivePort _mainReceivePort = ReceivePort();
//   static final Map<Capability, Completer<IsolateResponse>> _completesMap = {};
//   get map => _completesMap;
//   static void _workerIsolateCallback(SendPort masterSendPort) async {
//     ReceivePort workerReceivePort = ReceivePort();
//     masterSendPort.send(workerReceivePort.sendPort);

//     workerReceivePort.listen(_handleMasterMessage);
//   }

//   static _handleMasterMessage(message) {
//     if (message is IsolateRequest) {
//       message.sendPort.send(IsolateResponse(
//           message.requestId, message.function(message.data))); //执行业务函数
//     }
//   }

//   Future _createIsolate() async {
//     Isolate.spawn<SendPort>(_workerIsolateCallback, _mainReceivePort.sendPort);

//     _taskSendPort = await _mainReceivePort.first as SendPort;

//     _receivePort.listen(_handleWorkerResponse);
//   }

//   Future<IsolateResponse> requestTask(Function function, dynamic data,
//       {String tag = ''}) {
//     while (!_initialized) {
//       sleep(const Duration(milliseconds: 100));
//     }

//     if (!_initialized) {
//       throw Exception('CommonWorkerIsolate has not been initialized');
//     }
//     final completer = Completer<IsolateResponse<dynamic>>();
//     final requestId = Capability();
//     _taskSendPort
//         .send(IsolateRequest(_receivePort.sendPort, requestId, function, data));
//     _completesMap[requestId] = completer;

//     return completer.future;
//   }

//   static void _handleWorkerResponse(dynamic response) {
//     if (response is IsolateResponse) {
//       final completer = _completesMap[response.requestId];

//       if (completer == null) {
//         return;
//       }

//       completer.complete(response);
//       _completesMap.remove(response.requestId);
//     }
//   }
// }

// class IsolateRequest {
//   SendPort sendPort;
//   Capability requestId;
//   Function function;
//   dynamic data;
//   IsolateRequest(this.sendPort, this.requestId, this.function, this.data);
// }

// class IsolateResponse<R> {
//   Capability requestId;
//   R result;
//   IsolateResponse(this.requestId, this.result);
// }
