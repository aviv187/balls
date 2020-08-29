class FeedbackController {
  Function(bool) feedbackNeedsUpdateCallback;

  void updateFeedback(bool isOnTarget) {
    if (feedbackNeedsUpdateCallback != null) {
      feedbackNeedsUpdateCallback(isOnTarget);
    }
  }
}

class DraggableInfo<BallClass> {
  bool isOnTarget;
  BallClass data;
  DraggableInfo(this.isOnTarget, this.data);
}

class MyDraggableController<BallClass> {
  List<Function(bool, BallClass)> _targetUpdateCallbacks =
      new List<Function(bool, BallClass)>();

  MyDraggableController();

  void onTarget(bool onTarget, BallClass data) {
    if (_targetUpdateCallbacks != null) {
      _targetUpdateCallbacks.forEach((f) => f(onTarget, data));
    }
  }

  void subscribeToOnTargetCallback(Function(bool, BallClass) f) {
    _targetUpdateCallbacks.add(f);
  }

  void unSubscribeFromOnTargetCallback(Function(bool, BallClass) f) {
    _targetUpdateCallbacks.remove(f);
  }
}
