package flow.impl
{
import flow.dsl.FlowGroupMapping;
import flow.impl.support.MockTrigger;
import flow.impl.support.mappings.MockFlowGroup;

import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.instanceOf;
import org.hamcrest.object.nullValue;
import org.hamcrest.object.strictlyEqualTo;
import org.swiftsuspenders.Injector;

public class MapTest
{
    private var _classUnderTest:Map;
    private var _injector:Injector;

    [Before]
    public function before():void
    {
        _injector = new Injector();
        _injector.map( MockTrigger ).asSingleton();
        _injector.map( ControlFlow ).toSingleton( MockFlowGroup );
        _classUnderTest = new Map( _injector );
    }

    [Test]
    public function Map_creates_child_injector():void
    {
        assertThat( _classUnderTest.injector.parentInjector, strictlyEqualTo( _injector ) );
    }


    [Test]
    public function on_returns_instanceOf_FlowGroupMapping():void
    {
        assertThat( _classUnderTest.on( MockTrigger ), instanceOf( FlowGroupMapping ) )
    }

    [Test]
    public function when_trigger_listener_is_called__FlowGroup_is_executed():void
    {
        const trigger:MockTrigger = _injector.getInstance( MockTrigger );
        const flowGroup:MockFlowGroup = _injector.getInstance( ControlFlow );
        _classUnderTest.on( MockTrigger );
        trigger.listener();
        assertThat( flowGroup.executeCalled, equalTo( 1 ) );
    }

    [Test]
    public function when_trigger_is_removed__trigger_listener_is_null():void
    {
        const trigger:MockTrigger = _injector.getInstance( MockTrigger );
        _classUnderTest.on( MockTrigger );
        _classUnderTest.remove( MockTrigger );
        assertThat( trigger.listener, nullValue() );
    }
}
}
