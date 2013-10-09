package statemachine.flow.core
{
public interface Trigger
{
    function add( client:ExecutableBlock ):void;

    function remove():void;
}
}
