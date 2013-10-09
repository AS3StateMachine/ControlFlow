package statemachine.flow.impl
{
import org.swiftsuspenders.Injector;

public class Executor
{
    private var _injector:Injector;


    public function Executor( injector:Injector )
    {
        _injector = injector;
    }

    public function execute( executionGroup:ExecutionData ):Boolean
    {
        executionGroup.injectPayload( _injector);

        if ( executionGroup.guards.length > 0 && !approveGuards( executionGroup.guards ) ) {
            executionGroup.removePayload( _injector);
            return false;
        }

        const commands:Vector.<Class> = executionGroup.commands;

        for each( var cmdClass:Class in commands )
        {
            const cmd:* = _injector.instantiateUnmapped( cmdClass );
            cmd.execute();
        }

        executionGroup.removePayload( _injector);

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
