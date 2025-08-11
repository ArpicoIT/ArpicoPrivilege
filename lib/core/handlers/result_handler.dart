class ResultHandler {
  final String? message;
  final Function()? onSuccess;
  final Function()? onFailed;
  final Function(Exception)? onException;
  final Function(dynamic)? whenCompleted;

  ResultHandler({this.message, this.onSuccess, this.onFailed, this.onException, this.whenCompleted});

  ResultHandler showAlert(Function(String message) alert) {
    if (message != null) {
      alert(message!);
    }
    return this;
  }

  ResultHandler success(Function() callback) {
    if (onSuccess != null) {
      callback();
    }
    return this;
  }

  ResultHandler failed(Function() callback) {
    if (onFailed != null) {
      callback();
    }
    return this;
  }

  ResultHandler exception(Function(Exception exception) callback) {
    if (onException != null) {
      callback(onException!(Exception("An exception occurred")));
    }
    return this;
  }

  ResultHandler completed(Function(dynamic result) callback) {
    if (whenCompleted != null) {
      // callback(result);
    }
    return this;
  }
}