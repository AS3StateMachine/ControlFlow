package statemachine.flow.impl
{
import statemachine.flow.api.Payload;
import statemachine.flow.builders.FlowMapping;
import statemachine.flow.builders.SimpleFlowMapping;
import statemachine.flow.core.ExecutableBlock;

public class SimpleControlFlow implements SimpleFlowMapping, ExecutableBlock
{
    internal const _commandGroup:ExecutionData = new ExecutionData();

    public function SimpleControlFlow( executor:Executor ):void
    {
        _executor = executor;
    }

    private var _executor:Executor;
    private var _parent:FlowMapping;

    public function set parent( value:FlowMapping ):void
    {
        _parent = value;
    }

    public function get and():FlowMapping
    {
        _commandGroup.fix();
        return _parent;
    }

    public function execute( ...args ):SimpleFlowMapping
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

    public function executeBlock( payload:Payload ):void
    {
        _commandGroup.payload = payload;
        _executor.execute( _commandGroup );
        _commandGroup.payload = null;
    }
}
}
