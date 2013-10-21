package statemachine.flow.reflection
{
import flash.utils.describeType;

public class DescribeTypeReflector implements Reflector
{
    public function describe( type:Class ):TypeDescription
    {
        const desc:XMLList = describeType( type ).factory;
        const hasApprove:Boolean = getHasApproveMethod( desc );
        const hasExecute:Boolean = getHasExecuteMethod( desc );
        return new TypeDescription(
                hasApprove,
                hasExecute,
                hasExecute && getHasAsyncExecuteMethod( desc ) );
    }

    private function getHasApproveMethod( desc:XMLList ):Boolean
    {
        const approve:XMLList = desc.method.(@name == "approve");
        return (approve.length() == 1);
    }

    private function getHasExecuteMethod( desc:XMLList ):Boolean
    {
        const execute:XMLList = desc.method.(@name == "execute");
        return (execute.length() == 1);
    }

    private function getHasAsyncExecuteMethod( desc:XMLList ):Boolean
    {
        const param:XMLList = desc.method.(@name == "execute").parameter.(@index == "1" && @type == "Function");
        return (param.length() == 1);
    }
}
}
