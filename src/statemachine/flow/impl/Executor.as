package statemachine.flow.impl
{
import robotlegs.bender.framework.api.IInjector;

public class Executor
{
    public function Executor( injector:IInjector )
    {
        _injector = (injector == null) ? null : injector.createChild();
    }

    private var _injector:IInjector;

    public function execute( executionGroup:ExecutionData ):Boolean
    {
        executionGroup.injectPayload( _injector );

        if ( executionGroup.guards.length > 0 && !approveGuards( executionGroup.guards ) )
        {
            executionGroup.removePayload( _injector );
            return false;
        }

        const commands:Vector.<Class> = executionGroup.commands;

        for each( var cmdClass:Class in commands )
        {
            const cmd:* = _injector.instantiateUnmapped( cmdClass );
            cmd.execute();
        }

        executionGroup.removePayload( _injector );

        return true;
    }

    private function approveGuards( guards:Vector.<Class> ):Boolean
    {
        for each( var guardClass:Class in guards )
        {
            const guard:* = _injector.instantiateUnmapped( guardClass );
            if ( !guard.approve() ) return false;
        }
        return true;
    }


}
}
