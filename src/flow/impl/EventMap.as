package flow.impl
{
import flow.api.EventControlFlowMap;
import flow.dsl.ControlFlowMapping;

import org.swiftsuspenders.Injector;

public class EventMap implements EventControlFlowMap
{
    internal var injector:Injector;

    private var _map:TriggerMap

    public function EventMap( injector:Injector )
    {
        this.injector = injector.createChildInjector();
        this.injector.map( Injector ).toValue( this.injector );
        this.injector.map( Executor );
        _map = this.injector.getOrCreateNewInstance( TriggerMap );
    }


    public function on( type:String, eventClass:Class ):ControlFlowMapping
    {
        return null;
    }

    public function remove( type:String ):void
    {
    }
}
}
