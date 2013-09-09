package flow.impl
{
public class FlowError extends Error
{
    private var _sourceError:Error;
    private var _origin:String;
    private var _lineNumber:int;
    private var _method:String;


    public function FlowError( origin:Error )
    {
        _sourceError = origin;

        const _firstLine:String = _sourceError.getStackTrace().match( new RegExp( "at(.*?)\\]" ) )[0];
        _lineNumber = _firstLine.match( /:(\d+)]/ )[1];
        _origin = _firstLine.match( /at (.*?)\// )[1];
        _method = _firstLine.match( /\/(.*?)\[/ )[1];
    }


    public function get sourceError():Error
    {
        return _sourceError;
    }

    public function get origin():String
    {
        return _origin;
    }

    public function get method():String
    {
        return _method;
    }

    public function get lineNumber():int
    {
        return _lineNumber;
    }
}
}
