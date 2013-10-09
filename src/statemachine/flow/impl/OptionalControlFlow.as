package statemachine.flow.impl
{
import statemachine.flow.api.Payload;
import statemachine.flow.builders.FlowMapping;
import statemachine.flow.builders.OptionalFlowMapping;
import statemachine.flow.core.ExecutableBlock;

public class OptionalControlFlow implements OptionalFlowMapping, ExecutableBlock
{
    internal const executionData:Vector.<ExecutionData> = new Vector.<ExecutionData>();
    internal var currentCommandGroup:ExecutionData

    private var _parent:FlowMapping;
    private var _executor:Executor;

    public function OptionalControlFlow( parent:FlowMapping, executor:Executor ):void
    {
        _parent = parent;
        _executor = executor;
    }

    public function executeAll( ...args ):OptionalFlowMapping
    {
        (currentCommandGroup == null) && createAndPushCommandGroup();

        for each ( var commandClass:Class in args )
        {
            currentCommandGroup.pushCommand( commandClass );
        }

        return this;
    }

    public function onApproval( ...args ):OptionalFlowMapping
    {
        (currentCommandGroup == null) && createAndPushCommandGroup();

        for each ( var guardClass:Class in args )
        {
            currentCommandGroup.pushGuard( guardClass );
        }

        return this;
    }

    private function createAndPushCommandGroup():void
    {
        currentCommandGroup = new ExecutionData();
        executionData.push( currentCommandGroup );
    }

    public function get and():FlowMapping
    {
        fix();
        return _parent;
    }

    public function get or():OptionalFlowMapping
    {
        fix();
        return this;
    }

    private function fix():void
    {
        if ( currentCommandGroup == null )return;
        currentCommandGroup.fix();
        currentCommandGroup = null;
    }

    public function executeBlock( payload:Payload ):void
    {

        for each ( var data:ExecutionData in executionData )
        {
            data.payload = payload;
            if ( _executor.execute( data ) )
            {
                data.payload = null;
                return;
            }
            data.payload = null;
        }
    }
}
}
