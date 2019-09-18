abstract class BasePresenter{
  /**
   * Cancel pending transactions
   * - cancel usecase transactions by calling BaseUseCase#destroy()
   */
  void destroy();
}
abstract class BaseUseCase{
  /**
   * Cancel usecase transactions
   */
  void destroy();
}
abstract class BaseViews{
  /**
   * holds Navigate.pop() to close page
   * delay int milliseconds
   */
  void closePage({int delay = 0});
}