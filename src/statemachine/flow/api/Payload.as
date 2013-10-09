package statemachine.flow.api
{
import org.swiftsuspenders.Injector;

public class Payload
{
    private const _values:Vector.<ValueBag> = new Vector.<ValueBag>();

    public function add( value:*, classRef:Class ):Payload
    {
        _values.push( new ValueBag( value, classRef ) );
        return this;
    }

    public function inject( injector:Injector ):void
    {
        if ( _values.length == 0 )return;
        for each( var v:ValueBag in _values )
        {
            v.inject( injector )
        }
    }

    public function remove( injector:Injector ):void
    {
        if ( _values.length == 0 )return;
        for each( var v:ValueBag in _values )
        {
            v.remove( injector )
        }
    }

    public function get( classRef:Class ):*
    {
        if ( _values.length == 0 )return null;
        for each( var v:ValueBag in _values )
        {
            if ( v.classRef === classRef ) return v.value;
        }
        return null;
    }
}
}

import org.swiftsuspenders.Injector;

class ValueBag
{
    internal var value:*;
    internal var classRef:Class;

    public function ValueBag( value:*, classRef:Class )
    {
        this.value = value;
        this.classRef = classRef;
    }

    internal function inject( injector:Injector ):void
    {
        injector.map( classRef ).toValue( value );
    }

    public function remove( injector:Injector ):void
    {
        injector.unmap( classRef );
    }
}
