package statemachine.flow.impl
{
import flash.events.Event;
import flash.events.EventDispatcher;

import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.instanceOf;
import org.hamcrest.object.strictlyEqualTo;

import statemachine.flow.api.Payload;
import statemachine.flow.impl.support.ExecutableTrigger;
import statemachine.support.TestEvent;

public class EventTriggerTest
{
    private var _classUnderTest:EventTrigger;
    private var _dispatcher:EventDispatcher;
    private var _executable:ExecutableTrigger;

    [Before]
    public function before():void
    {
        _dispatcher = new EventDispatcher()
    }

    [Test]
    public function by_default__client_not_executed():void
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
    public function client_is_passed_instanceOf_payload_when_triggered():void
    {
        const event:Event = new TestEvent( "HELLO" );
        configure( TestEvent.TESTING, TestEvent );

        dispatch( event );

        assertThat( _executable.receivedPayload, instanceOf( Payload ) );
    }

    [Test]
    public function client_payload_contains_Event_by_default():void
    {
        const event:Event = new TestEvent( "HELLO" );
        configure( TestEvent.TESTING, null );

        dispatch( event );

        assertThat( _executable.receivedPayload.get( Event ), strictlyEqualTo( event ) );
    }

    [Test]
    public function client_payload_contains_eventClass_if_passed():void
    {
        const event:Event = new TestEvent( "HELLO" );
        configure( TestEvent.TESTING, TestEvent );

        dispatch( event );

        assertThat( _executable.receivedPayload.get( TestEvent ), strictlyEqualTo( event ) );
    }

    private function dispatch( event:Event ):void
    {
        _dispatcher.dispatchEvent( event );
    }

    public function configure( type:String, eventClass:Class ):void
    {
        _executable = new ExecutableTrigger();
        _classUnderTest = new EventTrigger( type, eventClass );
        _classUnderTest.setDispatcher( _dispatcher );
        _classUnderTest.add( _executable )
    }


}
}
