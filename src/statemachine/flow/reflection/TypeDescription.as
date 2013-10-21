package statemachine.flow.reflection
{
public class TypeDescription
{
    public function TypeDescription( hasApprove:Boolean, hasExecute:Boolean, hasAsync:Boolean )
    {
        _hasApprove = hasApprove;
        _hasExecute = hasExecute;
        _hasAsync = hasAsync;
    }

    private var _hasApprove:Boolean;
    private var _hasExecute:Boolean;
    private var _hasAsync:Boolean;

    public function get hasApproveMethod():Boolean
    {
        return _hasApprove;
    }

    public function get hasExecuteMethod():Boolean
    {
        return _hasExecute;
    }

    public function get hasAsyncExecuteMethod():Boolean
    {
        return _hasAsync;
    }
}
}
