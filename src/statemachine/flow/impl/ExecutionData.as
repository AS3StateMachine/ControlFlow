package statemachine.flow.impl
{
import org.swiftsuspenders.Injector;

import statemachine.flow.api.Payload;

public class ExecutionData
{
    private const _guards:Vector.<Class> = new Vector.<Class>();
    private const _commands:Vector.<Class> = new Vector.<Class>();

    private var _payload:Payload;

    public function get payload():Payload
    {
        return _payload;
    }

    public function set payload( value:Payload ):void
    {
        _payload = value;
    }

    public function get guards():Vector.<Class>
    {
        return _guards;
    }

    public function get commands():Vector.<Class>
    {
        return _commands;
    }

    public function pushGuard( guard:Class ):void
    {
        _guards.push( guard );
    }

    public function pushCommand( command:Class ):void
    {
        _commands.push( command );
    }

    public function injectPayload( injector:Injector ):void
    {
        if ( _payload == null ) return;
        _payload.inject( injector );
    }

    public function removePayload( injector:Injector ):void
    {
        if ( _payload == null ) return;
        _payload.remove( injector );
    }

    public function fix():void
    {
        _guards.fixed = true;
        _commands.fixed = true;
    }
}
}
