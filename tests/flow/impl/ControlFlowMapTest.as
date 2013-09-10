package flow.impl
{
import flow.dsl.ControlFlowMapping;
import flow.impl.support.ExecutableTrigger;
import flow.impl.support.mappings.MockControlFlowContainer;

import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.instanceOf;
import org.swiftsuspenders.Injector;

public class ControlFlowMapTest
{
    private var _classUnderTest:TriggerMap;
    private var _injector:Injector;

    [Before]
    public function before():void
    {
        _injector = new Injector();
        _injector.map( ExecutableTrigger ).asSingleton();
        _injector.map( Injector ).toValue( _injector );
        _injector.map( ControlFlowContainer ).toSingleton( MockControlFlowContainer );
        _classUnderTest = new TriggerMap( _injector );
    }



    [Test]
    public function on_returns_instanceOf_FlowGroupMapping():void
    {
        assertThat( _classUnderTest.map( new ExecutableTrigger() ), instanceOf( ControlFlowMapping ) )
    }

    [Test]
    public function when_trigger_listener_is_called__FlowGroup_is_executed():void
    {
        const trigger:ExecutableTrigger = _injector.getInstance( ExecutableTrigger );
        const flowGroup:MockControlFlowContainer = _injector.getInstance( ControlFlowContainer );
        _classUnderTest.map( trigger );
        trigger.execute();
        assertThat( flowGroup.executeCalled, equalTo( 1 ) );
    }

    [Test]
    public function when_trigger_is_removed__trigger_listener_is_null():void
    {
        const trigger:ExecutableTrigger = _injector.getInstance( ExecutableTrigger );
        const flowGroup:MockControlFlowContainer = _injector.getInstance( ControlFlowContainer );
        _classUnderTest.map( trigger );
        _classUnderTest.unmap( trigger );
        trigger.execute();
        assertThat( flowGroup.executeCalled, equalTo( 0 ) );
    }
}
}
