package statemachine.flow.impl
{
import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.instanceOf;

import statemachine.flow.builders.FlowMapping;
import statemachine.flow.impl.support.ExecutableTrigger;
import statemachine.flow.impl.support.mappings.MockExecutor;
import statemachine.support.cmds.MockCommandOne;

public class ControlFlowMapTest
{
    private var _classUnderTest:TriggerFlowMap;
    private var _executor:MockExecutor;

    [Before]
    public function before():void
    {
        _executor = new MockExecutor( null );
        _classUnderTest = new TriggerFlowMap( _executor );
    }

    [Test]
    public function on_returns_instanceOf_FlowGroupMapping():void
    {
        assertThat( _classUnderTest.map( new ExecutableTrigger() ), instanceOf( FlowMapping ) )
    }

    [Test]
    public function when_trigger_listener_is_called__FlowGroup_is_executed():void
    {
        const trigger:ExecutableTrigger = new ExecutableTrigger();
        _classUnderTest.map( trigger ).only.execute( MockCommandOne );
        trigger.executeBlock( null );
        assertThat( _executor.recievedPayload.length, equalTo( 1 ) );
    }

    [Test]
    public function when_trigger_is_removed__trigger_listener_is_null():void
    {
        const trigger:ExecutableTrigger = new ExecutableTrigger();
        _classUnderTest.map( trigger ).only.execute( MockCommandOne );
        _classUnderTest.unmap( trigger );
        trigger.executeBlock( null );
        assertThat( _executor.recievedPayload.length, equalTo( 0 ) );
    }
}
}
