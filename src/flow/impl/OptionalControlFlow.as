package flow.impl
{
import flow.dsl.CaseFlowMapping;
import flow.dsl.FlowGroupMapping;

public class OptionalControlFlow implements CaseFlowMapping, Executable
{
    internal const executionData:Vector.<ExecutionData> = new Vector.<ExecutionData>();
    internal var currentCommandGroup:ExecutionData

    private var _parent:FlowGroupMapping;
    private var _executor:Executor;

    public function OptionalControlFlow( parent:FlowGroupMapping, executor:Executor ):void
    {
        _parent = parent;
        _executor = executor;
    }

    public function executeAll( ...args ):CaseFlowMapping
    {
        (currentCommandGroup == null) && createAndPushCommandGroup();

        for each ( var commandClass:Class in args )
        {
            currentCommandGroup.pushCommand( commandClass );
        }

        return this;
    }

    public function onApproval( ...args ):CaseFlowMapping
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

    public function get and():FlowGroupMapping
    {
        fix();
        return _parent;
    }

    public function get or():CaseFlowMapping
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
