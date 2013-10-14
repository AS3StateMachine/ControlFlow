package statemachine.flow.api
{
import robotlegs.bender.framework.api.IInjector;

public class Payload
{
    private const _values:Vector.<ValueBag> = new Vector.<ValueBag>();

    public function add( value:*, classRef:Class ):Payload
    {
        _values.push( new ValueBag( value, classRef ) );
        return this;
    }

    public function inject( injector:IInjector ):void
    {
        if ( _values.length == 0 )return;
        for each( var v:ValueBag in _values )
        {
            v.inject( injector )
        }
    }

    public function remove( injector:IInjector ):void
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

import robotlegs.bender.framework.api.IInjector;

class ValueBag
{
    internal var value:*;
    internal var classRef:Class;

    public function ValueBag( value:*, classRef:Class )
    {
        this.value = value;
        this.classRef = classRef;
    }

    internal function inject( injector:IInjector ):void
    {
        injector.map( classRef ).toValue( value );
    }

    public function remove( injector:IInjector ):void
    {
        injector.unmap( classRef );
    }
}
