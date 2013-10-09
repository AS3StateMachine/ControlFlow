package statemachine.support
{
import flash.events.Event;

public class TestEvent extends Event
{
    public static const TESTING:String = "testing";
    private var _message:String;

    public function TestEvent( message:String )
    {
        super( TESTING );
        _message = message;
    }

    public function get message():String
    {
        return _message;
    }


    override public function clone():Event
    {
        return new TestEvent( message );
    }
}
}
