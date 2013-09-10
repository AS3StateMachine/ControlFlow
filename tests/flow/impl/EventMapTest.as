package flow.impl
{
import flow.core.Executable;

import org.hamcrest.assertThat;
import org.hamcrest.object.isTrue;
import org.hamcrest.object.strictlyEqualTo;
import org.swiftsuspenders.Injector;

public class EventMapTest
{
    private var _classUnderTest:EventMap;
    private var _injector:Injector;

    [Before]
    public function before():void
    {
        _injector = new Injector();
        _classUnderTest = new EventMap( _injector );
    }

    [Test]
    public function constructor_creates_childInjector():void
    {
        assertThat( _classUnderTest.injector.parentInjector, strictlyEqualTo( _injector ) );
    }

    [Test]
    public function constructor_injects_childInjector_as_Injector():void
    {
        assertThat( _classUnderTest.injector.getInstance( Injector ), strictlyEqualTo( _classUnderTest.injector ) );
    }

    [Test]
    public function constructor_injects_Executor():void
    {
        assertThat( _classUnderTest.injector.hasMapping( Executor ), isTrue() );
    }


}
}
