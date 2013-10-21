package statemachine.flow.reflection
{
import flash.utils.Dictionary;

public class TypeDescriptor implements Reflector
{
    private const cache:Dictionary = new Dictionary( false );

    public function TypeDescriptor( reflector:Reflector )
    {
        _reflector = reflector;
    }

    private var _reflector:Reflector;

    public function describe( type:Class ):TypeDescription
    {
        return cache[type] ||= _reflector.describe(type);
    }
}
}
