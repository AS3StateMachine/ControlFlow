package statemachine.flow.impl.support.mappings
{
import org.swiftsuspenders.Injector;

import statemachine.flow.api.Payload;

import statemachine.flow.impl.ExecutionData;
import statemachine.flow.impl.Executor;

public class MockExecutor extends Executor
{
    public const recievedPayload:Vector.<Payload> = new Vector.<Payload>();
    public const recievedData:Vector.<ExecutionData> = new Vector.<ExecutionData>();
    private var exectureReturn:Vector.<Boolean>;

    override public function execute( executionGroup:ExecutionData ):Boolean
    {
        recievedPayload.push( executionGroup.payload );
        recievedData.push( executionGroup );
        return (exectureReturn == null) ? true : exectureReturn.shift() ;
    }

    public function setExecuteReturn( ...args ):MockExecutor
    {
        exectureReturn = Vector.<Boolean>(args);
        return this;
    }

    public function MockExecutor( injector:Injector )
    {
        super( injector );
    }
}
}
