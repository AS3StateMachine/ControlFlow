package statemachine.flow.impl
{
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.events.ProgressEvent;

import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.isFalse;
import org.hamcrest.object.strictlyEqualTo;
import org.swiftsuspenders.Injector;

import statemachine.flow.impl.support.ExecutableTrigger;

public class EventTriggerTest
{
    private var _classUnderTest:EventTrigger;
    private var _injector:Injector;
    private var _dispatcher:EventDispatcher;
    private var _executable:ExecutableTrigger;

    [Before]
    public function before():void
    {
        _dispatcher = new EventDispatcher()
        _injector = new Injector();
        _injector.map( IEventDispatcher ).toValue( _dispatcher );

    }

    [Test]
    public function by_default_client_not_executed():void
    {
        configure( Event.COMPLETE, null );
        assertThat( _executable.numbExecutions, equalTo( 0 ) );
    }

    [Test]
    public function on_event_dispatch_once__client_executed_once():void
    {
        configure( Event.COMPLETE, null );
        dispatch( new Event( Event.COMPLETE ) )
        assertThat( _executable.numbExecutions, equalTo( 1 ) );
    }

    [Test]
    public function on_event_dispatch_twice__client_executed_twice():void
    {
        configure( Event.COMPLETE, null );
        dispatch( new Event( Event.COMPLETE ) );
        dispatch( new Event( Event.COMPLETE ) );
        assertThat( _executable.numbExecutions, equalTo( 2 ) );
    }

    [Test]
    public function remove__client_not_executed():void
    {
        configure( Event.COMPLETE, null );
        _classUnderTest.remove();
        dispatch( new Event( Event.COMPLETE ) );
        dispatch( new Event( Event.COMPLETE ) );
        assertThat( _executable.numbExecutions, equalTo( 0 ) );
    }

    [Test]
    public function event_is_mapped_as_Event_during_execution():void
    {
        var mappedEvent:Event;
        const event:Event = new ProgressEvent( ProgressEvent.PROGRESS, false, false, 50, 100 );
        configure( ProgressEvent.PROGRESS, null );

        _classUnderTest.preExecute = function ():void
        {
            mappedEvent = _classUnderTest.injector.getInstance( Event );
        }

        dispatch( event );
        assertThat( mappedEvent, strictlyEqualTo( event ) );
    }

    [Test]
    public function event_is_mapped_as_eventClass_if_parameter_is_passed():void
    {
        var mappedEvent:Event;
        const event:Event = new ProgressEvent( ProgressEvent.PROGRESS, false, false, 50, 100 );
        configure( ProgressEvent.PROGRESS, ProgressEvent );

        _classUnderTest.preExecute = function ():void
        {
            mappedEvent = _classUnderTest.injector.getInstance( ProgressEvent );
        }

        dispatch( event );
        assertThat( mappedEvent, strictlyEqualTo( event ) );
    }

    [Test]
    public function event_is_unmapped_after_execution():void
    {
        const event:Event = new ProgressEvent( ProgressEvent.PROGRESS, false, false, 50, 100 );
        configure( ProgressEvent.PROGRESS, null );
        dispatch( event );
        assertThat( _classUnderTest.injector.hasMapping( Event ), isFalse() );
    }

    private function dispatch( event:Event ):void
    {
        _dispatcher.dispatchEvent( event );
    }

    public function configure( type:String, eventClass:Class ):void
    {
        _executable = new ExecutableTrigger();
        _classUnderTest = new EventTrigger( type, eventClass );
        _classUnderTest.setInjector( _injector );
        _classUnderTest.add( _executable )
    }


}
}
