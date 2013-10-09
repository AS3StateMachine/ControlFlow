package statemachine.flow.impl
{
import statemachine.flow.api.Payload;
import statemachine.flow.builders.FlowMapping;
import statemachine.flow.builders.SimpleFlowMapping;
import statemachine.flow.core.ExecutableBlock;

public class SimpleControlFlow implements SimpleFlowMapping, ExecutableBlock
{
    internal const _commandGroup:ExecutionData = new ExecutionData();
    private var _parent:FlowMapping;
    private var _executor:Executor;

    public function SimpleControlFlow( parent:FlowMapping, executor:Executor ):void
    {
        _parent = parent;
        _executor = executor;
    }

    public function executeAll( ...args ):SimpleFlowMapping
    {
        for each ( var commandClass:Class in args )
        {
            _commandGroup.pushCommand( commandClass );
        }
        return this;
    }

    public function onApproval( ...args ):SimpleFlowMapping
    {
        for each ( var guardClass:Class in args )
        {
            _commandGroup.pushGuard( guardClass );
        }
        return this;
    }

    public function get and():FlowMapping
    {
        _commandGroup.fix();
        return _parent;
    }


    public function executeBlock( payload:Payload ):void
    {
        _commandGroup.payload = payload;
        _executor.execute( _commandGroup );
        _commandGroup.payload = null;
    }
}
}
