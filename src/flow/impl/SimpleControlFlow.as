package flow.impl
{
import flow.dsl.ControlFlowMapping;
import flow.dsl.SimpleControlFlowMapping;

public class SimpleControlFlow implements SimpleControlFlowMapping, Executable
{
    internal const _commandGroup:ExecutionData = new ExecutionData();
    private var _parent:ControlFlowMapping;
    private var _executor:Executor;

    public function SimpleControlFlow( parent:ControlFlowMapping, executor:Executor ):void
    {
        _parent = parent;
        _executor = executor;
    }

    public function executeAll( ...args ):SimpleControlFlowMapping
    {
        for each ( var commandClass:Class in args )
        {
            _commandGroup.pushCommand( commandClass );
        }
        return this;
    }

    public function onApproval( ...args ):SimpleControlFlowMapping
    {
        for each ( var guardClass:Class in args )
        {
            _commandGroup.pushGuard( guardClass );
        }
        return this;
    }

    public function get and():ControlFlowMapping
    {
        _commandGroup.fix();
        return _parent;
    }


    public function execute():void
    {
        _executor.execute( _commandGroup );
    }
}
}
