package flow.impl
{
import flow.dsl.FlowGroupMapping;
import flow.dsl.SingleFlowMapping;

public class SimpleControlFlow implements SingleFlowMapping, Executable
{
    internal const _commandGroup:ExecutionData = new ExecutionData();
    private var _parent:FlowGroupMapping;
    private var _executor:Executor;

    public function SimpleControlFlow( parent:FlowGroupMapping, executor:Executor ):void
    {
        _parent = parent;
        _executor = executor;
    }

    public function executeAll( ...args ):SingleFlowMapping
    {
        for each ( var commandClass:Class in args )
        {
            _commandGroup.pushCommand( commandClass );
        }
        return this;
    }

    public function onApproval( ...args ):SingleFlowMapping
    {
        for each ( var guardClass:Class in args )
        {
            _commandGroup.pushGuard( guardClass );
        }
        return this;
    }

    public function get and():FlowGroupMapping
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
