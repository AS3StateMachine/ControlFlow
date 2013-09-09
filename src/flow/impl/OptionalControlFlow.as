package flow.impl
{
import flow.dsl.OptionalControlFlowMapping;
import flow.dsl.ControlFlowMapping;

public class OptionalControlFlow implements OptionalControlFlowMapping, Executable
{
    internal const executionData:Vector.<ExecutionData> = new Vector.<ExecutionData>();
    internal var currentCommandGroup:ExecutionData

    private var _parent:ControlFlowMapping;
    private var _executor:Executor;

    public function OptionalControlFlow( parent:ControlFlowMapping, executor:Executor ):void
    {
        _parent = parent;
        _executor = executor;
    }

    public function executeAll( ...args ):OptionalControlFlowMapping
    {
        (currentCommandGroup == null) && createAndPushCommandGroup();

        for each ( var commandClass:Class in args )
        {
            currentCommandGroup.pushCommand( commandClass );
        }

        return this;
    }

    public function onApproval( ...args ):OptionalControlFlowMapping
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

    public function get and():ControlFlowMapping
    {
        fix();
        return _parent;
    }

    public function get or():OptionalControlFlowMapping
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

    public function execute():void
    {
        for each ( var data:ExecutionData in executionData )
        {
            if ( _executor.execute( data ) )return;
        }
    }
}
}
