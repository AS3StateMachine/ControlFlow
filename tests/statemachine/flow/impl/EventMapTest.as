package statemachine.flow.impl
{
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.events.ProgressEvent;

import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.isTrue;
import org.hamcrest.object.strictlyEqualTo;
import org.swiftsuspenders.Injector;

import statemachine.support.TestRegistry;
import statemachine.support.cmds.MockCommandOne;

public class EventMapTest implements TestRegistry
{
    private var _classUnderTest:EventMap;
    private var _injector:Injector;
    private var _executables:Vector.<Class>;
    private var _dispatcher:IEventDispatcher;

    [Before]
    public function before():void
    {
        _injector = new Injector();
        _dispatcher = new EventDispatcher();
        _injector.map( IEventDispatcher ).toValue( _dispatcher );
        _injector.map( TestRegistry ).toValue( this );
        _classUnderTest = new EventMap( _injector );
        _executables = new Vector.<Class>();
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

    [Test]
    public function flow_not_executed_if_event_not_dispatched():void
    {
        _classUnderTest.on( ProgressEvent.PROGRESS, ProgressEvent )
                .always.executeAll( MockCommandOne )
                .and.fix();

        assertThat( _executables.length, equalTo( 0 ) );
    }

    [Test]
    public function flow_executed_when_event_dispatched():void
    {
        _classUnderTest.on( ProgressEvent.PROGRESS, ProgressEvent )
                .always.executeAll( MockCommandOne )
                .and.fix();
        _dispatcher.dispatchEvent( new ProgressEvent( ProgressEvent.PROGRESS ) );
        assertThat( _executables.length, equalTo( 1 ) );
    }

    [Test]
    public function flow_not_executed_when_event_removed():void
    {
        _classUnderTest.on( ProgressEvent.PROGRESS, ProgressEvent )
                .always.executeAll( MockCommandOne )
                .and.fix();
        _classUnderTest.remove( ProgressEvent.PROGRESS );

        _dispatcher.dispatchEvent( new ProgressEvent( ProgressEvent.PROGRESS ) );
        assertThat( _executables.length, equalTo( 0 ) );
    }


    public function register( value:* ):void
    {
        _executables.push( value );
    }
}
}
