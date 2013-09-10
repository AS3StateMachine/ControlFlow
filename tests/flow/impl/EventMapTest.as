package flow.impl
{
import flow.api.EventControlFlowMap;
import flow.impl.support.MockTrigger;
import flow.impl.support.mappings.MockControlFlow;

import org.swiftsuspenders.Injector;

public class EventMapTest
{
    private var _classUnderTest:EventControlFlowMap;
    private var _injector:Injector;

    [Before]
    public function before():void
    {
        _injector = new Injector();
        _injector.map( MockTrigger ).asSingleton();
        _injector.map( Injector ).toValue( _injector );
        _injector.map( ControlFlow ).toSingleton( MockControlFlow );
        _classUnderTest = new EventMap( _injector );
    }

    [Test]
    public function test():void
    {

    }


}
}
