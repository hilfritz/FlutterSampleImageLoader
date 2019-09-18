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