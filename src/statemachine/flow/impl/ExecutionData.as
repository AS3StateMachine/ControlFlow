package statemachine.flow.impl
{
public class ExecutionData
{
    private const _guards:Vector.<Class> = new Vector.<Class>();
    private const _commands:Vector.<Class> = new Vector.<Class>();

    public function pushGuard( guard:Class ):void
    {
        _guards.push( guard );
    }

    public function pushCommand( command:Class ):void
    {
        _commands.push( command );
    }

    public function get guards():Vector.<Class>
    {
        return _guards;
    }

    public function get commands():Vector.<Class>
    {
        return _commands;
    }

    public function fix():void
    {
        _guards.fixed = true;
        _commands.fixed = true;
    }
}
}
