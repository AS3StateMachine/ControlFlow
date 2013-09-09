package flow.impl
{
import flash.utils.Dictionary;

import flow.api.Trigger;
import flow.api.TriggerMap;
import flow.dsl.ControlFlowMapping;

import org.swiftsuspenders.Injector;

public class Map implements TriggerMap
{
    internal var injector:Injector;

    private const _map:Dictionary = new Dictionary();

    public function Map( injector:Injector )
    {
        this.injector = injector.createChildInjector();
    }

    public function on( trigger:Class ):ControlFlowMapping
    {
       const test:Boolean = injector.hasMapping(Injector);
        const flowGroup:ControlFlow = injector.getOrCreateNewInstance( ControlFlow );
        const t:Trigger = injector.getOrCreateNewInstance( trigger );

        t.add(
                function ():void
                {
                    flowGroup.execute();
                }
        );

        _map[trigger] = t;

        return flowGroup;
    }

    public function remove( trigger:Class ):void
    {
        if ( _map[trigger] == null ) return;
        Trigger( _map[trigger] ).remove();
        delete _map[trigger];
    }


}
}
