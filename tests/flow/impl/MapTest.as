package flow.impl
{
import flow.dsl.ControlFlowMapping;
import flow.impl.support.MockTrigger;
import flow.impl.support.mappings.MockControlFlow;

import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.instanceOf;
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
        _injector.map( Injector ).toValue( _injector );
        _injector.map( ControlFlow ).toSingleton( MockControlFlow );
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
        assertThat( _classUnderTest.on( MockTrigger ), instanceOf( ControlFlowMapping ) )
    }

    [Test]
    public function when_trigger_listener_is_called__FlowGroup_is_executed():void
    {
        const trigger:MockTrigger = _injector.getInstance( MockTrigger );
        const flowGroup:MockControlFlow = _injector.getInstance( ControlFlow );
        _classUnderTest.on( MockTrigger );
        trigger.execute();
        assertThat( flowGroup.executeCalled, equalTo( 1 ) );
    }

    [Test]
    public function when_trigger_is_removed__trigger_listener_is_null():void
    {
        const trigger:MockTrigger = _injector.getInstance( MockTrigger );
        const flowGroup:MockControlFlow = _injector.getInstance( ControlFlow );
        _classUnderTest.on( MockTrigger );
        _classUnderTest.remove( MockTrigger );
        trigger.execute();
        assertThat( flowGroup.executeCalled, equalTo( 0 ) );
    }
}
}
