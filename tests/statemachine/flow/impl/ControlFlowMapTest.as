package statemachine.flow.impl
{
import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.instanceOf;
import org.swiftsuspenders.Injector;

import statemachine.flow.builders.FlowMapping;
import statemachine.flow.impl.support.ExecutableTrigger;
import statemachine.flow.impl.support.mappings.MockControlFlowContainer;

public class ControlFlowMapTest
{
    private var _classUnderTest:TriggerFlowMap;
    private var _injector:Injector;

    [Before]
    public function before():void
    {
        _injector = new Injector();
        _injector.map( ExecutableTrigger ).asSingleton();
        _injector.map( Injector ).toValue( _injector );
        _injector.map( ControlFlowContainer ).toSingleton( MockControlFlowContainer );
        _classUnderTest = new TriggerFlowMap( _injector );
    }


    [Test]
    public function on_returns_instanceOf_FlowGroupMapping():void
    {
        assertThat( _classUnderTest.map( new ExecutableTrigger() ), instanceOf( FlowMapping ) )
    }

    [Test]
    public function when_trigger_listener_is_called__FlowGroup_is_executed():void
    {
        const trigger:ExecutableTrigger = _injector.getInstance( ExecutableTrigger );
        const flowGroup:MockControlFlowContainer = _injector.getInstance( ControlFlowContainer );
        _classUnderTest.map( trigger );
        trigger.executeBlock( null );
        assertThat( flowGroup.executeCalled, equalTo( 1 ) );
    }

    [Test]
    public function when_trigger_is_removed__trigger_listener_is_null():void
    {
        const trigger:ExecutableTrigger = _injector.getInstance( ExecutableTrigger );
        const flowGroup:MockControlFlowContainer = _injector.getInstance( ControlFlowContainer );
        _classUnderTest.map( trigger );
        _classUnderTest.unmap( trigger );
        trigger.executeBlock( null );
        assertThat( flowGroup.executeCalled, equalTo( 0 ) );
    }
}
}
