package flow.api
{
public interface Trigger
{
    function add( listener:Function ):void;

    function remove():void;
}
}
