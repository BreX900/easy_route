

enum Transition {
  MATERIAL, CUPERTINO,
}


class Options {
  final Transition transition;
  final bool maintainState;

  const Options({
    this.transition,
    this.maintainState,
  });

  const Options.def() : this(transition: null, maintainState: true);
}