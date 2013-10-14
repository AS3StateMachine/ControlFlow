package statemachine.flow.impl
{
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.events.ProgressEvent;

import org.hamcrest.assertThat;

import org.hamcrest.object.equalTo;

import statemachine.flow.impl.support.mappings.MockExecutor;
import statemachine.support.cmds.MockCommandOne;

public class EventMapTest
{
    private var _classUnderTest:EventMap;
    private var _dispatcher:IEventDispatcher;
    private var _triggerMap:TriggerFlowMap;
    private var _executor:MockExecutor;

    [Before]
    public function before():void
    {
        _dispatcher = new EventDispatcher();
        _executor = new MockExecutor( null );
        _triggerMap = new TriggerFlowMap( _executor );
        _classUnderTest = new EventMap( _triggerMap, _dispatcher );
    }


    [Test]
    public function flow_not_executed_if_event_not_dispatched():void
    {
        _classUnderTest.on( ProgressEvent.PROGRESS, ProgressEvent )
                .always.executeAll( MockCommandOne )
                .and.fix();

        assertThat( _executor.recievedData.length, equalTo( 0 ) );
    }

    [Test]
    public function flow_executed_when_event_dispatched():void
    {
        _classUnderTest.on( ProgressEvent.PROGRESS, ProgressEvent )
                .always.executeAll( MockCommandOne )
                .and.fix();
        _dispatcher.dispatchEvent( new ProgressEvent( ProgressEvent.PROGRESS ) );
         assertThat( _executor.recievedData.length, equalTo( 1 ) );
    }

    [Test]
    public function flow_not_executed_when_event_removed():void
    {
        _classUnderTest.on( ProgressEvent.PROGRESS, ProgressEvent )
                .always.executeAll( MockCommandOne )
                .and.fix();
        _classUnderTest.remove( ProgressEvent.PROGRESS );

        _dispatcher.dispatchEvent( new ProgressEvent( ProgressEvent.PROGRESS ) );
        assertThat( _executor.recievedData.length, equalTo( 0 ) );
    }
}
}
