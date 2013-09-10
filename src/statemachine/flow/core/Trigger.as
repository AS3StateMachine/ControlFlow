package statemachine.flow.core
{
public interface Trigger
{
    function add( client:Executable ):void;

    function remove():void;
}
}
